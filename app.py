from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, session
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from db_config import get_connection
import random
from datetime import datetime
import bcrypt

app = Flask(__name__)
app.secret_key = "eatify_secret"

# Flask-Login setup
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

class User(UserMixin):
    def __init__(self, customer_id, email, role):
        self.id = customer_id
        self.email = email
        self.role = role

@login_manager.user_loader
def load_user(customer_id):
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT customer_id, email, role FROM Customer WHERE customer_id = %s", (customer_id,))
    user_data = cur.fetchone()
    conn.close()
    if user_data:
        return User(user_data['customer_id'], user_data['email'], user_data['role'])
    return None

# ---------- Home ----------
@app.route('/')
def home():
    return render_template('index.html')

# ---------- Login ----------
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        
        conn = get_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute("SELECT customer_id, email, password_hash, role FROM Customer WHERE email = %s", (email,))
        user_data = cur.fetchone()
        conn.close()
        
        if user_data and bcrypt.checkpw(password.encode('utf-8'), user_data['password_hash'].encode('utf-8')):
            user = User(user_data['customer_id'], user_data['email'], user_data['role'])
            login_user(user)
            flash("✅ Logged in successfully!", "success")
            return redirect(url_for('home'))
        else:
            flash("❌ Invalid email or password", "danger")
    
    return render_template('login.html')

# ---------- Logout ----------
@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash("✅ Logged out successfully!", "success")
    return redirect(url_for('home'))

# ---------- View Customers (admin only) ----------
@app.route('/customers')
@login_required
def view_customers():
    # Only admins can see the full customer list
    if current_user.role != 'admin':
        flash("Access denied: Admins only", "danger")
        return redirect(url_for('home'))

    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT * FROM Customer")
    customers = cur.fetchall()
    conn.close()
    return render_template('customers.html', customers=customers)

# ---------- Register New Customer ----------
@app.route('/register_customer', methods=['GET', 'POST'])
def register_customer():
    if request.method == 'POST':
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        dob = request.form['dob']
        email = request.form['email']
        phone = request.form['phone']
        payment_type = request.form['payment_type']
        password = request.form['password']
        role = request.form.get('role', 'user')  # Default to user

        # Hash the password
        password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')

        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("""
                INSERT INTO Customer (first_name, last_name, DoB, email, phone_no, preferred_payment_type, password_hash, role)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
            """, (first_name, last_name, dob, email, phone, payment_type, password_hash, role))
            conn.commit()
            flash("✅ Customer registered successfully!", "success")
        except Exception as e:
            conn.rollback()
            flash(f"❌ Error registering: {str(e)}", "danger")
        finally:
            conn.close()

        return redirect(url_for('login'))

    return render_template('register_customer.html')

# ---------- View Dishes ----------
@app.route('/dishes')
def view_dishes():
    conn = get_connection()
    cur = conn.cursor(dictionary=True)

    query = """
        SELECT 
            d.dish_id, d.dish_name, d.unit_price,
            COALESCE(c.category_name, 'N/A') AS category_name,
            r.restaurant_id, r.restaurant_name, r.restaurant_category
        FROM Dish d
        LEFT JOIN Category c ON d.category_id = c.category_id
        JOIN Restaurant r ON d.restaurant_id = r.restaurant_id
        ORDER BY r.restaurant_name, d.dish_name
    """
    cur.execute(query)
    rows = cur.fetchall()
    conn.close()

    # group dishes by restaurant
    restaurants = {}
    for row in rows:
        rname = row["restaurant_name"]
        if rname not in restaurants:
            restaurants[rname] = {
                "category": row["restaurant_category"],
                "dishes": []
            }
        restaurants[rname]["dishes"].append(row)

    return render_template('dishes.html', restaurants=restaurants)

