drop database if exists session05_5;
create database session5_5;
use session5_5;

create table products(
	productID int auto_increment primary key,
    productName varchar(100) not null
);
create table orderDateils(
	orderDatailID int auto_increment primary key,
    productID int not null,
    quantity int not null,
    price decimal(10,2) not null,
    foreign key (productID) references products(productID)
);

insert into products(productName) values
('Sản phẩm A'),
('Sản phẩm B');

insert into orderDateils(productID, quantity, price) values
(1, 5, 100.00),  
(2, 3, 200.00); 
-- Viết truy vấn để lấy danh sách các sản phẩm cùng với tổng số lượng bán được, sắp xếp theo số lượng bán giảm dần.

select p.productID, p.productName, sum(od.quantity) as SL_bán_được
from products p
join orderDateils od on p.productID = od.productID
group by p.productID, productName
order by SL_bán_được desc;