drop database if exists sesson11;
create database sesson11;
use sesson11;

CREATE TABLE accounts (
    accountID INT PRIMARY KEY,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0.00
);

CREATE TABLE transactions (
    transactionID INT PRIMARY KEY,
    fromAccountID INT NOT NULL,
    toAccountID INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transactionDate DATETIME NOT NULL,
    FOREIGN KEY (fromAccountID) REFERENCES accounts(accountID),
    FOREIGN KEY (toAccountID) REFERENCES accounts(accountID)
);
INSERT INTO accounts (accountID, balance) VALUES
(1, 1000.00),
(2, 500.00);

DELIMITER $$

CREATE PROCEDURE transferMoney(
    IN p_from INT,
    IN p_to INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE current_balance DECIMAL(10,2);
    DECLARE exit handler FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT balance INTO current_balance
    FROM accounts
    WHERE accountID = p_from
    FOR UPDATE;

    IF current_balance < p_amount THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Số dư không đủ để thực hiện giao dịch';
    END IF;

    UPDATE accounts
    SET balance = balance - p_amount
    WHERE accountID = p_from;

    UPDATE accounts
    SET balance = balance + p_amount
    WHERE accountID = p_to;

    INSERT INTO transactions(transactionID, fromAccountID, toAccountID, amount, transactionDate)
    VALUES (
        UNIX_TIMESTAMP(), 
        p_from, 
        p_to, 
        p_amount, 
        NOW()
    );
    COMMIT;
END$$
DELIMITER ;
CALL transferMoney(1, 2, 200.00);
SELECT * FROM accounts;
SELECT * FROM transactions;

-- luyen tap 2
CREATE TABLE budgets (
    budgetID INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    month VARCHAR(20) NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (accountID) REFERENCES accounts(accountID)
);


CREATE TABLE expenses (
    expenseID INT PRIMARY KEY AUTO_INCREMENT,
    accountID INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    expenseDate DATETIME NOT NULL,
    description VARCHAR(255),
    FOREIGN KEY (accountID) REFERENCES accounts(accountID)
);
INSERT INTO budgets (accountID, amount, month, description) VALUES
(1, 300.00, 'January', 'Ngân sách ăn uống'),
(1, 500.00, 'February', 'Ngân sách mua sắm'),
(2, 200.00, 'January', 'Ngân sách di chuyển'),
(2, 400.00, 'March', 'Ngân sách hóa đơn điện nước');
INSERT INTO expenses (accountID, amount, expenseDate, description) VALUES
(1, 50.00, NOW(), 'Ăn trưa'),
(1, 120.00, NOW(), 'Mua quần áo'),
(2, 30.00, NOW(), 'Đi xe bus'),
(2, 200.00, NOW(), 'Thanh toán tiền điện');
SELECT * FROM budgets;
SELECT * FROM expenses;

DELIMITER $$

CREATE PROCEDURE spendMoney(
    IN p_accountID INT,
    IN p_amount DECIMAL(10,2),
    IN p_description VARCHAR(255),
    IN p_month VARCHAR(20)
)
BEGIN
    DECLARE current_balance DECIMAL(10,2);
    DECLARE current_budget DECIMAL(10,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    START TRANSACTION;
    SELECT balance INTO current_balance
    FROM accounts
    WHERE accountID = p_accountID
    FOR UPDATE;
    IF current_balance < p_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số dư không đủ để chi tiêu';
    END IF;
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE accountID = p_accountID;
    INSERT INTO expenses (accountID, amount, expenseDate, description)
    VALUES (p_accountID, p_amount, NOW(), p_description);
    SELECT amount INTO current_budget
    FROM budgets
    WHERE accountID = p_accountID AND month = p_month
    FOR UPDATE;
    IF current_budget IS NOT NULL THEN
        UPDATE budgets
        SET amount = amount - p_amount
        WHERE accountID = p_accountID AND month = p_month;
    END IF;
    COMMIT;
END$$
DELIMITER ;
CALL spendMoney(1, 100.00, 'Mua đồ ăn nhẹ', 'January');
SELECT * FROM accounts;
SELECT * FROM expenses;
SELECT * FROM budgets;



