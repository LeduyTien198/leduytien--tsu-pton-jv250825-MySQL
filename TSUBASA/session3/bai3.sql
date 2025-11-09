DROP DATABASE IF EXISTS QuanLyCuaHang;
CREATE DATABASE QuanLyCuaHang;
USE QuanLyCuaHang;

CREATE TABLE SanPham (
    MaSP INT  UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    TenSP VARCHAR(100) NOT NULL,      
    Gia DECIMAL(10,2),    
    SoLuongTon INT DEFAULT 0
);

ALTER TABLE SanPham
ADD COLUMN MoTa Text;

INSERT INTO SanPham (MaSP, TenSP, Gia, SoLuongTon, MoTa)
VALUES
(1, 'Laptop Dell', 15000000.00, 5, 'Laptop cấu hình mạnh'),
(2, 'Chuột Logitech', 45000.00, 20, 'Chuột không dây'),
(3, 'Bàn phím cơ', 120000.00, 10, 'Bàn phím cơ RGB');

SELECT * FROM SanPham;
SELECT * 
FROM SanPham
WHERE Gia > 50000;
