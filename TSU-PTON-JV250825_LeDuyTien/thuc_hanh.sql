drop database if exists thuc_hanh;
create database thuc_hanh;
use thuc_hanh;

create table Customer (
	customer_id varchar(5) primary key not null,
    customer_full_name varchar(100) not null,
    customer_email varchar(100) not null unique,
    customer_phone varchar(15) not null,
    customer_address varchar(255) not null
);

create table Room (
	room_id varchar(5) primary key not null,
    room_type varchar(50) not null,
    room_price decimal(10,2) not null,
    room_status varchar(20) not null,
	room_area int not null
);

create table Booking (
	booking_id int auto_increment primary key,
	customer_id varchar(5) not null,
    room_id varchar(5) not null,
    check_in_date date not null,
    check_out_date date not null,
    total_amount decimal(10,2),
    foreign key (customer_id) references Customer(customer_id),
	foreign key (room_id) references Room(room_id)
);

create table Payment (
	payment_id int auto_increment primary key,
    booking_id int not null,
    payment_method varchar(50) not null,
    payment_date date not null,
    payment_amount decimal(10,2) not null,
    foreign key (booking_id) references Booking(booking_id)
);

insert into Customer (customer_id,customer_full_name,customer_email,customer_phone,customer_address)
values 
('C001','Nguyen Anh Tu','tu.nguyen@example.com','0912345678','Hanoi, Vietnam'),
('C002','Tran Thi Mai','mai.tran@example.com','0923456789','Ho Chi Minh, Vietnam'),
('C003','Le Minh Hoang','hoang.le@example.com','0934567890','Danang, Vietnam'),
('C004','Pham Hoang Nam','nam.pham@example.com.com','0945678901','Hue, Vietnam'),
('C005','Vu Minh Thu','thu.vu@example.com','0956789012','Hai Phong, Vietnam');

insert into Room (room_id,room_type,room_price,room_status,room_area)
values
('R001','Single','100.0','Available',25),
('R002','Double','150.0','Booked',40),
('R003','Suite','250.0','Available',60),
('R004','Single','120.0','Booked',30),
('R005','Double','160.0','Available',35);

insert into Booking (customer_id,room_id,check_in_date,check_out_date,total_amount)
values 
('C001','R001','2025-03-01','2025-03-05','400.0'),
('C002','R002','2025-03-02','2025-03-06','600.0'),
('C003','R003','2025-03-03','2025-03-07','1000.0'),
('C004','R004','2025-03-04','2025-03-08','480.0'),
('C005','R005','2025-03-05','2025-03-09','800.0');

insert into Payment (booking_id, payment_method, payment_date, payment_amount)
values 
(1,'Cash','2025-03-05','400.0'),
(2,'Credit Card','2025-03-06','600.0'),
(3,'Bank Transfer','2025-03-07','1000.0'),
(4,'Cash','2025-03-08','480.0'),
(5,'Credit Card','2025-03-09','800.0');

-- 3. Cập nhật dữ liệu (6 điểm) Viết câu lệnh 
-- UPDATE để cập nhật lại total_amount trong bảng Booking theo công thức:
--  total_amount = room_price * (số ngày lưu trú).

-- 4. Xóa dữ liệu (6 điểm) Viết câu lệnh DELETE để xóa các thanh toán trong bảng Payment nếu:
--   - Phương thức thanh toán (payment_method) là "Cash".
--   - Và tổng tiền thanh toán (payment_amount) nhỏ hơn 500.
delete from Payment
where payment_method = 'Cash' and payment_amount < '500';

-- ---------------------------------------------------------------------------------------------------------------------


-- PHẦN 2: Truy vấn dữ liệu
-- 5. (3 điểm) Lấy thông tin khách hàng gồm mã khách hàng, họ tên, email, số điện thoại và địa chỉ được sắp xếp theo họ tên khách hàng tăng dần.
select *
from customer
order by customer_full_name asc;

