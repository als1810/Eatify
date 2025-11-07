USE Eatify;

-- Insert into Customer (10 entries)
INSERT INTO Customer (first_name, last_name, DoB, email, phone_no, preferred_payment_type, password_hash, role) VALUES
('Arjun', 'Mehta', '1995-04-12', 'arjun.mehta@example.com', '9876543210', 'UPI', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'user'), -- id 1
('Priya', 'Sharma', '1998-09-23', 'priya.sharma@example.com', '9876501234', 'Credit Card', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'user'), -- id 2
('Ravi', 'Kumar', '1990-12-15', 'ravi.kumar@example.com', '9823456789', 'Cash', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'user'), -- id 3
('Sneha', 'Patil', '1997-06-10', 'sneha.patil@example.com', '9812345678', 'Debit Card', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'user'), -- id 4
('Karan', 'Singh', '1992-01-05', 'karan.singh@example.com', '9809876543', 'UPI', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'user'), -- id 5
('Neha', 'Verma', '1996-11-20', 'neha.verma@example.com', '9711223344', 'Credit Card', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'user'), -- id 6
('Amit', 'Dubey', '1988-03-01', 'amit.dubey@example.com', '9700998877', 'Cash', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'user'), -- id 7
('Tanya', 'Reddy', '2000-08-18', 'tanya.reddy@example.com', '9988776655', 'Debit Card', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'user'), -- id 8
('Rohit', 'Jain', '1994-05-25', 'rohit.jain@example.com', '9654321098', 'UPI', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'user'), -- id 9
('Kavita', 'Mishra', '1991-02-14', 'kavita.mishra@example.com', '9555443322', 'Credit Card', '$2b$12$x2eqksPwqxZa4BRe7DBL2ez/eS/E6DgZ49AtJ0X8Z4YAFjkHbc4d2', 'admin'); -- id 10

-- Insert into Restaurant (10 entries)
-- Insert into Restaurant (10 entries)
INSERT INTO Restaurant (restaurant_name, restaurant_category) VALUES
('Spice Hub', 'Veg'), -- id 1
('Tandoori Tales', 'Non-Veg'), -- id 2
('Curry House', 'Non-Veg'), -- id 3
('Pasta Palace', 'Veg'), -- id 4
('Sushi World', 'Non-Veg'), -- id 5
('Pizza Planet', 'Veg'), -- id 6
('Wok & Roll', 'Non-Veg'), -- id 7
('Dosa Delight', 'Veg'), -- id 8
('Biryani Bliss', 'Non-Veg'), -- id 9
('The Grilled Spot', 'Non-Veg'); -- id 10

-- Insert into Category (10 entries)
INSERT INTO Category (category_name) VALUES
('Starters'), -- id 1
('Main Course'), -- id 2
('Desserts'), -- id 3
('Beverages'), -- id 4
('Snacks'), -- id 5
('Salads'), -- id 6
('Soups'), -- id 7
('Breads'), -- id 8
('A La Carte'), -- id 9
('Specials'); -- id 10

-- Insert into Dish (10 entries)
INSERT INTO Dish (dish_name, unit_price, category_id, restaurant_id) VALUES
('Paneer Tikka', 250.00, 1, 1), -- dish_id = 1
('Butter Chicken', 400.00, 2, 2), -- dish_id = 2
('Chocolate Brownie', 180.00, 3, 3), -- dish_id = 3
('Cold Coffee', 120.00, 4, 4), -- dish_id = 4
('French Fries', 150.00, 5, 5), -- dish_id = 5
('Margherita Pizza', 350.00, 2, 6), -- dish_id = 6
('Chilli Garlic Noodles', 280.00, 9, 7), -- dish_id = 7
('Masala Dosa', 100.00, 5, 8), -- dish_id = 8
('Chicken Biryani', 450.00, 2, 9), -- dish_id = 9
('Grilled Sandwich', 200.00, 1, 10); -- dish_id = 10

