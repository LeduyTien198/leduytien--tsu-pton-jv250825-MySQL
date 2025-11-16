 -- Quản Lý Hóa Đơn và Chi Tiết Hóa Đơn
DROP DATABASE IF EXISTS QLDH_CT_HD;
CREATE DATABASE QLDH_CT_HD;
USE QLDH_CT_HD;

CREATE TABLE Invoices(
	InvoiceID  INT AUTO_INCREMENT PRIMARY KEY,
    InvoiceDate datetime,
    CostomerName VARCHAR(100) NOT NULL
);

CREATE TABLE Products(
	ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);
CREATE TABLE InvoiceDetails(
	DetailID INT AUTO_INCREMENT PRIMARY KEY,
    InvoiceID  INT NOT NULL,
    ProductID INT NOT NULL,
    Quantiny INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY(InvoiceID) REFERENCES Invoices(InvoiceID)  ON DELETE CASCADE,
    FOREIGN KEY(ProductID) REFERENCES Products(ProductID)  ON DELETE CASCADE
);

INSERT INTO Products(ProductName, Price) VALUES
('Product A', 100.00),
('Product B', 200.50),
('Product C', 75.25);
select * from Products;
INSERT INTO Invoices(InvoiceDate, CostomerName) VALUES
('2025-11-13, 10:00:00', 'Customer 1'),
('2025-11-14, 15:30:00', 'Customer 2');
select * from Invoices;
INSERT INTO InvoiceDetails(InvoiceID, ProductID, Quantiny, Price) VALUES
(1, 1, 2, 100.00),  
(1, 2, 1, 200.50), 
(2, 2, 3, 200.50), 
(2, 3, 5, 75.25);

-- Cập nhật giá của sản phẩm có ProductID = 1 thành 55.00.
 update Products set Price = 55.00 where ProductID  = 1;
 select * from Products;
-- Cập nhật số lượng sản phẩm trong chi tiết hóa đơn có DetailID = 2 thành 10.
update InvoiceDetails set  Quantiny = 10 where DetailID = 2;
select * from InvoiceDetails;

-- Xóa sản phẩm với ProductID = 3 khỏi bảng Products.
	delete from Products where ProductID = 3;
    select * from Products;
-- Xóa chi tiết hóa đơn với DetailID = 1 khỏi bảng InvoiceDetails.
delete from InvoiceDetails where DetailID = 1; 
select * from InvoiceDetails;
 
-- Viết truy vấn để lấy tổng giá trị hóa đơn (giá * số lượng) của từng hóa đơn.
-- Viết truy vấn để lấy danh sách tất cả sản phẩm trong từng hóa đơn cùng với số lượng và giá.