-- 6. (3 điểm) Lấy thông tin các phòng khách sạn gồm mã phòng, loại room phòng, giá phòng và diện tích phòng, sắp xếp theo giá phòng giảm dần.
select  room_id, room_type, room_price, room_area
from room order by room_price desc;

-- 7. (3 điểm) Lấy thông tin khách hàng và phòng khách sạn đã đặt, gồm mã khách hàng, họ tên khách hàng, mã phòng, ngày nhận phòng và ngày trả phòng.
select c.customer_id, c.customer_full_name, b.room_id, b.check_in_date, b.check_out_date
from customer as c
join booking as b ON c.customer_id = b.customer_id;

-- 8. (3 điểm) Lấy danh sách khách hàng và tổng tiền đã thanh toán khi đặt phòng
-- gồm mã khách hàng, họ tên khách hàng, phương thức thanh toán và số tiền thanh toán, sắp xếp theo số tiền thanh toán giảm dần.
--  p.payment_method, p.payment_amount
select c.customer_id, c.customer_full_name, p.payment_method, p.payment_amount
from customer as c
join booking b on c.customer_id = b.customer_id
join payment p on b.booking_id = p.booking_id
order by p.payment_amount desc;


-- 9. (3 điểm) Lấy thông tin khách hàng từ vị trí thứ 2 đến thứ 4 trong bảng Customer được sắp xếp theo tên khách hàng.
select * from customer
order by customer_full_name asc 
limit 3 offset 1;

-- LAY DC VI TRI 2 > 4 NHUNG PHAI chuyen sang customer_id
select * from customer
order by customer_id asc 
limit 3 offset 1;


-- 10. (5 điểm) Lấy danh sách khách hàng đã đặt ít nhất 2 phòng và có tổng số tiền thanh toán trên 1000, gồm mã khách hàng, họ tên khách hàng và số lượng phòng đã đặt.
select c.customer_id, c.customer_full_name, count(b.room_id) as so_phong_da_dat
from booking b
join customer c on b.customer_id = c.customer_id
group by c.customer_id, c.customer_full_name
having count(b.room_id) >= 2 and sum(b.total_amount) > 1000;
-- 11. (5 điểm) Lấy danh sách các phòng có tổng số tiền thanh toán dưới 1000 và có ít nhất 3 khách hàng đặt, gồm mã phòng, loại phòng, giá phòng và tổng số tiền thanh toán.

-- 12. (5 điểm) Lấy danh sách các khách hàng có tổng số tiền thanh toán lớn hơn 1000, gồm mã khách hàng, họ tên khách hàng, mã phòng, tổng số tiền thanh toán.

-- 13. (6 điểm) Lấy danh sách các khách hàng Mã KH, Họ tên, Email, SĐT) có họ tên chứa chữ "Minh" hoặc địa chỉ (address) ở "Hanoi". 
-- Sắp xếp kết quả theo họ tên tăng dần.
select customer_id, customer_full_name, customer_email, customer_phone
from customer
where customer_full_name like '%Minh%' or customer_address like '%Hanoi%'
order by customer_full_name asc;

-- 14. (4 điểm)  Lấy danh sách tất cả các phòng (Mã phòng, Loại phòng, Giá), sắp xếp theo giá phòng giảm dần.
-- Hiển thị 5 phòng tiếp theo sau 5 phòng đầu tiên (tức là lấy kết quả của trang thứ 2, biết mỗi trang có 5 phòng).
select room_id, room_type, room_price
from room
order by room_price desc;

-- ---------------------------------------------------------------------------------------------------------------------


-- PHẦN 3: Tạo View
-- 15. (5 điểm) Hãy tạo một view để lấy thông tin các phòng và khách hàng đã đặt, với điều kiện ngày nhận phòng nhỏ hơn ngày 2025-03-10.
-- Cần hiển thị các thông tin sau: Mã phòng, Loại phòng, Mã khách hàng, họ tên khách hàng
create view view_room_customer as
select r.room_id, r.room_type , c.customer_id, c.customer_full_name
from room as r
join booking  as b on r.room_id = b.room_id
join customer as c on b.customer_id = b.customer_id
where check_in_date > 2025-03-10;
select * from view_room_customer;