-- Additional Dishes (20 more entries)
INSERT INTO Dish (dish_name, unit_price, category_id, restaurant_id) VALUES
('Veg Biryani', 200.00, 2, 1), -- dish_id = 11
('Chicken Tikka', 300.00, 1, 2), -- dish_id = 12
('Fish Curry', 350.00, 2, 3), -- dish_id = 13
('Pasta Alfredo', 250.00, 2, 4), -- dish_id = 14
('Sushi Rolls', 400.00, 1, 5), -- dish_id = 15
('Pepperoni Pizza', 400.00, 2, 6), -- dish_id = 16
('Kung Pao Chicken', 320.00, 2, 7), -- dish_id = 17
('Idli', 80.00, 5, 8), -- dish_id = 18
('Mutton Biryani', 500.00, 2, 9), -- dish_id = 19
('Steak', 600.00, 2, 10), -- dish_id = 20
('Paneer Butter Masala', 280.00, 2, 1), -- dish_id = 21
('Tandoori Chicken', 350.00, 1, 2), -- dish_id = 22
('Prawn Curry', 450.00, 2, 3), -- dish_id = 23
('Lasagna', 300.00, 2, 4), -- dish_id = 24
('Tempura', 350.00, 1, 5), -- dish_id = 25
('Veggie Pizza', 320.00, 2, 6), -- dish_id = 26
('Sweet and Sour Pork', 340.00, 2, 7), -- dish_id = 27
('Uttapam', 120.00, 5, 8), -- dish_id = 28
('Hyderabadi Biryani', 480.00, 2, 9), -- dish_id = 29
('Burger', 250.00, 1, 10); -- dish_id = 30

-- Duplicate dish names in different restaurants
INSERT INTO Dish (dish_name, unit_price, category_id, restaurant_id) VALUES
('Paneer Tikka', 260.00, 1, 4), -- dish_id = 31 (Veg restaurant)
('Paneer Tikka', 255.00, 1, 6), -- dish_id = 32 (Veg restaurant)
('Paneer Tikka', 245.00, 1, 8), -- dish_id = 33 (Veg restaurant)
('Cold Coffee', 125.00, 4, 1), -- dish_id = 34 (Veg restaurant)
('Cold Coffee', 115.00, 4, 6), -- dish_id = 35 (Veg restaurant)
('Cold Coffee', 130.00, 4, 8), -- dish_id = 36 (Veg restaurant)
('Margherita Pizza', 360.00, 2, 4), -- dish_id = 37 (Veg restaurant)
('Chicken Biryani', 460.00, 2, 2), -- dish_id = 38 (Non-Veg restaurant)
('Chicken Biryani', 455.00, 2, 3), -- dish_id = 39 (Non-Veg restaurant)
('Chicken Biryani', 470.00, 2, 5), -- dish_id = 40 (Non-Veg restaurant)
('Chicken Biryani', 465.00, 2, 7), -- dish_id = 41 (Non-Veg restaurant)
('Chicken Biryani', 475.00, 2, 10), -- dish_id = 42 (Non-Veg restaurant)
('Veg Biryani', 210.00, 2, 4), -- dish_id = 43 (Veg restaurant)
('Veg Biryani', 205.00, 2, 6), -- dish_id = 44 (Veg restaurant)
('Veg Biryani', 215.00, 2, 8), -- dish_id = 45 (Veg restaurant)
('Butter Chicken', 410.00, 2, 3), -- dish_id = 46 (Non-Veg restaurant)
('Butter Chicken', 405.00, 2, 7), -- dish_id = 47 (Non-Veg restaurant)
('Butter Chicken', 415.00, 2, 9), -- dish_id = 48 (Non-Veg restaurant)
('Masala Dosa', 105.00, 5, 1), -- dish_id = 49 (Veg restaurant)
('Masala Dosa', 110.00, 5, 4); -- dish_id = 50 (Veg restaurant)

-- Insert into Offer (10 entries)
-- NOTE: Dates are set in 2025. We will assume the 'current' time is 2025-11-05 for DML consistency.
INSERT INTO Offer (dish_id, start_date, end_date, percentage) VALUES
(1, '2025-10-01', '2025-11-30', 10.00), -- offer_id = 1 (Active)
(2, '2025-09-05', '2025-09-20', 15.00), -- offer_id = 2 (Expired)
(3, '2025-09-10', '2025-09-25', 20.00), -- offer_id = 3 (Expired)
(4, '2025-09-15', '2025-09-30', 5.00), -- offer_id = 4 (Expired)
(5, '2025-09-18', '2025-09-28', 12.00), -- offer_id = 5 (Expired)
(6, '2025-11-01', '2025-11-06', 10.00), -- offer_id = 6 (Active)
(7, '2025-08-01', '2025-08-31', 25.00), -- offer_id = 7 (Expired)
(8, '2025-10-01', '2025-11-30', 5.00), -- offer_id = 8 (Active)
(9, '2025-11-06', '2025-11-06', 30.00), -- offer_id = 9 (Future)
(10, '2025-07-01', '2025-07-31', 10.00); -- offer_id = 10 (Expired)