# ---------- Compare Dishes with Offers ----------
@app.route('/compare_dishes')
def compare_dishes():
    conn = get_connection()
    cur = conn.cursor(dictionary=True)

    query = """
        SELECT d.dish_name, r.restaurant_name, d.unit_price, 
               COALESCE(o.percentage, 0) AS discount,
               ROUND(d.unit_price * (1 - COALESCE(o.percentage, 0)/100), 2) AS final_price
        FROM Dish d
        JOIN Restaurant r ON d.restaurant_id = r.restaurant_id
        LEFT JOIN Offer o ON d.dish_id = o.dish_id 
            AND CURDATE() BETWEEN o.start_date AND o.end_date
        ORDER BY d.dish_name, final_price
    """
    cur.execute(query)
    rows = cur.fetchall()

    dishes = {}
    for row in rows:
        dish_name = row["dish_name"]
        if dish_name not in dishes:
            dishes[dish_name] = []
        dishes[dish_name].append(row)

    conn.close()
    return render_template('compare_dishes.html', dishes=dishes)

# ---------- View Orders ----------
@app.route('/orders')
@login_required
def view_orders():
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    
    if current_user.role == 'admin':
        # Fetch orders with payment
        cur.execute("""
            SELECT o.order_id, o.order_time, o.status, 
                   CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
                   p.amount, p.payment_type
            FROM Orders o
            JOIN Customer c ON o.customer_id = c.customer_id
            LEFT JOIN Payment p ON o.order_id = p.order_id
            ORDER BY o.order_time DESC
        """)
        orders = cur.fetchall()
        
        # Fetch all order items
        cur.execute("""
            SELECT oi.order_id, d.dish_name, r.restaurant_name, oi.quantity, oi.unit_price, COALESCE(off.percentage, 0) as discount
            FROM Orders_Item oi
            JOIN Dish d ON oi.dish_id = d.dish_id
            JOIN Restaurant r ON d.restaurant_id = r.restaurant_id
            LEFT JOIN Offer off ON oi.offer_id = off.offer_id
            ORDER BY oi.order_id
        """)
        all_items = cur.fetchall()
    else:
        # For users, only their orders
        cur.execute("""
            SELECT o.order_id, o.order_time, o.status, 
                   CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
                   p.amount, p.payment_type
            FROM Orders o
            JOIN Customer c ON o.customer_id = c.customer_id
            LEFT JOIN Payment p ON o.order_id = p.order_id
            WHERE o.customer_id = %s
            ORDER BY o.order_time DESC
        """, (current_user.id,))
        orders = cur.fetchall()
        
        # Fetch items for user's orders
        cur.execute("""
            SELECT oi.order_id, d.dish_name, r.restaurant_name, oi.quantity, oi.unit_price, COALESCE(off.percentage, 0) as discount
            FROM Orders_Item oi
            JOIN Dish d ON oi.dish_id = d.dish_id
            JOIN Restaurant r ON d.restaurant_id = r.restaurant_id
            LEFT JOIN Offer off ON oi.offer_id = off.offer_id
            JOIN Orders o ON oi.order_id = o.order_id
            WHERE o.customer_id = %s
            ORDER BY oi.order_id
        """, (current_user.id,))
        all_items = cur.fetchall()
    
    conn.close()
    
    # Group items by order_id
    items_by_order = {}
    for item in all_items:
        oid = item['order_id']
        if oid not in items_by_order:
            items_by_order[oid] = []
        items_by_order[oid].append(item)
    
    # Add items to orders
    for order in orders:
        order['items'] = items_by_order.get(order['order_id'], [])
    
    return render_template('orders.html', orders=orders)

# ---------- Customer: My Orders ----------
@app.route('/my_orders/<int:customer_id>')
@login_required
def my_orders(customer_id):
    # Allow only the customer themselves or admins to view this page
    if current_user.role != 'admin' and int(current_user.id) != int(customer_id):
        flash("Access denied: You can only view your own orders", "danger")
        return redirect(url_for('home'))
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    
    cur.execute("""
        SELECT o.order_id, o.order_time, o.status, 
               p.amount, p.payment_type,
               d.dish_name, r.restaurant_name, oi.quantity
        FROM Orders o
        JOIN Payment p ON o.order_id = p.order_id
        JOIN Orders_Item oi ON o.order_id = oi.order_id
        JOIN Dish d ON oi.dish_id = d.dish_id
        JOIN Restaurant r ON d.restaurant_id = r.restaurant_id
        WHERE o.customer_id = %s
        ORDER BY o.order_time DESC
    """, (customer_id,))
    
    orders = cur.fetchall()
    conn.close()
    return render_template('my_orders.html', orders=orders, customer_id=customer_id)