-- 16. (5 điểm) Hãy tạo một view để lấy thông tin khách hàng và phòng đã đặt, với điều kiện diện tích phòng lớn hơn 30 m².
-- Cần hiển thị các thông tin sau: Mã khách hàng, Họ tên khách hàng, Mã phòng, Diện tích phòng

create view view_room_customer as
select c.customer_id, c.customer_full_name, r.room_id, r.room_area
from customer as c
join booking  as b on c.customer_id = b.customer_id
join room as r on r.room_id = b.room_id
where r.room_area > 30;

-- ---------------------------------------------------------------------------------------------------------------------


-- PHẦN 4: Tạo Trigger
-- 17. (5 điểm) Hãy tạo một trigger check_insert_booking để kiểm tra dữ liệu mối khi chèn vào bảng Booking.
-- Kiểm tra nếu ngày đặt phòng mà sau ngày trả phòng thì thông báo lỗi với nội dung 
-- “Ngày đặt phòng không thể sau ngày trả phòng được !” và hủy thao tác chèn dữ liệu vào bảng.

drop trigger if exists check_insert_booking;
delimiter $$
create trigger check_insert_booking
before insert on Booking
for each row
begin
	if new.check_in_date >= new.check_out_date then
    signal sqlstate '45000' set message_text =  'Ngày đặt phòng không thể sau ngày trả phòng được !';   
    end if;
end;
delimiter ;
insert into booking (customer_id,room_id,check_in_date,check_out_date,total_amount)
value('C002','R001','2025-03-02','2020-03-01','400.0');
select * from booking;



-- 18. (5 điểm) Hãy tạo một trigger có tên là update_room_status_on_booking để tự động cập nhật trạng thái phòng thành "Booked" khi một phòng được đặt 
-- (khi có bản ghi được INSERT vào bảng Booking).


-- ---------------------------------------------------------------------------------------------------------------------
-- PHẦN 5: Tạo Store Procedure
-- 19. (5 điểm) Viết store procedure có tên add_customer để thêm mới một khách hàng với đầy đủ các thông tin cần thiết.
drop procedure if exists add_customer;
delimiter $$

create procedure add_customer(
	in _customer_id varchar(5),
	in _customer_full_name varchar(100),
    in _customer_email varchar(100),
    in _customer_phone varchar(15),
    in _customer_address varchar(255))
begin
	insert into customer (customer_id,customer_full_name,customer_email,customer_phone,customer_address)
    values (_customer_id, _customer_full_name, _customer_email, _customer_phone, _customer_address);
end $$

delimiter ;
call add_customer('C006','Le Duy Tien','tien@gmail.com','0123456789','Hanoi, Vietnam');
select * from customer;


-- 20. (5 điểm) Hãy tạo một Stored Procedure  có tên là add_payment để thực hiện việc thêm một thanh toán mới cho một lần đặt phòng.
-- Procedure này nhận các tham số đầu vào:
-- - p_booking_id: Mã đặt phòng (booking_id).
-- - p_payment_method: Phương thức thanh toán (payment_method).
-- - p_payment_amount: Số tiền thanh toán (payment_amount).
-- - p_payment_date: Ngày thanh toán (payment_date).
drop procedure if exists add_payment;
delimiter $$

create procedure add_payment(
	in p_booking_id int,
	in p_payment_method varchar(100),
    in p_payment_amount decimal(10,2),
    in p_payment_date date)
begin
	insert into payment (booking_id,payment_method,payment_amount,payment_date)
    values (p_booking_id, p_payment_method, p_payment_amount, p_payment_date);
end $$

delimiter ;
call add_payment(5,'Cash','400.0','2025-03-09');
select * from payment;















