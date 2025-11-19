-- Bai 2: 
create database qlbh_b2_ss6;
use qlbh_b2_ss6;
create table customers(
	id int primary key auto_increment,
    name varchar(100) NOT NULL,
    email varchar(100) NOT NULL unique
);
create table categories(
	id int primary key auto_increment,
    name varchar(100) not null
);
create table products(
	id int primary key auto_increment,
    name varchar(100),
    price float,
    category_id int not null,
    foreign key(category_id) references categories(id)
);
create table orders(
	id int primary key auto_increment,
    customer_id int not null,
    order_date date,
    foreign key(customer_id) references customers(id)
);

create table order_detail(
	order_id int not null,
    product_id int not null,
    quantity int,
    price float,
    foreign key (order_id) references orders(id),
    foreign key (product_id) references products(id)
);
insert into customers(name,email) values
('A','a@gmail'),
('B','b@gmail'),
('C','c@gmail');

insert into categories(name) values
('AO'),('Quan'),('Mu');

insert into products(name,price,category_id) VALUES 
('Ao kaki',100,1),
('Ao 3 lo',30,1),
('quan 3 lo',50,2);

insert into orders (customer_id,order_date) VALUES 
(1,'2025-11-11'),
(2,'2025-12-11');

insert into order_detail(order_id,product_id,quantity,price) VALUES 
(1,1,1,100),
(2,1,1,100);

-- ONG A mua them 1 cai quan

insert into orders (customer_id,order_date) VALUES (1,'2025-11-12');
insert into order_detail(order_id,product_id,quantity,price) VALUES (3,3,1,50);
-- Liệt kê những khách hàng đã có ít nhất một đơn hàng.
SELECT distinct c.id,c.name,c.email FROM customers c JOIN orders o ON c.id = o.customer_id;
-- Tìm những khách hàng chưa từng đặt đơn hàng nào.
SELECT id,name,email FROM customers WHERE id NOT IN (SELECT customer_id FROM orders);
-- Tính toán tổng doanh thu mà mỗi khách hàng đã mang lại.
SELECT c.id,c.name,c.email, IFNULL(SUM(od.quantity * od.price),0) AS total_revenue
FROM customers c 
left JOIN orders o ON c.id = o.customer_id 
left JOIN order_detail od ON o.id = od.order_id
group by c.id,c.name,c.email;
-- Xác định khách hàng đã mua sản phẩm có giá cao nhất.
SELECT distinct c.id,c.name,c.email, p.name, p.price
FROM customers c 
JOIN orders o ON c.id = o.customer_id 
JOIN order_detail od ON o.id = od.order_id
JOIN products p ON od.product_id = p.id
WHERE p.price = (select max(price) from products);


-- thuc hanh 3 
-- Tìm các sản phẩm có giá nằm trong một khoảng cụ thể.
select * from products where price between 30 and 60;
-- Tìm các sản phẩm có tên chứa một chuỗi ký tự nhất định.
select * from products where name LIKE 'quan_3_lo';
-- Tính giá trung bình của sản phẩm cho mỗi danh mục.
select c.id, c.name, avg(p.price) as tien_TB
from customers c
join products p
on c.id = p.category_id
group by  c.id, c.name;
 
-- sTìm những sản phẩm có giá cao hơn mức giá trung bình của toàn bộ sản phẩm.
select *
from products 
where price > ( select avg(price) from products);

-- Tìm sản phẩm có giá thấp nhất cho từng danh mục.
select c.id,c.name,p.name,p.price
from products p
join categories c
on p.category_id = c.id
where p.price = (
	select min(p2.price) 
    from products p2
    where p2.category_id = c.id
);


-- ---------------------------------------------------------------------------------
-- thuc hanh 4
-- Thêm một đơn hàng mới vào bảng orders 
-- và chi tiết của đơn hàng đó vào bảng order_details.
insert into orders(customer_id,order_date) values 
(2,'2025-11-19');
insert into order_detail(order_id,product_id,quantity,price)
values (3,2,1,999);
-- Tính tổng doanh thu của toàn bộ cửa hàng.
select sum(quantity * price) as tong
  from order_detail;
-- Tính doanh thu trung bình của mỗi đơn hàng.
select AVG(price) from order_detail;
-- Tìm và hiển thị thông tin của đơn hàng có doanh thu cao nhất.
select 
