DROP DATABASE IF EXISTS QuanLyThuVien;
CREATE DATABASE QuanLyThuVien;
USE QuanLyThuVien;

CREATE TABLE Sach (
    MaSach INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    TenSach VARCHAR(100) NOT NULL,
    NamXuatBan YEAR
);

CREATE TABLE TacGia (
    MaTacGia INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    TenTacGia VARCHAR(100) NOT NULL
);

CREATE TABLE Sach_TacGia (
    MaSach INT UNSIGNED,
    MaTacGia INT UNSIGNED,
    PRIMARY KEY (MaSach, MaTacGia),
    FOREIGN KEY (MaSach) REFERENCES Sach(MaSach) ON DELETE CASCADE,
    FOREIGN KEY (MaTacGia) REFERENCES TacGia(MaTacGia) ON DELETE CASCADE
);
INSERT INTO Sach (MaSach, TenSach, NamXuatBan)
VALUES
(1, 'Lap trinh Java', 2020),
(2, 'Co so du lieu', 2018);

INSERT INTO TacGia (MaTacGia, TenTacGia)
VALUES
(1, 'Nguyen Van A'),
(2, 'Tran Thi B');

INSERT INTO Sach_TacGia (MaSach, MaTacGia)
VALUES
(1, 1),
(1, 2),
(2, 1);


SELECT * FROM Sach;
SELECT * FROM TacGia;
SELECT * FROM Sach_TacGia;
