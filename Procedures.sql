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
