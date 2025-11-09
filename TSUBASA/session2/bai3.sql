DROP DATABASE IF EXISTS BAI3;
CREATE DATABASE BAI3;
USE BAI3;

DROP TABLE IF EXISTS Departments;
CREATE TABLE Departments(
	DepartmentID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees(
	EmployeesID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    EmployeesName NVARCHAR(50),
    Address NVARCHAR(255),
    Phone CHAR(10),
    DepartmentID INT UNSIGNED,
    Salary DECIMAL(10,2),
    FOREIGN KEY(DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Departments (DepartmentName)
VALUES 
('IT'),
('HR'),
('Finance'),
('Marketing'),
('Sales');

INSERT INTO Employees (EmployeesName, Address, Phone,Salary, DepartmentID)
VALUES
('Nguyen Van A', 'Tokyo, Japan', '0901234567',1000, 1),  
('Tran Thi B', 'Osaka, Japan', '0807654321',2000, 2),   
('Le Van C', 'Nagoya, Japan', '0701112223',3000, 3),    
('Pham Thi D', 'Fukuoka, Japan', '0603334445',4000, 4), 
('Nguyen Van E', 'Sapporo, Japan', '0505556667',5000, 5); 


-- Truy vấn tất cả nhân viên thuộc phòng ban cụ thể.

SELECT * FROM Departments;
SELECT e.EmployeesID, e.EmployeesName, e.Address, e.Phone, d.DepartmentName
FROM Employees e	JOIN Departments d
ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName = 'IT';

-- Cập nhật thông tin lương của 1 nhân viên
UPDATE Employees
SET Salary = 3000
WHERE EmployeesID = 2;
SELECT * FROM Employees;

-- Xóa tất cả nhân viên có mức lương thấp hơn một giá trị nhất định.
SET SQL_SAFE_UPDATES = 0;
DELETE FROM Employees
WHERE Salary < 3000;
SET SQL_SAFE_UPDATES = 1;