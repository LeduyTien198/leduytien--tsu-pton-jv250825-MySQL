drop database if exists b_v_c_s;
create database b_v_c_s;
use b_v_c_s;

create table customers (
	customerID int auto_increment primary key,
    customerName varchar(100) not null,
    phone varchar(15),
    createdAt datetime
);
create table orders(
	orderID int auto_increment primary key,
    customerID int,
    totalAmount decimal(10,2) not null,
    foreign key(customerID) references customers(customerID)
);
create table products (
	productID int auto_increment primary key,
    productName varchar(255) not null,
    category varchar(255),
    price decimal(10,2) not null
);
create table orderDetails (
	orderDetailID int auto_increment primary key,
    orderID int,
    productID int,
    quantity int not null,
    unitPrice decimal(10,2) not null,
    foreign key(orderID) references orders(orderID),
	foreign key(productID) references products(productID)
);

INSERT INTO customers (customerName, phone, createdAt) VALUES
('Nguyễn Văn A', '0912345678', NOW()),
('Trần Thị B', '0987654321', NOW()),
('Lê Văn C', '0901234567', NOW());

INSERT INTO products (productName, category, price) VALUES
('Laptop Dell XPS 13', 'Electronics', 35000000.00),
('Bàn phím cơ Logitech', 'Accessories', 3500000.00),
('Chuột không dây', 'Accessories', 800000.00);

INSERT INTO orders (customerID, totalAmount) VALUES
(1, 38500000.00), 
(2, 800000.00),  
(1, 3500000.00);   
 INSERT INTO orderDetails (orderID, productID, quantity, unitPrice) VALUES
(1, 1, 1, 35000000.00),
(1, 2, 1, 3500000.00),
(2, 3, 1, 800000.00),
(3, 2, 1, 3500000.00);

-- Thêm chỉ số cho cột Email trong bảng Customers và cột OrderDate trong bảng Orders.
alter table customers add column email varchar(255);
alter table orders add column orderDate date;
select * from orders;
select * from customers;
update customers set email = 'upd@gmail.com' where customerID = 1;
-- ---------------------------------------------------------------------
-- co ban 2
-- Hãy tạo một view 
-- CustomerOrders với các cột: OrderID, CustomerName (họ và tên của khách hàng), OrderDate, TotalAmount
create view CustomerOrders as
select orderID, customerName, orderDate, totalAmount 
from orders o
join customers c on o.customerID = c.customerID;

select * from CustomerOrders;
-- ---------------------------------------------------------------------
-- co ban 3
create table orderItems (
	orderItemID int auto_increment primary key,
    orderID int,
    productID int,
    quantity int,
    price decimal(10,2),
       foreign key(orderID) references orders(orderID),
       foreign key(productID) references products(productID)
);
INSERT INTO orderItems (orderID, productID, quantity, price) VALUES
(2, 1, 1, 35000000.00),
(3, 2, 1, 3500000.00);
select * from orderItems;

-- co ban 4
-- Tạo một view CustomerOrders với các cột:
-- OrderID, CustomerName (họ và tên của khách hàng), OrderDate, TotalAmount 
-- Cập nhật TotalAmount cho đơn hàng có OrderID là 1 thành 250.00.
drop view customerOrders;
create view customerOrders as 
select orderID, customerName, orderDate, totalAmount
from customers c 
join orders od 
on c.customerID = od.customerID;
select * from customerOrders;
-- Cập nhật TotalAmount cho đơn hàng có OrderID là 1 thành 250.00.
update orders set TotalAmount = 250.00 where orderID = 1;
select * from orders;
-- ---------------------------------------------------------------------
-- co ban 6
create table sales (
	saleID int auto_increment primary key,
	orderID int not null,
	saleDate date,
	saleAmount decimal(10,2),
	foreign key(orderID) references orders(orderID)
);
INSERT INTO sales (orderID, saleDate, saleAmount) VALUES
(1, '2025-11-20', 250.00),
(2, '2025-11-21', 800.00);
-- Tạo chỉ số cho cột OrderDate trong bảng Orders và SaleDate trong bảng Sales
-- ......
-- Tạo view CustomerMonthlySales để tổng hợp doanh thu hàng tháng theo khách hàng, bao gồm:
-- CustomerID 	CustomerName	MonthYear (tháng và năm)	TotalSales (tổng doanh thu)
-- Truy vấn từ view CustomerMonthlySales để tìm các khách hàng có tổng doanh thu trong tháng
--  2024-07 lớn hơn 2000 và sắp xếp theo doanh thu giảm dần
create view CustomerMonthlySales as select CustomerID, CustomerName, MonthYear, TotalSales