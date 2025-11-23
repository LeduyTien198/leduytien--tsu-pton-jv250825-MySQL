DROP DATABASE IF EXISTS session8;
CREATE DATABASE session8;
USE session8;

CREATE TABLE promotions(
    promotionID INT PRIMARY KEY AUTO_INCREMENT,
    promotionName VARCHAR(255) NOT NULL,
    discountPercentage DECIMAL(10,2)
);

CREATE TABLE products(
    productID INT PRIMARY KEY AUTO_INCREMENT,
    productName VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    promotionID INT NOT NULL,
    FOREIGN KEY (promotionID) REFERENCES promotions(promotionID)
);

CREATE TABLE customers(
    customerID INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE orders(
    orderID INT PRIMARY KEY AUTO_INCREMENT,
    customerID INT,
    orderDate DATETIME,
    totalAmount DECIMAL(10,2),
    FOREIGN KEY (customerID) REFERENCES customers(customerID)
);

CREATE TABLE orderDetails(
    orderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    orderID INT NOT NULL,
    productID INT NOT NULL,
    quantity INT NOT NULL,
    unitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(orderID) REFERENCES orders(orderID),
    FOREIGN KEY(productID) REFERENCES products(productID)
);


CREATE TABLE sales(
    saleID INT PRIMARY KEY AUTO_INCREMENT,
    orderID INT,
    saleDate DATE,
    saleAmount DECIMAL(10,2),
    FOREIGN KEY(orderID) REFERENCES orders(orderID)
);

INSERT INTO promotions (promotionName, discountPercentage) VALUES
('No Discount', 0),
('New Year Sale', 15.50),
('Black Friday', 30.00);

INSERT INTO products (productName, price, promotionID) VALUES
('Laptop Dell', 1500.00, 3),
('iPhone 14', 1200.00, 2),
('AirPods Pro', 250.00, 1);

INSERT INTO customers (firstName, lastName, email) VALUES
('Nguyen', 'An', 'an.nguyen@gmail.com'),
('Tran', 'Binh', 'binh.tran@gmail.com'),
('Le', 'Chi', 'chi.le@gmail.com');

INSERT INTO orders (customerID, orderDate, totalAmount) VALUES
(1, '2025-11-01 10:30:00', 1500.00),
(2, '2025-11-02 15:20:00', 1450.00),
(3, '2025-11-03 09:45:00', 250.00);

INSERT INTO orderDetails (orderID, productID, quantity, unitPrice) VALUES
(1, 1, 1, 1500.00),
(2, 2, 1, 1200.00),
(2, 3, 1, 250.00);

INSERT INTO sales (orderID, saleDate, saleAmount) VALUES
(1, '2025-11-01', 1500.00),
(2, '2025-11-02', 1450.00),
(3, '2025-11-03', 250.00);

-- Xây dựng một stored procedure nhận đầu vào là
--  CustomerID, startDate, và endDate 
-- để tính tổng doanh thu của khách hàng trong khoảng thời gian đó.
-- Hãy tạo các bảng 
-- Customers, Products, Orders, Promotions, Sales 
-- trong cơ sở dữ liệu SalesDB và thêm chỉ số vào một số cột 
-- để cải thiện hiệu suất truy vấn.
-- Tạo stored procedure GetCustomerTotalRevenue với các tham số:
-- inCustomerID (INT) – ID của khách hàng.
-- inStartDate (DATE) – Ngày bắt đầu của khoảng thời gian.
-- inEndDate (DATE) – Ngày kết thúc của khoảng thời gian.
-- Procedure sẽ tính tổng doanh thu 
-- của khách hàng trong khoảng thời gian từ inStartDate đến inEndDate.
-- Procedure sẽ trả về tổng doanh thu.
-- Xóa procedure nếu đã tồn tại

DELIMITER $$
DROP PROCEDURE IF EXISTS GetCustomerTotalRevenue;

CREATE PROCEDURE GetCustomerTotalRevenue(
    IN inCustomerID INT,
    IN inStartDate DATE,
    IN inEndDate DATE
)
BEGIN
    -- Tính tổng doanh thu của khách hàng
    SELECT 
        c.customerID,
        CONCAT(c.firstName, ' ', c.lastName) AS customerName,
        SUM(s.saleAmount) AS totalRevenue
    FROM customers c
    JOIN orders o ON c.customerID = o.customerID
    JOIN sales s ON o.orderID = s.orderID
    WHERE c.customerID = inCustomerID
      AND s.saleDate BETWEEN inStartDate AND inEndDate
    GROUP BY c.customerID;
END $$

DELIMITER ;

CALL GetCustomerTotalRevenue(1, '2025-11-01', '2025-11-30');


-- luyen tap 2-------------------------------------------------
DROP PROCEDURE IF EXISTS GetCustomerTotalRevenue;
DELIMITER $$

CREATE PROCEDURE AddNewCustomer (
    IN firstName  varchar(50), 
    IN lastName  varchar(50),
    IN email  varchar(50)
)
BEGIN 
    INSERT INTO customers(firstName, lastName, email)
    values(firstName, lastName, email);
    
END $$

DELIMITER ;

CALL AddNewCustomer('Le', 'Tien', 'letien@gmail.com');
select * from customers;
-- luyen tap 3-------------------------------------------------
-- Tạo stored procedure UpdateOrderTotalAmount với các tham số:
-- inOrderID (INT) – ID của đơn hàng.
-- inNewTotalAmount (DECIMAL) – Tổng số tiền mới của đơn hàng.
-- Procedure sẽ cập nhật tổng số tiền của đơn hàng trong bảng Orders.

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateOrderTotalAmount;
CREATE PROCEDURE UpdateOrderTotalAmount(in inorderID int, in innewTotalAmount decimal(10,2))
BEGIN
	UPDATE orders
    SET totalAmount = innewTotalAmount
    WHERE orderID = inorderID;
END//
DELIMITER ;
CALL UpdateOrderTotalAmount(1, 500000.00);
select * from orders;

-- luyen tap 4-------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS DeleteOrderAndSales;

CREATE PROCEDURE DeleteOrderAndSales(
    IN inOrderID INT
)
BEGIN
	DELETE FROM orderDetails
    WHERE orderID = inOrderID;

    DELETE FROM sales
    WHERE orderID = inOrderID;

    DELETE FROM orders
    WHERE orderID = inOrderID;
END //

DELIMITER ;
CALL DeleteOrderAndSales(2);
SELECT * FROM orders;
-- -- luyen tap 5-------------------------------------------------
-- Tạo stored procedure GetMonthlyRevenueByCustomer với các tham số:
-- inCustomerID (INT) – ID của khách hàng.
-- inMonthYear (VARCHAR) – Tháng và năm để tính doanh thu (ví dụ: '2024-07')
-- Procedure sẽ tính tổng doanh thu của khách hàng trong tháng và năm được chỉ định.
-- Procedure sẽ trả về tổng doanh thu.
DROP PROCEDURE IF EXISTS GetMonthlyRevenueByCustomer;

DELIMITER $$

CREATE PROCEDURE GetMonthlyRevenueByCustomer(
    IN inCustomerID INT,
    IN inMonthYear VARCHAR(10)
)
BEGIN
    SELECT 
        c.customerID,
        CONCAT(c.firstName, ' ', c.lastName) AS customerName,
        SUM(s.saleAmount) AS totalRevenue
    FROM customers c
    JOIN orders o ON c.customerID = o.customerID
    JOIN sales s ON o.orderID = s.orderID
    WHERE c.customerID = inCustomerID
      AND DATE_FORMAT(s.saleDate, '%Y-%m') = inMonthYear
    GROUP BY c.customerID;
END $$

DELIMITER ;
CALL GetMonthlyRevenueByCustomer(1, '2025-11');

SELECT * FROM customers;