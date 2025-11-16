--  Quản Lý Đơn Hàng và Khách Hàng
DROP DATABASE IF EXISTS QLDH_KH;
CREATE DATABASE QLDH_KH;
USE QLDH_KH;

CREATE TABLE Customers(
	CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    JoinDate DATE
);

CREATE TABLE Orders(
	OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID) ON DELETE CASCADE
);
-- Thêm 4 khách hàng vào bảng Customers.
INSERT INTO Customers(Name, Email, JoinDate) VALUES 
('Name 1', '1email1@gmail.com', '2025-11-12'),
('Name 2', '2email1@gmail.com', '2025-11-2'),
('Name 3', '3email1@gmail.com', '2025-11-1'),
('Name 4', '4email1@gmail.com', '2025-11-9'),
('Name 5', '5email1@gmail.com', '2025-11-10');
-- Thêm 5 đơn hàng vào bảng Orders với liên kết đến khách hàng.
INSERT INTO Orders(CustomerID, OrderDate, TotalAmount) VALUES
(1, '2025-11-13', 150.50),
(2, '2025-11-13', 200.00),
(3, '2025-11-14', 75.25),
(4, '2025-11-14', 300.00),
(5, '2025-11-15', 120.75);
-- Cập nhật tổng số tiền của đơn hàng có OrderID = 3 thành 350.00.
UPDATE Orders SET TotalAmount = 350.00 WHERE CustomerID = 2;
select * from Orders;
-- Cập nhật địa chỉ email của khách hàng có CustomerID = 2.
update Customers set Email = 'update@gmail.com' where CustomerID = 2;
select * from Customers;
-- Xóa khách hàng với CustomerID = 4 khỏi bảng Customers.
delete from Customers where CustomerID = 4;	 
select * from Customers;
-- Xóa đơn hàng với OrderID = 1 khỏi bảng Orders.
delete from Orders where OrderID = 1;	
select * from Orders;