-- BAI 1234
DROP DATABASE IF EXISTS Bai4_1_2_3;
CREATE DATABASE Bai4_1_2_3;
USE Bai4_1_2_3;

CREATE TABLE Students(
	StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name NVARCHAR(255),
	Age INT NOT NULL,
    Major NVARCHAR(100)
);
-- ---------------------------
-- bai 1, taoj bang
INSERT INTO Students (Name, Age, Major) VALUES 
('Alice', 20, 'Computer Science'),
('Alice', 22, 'Mathematics'),
('Alice', 21, 'Physics');
SELECT * FROM Students;
-- -------------------------------------
-- 
-- bai 2 cap nhat tuoi id = 2 ==> 23
UPDATE Students
SET Age = 23
WHERE StudentID = 2; 
SELECT * FROM Students;

 
-- -----------------------------------------
-- bai 3 xoa sinh vien id = 1 khoi bang
DELETE FROM Students 
WHERE StudentID = 1;
SELECT * FROM Students;


