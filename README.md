Eatify: A Unified Food Ordering and Restaurant Management System

Eatify is a comprehensive full-stack application designed to simulate a modern food ordering platform. It bridges the gap between customers and multiple restaurants, featuring secure user authentication, dynamic real-time discount application, efficient order processing, and advanced business intelligence reporting.

Features

Customer Features

1) Secure Authentication: User registration and login using industry-standard bcrypt password hashing.

2) Menu Browsing: View dishes grouped by restaurant with category tags.

3) Price Comparison: A dedicated page to compare prices (including active discounts) for the same dish across multiple restaurants.

4) Efficient Ordering: Add multiple items to a cart and place an order seamlessly.

5) Automated Discounting: The system automatically identifies and applies the best currently active offer for any dish at the time of order entry.

6) Payment Processing: Simulate payment using the final calculated, discounted order amount.

Admin/DBMS Features

1) Role-Based Access Control (RBAC): Restricts access to sensitive pages (/customers, /reports) to users with the admin role.

2) Centralized Business Logic: Core transactional and analytical logic is handled via Stored Procedures and Functions (TPF) in the database layer.

3) Data Integrity: Implemented Triggers to enforce business rules, such as preventing orders with zero or negative quantities.

4) Advanced Reporting: Generate dynamic visual reports on key business metrics:

  a) Total Sales Revenue per Restaurant.

  b) Identification of "High Spenders" (customers who spend above the average payment amount).

  c) Orders where active offers were successfully applied.
  
Technologies Used

| Category       | Component                | Detail                                                                        |
| -------------- | ------------------------ | ----------------------------------------------------------------------------- |
| Database       | MySQL                    | Relational data persistence, DDL, DML, TPF (Procedures, Functions, Triggers). |
| Backend        | Python 3.x               | Core language.                                                                |
| Web Framework  | Flask                    | Handling routing, sessions, and database integration.                         |
| Authentication | Flask-Login & bcrypt     | User session management and secure password hashing.                          |
| Reporting      | Matplotlib               | Generating dynamic sales and customer behavior charts server-side.            |
| Frontend       | HTML/Jinja2, Bootstrap 5 | UI structure and responsive styling.                                          |

Database Schema and Logic

| Table Name  | Primary Key (PK) | Foreign Keys (FK)           | Core Purpose                                                      |
| ----------- | ---------------- | --------------------------- | ----------------------------------------------------------------- |
| Customer    | customer_id      | -                           | User profile and authentication.                                  |
| Category    | category_id      | -                           | Particular Category to which the dish belongs to.                  |
| Restaurant  | restaurant_id    | -                           | Restaurant details.                                               |
| Dish        | dish_id          | category_id, restaurant_id  | Menu items and base pricing.                                      |
| Offer       | offer_id         | dish_id                     | Time-sensitive discount percentages.                              |
| Orders      | order_id         | customer_id                 | Transaction header and status tracking.                           |
| Orders_Item | order_item_id    | order_id, dish_id, offer_id | Line items of an order, capturing the price at the time of order. |
| Payment     | order_id         | -                           | Final calculated payment amount and method.                       |


The database follows a normalized relational model (3NF) to ensure data consistency and efficiency.

Key Stored Routines (TPF)

1) get_discounted_price(p_dish_id) (Function): Calculates the unit price after finding and applying the maximum active discount using date range checking (CURDATE() BETWEEN start_date AND end_date).

2) add_order_item(p_order_id, p_dish_id, p_quantity) (Procedure): Inserts an order item and links the offer_id of the best active discount found by dynamically querying the Offer table.

3) process_payment(p_order_id, p_payment_type) (Procedure): Computes the final total amount for the entire order (summing up all discounted line items), records the payment, and updates the order status to 'Completed'.

4) get_high_spenders() (Procedure): Performs complex aggregation to identify customers whose total spent exceeds the average spent across all orders.

Setup and Installation

Follow these steps to get the Eatify system running locally.

1. Database Setup (MySQL)

  a) Start MySQL Server: Ensure your MySQL server is running.

  b) Create Schema and Tables: Execute the contents of your DDL file (CREATE DATABASE Eatify; and all CREATE TABLE statements).

  c) Insert Data: Execute the DML file to populate the database with initial restaurants, dishes, customers, and sample orders.

  d) Create Routines: Execute the contents of your TPF file (Triggers, Procedures, and Functions).

2. Python Environment Setup

Clone the Repository:

git clone https://github.com/als1810/Eatify.git
cd Eatify

Create Virtual Environment:

python -m venv venv
source venv/bin/activate # On Windows, use `venv\Scripts\activate`

Install Dependencies:

pip install Flask flask-login mysql-connector-python bcrypt matplotlib

3. Configure Database Connection
   
Create a file named db_config.py in the root directory.

Update the connection details using your MySQL credentials:
