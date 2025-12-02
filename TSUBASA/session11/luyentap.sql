DROP DATABASE IF EXISTS sesson11;
CREATE DATABASE sesson11;
USE sesson11;

-- Bảng accounts
CREATE TABLE accounts (
    accountID INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0.00
);

-- Bảng transactions
CREATE TABLE transactions (
    transactionID INT PRIMARY KEY AUTO_INCREMENT,
    fromAccountID INT NOT NULL,
    toAccountID INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transactionDate DATETIME NOT NULL,
    FOREIGN KEY (fromAccountID) REFERENCES accounts(accountID),
    FOREIGN KEY (toAccountID) REFERENCES accounts(accountID)
);


INSERT INTO accounts (balance) VALUES
(1000.00),
(500.00);

INSERT INTO transactions (fromAccountID, toAccountID, amount, transactionDate)
VALUES 
(1, 2, 150.00, NOW()),
(2, 1, 50.00, NOW());


-- Viết một stored procedure 
-- để thực hiện một giao dịch chuyển tiền từ một tài khoản sang tài khoản khác.
--  Stored procedure này cần đảm bảo rằng giao dịch là nguyên tử (atomic) và số dư của tài khoản nguồn không bị âm.

DELIMITER $$

CREATE PROCEDURE transferMoneyAtomic(
    IN _fromAccount INT,
    IN _toAccount INT,
    IN _amount DECIMAL(10,2)
)
BEGIN
    DECLARE current_balance DECIMAL(10,2);  -- khai báo đúng tên

    -- Handler xử lý lỗi
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Lấy số dư tài khoản nguồn
    SELECT balance INTO current_balance
    FROM accounts
    WHERE accountID = _fromAccount
    FOR UPDATE;

    -- Kiểm tra số dư
    IF current_balance < _amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'So du tai khoan khong du';
    END IF;

    -- Trừ tiền tài khoản nguồn
    UPDATE accounts
    SET balance = balance - _amount
    WHERE accountID = _fromAccount;

    -- Cộng tiền tài khoản đích
    UPDATE accounts
    SET balance = balance + _amount
    WHERE accountID = _toAccount;

    -- Thêm bản ghi giao dịch
    INSERT INTO transactions(fromAccountID, toAccountID, amount, transactionDate)
    VALUES (_fromAccount, _toAccount, _amount, NOW());

    COMMIT;

END$$

DELIMITER ;

CALL transferMoneyAtomic(1, 2, 200.00);

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

-- Viết một stored procedure để thực hiện chi tiêu từ một tài khoản:
-- Trừ số tiền chi tiêu từ số dư tài khoản tương ứng trong bảng Accounts.
-- Thêm bản ghi chi tiêu vào bảng Expenses.
-- Cập nhật ngân sách trong bảng Budgets nếu cần.
-- Đảm bảo rằng số dư tài khoản không bị âm và toàn bộ giao dịch phải thành công hoặc không có gì thay đổi nếu có lỗi.

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
        SET MESSAGE_TEXT = 'Số dư tài khoản không đủ';
    END IF;
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE accountID = p_accountID;
    INSERT INTO expenses(accountID, amount, expenseDate, description)
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

CALL spendMoney(2, 100.00, 'Mua do an', 'January');

-- Kiểm tra kết quả
SELECT * FROM accounts;
SELECT * FROM expenses;
SELECT * FROM budgets;

-- ---------------------------------------------------------------------------
-- CO BAN 3
CREATE TABLE transcationHistory (
	historyID INT AUTO_INCREMENT PRIMARY KEY,
    transactionID INT NOT NULL,
    accountID INT NOT NULL,
    amount DECIMAL(10,2),
    transactionDATE DATETIME,
    type varchar(50),
	FOREIGN KEY (accountID) REFERENCES accounts(accountID),
	FOREIGN KEY (transactionID) REFERENCES transactions(transactionID)
);

-- Viết một stored procedure để ghi lại lịch sử giao dịch vào bảng TransactionHistory khi có giao dịch mới trong bảng Transactions:
-- Thêm một bản ghi vào bảng TransactionHistory mỗi khi có giao dịch từ hoặc đến một tài khoản.
-- Theo dõi tổng số tiền giao dịch trong một khoảng thời gian cụ thể cho mỗi tài khoản
DROP PROCEDURE IF EXISTS logTransactionHistory;

DELIMITER $$

CREATE PROCEDURE logTransactionHistory(
    IN p_transactionID INT
)
BEGIN
    DECLARE v_from INT;
    DECLARE v_to INT;
    DECLARE v_amount DECIMAL(10,2);
    DECLARE v_date DATETIME;

    SELECT fromAccountID, toAccountID, amount, transactionDate
    INTO v_from, v_to, v_amount, v_date
    FROM transactions
    WHERE transactionID = p_transactionID;
    
    INSERT INTO transcationHistory(transactionID, accountID, amount, transactionDATE, type)
    VALUES (p_transactionID, v_from, v_amount, v_date, 'Gui');

    INSERT INTO transcationHistory(transactionID, accountID, amount, transactionDATE, type)
    VALUES (p_transactionID, v_to, v_amount, v_date, 'Nhan');
END$$

DELIMITER ;
-- Ví dụ: ghi lịch sử giao dịch có transactionID = 1
CALL logTransactionHistory(2);

-- Kiểm tra bảng lịch sử
SELECT * FROM transcationHistory;



-- ---------------------------------------------------------------------------
-- CO BAN 4
DROP TABLE IF EXISTS recurringTransactions;

CREATE TABLE recurringTransactions (
    recurringID INT PRIMARY KEY AUTO_INCREMENT,  -- sửa tên cột từ "recurrungID" thành "recurringID"
    fromAccountID INT NOT NULL,
    toAccountID INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    startDate DATETIME NOT NULL,
    frequency VARCHAR(50) NOT NULL,
    nextTransactionDate DATETIME NOT NULL,
    FOREIGN KEY (fromAccountID) REFERENCES accounts(accountID),
    FOREIGN KEY (toAccountID) REFERENCES accounts(accountID)
);


INSERT INTO recurringTransactions (fromAccountID, toAccountID, amount, startDate, frequency, nextTransactionDate)
VALUES
(1, 2, 100.00, '2025-12-01 08:00:00', 'daily', '2025-12-01 08:00:00'),
(2, 1, 50.00, '2025-12-01 09:00:00', 'weekly', '2025-12-08 09:00:00');

-- Viết một stored procedure để thực hiện giao dịch định kỳ:
-- Tự động chuyển tiền từ tài khoản nguồn đến tài khoản đích theo tần suất đã định.
-- Cập nhật trường NextTransactionDate trong bảng RecurringTransactions sau mỗi lần giao dịch.


DROP PROCEDURE IF EXISTS executeRecurringTransactions;

DELIMITER $$

CREATE PROCEDURE executeRecurringTransactions()
BEGIN
    DECLARE done INT DEFAULT 0;

    DECLARE v_id INT;
    DECLARE v_from INT;
    DECLARE v_to INT;
    DECLARE v_amount DECIMAL(10,2);
    DECLARE v_nextDate DATETIME;
    DECLARE v_frequency VARCHAR(50);

    DECLARE recur_cursor CURSOR FOR
        SELECT recurringID, fromAccountID, toAccountID, amount, nextTransactionDate, frequency
        FROM recurringTransactions
        WHERE nextTransactionDate <= NOW();

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN recur_cursor;

    recur_loop: LOOP
        FETCH recur_cursor INTO v_id, v_from, v_to, v_amount, v_nextDate, v_frequency;
        IF done THEN
            LEAVE recur_loop;
        END IF;

        IF (SELECT balance FROM accounts WHERE accountID = v_from) >= v_amount THEN
            
            START TRANSACTION;
            
            UPDATE accounts
            SET balance = balance - v_amount
            WHERE accountID = v_from;

            UPDATE accounts
            SET balance = balance + v_amount
            WHERE accountID = v_to;

            INSERT INTO transactions(fromAccountID, toAccountID, amount, transactionDate)
            VALUES (v_from, v_to, v_amount, NOW());

            INSERT INTO transcationHistory(transactionID, accountID, amount, transactionDATE, type)
            SELECT transactionID, v_from, v_amount, NOW(), 'Gui'
            FROM transactions
            ORDER BY transactionID DESC
            LIMIT 1;

            INSERT INTO transcationHistory(transactionID, accountID, amount, transactionDATE, type)
            SELECT transactionID, v_to, v_amount, NOW(), 'Nhan'
            FROM transactions
            ORDER BY transactionID DESC
            LIMIT 1;

            IF v_frequency = 'daily' THEN
                UPDATE recurringTransactions
                SET nextTransactionDate = DATE_ADD(nextTransactionDate, INTERVAL 1 DAY)
                WHERE recurringID = v_id;
            ELSEIF v_frequency = 'weekly' THEN
                UPDATE recurringTransactions
                SET nextTransactionDate = DATE_ADD(nextTransactionDate, INTERVAL 1 WEEK)
                WHERE recurringID = v_id;
            ELSEIF v_frequency = 'monthly' THEN
                UPDATE recurringTransactions
                SET nextTransactionDate = DATE_ADD(nextTransactionDate, INTERVAL 1 MONTH)
                WHERE recurringID = v_id;
            END IF;

            COMMIT;
        END IF;
    END LOOP;

    CLOSE recur_cursor;
END$$

DELIMITER ;

CALL executeRecurringTransactions();
SELECT * FROM accounts;
SELECT * FROM transactions;
SELECT * FROM transcationHistory;
SELECT * FROM recurringTransactions;