# ---------- Add Order ----------
@app.route('/add_order', methods=['GET', 'POST'])
@login_required
def add_order():
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    
    cur.execute("SELECT restaurant_id, restaurant_name FROM Restaurant")
    restaurants = cur.fetchall()
    conn.close()

    cart = session.get('cart', [])

    if request.method == 'POST':
        action = request.form.get('action')
        
        if action == 'add_item':
            restaurant_id = request.form['restaurant_id']
            dish_id = request.form['dish_id']
            quantity = int(request.form['quantity'])
            
            # Get names
            conn = get_connection()
            cur = conn.cursor(dictionary=True)
            cur.execute("SELECT restaurant_name FROM Restaurant WHERE restaurant_id = %s", (restaurant_id,))
            restaurant_name = cur.fetchone()['restaurant_name']
            cur.execute("SELECT dish_name FROM Dish WHERE dish_id = %s", (dish_id,))
            dish_name = cur.fetchone()['dish_name']
            conn.close()
            
            # Add to cart
            cart.append({
                'restaurant_id': restaurant_id,
                'restaurant_name': restaurant_name,
                'dish_id': dish_id,
                'dish_name': dish_name,
                'quantity': quantity
            })
            session['cart'] = cart
            flash('Item added to cart!', 'success')
            return redirect(url_for('add_order'))
        
        elif action == 'place_order':
            if not cart:
                flash('Cart is empty!', 'danger')
                return redirect(url_for('add_order'))
            
            customer_id = current_user.id if current_user.role == 'user' else request.form.get('customer_id')
            
            try:
                conn = get_connection()
                cur = conn.cursor()
                
                # Create order
                cur.execute("INSERT INTO Orders (customer_id, status) VALUES (%s, 'Pending')", (customer_id,))
                order_id = cur.lastrowid
                
                for item in cart:
                    dish_id = item['dish_id']
                    quantity = item['quantity']
                    
                    # Get dish price
                    cur.execute("SELECT unit_price FROM Dish WHERE dish_id = %s", (dish_id,))
                    result = cur.fetchone()
                    unit_price = result[0] if result else 0
                    
                    # Find offer
                    cur.execute("""
                        SELECT offer_id, percentage FROM Offer 
                        WHERE dish_id = %s AND CURDATE() BETWEEN start_date AND end_date 
                        ORDER BY percentage DESC LIMIT 1
                    """, (dish_id,))
                    offer = cur.fetchone()
                    if offer:
                        offer_id = offer[0]
                        discount = offer[1] / 100
                    else:
                        offer_id = None
                        discount = 0
                    
                    # Insert order item
                    cur.execute("""
                        INSERT INTO Orders_Item (order_id, dish_id, offer_id, unit_price, quantity)
                        VALUES (%s, %s, %s, %s, %s)
                    """, (order_id, dish_id, offer_id, unit_price, quantity))
                
                conn.commit()
                
                # Clear cart
                session.pop('cart', None)
                
                flash('Order created! Please complete payment.', 'info')
                return redirect(url_for('pay_order', order_id=order_id))
                
            except Exception as e:
                conn.rollback()
                flash(f'Error placing order: {str(e)}', 'danger')
            finally:
                conn.close()
    
    # For admins, get customers
    customers = []
    if current_user.role == 'admin':
        conn = get_connection()
        cur = conn.cursor(dictionary=True)
        cur.execute("SELECT customer_id, first_name, last_name FROM Customer")
        customers = cur.fetchall()
        conn.close()
    
    return render_template('add_order.html', restaurants=restaurants, cart=cart, customers=customers)

# ---------- AJAX: Get Dishes by Restaurant ----------
@app.route('/get_dishes/<int:restaurant_id>')
def get_dishes(restaurant_id):
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("""
        SELECT dish_id, dish_name, unit_price 
        FROM Dish 
        WHERE restaurant_id = %s
    """, (restaurant_id,))
    dishes = cur.fetchall()
    conn.close()
    return jsonify(dishes)

