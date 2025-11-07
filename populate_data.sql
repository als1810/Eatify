USE Eatify;

DELETE FROM Orders_Item;
DELETE FROM Payment;
DELETE FROM Orders;
DELETE FROM Offer;
DELETE FROM Dish;
DELETE FROM Restaurant;
DELETE FROM Category;


-- CUSTOMERS
INSERT INTO Customer (first_name, last_name, DoB, email, phone_no, preferred_payment_type, password_hash, role) VALUES
('Alice', 'Johnson', '1990-05-15', 'alice@example.com', '1234567890', 'UPI', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPjYLC7Tkz5m', 'user'),  -- password: password
('Bob', 'Smith', '1985-03-22', 'bob@example.com', '0987654321', 'Credit Card', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPjYLC7Tkz5m', 'user'),
('Admin', 'User', '1980-01-01', 'admin@eatify.com', '1111111111', 'Cash', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPjYLC7Tkz5m', 'admin');
('Starters'),         -- id 1
('North Indian'),     -- id 2
('South Indian'),     -- id 3
('Desserts'),         -- id 4
('Beverages'),        -- id 5
('Snacks'),           -- id 6
('Salads'),           -- id 7
('Soups'),            -- id 8
('Breads'),           -- id 9
('Specials');         -- id 10


-- RESTAURANTS

-- Pure Veg Restaurants (IDs 1–5)
INSERT INTO Restaurant (restaurant_name, restaurant_category) VALUES
('Green Leaf', 'Pure Veg'),
('Spice Villa', 'Pure Veg'),
('Veggie Palace', 'Pure Veg'),
('Dosa Delight', 'Pure Veg'),
('Shuddh Swaad', 'Pure Veg');

-- Veg + Non-Veg Restaurants (IDs 6–10)
INSERT INTO Restaurant (restaurant_name, restaurant_category) VALUES
('The Grill House', 'Veg + Non-Veg'),
('Urban Tandoor', 'Veg + Non-Veg'),
('Curry Junction', 'Veg + Non-Veg'),
('Food Carnival', 'Veg + Non-Veg'),
('The Spice Yard', 'Veg + Non-Veg');

-- DISHES

-- Common Pure Veg Dishes (10 dishes) for each Veg Restaurant
-- Each of the 5 Veg restaurants will have these same dishes with slightly varied prices

INSERT INTO Dish (dish_name, unit_price, category_id, restaurant_id) VALUES
('Paneer Tikka', 230.00, 1, 1),
('Paneer Tikka', 240.00, 1, 2),
('Paneer Tikka', 235.00, 1, 3),
('Paneer Tikka', 245.00, 1, 4),
('Paneer Tikka', 250.00, 1, 5),

('Veg Biryani', 180.00, 2, 1),
('Veg Biryani', 190.00, 2, 2),
('Veg Biryani', 200.00, 2, 3),
('Veg Biryani', 195.00, 2, 4),
('Veg Biryani', 185.00, 2, 5),

('Masala Dosa', 110.00, 3, 1),
('Masala Dosa', 115.00, 3, 2),
('Masala Dosa', 120.00, 3, 3),
('Masala Dosa', 125.00, 3, 4),
('Masala Dosa', 130.00, 3, 5),

('Gulab Jamun', 90.00, 4, 1),
('Gulab Jamun', 85.00, 4, 2),
('Gulab Jamun', 95.00, 4, 3),
('Gulab Jamun', 100.00, 4, 4),
('Gulab Jamun', 80.00, 4, 5),

('Cold Coffee', 120.00, 5, 1),
('Cold Coffee', 115.00, 5, 2),
('Cold Coffee', 125.00, 5, 3),
('Cold Coffee', 130.00, 5, 4),
('Cold Coffee', 110.00, 5, 5),

('Spring Rolls', 160.00, 6, 1),
('Spring Rolls', 155.00, 6, 2),
('Spring Rolls', 165.00, 6, 3),
('Spring Rolls', 150.00, 6, 4),
('Spring Rolls', 170.00, 6, 5),

('Caesar Salad', 140.00, 7, 1),
('Caesar Salad', 145.00, 7, 2),
('Caesar Salad', 135.00, 7, 3),
('Caesar Salad', 150.00, 7, 4),
('Caesar Salad', 138.00, 7, 5),

('Tomato Soup', 100.00, 8, 1),
('Tomato Soup', 95.00, 8, 2),
('Tomato Soup', 105.00, 8, 3),
('Tomato Soup', 110.00, 8, 4),
('Tomato Soup', 90.00, 8, 5),

('Butter Naan', 60.00, 9, 1),
('Butter Naan', 55.00, 9, 2),
('Butter Naan', 65.00, 9, 3),
('Butter Naan', 70.00, 9, 4),
('Butter Naan', 58.00, 9, 5),

('Thali Deluxe', 250.00, 10, 1),
('Thali Deluxe', 260.00, 10, 2),
('Thali Deluxe', 255.00, 10, 3),
('Thali Deluxe', 265.00, 10, 4),
('Thali Deluxe', 270.00, 10, 5);

-- Veg + Non-Veg Restaurants: 20 dishes each (5x20 = 100)
-- Shared menu for all, with small price variations

INSERT INTO Dish (dish_name, unit_price, category_id, restaurant_id) VALUES
('Butter Chicken', 380.00, NULL, 6),
('Butter Chicken', 390.00, NULL, 7),
('Butter Chicken', 370.00, NULL, 8),
('Butter Chicken', 400.00, NULL, 9),
('Butter Chicken', 395.00, NULL, 10),

('Chicken Biryani', 420.00, NULL, 6),
('Chicken Biryani', 440.00, NULL, 7),
('Chicken Biryani', 430.00, NULL, 8),
('Chicken Biryani', 410.00, NULL, 9),
('Chicken Biryani', 415.00, NULL, 10),

('Fish Curry', 460.00, NULL, 6),
('Fish Curry', 450.00, NULL, 7),
('Fish Curry', 465.00, NULL, 8),
('Fish Curry', 470.00, NULL, 9),
('Fish Curry', 455.00, NULL, 10),

('Egg Fried Rice', 180.00, NULL, 6),
('Egg Fried Rice', 190.00, NULL, 7),
('Egg Fried Rice', 175.00, NULL, 8),
('Egg Fried Rice', 185.00, NULL, 9),
('Egg Fried Rice', 180.00, NULL, 10),

('Paneer Butter Masala', 250.00, NULL, 6),
('Paneer Butter Masala', 260.00, NULL, 7),
('Paneer Butter Masala', 255.00, NULL, 8),
('Paneer Butter Masala', 265.00, NULL, 9),
('Paneer Butter Masala', 270.00, NULL, 10),

('Mutton Rogan Josh', 480.00, NULL, 6),
('Mutton Rogan Josh', 470.00, NULL, 7),
('Mutton Rogan Josh', 460.00, NULL, 8),
('Mutton Rogan Josh', 490.00, NULL, 9),
('Mutton Rogan Josh', 475.00, NULL, 10),

('Chicken 65', 250.00, NULL, 6),
('Chicken 65', 240.00, NULL, 7),
('Chicken 65', 260.00, NULL, 8),
('Chicken 65', 255.00, NULL, 9),
('Chicken 65', 245.00, NULL, 10),

('Veg Fried Rice', 160.00, NULL, 6),
('Veg Fried Rice', 170.00, NULL, 7),
('Veg Fried Rice', 155.00, NULL, 8),
('Veg Fried Rice', 165.00, NULL, 9),
('Veg Fried Rice', 158.00, NULL, 10),

('Gajar Halwa', 110.00, NULL, 6),
('Gajar Halwa', 115.00, NULL, 7),
('Gajar Halwa', 108.00, NULL, 8),
('Gajar Halwa', 120.00, NULL, 9),
('Gajar Halwa', 112.00, NULL, 10),

('Tandoori Roti', 25.00, NULL, 6),
('Tandoori Roti', 30.00, NULL, 7),
('Tandoori Roti', 28.00, NULL, 8),
('Tandoori Roti', 32.00, NULL, 9),
('Tandoori Roti', 26.00, NULL, 10);

-- OFFERS (Randomized)
-- Active offers between 2025-11-01 and 2025-12-31

INSERT INTO Offer (dish_id, start_date, end_date, percentage) VALUES
(1, '2025-11-01', '2025-12-31', 10.00),
(6, '2025-11-01', '2025-11-20', 5.00),
(11, '2025-11-05', '2025-11-25', 8.00),
(16, '2025-11-10', '2025-12-10', 12.00),
(21, '2025-11-15', '2025-12-15', 15.00),
(26, '2025-11-01', '2025-12-31', 20.00),
(31, '2025-11-10', '2025-12-05', 18.00),
(36, '2025-11-12', '2025-11-30', 7.00),
(41, '2025-11-03', '2025-12-15', 9.00),
(46, '2025-11-05', '2025-12-20', 10.00),
(51, '2025-11-01', '2025-12-25', 10.00),
(56, '2025-11-01', '2025-12-31', 12.00),
(61, '2025-11-01', '2025-11-30', 15.00),
(66, '2025-11-10', '2025-12-10', 8.00),
(71, '2025-11-20', '2025-12-25', 5.00),
(76, '2025-11-01', '2025-11-30', 22.00),
(81, '2025-11-10', '2025-12-05', 25.00),
(86, '2025-11-01', '2025-12-31', 18.00),
(91, '2025-11-12', '2025-12-10', 10.00),
(96, '2025-11-05', '2025-12-15', 20.00);
