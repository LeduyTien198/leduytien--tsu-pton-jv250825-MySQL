--  Quản lý Sản phẩm và Nhà cung cấp
DROP DATABASE IF EXISTS QLSP_NCC;
CREATE DATABASE QLSP_NCC;
USE QLSP_NCC;

CREATE TABLE Suppliers(
	SupplierID INT AUTO_INCREMENT PRIMARY KEY ,
    SupplierName VARCHAR(100) NOT NULL,
    ContactEmail VARCHAR(100) NOT NULL
);

CREATE TABLE Products(
 ProductID  INT AUTO_INCREMENT PRIMARY KEY,
ProductName  VARCHAR(100) NOT NULL,
SupplierID INT,
Price DECIMAL(10,2) NOT NULL,
Stock INT NOT NULL,
FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE
);

INSERT INTO Suppliers(SupplierName, ContactEmail) VALUES 
('SupplierName1', 'ContactEmail1'),
('SupplierName2', 'ContactEmail2'),
('SupplierName3', 'ContactEmail3'),
('SupplierName4', 'ContactEmail4');
INSERT INTO Products(ProductName,SupplierID,Price,Stock) VALUES
('ProductName1',1,10000,10),
('ProductName2',2,10000,20),
('ProductName3',3,10000,3),
('ProductName4',4,10000,4);

-- ------------------------------------------------------------
UPDATE Products SET Price = 45.99 WHERE ProductID = 2;
select * from Products;
-- -----------------------------------------------------------
UPDATE Suppliers SET SupplierName = 'UPDATE NAME' WHERE SupplierID = 1;
select * from Suppliers;
-- -----------------------------------------------------------
DELETE FROM Suppliers WHERE SupplierID = 3;
select * from Suppliers;
-- ----------------------------------------------
DELETE FROM Products WHERE ProductID = 4;
select * from Products;