-- Additional Offers (10 more entries)
INSERT INTO Offer (dish_id, start_date, end_date, percentage) VALUES
(11, '2025-11-01', '2025-11-06', 15.00), -- offer_id = 11 (Active)
(12, '2025-10-15', '2025-10-31', 10.00), -- offer_id = 12 (Expired)
(13, '2025-11-05', '2025-11-06', 20.00), -- offer_id = 13 (Active)
(14, '2025-09-20', '2025-10-20', 5.00), -- offer_id = 14 (Expired)
(15, '2025-11-06', '2025-11-06', 25.00), -- offer_id = 15 (Active)
(16, '2025-10-01', '2025-11-15', 10.00), -- offer_id = 16 (Active)
(17, '2025-08-15', '2025-09-15', 15.00), -- offer_id = 17 (Expired)
(18, '2025-11-01', '2025-11-06', 8.00), -- offer_id = 18 (Active)
(19, '2025-11-06', '2025-11-06', 12.00), -- offer_id = 19 (Future)
(20, '2025-09-01', '2025-09-30', 18.00); -- offer_id = 20 (Expired)

-- Additional Offers for duplicate dishes (10 more entries)
INSERT INTO Offer (dish_id, start_date, end_date, percentage) VALUES
(21, '2025-11-01', '2025-11-06', 10.00), -- offer_id = 21 (Active)
(32, '2025-10-20', '2025-11-10', 5.00), -- offer_id = 22 (Active)
(23, '2025-11-05', '2025-11-06', 15.00), -- offer_id = 23 (Active)
(34, '2025-09-25', '2025-10-25', 8.00), -- offer_id = 24 (Expired)
(25, '2025-11-06', '2025-11-06', 12.00), -- offer_id = 25 (Active)
(36, '2025-10-01', '2025-11-01', 10.00), -- offer_id = 26 (Expired)
(27, '2025-11-06', '2025-11-06', 20.00), -- offer_id = 27 (Active)
(38, '2025-08-20', '2025-09-20', 15.00), -- offer_id = 28 (Expired)
(29, '2025-11-01', '2025-11-06', 10.00), -- offer_id = 29 (Active)
(30, '2025-11-06', '2025-11-06', 25.00); -- offer_id = 30 (Future)

-- Insert into Orders (10 entries)
INSERT INTO Orders (customer_id, status, order_time) VALUES
(1, 'Completed', '2025-10-15 10:00:00'), -- order_id = 1 (Offer 1 active)
(2, 'Completed', '2025-09-18 11:30:00'), -- order_id = 2 (Offer 2 active)
(3, 'Pending',   '2025-09-22 12:45:00'), -- order_id = 3 (Offer 3 active)
(4, 'Completed', '2025-09-25 13:00:00'), -- order_id = 4 (Offer 4 active)
(5, 'Completed', '2025-09-26 14:15:00'), -- order_id = 5 (Offer 5 active)
(6, 'Completed', '2025-11-03 15:00:00'), -- order_id = 6 (Offer 6 active)
(7, 'Completed',   '2025-09-01 16:20:00'), -- order_id = 7 (Offer 7 expired, order placed after expiry)
(8, 'Completed', '2025-11-04 17:30:00'), -- order_id = 8 (Offer 8 active)
(9, 'Pending',   '2025-11-05 18:00:00'), -- order_id = 9 (Offer 9 future)
(10, 'Completed', '2025-10-20 19:10:00'); -- order_id = 10 (Offer 10 expired)

-- Additional Orders (10 more entries)
INSERT INTO Orders (customer_id, status, order_time) VALUES
(1, 'Completed', '2025-11-01 10:00:00'), -- order_id = 11
(2, 'Completed', '2025-11-02 11:00:00'), -- order_id = 12
(3, 'Pending', '2025-11-03 12:00:00'), -- order_id = 13
(4, 'Completed', '2025-11-04 13:00:00'), -- order_id = 14
(5, 'Completed', '2025-11-05 14:00:00'), -- order_id = 15
(6, 'Completed', '2025-11-06 15:00:00'), -- order_id = 16
(7, 'Completed', '2025-11-06 16:00:00'), -- order_id = 17
(8, 'Completed', '2025-11-06 17:00:00'), -- order_id = 18
(9, 'Pending', '2025-11-06 18:00:00'), -- order_id = 19
(10, 'Completed', '2025-11-06 19:00:00'); -- order_id = 20

