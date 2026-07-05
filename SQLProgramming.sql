-- BASIC QUERIES

-- 1: Retrieve each table
SELECT * FROM [USER];
SELECT * FROM COSTUME;
SELECT * FROM COSTUME_ITEM;
SELECT * FROM COSTUME_IMAGE;
SELECT * FROM ORDER_ITEM;
SELECT * FROM RENTAL_ORDER;
SELECT * FROM PAYMENT;
SELECT * FROM PRICING_POLICY;


-- WHERE QUERIES
-- 2: Retrieves with condition
SELECT * FROM [USER] WHERE status = 'active';
SELECT * FROM [USER] WHERE role = 'customer';
SELECT * FROM COSTUME_ITEM WHERE status = 'available';
SELECT * FROM RENTAL_ORDER WHERE status = 'Active'
SELECT * FROM PAYMENT WHERE status = 'success';


-- ORDER BY QUERIES
-- 3: Order by
-- Display costumes from highest rental fee to lowest.
SELECT * FROM COSTUME ORDER BY dailyRate DESC;

-- Sort users alphabetically.
SELECT * FROM [USER] ORDER BY fullName ASC;

-- Show newest orders first.
SELECT * FROM RENTAL_ORDER ORDER BY orderDate DESC;

-- Display highest payments first.
SELECT * FROM PAYMENT ORDER BY amount DESC;

-- Show latest policies first.
SELECT * FROM PRICING_POLICY ORDER BY effectiveDate DESC;

-- AGGREGATE QUERIES
-- 4: Count
-- Count all registered users.
SELECT COUNT(*) AS TotalUsers FROM [USER];

-- Count rentable costume items.
SELECT COUNT(*) AS AvailableItems FROM COSTUME_ITEM WHERE status = 'available';

-- 5: Calculate Average
-- Calculate average rental price per day.
SELECT AVG(dailyRate) AS AverageDailyRate FROM COSTUME;

-- 6: Find Maximum
-- Find the highest payment.
SELECT MAX(amount) AS HighestPayment FROM PAYMENT;

-- 7: Calculate total
SELECT SUM(amount) AS TotalRevenue FROM PAYMENT WHERE status = 'success';

-- JOIN QUERIES
-- 8: Customer information with rental orders
SELECT u.fullName, ro.orderId, ro.orderDate, ro.status
FROM [USER] u
INNER JOIN RENTAL_ORDER ro ON u.userId = ro.customerId;

-- 9: Staff handling orders
SELECT s.fullName, ro.orderId, ro.status
FROM [USER] s
INNER JOIN RENTAL_ORDER ro ON s.userId = ro.staffId;

-- 10: Costume items with costume names
SELECT ci.itemId, c.name, ci.size, ci.color, ci.status
FROM COSTUME_ITEM ci
INNER JOIN COSTUME c ON ci.costumeId = c.costumeId;

-- 11: Rental orders with pricing policies
SELECT ro.orderId, pp.policyName, pp.lateFeeRate
FROM RENTAL_ORDER ro
INNER JOIN PRICING_POLICY pp ON ro.policyId = pp.policyId;

-- 12: Orders and payments
SELECT ro.orderId, p.paymentId, p.amount, p.status
FROM RENTAL_ORDER ro
INNER JOIN PAYMENT p ON ro.orderId = p.orderId;



-- GROUP BY AND HAVING QUERIES 
-- 13: Number of orders per customer
SELECT customerId, COUNT(*) AS TotalOrders
FROM RENTAL_ORDER
GROUP BY customerId;

-- 14: Customers with at least 1 order
SELECT customerId, COUNT(*) AS TotalOrders
FROM RENTAL_ORDER
GROUP BY customerId
HAVING COUNT(*) >= 1;

-- 15: Total revenue by payment method
SELECT paymentMethod, SUM(amount) AS Revenue
FROM PAYMENT
GROUP BY paymentMethod;

-- 16: Average costume rental price by theme 
SELECT theme, AVG(dailyRate) AS AvgRate
FROM COSTUME
GROUP BY theme;

-- 17: Number of costumes in each theme
SELECT theme, COUNT(*) AS TotalCostumes
FROM COSTUME
GROUP BY theme;


-- QUERIES CONTAIN SUBQUERIES


-- 18: Costumes with rental price above average
SELECT * FROM COSTUME 
WHERE dailyRate > (SELECT AVG(dailyRate) FROM COSTUME);

-- 19: Customers who have placed orders
SELECT * FROM [USER] 
WHERE userId IN (SELECT customerId FROM RENTAL_ORDER);

