drop database if exists truyVanJoin;
create database truyVanJoin;
use truyVanJoin;

create table customers(
	customerID int auto_increment primary key,
    customerName varchar(100) Not null,
    contactEmail varchar(100) not null
);
create table orders(
	orderID int auto_increment primary key,
    customerID int not null,
    orderDate date not null,
    totalAmount decimal(10,2) not null,
    foreign key (customerID) references customers(customerID)
);

insert into customers(customerName, contactEmail)
values ('customerName1','contact1@gamil.com'),
('customerName2','contact2@gamil.com');
insert into orders(customerID, orderDate, totalAmount)
values(1,'2025-2-4',2000),
(2,'2025-2-4',40000);

-- Viết truy vấn để lấy danh sách các đơn hàng cùng với tên khách hàng và email của họ.
select orderID,orderDate,totalAmount,customerName,contactEmail
from orders as o
join customers c 
on o.customerID = c.customerID;

