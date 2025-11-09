DROP DATABASE IF EXISTS Products;
CREATE DATABASE Products;
USE Products;

CREATE TABLE Products(
	ProductID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    ProductName NVARCHAR(255),
    Category NVARCHAR(50),
    Price DECIMAL(10,2),
    StockQuantity INT
);

INSERT INTO Products(ProductName, Category,Price,StockQuantity)
VALUE ('Điện thoại', 'Điện tử', 2000000, 10),
('Tủ lạnh', 'Điện gia dụng', 3000000, 20),
('Ti vi', 'Điện gia dụng', 4000000, 30);

Select * from Products;