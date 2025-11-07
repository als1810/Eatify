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

    -- Insert into Orders_Item using the base price
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

-- Reset delimiter
DELIMITER ;