-- 20: Customers who never rented
SELECT * FROM [USER] 
WHERE role = 'customer' AND userId NOT IN (SELECT customerId FROM RENTAL_ORDER);

-- 21: Orders with highest total fee
SELECT * FROM RENTAL_ORDER 
WHERE totalFee = (SELECT MAX(totalFee) FROM RENTAL_ORDER);

-- 22: Payments larger than average payment
SELECT * FROM PAYMENT 
WHERE amount > (SELECT AVG(amount) FROM PAYMENT);

-- 23: Most expensive costume
SELECT * FROM COSTUME 
WHERE dailyRate = (SELECT MAX(dailyRate) FROM COSTUME);

-- 24: Orders using newest policy
SELECT * FROM RENTAL_ORDER 
WHERE policyId = (SELECT TOP 1 policyId FROM PRICING_POLICY ORDER BY effectiveDate DESC);

-- 25: Available items belonging to expensive costumes 
SELECT * FROM COSTUME_ITEM
WHERE costumeId IN (SELECT costumeId FROM COSTUME WHERE dailyRate > 150000);

-- 26: Payments for active orders (Sửa 'active' thành 'Active' khớp data mới)
SELECT * FROM PAYMENT 
WHERE orderId IN (SELECT orderId FROM RENTAL_ORDER WHERE status = 'Active');

-- 27: Orders with total fee above average
SELECT * FROM RENTAL_ORDER 
WHERE totalFee > (SELECT AVG(totalFee) FROM RENTAL_ORDER);


-- ADVANCED QUERIES & SUBQUERIES
-- 28: Customers with orders having total fee above average
SELECT u.userId, u.fullName AS username, ro.totalFee
FROM [USER] u
INNER JOIN RENTAL_ORDER ro ON u.userId = ro.customerId
WHERE ro.totalFee > (SELECT AVG(totalFee) FROM RENTAL_ORDER);

-- 29: Costumes rented in the most expensive order
SELECT * FROM COSTUME
WHERE costumeId IN (
   SELECT costumeId FROM COSTUME_ITEM WHERE itemId IN (
       SELECT itemId FROM ORDER_ITEM WHERE orderId = (
           SELECT TOP 1 orderId FROM RENTAL_ORDER ORDER BY totalFee DESC
       )
   )
);

-- 30: Payments related to orders with highest fee
SELECT * FROM PAYMENT 
WHERE orderId IN (SELECT orderId FROM RENTAL_ORDER WHERE totalFee = (SELECT MAX(totalFee) FROM RENTAL_ORDER));

-- 31: Policies used by above-average orders
SELECT * FROM PRICING_POLICY 
WHERE policyId IN (SELECT policyId FROM RENTAL_ORDER WHERE totalFee > (SELECT AVG(totalFee) FROM RENTAL_ORDER));


-- IN, ANY, ALL QUERIES
-- 32: Customers with active orders (Sửa 'active' thành 'Active')
SELECT * FROM [USER] 
WHERE userId IN (SELECT customerId FROM RENTAL_ORDER WHERE status = 'Active');

-- 33: Payments greater than ANY order fee
SELECT * FROM PAYMENT 
WHERE amount > ANY (SELECT totalFee FROM RENTAL_ORDER);

-- 34: Payments greater than ALL order fees
SELECT * FROM PAYMENT 
WHERE amount > ALL (SELECT totalFee FROM RENTAL_ORDER);






--FUNCTION--
--1: Calculate Rental Days 
CREATE FUNCTION fn_CalculateRentalDays
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(DAY, @StartDate, @EndDate) + 1;
END;
GO

--Test fn_CalculateRentalDays (Tính số ngày thuê)
-- Khách thuê từ mùng 2 đến mùng 5 -> Kết quả mong đợi: 4 ngày
SELECT dbo.fn_CalculateRentalDays('2026-06-02', '2026-06-05') AS Test_RentalDays;



