-- Create the database
CREATE DATABASE IF NOT EXISTS Eatify;
USE Eatify;

-- 1. Customer Table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    DoB DATE,
    email VARCHAR(100) UNIQUE,
    phone_no VARCHAR(15) UNIQUE,
    preferred_payment_type VARCHAR(20),
    password_hash VARCHAR(255),
    role ENUM('user', 'admin') DEFAULT 'user'
); 

-- 2. Restaurant Table
CREATE TABLE Restaurant (
    restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_name VARCHAR(100) NOT NULL,
    restaurant_category VARCHAR(50)
);

-- 3. Category Table
CREATE TABLE Category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL
);

-- 4. Dish Table
CREATE TABLE Dish (
    dish_id INT PRIMARY KEY AUTO_INCREMENT,
    dish_name VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    category_id INT,
    restaurant_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id),
    FOREIGN KEY (restaurant_id) REFERENCES Restaurant(restaurant_id)
);

-- 5. Offer Table
CREATE TABLE Offer (
    offer_id INT PRIMARY KEY AUTO_INCREMENT,
    dish_id INT,
    start_date DATE,
    end_date DATE,
    percentage DECIMAL(5,2),
    FOREIGN KEY (dish_id) REFERENCES Dish(dish_id)
);

-- 6. Orders Table 
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- 7. Payment Table
CREATE TABLE Payment (
    order_id INT PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL,
    payment_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_type VARCHAR(20),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- 8. Orders_Item Table (New name and Primary Key structure)
CREATE TABLE Orders_Item (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    dish_id INT,
    offer_id INT, 
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (dish_id) REFERENCES Dish(dish_id),
    FOREIGN KEY (offer_id) REFERENCES Offer(offer_id)
);