# ---------- Pay Order ----------
@app.route('/pay_order/<int:order_id>', methods=['GET', 'POST'])
@login_required
def pay_order(order_id):
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    
    # Check if order belongs to user or user is admin
    cur.execute("SELECT customer_id, status FROM Orders WHERE order_id = %s", (order_id,))
    order_info = cur.fetchone()
    if not order_info or (current_user.role != 'admin' and order_info['customer_id'] != current_user.id):
        conn.close()
        flash("Access denied", "danger")
        return redirect(url_for('home'))
    
    if order_info['status'] != 'Pending':
        conn.close()
        flash("Order already paid or processed", "warning")
        return redirect(url_for('view_orders'))
    
    if request.method == 'POST':
        payment_type = request.form['payment_type']
        
        # Calculate total
        cur.execute("""
            SELECT oi.unit_price, oi.quantity, COALESCE(o.percentage, 0) as discount
            FROM Orders_Item oi
            LEFT JOIN Offer o ON oi.offer_id = o.offer_id
            WHERE oi.order_id = %s
        """, (order_id,))
        items = cur.fetchall()
        total_amount = sum(item['unit_price'] * item['quantity'] * (1 - item['discount']/100) for item in items)
        
        # Insert payment
        cur.execute("""
            INSERT INTO Payment (order_id, amount, payment_type)
            VALUES (%s, %s, %s)
        """, (order_id, total_amount, payment_type))
        
        # Update order status
        cur.execute("UPDATE Orders SET status = 'Completed' WHERE order_id = %s", (order_id,))
        
        conn.commit()
        conn.close()
        
        flash("Payment successful! Order completed.", "success")
        return redirect(url_for('view_orders'))
    
    # GET: Show order details
    cur.execute("""
        SELECT d.dish_name, r.restaurant_name, oi.unit_price, oi.quantity, COALESCE(o.percentage, 0) as discount
        FROM Orders_Item oi
        JOIN Dish d ON oi.dish_id = d.dish_id
        JOIN Restaurant r ON d.restaurant_id = r.restaurant_id
        LEFT JOIN Offer o ON oi.offer_id = o.offer_id
        WHERE oi.order_id = %s
    """, (order_id,))
    order_items = cur.fetchall()
    
    # Calculate total
    total = sum(item['unit_price'] * item['quantity'] * (1 - item['discount']/100) for item in order_items)
    
    conn.close()
    
    return render_template('pay_order.html', order_items=order_items, total=total, order_id=order_id)

# ---------- Update Order ----------
@app.route('/update_order/<int:order_id>', methods=['GET', 'POST'])
@login_required
def update_order(order_id):
    if current_user.role != 'admin':
        flash("Access denied: Admins only", "danger")
        return redirect(url_for('home'))
    conn = get_connection()
    cur = conn.cursor(dictionary=True)

    if request.method == 'POST':
        new_status = request.form['status']
        try:
            cur.execute("UPDATE Orders SET status = %s WHERE order_id = %s", (new_status, order_id))
            conn.commit()
            flash("✅ Order status updated successfully!", "success")
        except Exception as e:
            conn.rollback()
            flash(f"❌ Error updating status: {str(e)}", "danger")
        finally:
            conn.close()
        return redirect(url_for('view_orders'))

    cur.execute("""
        SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
               o.status, p.amount, p.payment_type
        FROM Orders o
        JOIN Customer c ON o.customer_id = c.customer_id
        JOIN Payment p ON o.order_id = p.order_id
        WHERE o.order_id = %s
    """, (order_id,))
    order = cur.fetchone()
    conn.close()
    return render_template('update_order.html', order=order)

# ---------- Delete Order ----------
@app.route('/delete_order/<int:order_id>', methods=['POST'])
@login_required
def delete_order(order_id):
    if current_user.role != 'admin':
        flash("Access denied: Admins only", "danger")
        return redirect(url_for('home'))
    conn = get_connection()
    cur = conn.cursor()
    try:
        cur.execute("DELETE FROM Orders_Item WHERE order_id = %s", (order_id,))
        cur.execute("DELETE FROM Payment WHERE order_id = %s", (order_id,))
        cur.execute("DELETE FROM Orders WHERE order_id = %s", (order_id,))
        conn.commit()
        flash("🗑️ Order deleted successfully!", "success")
    except Exception as e:
        conn.rollback()
        flash(f"❌ Error deleting order: {str(e)}", "danger")
    finally:
        conn.close()
    return redirect(url_for('view_orders'))

