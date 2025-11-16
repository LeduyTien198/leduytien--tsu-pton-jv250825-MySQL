drop database if exists session6_1;
create database session6_1;
use session6_1;


create table categories(
	id int auto_increment primary key,
    name varchar(100)
);
create table products(
	id int auto_increment primary key,
    name varchar(100),
    price float(10,2),
    categoryID int not null,
    foreign key (categoryID) references categories(id)
);
-- Thêm 3 sản phẩm mới vào bảng products.

insert into categories(name)
values 
('name1'),
('name2'),
('name3'),
('name4');
insert into products(name,price, categoryID)
values
('sản phẩm 1123', 10045600, 2),
('sản phẩm 221', 10045600, 4),
('sản phẩm 41', 1002100, 1);
-- Cập nhật giá của một sản phẩm đã có.

update 
products set price = 1111
where id = 2;

-- Xóa một sản phẩm.
delete from products where id = 2;
-- Hiển thị tất cả sản phẩm, sắp xếp theo giá.
select * from products 
order by price desc;

-- Thống kê số lượng sản phẩm cho từng danh mục.
select c.name, count(p.id) 
from categories c
join products p 
on c.id = p.categoryID	group by c.id, c.name;


select * from products;
select * from  categories;