--2: Calculate Total Rental Fee 
CREATE FUNCTION fn_CalculateTotalFee
(
    @DailyRate DECIMAL(10,2),
    @StartDate DATE,
    @EndDate DATE
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Days INT;

    SET @Days =
        DATEDIFF(DAY, @StartDate, @EndDate) + 1;

    RETURN @Days * @DailyRate;
END;
GO


-- Test fn_CalculateTotalFee (Tính tổng tiền thuê)
-- Giá 150k/ngày, thuê từ mùng 2 đến mùng 5 (4 ngày) -> Kết quả mong đợi: 600,000
SELECT dbo.fn_CalculateTotalFee(150000.00, '2026-06-02', '2026-06-05') AS Test_TotalFee


--3: Calculate Late Fee 
CREATE FUNCTION fn_CalculateLateFee
(
    @ExpectedReturnDate DATE,
    @ActualReturnDate DATE,
    @LateFeePerDay DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @LateDays INT;

    SET @LateDays =
        DATEDIFF
        (
            DAY,
            @ExpectedReturnDate,
            @ActualReturnDate
        );

    IF @LateDays < 0
        SET @LateDays = 0;

    RETURN @LateDays * @LateFeePerDay;
END;
GO

--Test fn_CalculateLateFee (Tính tiền phạt trễ hạn)
-- Trường hợp 1: Trả trễ 2 ngày (hạn mùng 8, trả mùng 10), phạt 50k/ngày -> Mong đợi: 100,000
SELECT dbo.fn_CalculateLateFee('2026-06-08', '2026-06-10', 50000.00) AS Test_LateFee_TreHan;

-- Trường hợp 2: Trả sớm hoặc đúng hạn (hạn mùng 8, trả mùng 7) -> Mong đợi: 0
SELECT dbo.fn_CalculateLateFee('2026-06-08', '2026-06-07', 50000.00) AS Test_LateFee_DungHan

--4: Count Active Rentals of a Customer 
CREATE FUNCTION fn_CountActiveRentals
(
    @CustomerID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;
    SELECT @Total = COUNT(*)
    FROM RENTAL_ORDER
    WHERE customerId = @CustomerID
      AND status = 'active';
    RETURN @Total;
END;
GO


--Test fn_CountActiveRentals (Đếm đơn đang thuê của khách)
-- Truyền ID của một khách hàng (ví dụ ID = 4) -> Kết quả: Đếm số đơn 'Active' của khách số 4
SELECT dbo.fn_CountActiveRentals(4) AS Test_ActiveRentals_Cus4




--PROCEDURES--

--1: Create a new rental order.
GO
CREATE PROCEDURE sp_CreateRentalOrder
(
    @CustomerID INT,
    @PolicyID INT,
    @StartDate DATE,
    @EndDate DATE,
    @LateFeePerDay DECIMAL(10,2),
    @TotalFee DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO RENTAL_ORDER
    (
        customerId,
        policyId,
        status,
        orderDate,
        startDate,
        endDate,
        lateFeePerDay,
        totalFee
    )
    VALUES
    (
        @CustomerID,
        @PolicyID,
        'Pending', 
        GETDATE(),
        @StartDate,
        @EndDate,
        @LateFeePerDay,
        @TotalFee
    );
END;
GO
-- Test
EXEC sp_CreateRentalOrder -- Để sẵn tạo đơn số 15
    @CustomerID = 9,
    @PolicyID = 1,
    @StartDate = '2026-05-10',
    @EndDate = '2026-05-15',
    @LateFeePerDay = 50000,
    @TotalFee = 500000;
-- Check
SELECT * FROM RENTAL_ORDER;



--2: Assign a staff member to process an order
GO
CREATE PROCEDURE sp_AssignStaffToOrder
(
    @OrderID INT,
    @StaffID INT
)
AS
BEGIN
    UPDATE RENTAL_ORDER
    SET staffId = @StaffID
    WHERE orderId = @OrderID;
END;
GO
-- Test
EXEC sp_AssignStaffToOrder
    @OrderID = 15, -- Để sẵn để update đơn số 15 chưa có staffId
    @StaffID = 4;
-- Check
SELECT * FROM RENTAL_ORDER;



--3: Update the status of a rental order.
GO
CREATE PROCEDURE sp_UpdateOrderStatus
(
    @OrderID INT,
    @NewStatus VARCHAR(20)
)
AS
BEGIN
    UPDATE RENTAL_ORDER
    SET status = @NewStatus
    WHERE orderId = @OrderID;
END;
GO
-- Test
EXEC sp_UpdateOrderStatus -- Update don so 9 tu Pending -> Active
    @OrderID = 9,
    @NewStatus = "Active"
-- Check
SELECT * FROM RENTAL_ORDER;


--4: Calculate total revenue from successful payments.
GO
CREATE PROCEDURE sp_GenerateRevenueReport
AS
BEGIN
    SELECT
        COUNT(*) AS TotalPayments,
        ISNULL(SUM(amount), 0) AS TotalRevenue 
    FROM PAYMENT
    WHERE status = 'success';
END;
GO
-- Test and Check
SELECT * FROM PAYMENT
EXEC sp_GenerateRevenueReport -- Kết quả là tổng tiền của 4 hóa đơn thanh toán có status là success



--TRIGGERS--

--1 This trigger prevents deleting costume items that are referenced in rental history
GO
CREATE TRIGGER trg_PreventDeleteCostumeItem
ON COSTUME_ITEM
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM ORDER_ITEM oi
        INNER JOIN deleted d
            ON oi.itemId = d.itemId
    )
    BEGIN
        RAISERROR('Cannot delete a costume item because it has been used in rental orders.',16,1);
        rollback transaction
        RETURN;
    END;

    DELETE
    FROM COSTUME_ITEM
    WHERE itemId IN
    (
        SELECT itemId
        FROM deleted
    );
END;
GO

-- Test 
DELETE FROM COSTUME_ITEM WHERE itemId = 2; 
-- Expected output: System sẽ không cho delete vì item có id = 2 đang được cho thuê

-- Check
SELECT * FROM COSTUME_ITEM;



--2 This trigger automatically updates the costume item status after it is rented
GO
CREATE TRIGGER trg_UpdateItemStatusAfterRent
ON ORDER_ITEM
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE COSTUME_ITEM
    SET status = 'rented'
    WHERE itemId IN
    (
        SELECT itemId
        FROM inserted
    );
END;
GO

-- Test and Check
BEGIN TRAN; -- Item đang 'available' -> insert vào ORDER_ITEM -> phải đổi thành 'rented'

SELECT * FROM COSTUME_ITEM WHERE itemId = 11; -- trước: available

INSERT INTO ORDER_ITEM (orderId, itemId, statusBefore, statusAfter, itemDailyRate)
VALUES (9, 11, '100% New', NULL, 130000.00); -- dùng lại orderId 9 (Pending) cho tiện

SELECT * FROM COSTUME_ITEM WHERE itemId = 11; -- sau: mong muốn 'rented'

ROLLBACK;



--3 This trigger restores costume availability after the rental process is completed
GO
CREATE TRIGGER trg_ReturnCostumeItem
ON RENTAL_ORDER
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ci
    SET ci.status = 'available'
    FROM COSTUME_ITEM ci
    INNER JOIN ORDER_ITEM oi
        ON ci.itemId = oi.itemId
    INNER JOIN inserted i
        ON oi.orderId = i.orderId
    INNER JOIN deleted d
        ON d.orderId = i.orderId
    WHERE
        d.status <> 'Returned'
        AND i.status = 'Returned';
END;
GO

-- Test and Check
BEGIN TRAN;

select * from RENTAL_ORDER where orderId = 6 -- Đơn số 6 đang active

SELECT * FROM ORDER_ITEM where orderId = 6 -- Đơn số 6 có item id = 8 đang được cho thuê rented

SELECT * FROM COSTUME_ITEM where itemId = 8 -- item id = 8 đang được cho thuê rented

UPDATE RENTAL_ORDER SET status = 'Returned' WHERE orderId = 6; -- Khi đơn số 6 được thuê xong returned

SELECT * FROM COSTUME_ITEM WHERE itemId = 8; -- item id = 8 của đơn số 6 sẽ có status là available

ROLLBACK


--4 Giới hạn số đơn rental order cho 1 khách hàng là 3 đơn. Nếu > 3 sẽ báo lỗi và không thêm đơn hàng đó.
GO
CREATE TRIGGER trg_CheckMaxActiveRentals
ON RENTAL_ORDER
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        WHERE
        (
            SELECT COUNT(*)
            FROM RENTAL_ORDER r
            WHERE r.customerId = i.customerId
            AND r.status = 'Active'
        ) > 3
    )
    BEGIN
        RAISERROR('Customer cannot have more than 3 active rental orders.',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Test and Check
-- customerId 9, insert thêm active order thứ 3 (tổng 3, chưa vượt)

INSERT INTO RENTAL_ORDER (customerId, staffId, policyId, status, orderDate, startDate, endDate, actualReturnDate, lateFeePerDay, totalFee)
VALUES (9, 2, 1, 'Active', GETDATE(), '2026-07-10', '2026-07-12', NULL, 50000, 300000);
-- Mong muốn: OK, tổng active = 3 (chưa > 3)

-- customerId 9, insert active order thứ 4 -> PHẢI bị chặn

BEGIN TRY
    INSERT INTO RENTAL_ORDER (customerId, staffId, policyId, status, orderDate, startDate, endDate, actualReturnDate, lateFeePerDay, totalFee)
    VALUES (9, 2, 1, 'Active', GETDATE(), '2026-07-10', '2026-07-12', NULL, 50000, 300000);
    PRINT 'FAIL - không có lỗi nào được ném ra';
END TRY
BEGIN CATCH
    PRINT ERROR_MESSAGE();
END CATCH;

SELECT COUNT(*) AS ActiveCount FROM RENTAL_ORDER WHERE customerId = 9 AND status = 'Active';
-- Mong muốn: vẫn = 3, KHÔNG tăng lên 4 (vì ROLLBACK trong trigger đã hủy đúng statement insert thứ 4)

SELECT * FROM RENTAL_ORDER;




--VIEW--


-- Create view vw_RentalOrderDetails
CREATE VIEW vw_RentalOrderDetails AS
SELECT
    ro.orderId,
    c.userId AS customerId,
    c.fullName AS customerName,
    s.userId AS staffId,
    s.fullName AS staffName,
    co.costumeId,
    co.name AS costumeName,
    ci.itemId,
    ci.size,
    ci.color,
    oi.itemDailyRate,
    ro.orderDate,
    ro.startDate,
    ro.endDate,
    ro.actualReturnDate,
    ro.status,
    ro.totalFee
FROM RENTAL_ORDER ro
JOIN [USER] c
    ON ro.customerId = c.userId
LEFT JOIN [USER] s
    ON ro.staffId = s.userId
JOIN ORDER_ITEM oi
    ON ro.orderId = oi.orderId
JOIN COSTUME_ITEM ci
    ON oi.itemId = ci.itemId
JOIN COSTUME co
    ON ci.costumeId = co.costumeId;

-- Test
SELECT *
FROM vw_RentalOrderDetails
WHERE customerName = N'Trần Minh Hoàng'

-- Drop
DROP VIEW IF EXISTS vw_RentalOrderDetails



-- Create view vw_PaymentSummary
CREATE VIEW vw_PaymentSummary AS
SELECT
    p.paymentId,
    ro.orderId,
    u.fullName AS customerName,
    p.paymentDate,
    p.amount,
    p.totalLateFee,
    p.paymentMethod,
    p.status
FROM PAYMENT p
JOIN RENTAL_ORDER ro
    ON p.orderId = ro.orderId
JOIN [USER] u
    ON ro.customerId = u.userId;

-- Test
SELECT *
FROM vw_PaymentSummary
WHERE status = 'success'

-- Drop
DROP VIEW IF EXISTS vw_PaymentSummary


-- Create view vw_AvailableCostumes
CREATE VIEW vw_AvailableCostumes AS
SELECT
    c.costumeId,
    c.name,
    c.characterName,
    c.theme,
    c.dailyRate,
    ci.itemId,
    ci.size,
    ci.color,
    ci.status
FROM COSTUME c
JOIN COSTUME_ITEM ci
    ON c.costumeId = ci.costumeId
WHERE ci.status = 'available';

-- Test View vw_AvailableCostumes
SELECT *
FROM vw_AvailableCostumes;

-- Drop
DROP VIEW IF EXISTS vw_AvailableCostumes




--INDEXES--



-- Creat IX_USER_Email
CREATE INDEX IX_USER_Email
ON [USER](email);

--Test
SELECT *
FROM [USER]
WHERE email = 'tamld@fpt.edu.vn';

DROP INDEX IX_USER_Email ON [USER]

-- Creat IX_RENTAL_ORDER_Customer_Status
CREATE NONCLUSTERED INDEX IX_RENTAL_ORDER_customerId_Active
ON RENTAL_ORDER(customerId)
WHERE status = 'active';

-- Test
SELECT r.customerId , COUNT(*) as ActiveRentals
FROM RENTAL_ORDER r
WHERE r.customerId = 5 AND r.status = 'active'
GROUP BY r.customerId;

-- Drop
DROP INDEX IX_RENTAL_ORDER_Customer_Status ON RENTAL_ORDER



-- Create IX_PAYMENT_paymentMethod_status
CREATE NONCLUSTERED INDEX IX_PAYMENT_paymentMethod_status
ON PAYMENT(paymentMethod, status)
INCLUDE (amount);

-- Test
SELECT paymentMethod, SUM(amount) AS Revenue
FROM PAYMENT
WHERE status = 'success'
GROUP BY paymentMethod;

DROP INDEX IX_PAYMENT_paymentMethod_status ON PAYMENT