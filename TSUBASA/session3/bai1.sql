DROP DATABASE IF EXISTS QuanLyCuaHang;
CREATE DATABASE QuanLyCuaHang;
USE QuanLyCuaHang;

CREATE TABLE KhachHang (
    MaKH INT  UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    TenKH VARCHAR(50) NOT NULL,
    NgaySinh DATE,
    DiaChi VARCHAR(100)
);

INSERT INTO KhachHang (MaKH, TenKH, NgaySinh, DiaChi)
VALUES
(1, 'Nguyen Van A', '1990-05-12', 'Hanoi'),
(2, 'Tran Thi B', '1985-08-20', 'Ho Chi Minh'),
(3, 'Le Van C', '2000-01-15', 'Da Nang');

SELECT * FROM KhachHang;
