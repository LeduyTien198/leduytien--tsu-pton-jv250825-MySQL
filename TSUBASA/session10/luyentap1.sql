drop database if exists SLSP;
create database SLSP;
USE SLSP;

CREATE TABLE products (
    productID INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(100),
    quantity INT
);

CREATE TABLE inventoryChanges (
    changeID INT AUTO_INCREMENT PRIMARY KEY,
    productID INT NOT NULL,
    oldQuantity INT,
    newQuantity INT,
    changeDate DATETIME,
    FOREIGN KEY (productID) REFERENCES products(productID)
);

INSERT INTO products (productName, quantity)
VALUES
('iPhone 15', 20),
('Laptop Dell XPS', 10),
('Sony Headphones', 30);

INSERT INTO inventoryChanges (productID, oldQuantity, newQuantity, changeDate)
VALUES
(1, 20, 18, NOW()),
(2, 10, 15, NOW()),
(3, 30, 25, NOW());
-- CO BAN 1
-- Tạo Trigger để ghi lại thông tin 
-- thay đổi số lượng sản phẩm vào bảng InventoryChanges mỗi khi có cập nhật số lượng trong bảng Products.
-- Tạo Trigger AfterProductUpdate để ghi lại các thay đổi số lượng hàng:

drop trigger if exists AfterProductUpdate ;
delimiter $$
create trigger AfterProductUpdate 
after update on products
for each row
begin
	if old.quantity <> new.quantity then
    insert into inventoryChanges(productID,oldQuantity,newQuantity,changeDate)
    values (old.productID, old.quantity, new.quantity, now());
	end if;
end $$
delimiter ;

UPDATE products
SET quantity = 25
WHERE productID = 1;

SELECT * FROM products;
-- -------------------------------------------------------------------------------------------
-- CO BAN 2
-- Tạo Trigger BeforeProductDelete để kiểm tra số lượng sản phẩm trước khi xóa:
-- Kiểm tra xóa một sản phẩm có số lượng lớn hơn 10 và kiểm tra thông báo lỗi.
-- Xóa trigger nếu đã tồn tại
DROP TRIGGER IF EXISTS BeforeProductDelete;

DELIMITER $$

CREATE TRIGGER BeforeProductDelete
BEFORE DELETE ON products
FOR EACH ROW
BEGIN
    -- Kiểm tra nếu số lượng sản phẩm lớn hơn 10 thì không cho xóa
IF OLD.quantity > 10 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = CONCAT('Không thể xóa sản phẩm vì số lượng lớn hơn 10')
END IF;

DELIMITER ;




-- -------------------------------------------------------------------------------------------

-- CO BAN 3
-- Thay đổi cấu trúc bảng Products để bao gồm một trường LastUpdated
-- Tạo Trigger AfterProductUpdateSetDate để cập nhật trường LastUpdated khi có thay đổi
ALTER TABLE products ADD COLUMN LastUpdated DATETIME DEFAULT NULL;

DROP TRIGGER IF EXISTS AfterProductUpdateSetDate;

DELIMITER $$

CREATE TRIGGER BeforeProductUpdateSetDate
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
    IF OLD.quantity <> NEW.quantity THEN
        SET NEW.LastUpdated = NOW();
    END IF;
END$$

DELIMITER ;


SELECT * FROM products;

UPDATE products
SET quantity = 25
WHERE productID = 1;

SELECT * FROM products;