# ---------- Reports ----------
import io
import base64
import matplotlib
matplotlib.use('Agg')  # Use non-GUI backend
import matplotlib.pyplot as plt
from markupsafe import Markup

@app.route('/reports')
@login_required
def reports():
    if current_user.role != 'admin':
        flash("Access denied: Admins only", "danger")
        return redirect(url_for('home'))
    conn = get_connection()
    cur = conn.cursor(dictionary=True)

    # --- 1️⃣ Total Sales per Restaurant ---
    cur.execute("""
        SELECT r.restaurant_name, SUM(p.amount) AS total_sales
        FROM Payment p
        JOIN Orders o ON p.order_id = o.order_id
        JOIN Orders_Item oi ON o.order_id = oi.order_id
        JOIN Dish d ON oi.dish_id = d.dish_id
        JOIN Restaurant r ON d.restaurant_id = r.restaurant_id
        GROUP BY r.restaurant_name
        ORDER BY total_sales DESC
    """)
    sales = cur.fetchall()

    # --- 2️⃣ Orders with Offers ---
    cur.execute("""
        SELECT c.first_name, d.dish_name, o2.percentage AS discount, p.amount
        FROM Orders_Item oi
        JOIN Orders o ON oi.order_id = o.order_id
        JOIN Customer c ON o.customer_id = c.customer_id
        JOIN Dish d ON oi.dish_id = d.dish_id
        LEFT JOIN Offer o2 ON oi.offer_id = o2.offer_id
        JOIN Payment p ON o.order_id = p.order_id
        WHERE o2.offer_id IS NOT NULL
    """)
    offers = cur.fetchall()

    # --- 3️⃣ High Spenders ---
    cur.execute("""
        SELECT c.first_name, SUM(p.amount) AS total_spent
        FROM Customer c
        JOIN Orders o ON c.customer_id = o.customer_id
        JOIN Payment p ON o.order_id = p.order_id
        GROUP BY c.customer_id
        HAVING total_spent > (SELECT AVG(amount) FROM Payment)
        ORDER BY total_spent DESC
    """)
    high_spenders = cur.fetchall()

    conn.close()

    # === Generate Matplotlib Charts ===
    def plot_to_base64(fig):
        buf = io.BytesIO()
        fig.savefig(buf, format='png', bbox_inches='tight')
        buf.seek(0)
        img_base64 = base64.b64encode(buf.read()).decode('utf-8')
        buf.close()
        plt.close(fig)
        return Markup(f"data:image/png;base64,{img_base64}")

    # --- Chart 1: Total Sales Bar Chart ---
    fig1, ax1 = plt.subplots(figsize=(6, 4))
    if sales:
        names = [s['restaurant_name'] for s in sales]
        sales_values = [s['total_sales'] for s in sales]
        ax1.bar(range(len(sales)), sales_values, color='skyblue')
        ax1.set_title("Total Sales per Restaurant")
        ax1.set_ylabel("Sales (₹)")
        ax1.set_xticks(range(len(sales)))
        ax1.set_xticklabels(names, rotation=45, ha='right')
    sales_chart = plot_to_base64(fig1)

    # --- Chart 2: High Spenders Pie Chart ---
    fig2, ax2 = plt.subplots(figsize=(5, 5))
    if high_spenders:
        ax2.pie([h['total_spent'] for h in high_spenders],
                labels=[h['first_name'] for h in high_spenders],
                autopct='%1.1f%%', startangle=140)
        ax2.set_title("High Spenders Distribution")
    spenders_chart = plot_to_base64(fig2)

    # --- Chart 3: Discounted Dishes Bar Chart ---
    fig3, ax3 = plt.subplots(figsize=(6, 4))
    if offers:
        ax3.barh([o['dish_name'] for o in offers],
                 [o['discount'] for o in offers],
                 color='salmon')
        ax3.set_xlabel("Discount (%)")
        ax3.set_title("Dishes with Offers Applied")
    discounts_chart = plot_to_base64(fig3)

    return render_template(
        'reports.html',
        sales=sales,
        offers=offers,
        high_spenders=high_spenders,
        sales_chart=sales_chart,
        spenders_chart=spenders_chart,
        discounts_chart=discounts_chart
    )

# ---------- Run Flask App ----------
if __name__ == '__main__':
    app.run(debug=True)
