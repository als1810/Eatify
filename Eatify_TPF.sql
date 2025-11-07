USE Eatify;

-- Change delimiter for routines
DELIMITER //

-- Trigger: Don't allow negative quantities
CREATE TRIGGER trg_check_quantity
BEFORE INSERT ON Orders_Item 
FOR EACH ROW
BEGIN
    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;
END//

-- Trigger: Don't allow invalid percentages
CREATE TRIGGER trg_check_offer
BEFORE INSERT ON Offer
FOR EACH ROW
BEGIN
    IF NEW.percentage < 0 OR NEW.percentage > 100 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Percentage must be between 0 and 100';
    END IF;
END//

-- Procedure: Place a new order
CREATE PROCEDURE place_order(
    IN p_customer_id INT,
    IN p_dish_id INT,
    IN p_quantity INT
)
-- Added SQL characteristic
READS SQL DATA
BEGIN
    DECLARE v_order_id INT;
    DECLARE v_unit_price DECIMAL(10,2);
    DECLARE v_offer_id INT DEFAULT NULL;
    DECLARE v_discount DECIMAL(5,2) DEFAULT 0;
    
    -- Insert into Orders
    INSERT INTO Orders (customer_id, status) 
    VALUES (p_customer_id, 'Pending');
    SET v_order_id = LAST_INSERT_ID();

    -- Get the current dish price
    SELECT unit_price INTO v_unit_price 
    FROM Dish 
    WHERE dish_id = p_dish_id;

    -- Find the best current offer
    SELECT offer_id, percentage
    INTO v_offer_id, v_discount
    FROM Offer
    WHERE dish_id = p_dish_id
      AND CURDATE() BETWEEN start_date AND end_date
    ORDER BY percentage DESC 
    LIMIT 1;

    -- Insert into Orders_Item
    INSERT INTO Orders_Item (order_id, dish_id, offer_id, unit_price, quantity)
    VALUES (v_order_id, p_dish_id, v_offer_id, v_unit_price, p_quantity);

    SELECT v_order_id AS new_order_id;
END //

-- Function: Get the discounted price for a dish
CREATE FUNCTION get_discounted_price(p_dish_id INT)
RETURNS DECIMAL(10,2)
-- Added SQL characteristics to fix Error 1418
READS SQL DATA
NOT DETERMINISTIC 
BEGIN
    DECLARE v_price DECIMAL(10,2);
    DECLARE v_discount DECIMAL(5,2) DEFAULT 0;

    SELECT unit_price INTO v_price
    FROM Dish
    WHERE dish_id = p_dish_id;

    -- Select the maximum current percentage discount for the dish
    SELECT MAX(percentage) INTO v_discount
    FROM Offer
    WHERE dish_id = p_dish_id
      AND CURDATE() BETWEEN start_date AND end_date;

    IF v_discount IS NULL THEN
        SET v_discount = 0;
    END IF;

    RETURN v_price - (v_price * v_discount / 100);
END//

-- Procedure: Add an order item with automatic offer application
CREATE PROCEDURE add_order_item(
    IN p_order_id INT,
    IN p_dish_id INT,
    IN p_quantity INT
)
READS SQL DATA
BEGIN
    DECLARE v_unit_price DECIMAL(10,2);
    DECLARE v_offer_id INT DEFAULT NULL;
    DECLARE v_discount DECIMAL(5,2) DEFAULT 0;
    
    -- Get the current dish price
    SELECT unit_price INTO v_unit_price 
    FROM Dish 
    WHERE dish_id = p_dish_id;

    -- Find the best current offer
    SELECT offer_id, percentage
    INTO v_offer_id, v_discount
    FROM Offer
    WHERE dish_id = p_dish_id
      AND CURDATE() BETWEEN start_date AND end_date
    ORDER BY percentage DESC 
    LIMIT 1;

    -- Insert into Orders_Item
    INSERT INTO Orders_Item (order_id, dish_id, offer_id, unit_price, quantity)
    VALUES (p_order_id, p_dish_id, v_offer_id, v_unit_price, p_quantity);
END //

-- Procedure: Process payment for an order
CREATE PROCEDURE process_payment(
    IN p_order_id INT,
    IN p_payment_type VARCHAR(20)
)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    
    -- Calculate total amount with discounts
    SELECT SUM(oi.unit_price * oi.quantity * (1 - COALESCE(o.percentage, 0)/100))
    INTO v_total
    FROM Orders_Item oi
    LEFT JOIN Offer o ON oi.offer_id = o.offer_id
    WHERE oi.order_id = p_order_id;
    
    -- Insert payment
    INSERT INTO Payment (order_id, amount, payment_type)
    VALUES (p_order_id, v_total, p_payment_type);
    
    -- Update order status
    UPDATE Orders SET status = 'Completed' WHERE order_id = p_order_id;
END //

-- Procedure: Get total sales per restaurant
CREATE PROCEDURE get_total_sales()
READS SQL DATA
BEGIN
    SELECT r.restaurant_name, SUM(p.amount) AS total_sales
    FROM Payment p
    JOIN Orders o ON p.order_id = o.order_id
    JOIN Orders_Item oi ON o.order_id = oi.order_id
    JOIN Dish d ON oi.dish_id = d.dish_id
    JOIN Restaurant r ON d.restaurant_id = r.restaurant_id
    GROUP BY r.restaurant_name
    ORDER BY total_sales DESC;
END //

-- Procedure: Get orders with offers applied
CREATE PROCEDURE get_orders_with_offers()
READS SQL DATA
BEGIN
    SELECT c.first_name, d.dish_name, o2.percentage AS discount, p.amount
    FROM Orders_Item oi
    JOIN Orders o ON oi.order_id = o.order_id
    JOIN Customer c ON o.customer_id = c.customer_id
    JOIN Dish d ON oi.dish_id = d.dish_id
    LEFT JOIN Offer o2 ON oi.offer_id = o2.offer_id
    JOIN Payment p ON o.order_id = p.order_id
    WHERE o2.offer_id IS NOT NULL;
END //

-- Procedure: Get high spenders
CREATE PROCEDURE get_high_spenders()
READS SQL DATA
BEGIN
    SELECT c.first_name, SUM(p.amount) AS total_spent
    FROM Customer c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN Payment p ON o.order_id = p.order_id
    GROUP BY c.customer_id
    HAVING total_spent > (SELECT AVG(amount) FROM Payment)
    ORDER BY total_spent DESC;
END //

-- Reset delimiter
DELIMITER ;