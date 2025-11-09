drop database if exists CombanyDB;
create database CombanyDB;
USE CombanyDB;

create table Employess(
	EmployessID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    FirstName NVARCHAR(255),
    LastName NVARCHAR(255),
    HireDate Date,
    Salary  int
);

alter table Employess
add Deparment NVARCHAR(50);

alter table Employess
modify Salary DECIMAL(10,2);