-- BÀI 2-- -------------------------------------- ------------------------------------
drop database if exists session05_2;
create database session5_2;
use session5_2;

create table products(
	productID int auto_increment primary key,
	productName varchar(100) not null,
	unitPrice DECIMAL(10,2) not null,
	stock int not null
);

create table sales(
	saleID int auto_increment primary key,
	productID int,
    saleDate date not null,
    quantity int not null,
    amount decimal(10,2) not null,
    foreign key(productID) references products(productID)
);

INSERT INTO products (productName, unitPrice, stock)
VALUES 
('Sản phẩm A', 150000, 20),
('Sản phẩm B', 250000, 15);
INSERT INTO sales (productID, saleDate, quantity, amount)
VALUES
(1, '2025-02-10', 2, 300000),
(2, '2025-02-10', 1, 250000);
select productID, count(saleID)
from sales 
group by productID;