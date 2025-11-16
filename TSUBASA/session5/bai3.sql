-- BAI 3 Sử Dụng Hàm SUM và AVG
drop database if exists session05_3;
create database session5_3;
use session5_3;

create table Departments (
    departmentID int auto_increment primary key,
    departmentName varchar(100) not null
);

create table EmployeeSalaries(
	employeeID int auto_increment primary key,
    departmentID int not null,
    salary decimal(10,2) not null,
    foreign key(departmentID) references Departments(departmentID)
);

insert into Departments (departmentID, departmentName)
values
(1, 'Phòng Kế Toán'),
(2, 'Phòng Nhân Sự'),
(3, 'Phòng IT');

INSERT INTO EmployeeSalaries (departmentID, salary)
VALUES
(1, 4000),
(3, 4800),
(3, 5200);
select d.departmentID, d.departmentName, sum(e.salary), avg(e.salary)
from EmployeeSalaries e
join Departments d on e.departmentID = d.departmentID
group by d.departmentID, d.departmentName;

