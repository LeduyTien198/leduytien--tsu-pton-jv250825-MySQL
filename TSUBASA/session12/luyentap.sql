DROP DATABASE IF EXISTS ecommerce;
CREATE DATABASE ecommerce;
USE ecommerce;
-- Bảng customers (Khách hàng)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng orders (Đơn hàng)
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- Bảng products (Sản phẩm)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng order_items (Chi tiết đơn hàng)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Bảng inventory (Kho hàng)
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- Bảng payments (Thanh toán)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash') NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);


INSERT INTO customers (name, email, phone, address) VALUES
('Nguyen Van A', 'a.nguyen@example.com', '0901234567', 'Hanoi, Vietnam'),
('Tran Thi B', 'b.tran@example.com', '0912345678', 'Ho Chi Minh , Vietnam'),
('Le Van C', 'c.le@example.com', '0923456789', 'Da Nang, Vietnam');
INSERT INTO products (name, price, description) VALUES
('Laptop Dell XPS 13', 1200.00, 'Laptop cao cấp, mỏng nhẹ, cấu hình mạnh'),
('iPhone 15', 999.00, 'Điện thoại iPhone 15 chính hãng'),
('Tai nghe Sony WH-1000XM5', 350.00, 'Tai nghe chống ồn cao cấp'),
('Bàn phím cơ Logitech', 120.00, 'Bàn phím cơ dùng cho game và văn phòng');
INSERT INTO inventory (product_id, stock_quantity) VALUES
(1, 50),
(2, 100),
(3, 30),
(4, 75);
INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 1350.00, 'Completed'),
(2, 999.00, 'Pending'),
(3, 470.00, 'Completed');
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1200.00),
(1, 3, 1, 150.00),
(2, 2, 1, 999.00),
(3, 3, 1, 350.00),
(3, 4, 1, 120.00);
INSERT INTO payments (order_id, amount, payment_method, status) VALUES
(1, 1350.00, 'Credit Card', 'Completed'),
(2, 999.00, 'PayPal', 'Pending'),
(3, 470.00, 'Bank Transfer', 'Completed');

-- LUYEN TAP 1
-- Trigger BEFORE INSERT:
-- Tạo Trigger kiểm tra số lượng tồn kho trước khi thêm sản phẩm vào order_items. Nếu không đủ, báo lỗi SQLSTATE '45000'.
DROP TRIGGER IF EXISTS check_qty;
DELIMITER $$

CREATE TRIGGER check_qty
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;

    SELECT stock_quantity INTO current_stock
    FROM inventory
    WHERE product_id = NEW.product_id;

    IF current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ko du hang trong kho';
    END IF;
END$$

DELIMITER ;
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 1, 999, 1000);

-- Trigger AFTER INSERT:
-- Tạo Trigger cập nhật total_amount trong bảng orders sau khi thêm một sản phẩm mới vào order_items.
DROP TRIGGER IF EXISTS update_total_amount;
DELIMITER $$
CREATE TRIGGER update_total_amount
AFTER INSERT ON order_items 
FOR EACH ROW
	BEGIN
		UPDATE orders
        SET total_amount = total_amount + (new.price * new.quantity)
        WHERE order_id = NEW.order_id;
    END $$
DELIMITER ;
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 2, 3, 999.00);
SELECT total_amount FROM orders WHERE order_id = 1;

-- Trigger BEFORE UPDATE:
-- Tạo Trigger kiểm tra số lượng tồn kho trước khi cập nhật số lượng sản phẩm trong order_items.
--  Nếu không đủ, báo lỗi SQLSTATE '45000'.
DROP TRIGGER IF EXISTS check_total_amount;
DELIMITER $$
CREATE TRIGGER check_total_amount
BEFORE UPDATE ON order_items 
FOR EACH ROW
	BEGIN
		DECLARE stock int;
        
        SELECT stock_quantity INTO stock
        FROM inventory
        WHERE product_id = NEW.product_id;
        
        IF stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000' 
        SET message_text = 'Ko du hang trong kho de cap nhat so luong';
        END IF;
    END $$
DELIMITER ;
UPDATE order_items SET quantity = 5000 WHERE order_item_id = 1;

-- Trigger AFTER UPDATE:
-- Tạo Trigger cập nhật lại total_amount trong bảng orders khi số lượng hoặc giá của một sản phẩm trong order_items thay đổi.
DROP TRIGGER IF EXISTS update_total_amount_after_update;
DELIMITER $$
CREATE TRIGGER update_total_amount_after_update
AFTER UPDATE ON order_items 
FOR EACH ROW
	BEGIN
        declare new_total decimal(10,2);
        select sum(price * quantity ) into new_total
        from order_items
        where order_id = new.order_id;
        
        update orders
        set total_amount = new_total
        where order_id = new.order_id;
        
    END $$
DELIMITER ;
update order_items
set quantity = 3
where order_item_id = 1;
select * from order_items;

-- Trigger BEFORE DELETE:Tạo Trigger
--  ngăn chặn việc xóa một đơn hàng có trạng thái Completed trong bảng orders. Nếu cố gắng xóa, báo lỗi SQLSTATE '45000'.
 DROP TRIGGER IF EXISTS prevent_delete_completed_order;
DELIMITER $$

CREATE TRIGGER prevent_delete_completed_order
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Không thể xóa đơn hàng đã hoàn thành';
    END IF;
END$$

DELIMITER ;
DELETE FROM orders
WHERE order_id = 1;

-- Trigger AFTER DELETE:
-- Tạo Trigger hoàn trả số lượng sản phẩm vào kho (inventory) sau khi một sản phẩm trong order_items bị xóa.

DROP TRIGGER IF EXISTS restore_inventory_after_delete;
DELIMITER $$

