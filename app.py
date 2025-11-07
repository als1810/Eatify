from flask import Flask, render_template, request, redirect, url_for, flash, jsonify
from db_config import get_connection
import random
from datetime import datetime

app = Flask(__name__)
app.secret_key = "eatify_secret"

# ---------- Home ----------
@app.route('/')
def home():
    return render_template('index.html')

# ---------- View Customers ----------
@app.route('/customers')
def view_customers():
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

        try:
            conn = get_connection()
            cur = conn.cursor()
            cur.execute("""
                INSERT INTO Customer (first_name, last_name, DoB, email, phone_no, preferred_payment_type)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (first_name, last_name, dob, email, phone, payment_type))
            conn.commit()
            flash("✅ Customer registered successfully!", "success")
        except Exception as e:
            conn.rollback()
            flash(f"❌ Error registering: {str(e)}", "danger")
        finally:
            conn.close()

        return redirect(url_for('add_order'))

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
            r.restaurant_id, r.restaurant_name, r.restaurant_type
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
                "type": row["restaurant_type"],
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
def view_orders():
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    query = """
        SELECT 
            o.order_id,
            CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
            o.order_time, 
            o.status,
            p.amount, 
            p.payment_type,
            d.dish_name,
            r.restaurant_name,
            oi.quantity
        FROM Orders o
        JOIN Customer c ON o.customer_id = c.customer_id
        JOIN Payment p ON o.order_id = p.order_id
        JOIN Orders_Item oi ON o.order_id = oi.order_id
        JOIN Dish d ON oi.dish_id = d.dish_id
        JOIN Restaurant r ON d.restaurant_id = r.restaurant_id
        ORDER BY o.order_time DESC
    """
    cur.execute(query)
    orders = cur.fetchall()
    conn.close()
    return render_template('orders.html', orders=orders)

# ---------- Customer: My Orders ----------
@app.route('/my_orders/<int:customer_id>')
def my_orders(customer_id):
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
def add_order():
    conn = get_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute("SELECT customer_id, first_name, last_name FROM Customer")
    customers = cur.fetchall()
    cur.execute("SELECT restaurant_id, restaurant_name FROM Restaurant")
    restaurants = cur.fetchall()
    conn.close()

    if request.method == 'POST':
        customer_id = request.form.get('customer_id')
        restaurant_id = request.form['restaurant_id']
        dish_id = request.form['dish_id']
        quantity = request.form['quantity']
        payment_type = request.form['payment_type']

        try:
            conn = get_connection()
            cur = conn.cursor()

            cur.callproc('place_order', [customer_id, dish_id, quantity])
            conn.commit()

            cur.execute("SELECT MAX(order_id) FROM Orders WHERE customer_id = %s", (customer_id,))
            order_id = cur.fetchone()[0]

            cur.execute("""
                SELECT d.unit_price, COALESCE(o.percentage, 0)
                FROM Dish d
                LEFT JOIN Offer o ON d.dish_id = o.dish_id 
                    AND CURDATE() BETWEEN o.start_date AND o.end_date
                WHERE d.dish_id = %s
            """, (dish_id,))
            result = cur.fetchone()
            unit_price, discount = result
            total = float(unit_price) * int(quantity) * (1 - float(discount) / 100)

            cur.execute("""
                INSERT INTO Payment (order_id, amount, payment_type)
                VALUES (%s, %s, %s)
            """, (order_id, total, payment_type))
            conn.commit()

            flash('✅ Order placed successfully!', 'success')

        except Exception as e:
            conn.rollback()
            flash(f'❌ Error placing order: {str(e)}', 'danger')
        finally:
            conn.close()

        return redirect(url_for('view_orders'))

    return render_template('add_order.html', customers=customers, restaurants=restaurants)

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

# ---------- Update Order ----------
@app.route('/update_order/<int:order_id>', methods=['GET', 'POST'])
def update_order(order_id):
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
def delete_order(order_id):
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
import matplotlib.pyplot as plt
from markupsafe import Markup

@app.route('/reports')
def reports():
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
        ax1.bar([s['restaurant_name'] for s in sales],
                [s['total_sales'] for s in sales],
                color='skyblue')
        ax1.set_title("Total Sales per Restaurant")
        ax1.set_ylabel("Sales (₹)")
        ax1.set_xticklabels([s['restaurant_name'] for s in sales], rotation=45, ha='right')
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
