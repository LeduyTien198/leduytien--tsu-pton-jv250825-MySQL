drop database if exists session05_4;
create database session5_4;
use session5_4;

create table products(
	productID int,
    productName varchar(100) not null,
    price decimal(10,2) not null
);
insert into products(productName, price)
values
('productName11111', 1000),
('productName22223', 2230000);
select * from products;

-- MAX
select *
from products where price = (select max(price) from products);
-- MIN
select * from products where price = (select min(price) from products);