CREATE TRIGGER restore_inventory_after_delete
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    UPDATE inventory
    SET stock_quantity = stock_quantity + OLD.quantity
    WHERE product_id = OLD.product_id;
END$$

DELIMITER ;
SELECT stock_quantity FROM inventory WHERE product_id = 1;
DELETE FROM order_items
WHERE order_item_id = 1;

-- ------------------------------------------------------------------------------------------------------------------
-- LUYEN TAP 2

-- Stored Procedure sp_create_order:

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_order$$

CREATE PROCEDURE sp_create_order(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE current_stock INT;
    DECLARE new_order_id INT;

    START TRANSACTION;

    SELECT stock_quantity INTO current_stock
    FROM inventory
    WHERE product_id = p_product_id
    FOR UPDATE;  

    -- Kiểm tra tồn kho
    IF current_stock < p_quantity THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Không đủ hàng trong kho để tạo đơn hàng';
    ELSE
        INSERT INTO orders(customer_id, total_amount, status)
        VALUES (p_customer_id, 0, 'Pending');

        SET new_order_id = LAST_INSERT_ID();

        INSERT INTO order_items(order_id, product_id, quantity, price)
        VALUES (new_order_id, p_product_id, p_quantity, p_price);

        UPDATE inventory
        SET stock_quantity = stock_quantity - p_quantity
        WHERE product_id = p_product_id;

        UPDATE orders
        SET total_amount = total_amount + (p_quantity * p_price)
        WHERE order_id = new_order_id;

        COMMIT;
    END IF;
END$$

DELIMITER ;
CALL sp_create_order(1, 2, 99, 999.00);




-- Stored Procedure sp_pay_order:


DELIMITER $$

DROP PROCEDURE IF EXISTS sp_pay_order$$

CREATE PROCEDURE sp_pay_order(
    IN p_order_id INT,
    IN p_payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash')
)
BEGIN
    DECLARE order_status VARCHAR(20);
    DECLARE total_amt DECIMAL(10,2);

    START TRANSACTION;

    SELECT status INTO order_status
    FROM orders
    WHERE order_id = p_order_id
    FOR UPDATE;  

    IF order_status <> 'Pending' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Đơn hàng không thể thanh toán';
    ELSE
        SELECT total_amount INTO total_amt
        FROM orders
        WHERE order_id = p_order_id;

        INSERT INTO payments(order_id, amount, payment_method, status, payment_date)
        VALUES (p_order_id, total_amt, p_payment_method, 'Completed', NOW());

        UPDATE orders
        SET status = 'Completed'
        WHERE order_id = p_order_id;

        COMMIT;
    END IF;
END$$

DELIMITER ;
CALL sp_pay_order(3, 'Credit Card');



-- Stored Procedure sp_cancel_order
	DELIMITER $$

	DROP PROCEDURE IF EXISTS sp_cancel_order$$

	CREATE PROCEDURE sp_cancel_order(
		IN p_order_id INT
	)
	BEGIN
		DECLARE order_status VARCHAR(20);

		START TRANSACTION;

		SELECT status INTO order_status
		FROM orders
		WHERE order_id = p_order_id
		FOR UPDATE;

		IF order_status <> 'Pending' THEN
			ROLLBACK;
			SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Đơn hàng không thể hủy';
		ELSE
			UPDATE inventory i
			JOIN order_items oi ON i.product_id = oi.product_id
			SET i.stock_quantity = i.stock_quantity + oi.quantity
			WHERE oi.order_id = p_order_id;

			DELETE FROM order_items
			WHERE order_id = p_order_id;

			UPDATE orders
			SET status = 'Cancelled'
			WHERE order_id = p_order_id;

			COMMIT;
		END IF;
	END$$

	DELIMITER ;

CALL sp_cancel_order(3);

-- -- ------------------------------------------------------------------------------------------------------------------
-- LUYEN TAP 3
DROP TABLE IF EXISTS order_logs;

CREATE TABLE order_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    old_status ENUM('Pending', 'Completed', 'Cancelled'),
    new_status ENUM('Pending', 'Completed', 'Cancelled'),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);
-- Tạo một Trigger có tên before_insert_check_payment.
--  Trigger này sẽ được kích hoạt trước khi chèn dữ liệu vào bảng payments. 
--  Nó sẽ kiểm tra xem số tiền thanh toán (amount) có khớp với tổng tiền đơn hàng (total_amount) hay không.
--  Nếu không khớp, Trigger sẽ báo lỗi SQLSTATE '45000'.

DROP TRIGGER IF EXISTS before_insert_check_payment;
DELIMITER $$

CREATE TRIGGER before_insert_check_payment
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE order_total DECIMAL(10,2);

    SELECT total_amount INTO order_total
    FROM orders
    WHERE order_id = NEW.order_id;

    IF NEW.amount <> order_total THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Số tiền thanh toán không khớp với tổng tiền đơn hàng';
    END IF;
END$$

DELIMITER ;

INSERT INTO payments(order_id, amount, payment_method, status)
VALUES (1, 1000.00, 'Credit Card', 'Completed');

--
-- Tạo Trigger AFTER UPDATE:
-- Tạo một Trigger có tên after_update_order_status. Trigger này sẽ được kích hoạt sau khi cập nhật trạng thái của đơn hàng trong bảng orders.
--  Nếu trạng thái có sự thay đổi (OLD.status khác NEW.status), Trigger sẽ tự động ghi log vào bảng order_logs.
DROP TRIGGER IF EXISTS after_update_order_status;
DELIMITER $$

CREATE TRIGGER after_update_order_status
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO order_logs(order_id, old_status, new_status)
        VALUES (NEW.order_id, OLD.status, NEW.status);
    END IF;
END$$

DELIMITER ;




