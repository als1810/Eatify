USE Eatify;

-- Insert into Customer (10 entries)
INSERT INTO Customer (first_name, last_name, DoB, email, phone_no, preferred_payment_type) VALUES
('Arjun', 'Mehta', '1995-04-12', 'arjun.mehta@example.com', '9876543210', 'UPI'), -- id 1
('Priya', 'Sharma', '1998-09-23', 'priya.sharma@example.com', '9876501234', 'Credit Card'), -- id 2
('Ravi', 'Kumar', '1990-12-15', 'ravi.kumar@example.com', '9823456789', 'Cash'), -- id 3
('Sneha', 'Patil', '1997-06-10', 'sneha.patil@example.com', '9812345678', 'Debit Card'), -- id 4
('Karan', 'Singh', '1992-01-05', 'karan.singh@example.com', '9809876543', 'UPI'), -- id 5
('Neha', 'Verma', '1996-11-20', 'neha.verma@example.com', '9711223344', 'Credit Card'), -- id 6
('Amit', 'Dubey', '1988-03-01', 'amit.dubey@example.com', '9700998877', 'Cash'), -- id 7
('Tanya', 'Reddy', '2000-08-18', 'tanya.reddy@example.com', '9988776655', 'Debit Card'), -- id 8
('Rohit', 'Jain', '1994-05-25', 'rohit.jain@example.com', '9654321098', 'UPI'), -- id 9
('Kavita', 'Mishra', '1991-02-14', 'kavita.mishra@example.com', '9555443322', 'Credit Card'); -- id 10

-- Insert into Restaurant (10 entries)
INSERT INTO Restaurant (restaurant_name, location) VALUES
('Spice Hub', 'Mumbai'), -- id 1
('Tandoori Tales', 'Delhi'), -- id 2
('Curry House', 'Bangalore'), -- id 3
('Pasta Palace', 'Chennai'), -- id 4
('Sushi World', 'Hyderabad'), -- id 5
('Pizza Planet', 'Pune'), -- id 6
('Wok & Roll', 'Kolkata'), -- id 7
('Dosa Delight', 'Mysore'), -- id 8
('Biryani Bliss', 'Lucknow'), -- id 9
('The Grilled Spot', 'Ahmedabad'); -- id 10

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

-- Insert into Offer (10 entries)
-- NOTE: Dates are set in 2025. We will assume the 'current' time is 2025-11-05 for DML consistency.
INSERT INTO Offer (dish_id, start_date, end_date, percentage) VALUES
(1, '2025-10-01', '2025-11-30', 10.00), -- offer_id = 1 (Active)
(2, '2025-09-05', '2025-09-20', 15.00), -- offer_id = 2 (Expired)
(3, '2025-09-10', '2025-09-25', 20.00), -- offer_id = 3 (Expired)
(4, '2025-09-15', '2025-09-30', 5.00), -- offer_id = 4 (Expired)
(5, '2025-09-18', '2025-09-28', 12.00), -- offer_id = 5 (Expired)
(6, '2025-11-01', '2025-12-15', 10.00), -- offer_id = 6 (Active)
(7, '2025-08-01', '2025-08-31', 25.00), -- offer_id = 7 (Expired)
(8, '2025-10-01', '2025-11-30', 5.00), -- offer_id = 8 (Active)
(9, '2025-12-01', '2025-12-31', 30.00), -- offer_id = 9 (Future)
(10, '2025-07-01', '2025-07-31', 10.00); -- offer_id = 10 (Expired)

-- Insert into Orders (10 entries)
INSERT INTO Orders (customer_id, status, order_time) VALUES
(1, 'Completed', '2025-10-15 10:00:00'), -- order_id = 1 (Offer 1 active)
(2, 'Completed', '2025-09-18 11:30:00'), -- order_id = 2 (Offer 2 active)
(3, 'Pending',   '2025-09-22 12:45:00'), -- order_id = 3 (Offer 3 active)
(4, 'Completed', '2025-09-25 13:00:00'), -- order_id = 4 (Offer 4 active)
(5, 'Cancelled', '2025-09-26 14:15:00'), -- order_id = 5 (Offer 5 active)
(6, 'Completed', '2025-11-03 15:00:00'), -- order_id = 6 (Offer 6 active)
(7, 'Shipped',   '2025-09-01 16:20:00'), -- order_id = 7 (Offer 7 expired, order placed after expiry)
(8, 'Completed', '2025-11-04 17:30:00'), -- order_id = 8 (Offer 8 active)
(9, 'Pending',   '2025-11-05 18:00:00'), -- order_id = 9 (Offer 9 future)
(10, 'Completed', '2025-10-20 19:10:00'); -- order_id = 10 (Offer 10 expired)

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

-- Insert into Payment (10 entries - Amounts calculated based on applied discount)
-- Order 1: 250 * 1 * (1 - 0.10) = 225.00 (UPI)
-- Order 2: 400 * 1 * (1 - 0.15) = 340.00 (Credit Card)
-- Order 3: 180 * 2 * (1 - 0.20) = 288.00 (Cash)
-- Order 4: 120 * 1 * (1 - 0.05) = 114.00 (Debit Card)
-- Order 5: 150 * 3 * (1 - 0.12) = 396.00 (UPI) - Cancelled, but payment recorded
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