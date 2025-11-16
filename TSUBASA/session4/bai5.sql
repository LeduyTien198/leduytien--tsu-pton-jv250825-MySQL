-- Quản lý dữ liệu Sinh viên và Môn học
DROP DATABASE IF EXISTS SS4_Bai5;
CREATE DATABASE SS4_Bai5;
USE SS4_Bai5;

CREATE TABLE Students(
	studentID INT AUTO_INCREMENT PRIMARY KEY,
	studentName VARCHAR(50) NOT NULL,
    major VARCHAR(50) NOT NULL
);

CREATE TABLE courses(
	coursesID INT  AUTO_INCREMENT PRIMARY KEY,
    coursesName VARCHAR(50) NOT NULL,
    instrutor VARCHAR(50) NOT NULL
);

INSERT INTO Students(studentName, major) VALUE 
('Students1', 'major1'),
('Students2', 'major2'),
('Students3', 'major3'),
('Students4', 'major4');
INSERT INTO courses(coursesName,instrutor)VALUES
('coursesName1','instrutor1'),
('coursesName2','instrutor2'),
('coursesName3','instrutor3'),
('coursesName4','instrutor4');
SELECT * FROM Students;
SELECT * FROM courses;
-- ---------------------------------------------------

UPDATE courses SET coursesName = 'Advanced Mathematics'
WHERE coursesID = 2;


UPDATE Students SET major = 'Engineering' WHERE studentID = 3;
-- ---------------------------------------------------

DELETE FROM Students WHERE StudentID = 1;
-- -------------------------------------
DELETE FROM courses WHERE coursesID = 3;

-- ----------------------------------------------------