-- Insert into Orders_Item (10 entries)
INSERT INTO Orders_Item (order_id, dish_id, offer_id, unit_price, quantity) VALUES
(1, 1, 1, 250.00, 1),    -- Order 1: Paneer Tikka (Offer 1 applied)
(2, 2, 2, 400.00, 1),    -- Order 2: Butter Chicken (Offer 2 applied)
(3, 3, 3, 180.00, 2),    -- Order 3: Brownie x2 (Offer 3 applied)
(4, 4, 4, 120.00, 1),    -- Order 4: Cold Coffee (Offer 4 applied)
(5, 5, 5, 150.00, 3),    -- Order 5: French Fries x3 (Offer 5 applied)
(6, 6, 6, 350.00, 2),    -- Order 6: Pizza x2 (Offer 6 applied)
(7, 7, NULL, 280.00, 1), -- Order 7: Noodles (No active offer at time of order, offer 7 was Aug)
(8, 8, 8, 100.00, 5),    -- Order 8: Dosa x5 (Offer 8 applied)
(9, 9, NULL, 450.00, 1), -- Order 9: Biryani (No active offer, offer 9 is future)
(10, 1, NULL, 250.00, 2); -- Order 10: Paneer Tikka x2 (No offer applied, offer 1 was Oct-Nov, order placed in Oct, but let's assume offer 1 only applies to first order item for simplicity in DML)

-- Additional Orders_Item (10 more entries)
INSERT INTO Orders_Item (order_id, dish_id, offer_id, unit_price, quantity) VALUES
(11, 11, 11, 200.00, 1), -- Order 11: Veg Biryani (Offer 11 applied)
(12, 12, 12, 300.00, 1), -- Order 12: Chicken Tikka (Offer 12 applied)
(13, 13, 13, 350.00, 2), -- Order 13: Fish Curry x2 (Offer 13 applied)
(14, 14, NULL, 250.00, 1), -- Order 14: Pasta Alfredo (No offer)
(15, 15, 15, 400.00, 1), -- Order 15: Sushi Rolls (Offer 15 applied)
(16, 16, 16, 400.00, 2), -- Order 16: Pepperoni Pizza x2 (Offer 16 applied)
(17, 17, NULL, 320.00, 1), -- Order 17: Kung Pao Chicken (No offer)
(18, 18, 18, 80.00, 3), -- Order 18: Idli x3 (Offer 18 applied)
(19, 19, NULL, 500.00, 1), -- Order 19: Mutton Biryani (No offer)
(20, 20, 20, 600.00, 1); -- Order 20: Steak (Offer 20 applied)

-- Insert into Payment (10 entries - Amounts calculated based on applied discount)
-- Order 1: 250 * 1 * (1 - 0.10) = 225.00 (UPI)
-- Order 2: 400 * 1 * (1 - 0.15) = 340.00 (Credit Card)
-- Order 3: 180 * 2 * (1 - 0.20) = 288.00 (Cash)
-- Order 4: 120 * 1 * (1 - 0.05) = 114.00 (Debit Card)
-- Order 5: 150 * 3 * (1 - 0.12) = 396.00 (UPI)
-- Order 6: 350 * 2 * (1 - 0.10) = 630.00 (Credit Card)
-- Order 7: 280 * 1 * (1 - 0.00) = 280.00 (Cash)
-- Order 8: 100 * 5 * (1 - 0.05) = 475.00 (Debit Card)
-- Order 9: 450 * 1 * (1 - 0.00) = 450.00 (UPI)
-- Order 10: 250 * 2 * (1 - 0.00) = 500.00 (Credit Card)
INSERT INTO Payment (order_id, amount, payment_type) VALUES
(1, 225.00, 'UPI'),
(2, 340.00, 'Credit Card'),
(3, 288.00, 'Cash'),
(4, 114.00, 'Debit Card'),
(5, 396.00, 'UPI'),
(6, 630.00, 'Credit Card'),
(7, 280.00, 'Cash'),
(8, 475.00, 'Debit Card'),
(9, 450.00, 'UPI'),
(10, 500.00, 'Credit Card');

-- Additional Payments (10 more entries)
INSERT INTO Payment (order_id, amount, payment_type) VALUES
(11, 170.00, 'UPI'),        -- Order 11: 200 * 1 * (1 - 0.15) = 170.00
(12, 270.00, 'Credit Card'), -- Order 12: 300 * 1 * (1 - 0.10) = 270.00
(13, 560.00, 'Cash'),       -- Order 13: 350 * 2 * (1 - 0.20) = 560.00
(14, 250.00, 'Debit Card'), -- Order 14: 250 * 1 * (1 - 0.00) = 250.00
(15, 300.00, 'UPI'),        -- Order 15: 400 * 1 * (1 - 0.25) = 300.00
(16, 720.00, 'Credit Card'), -- Order 16: 400 * 2 * (1 - 0.10) = 720.00
(17, 320.00, 'Cash'),       -- Order 17: 320 * 1 * (1 - 0.00) = 320.00
(18, 220.80, 'Debit Card'), -- Order 18: 80 * 3 * (1 - 0.08) = 220.80
(19, 500.00, 'UPI'),        -- Order 19: 500 * 1 * (1 - 0.00) = 500.00
(20, 492.00, 'Credit Card'); -- Order 20: 600 * 1 * (1 - 0.18) = 492.00