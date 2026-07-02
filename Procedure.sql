--1: Count: Create a new rental order.

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
        'pending',
        GETDATE(),
        @StartDate,
        @EndDate,
        @LateFeePerDay,
        @TotalFee
    );
END;
GO


--2: Assign a staff member to process an order

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


--3: Update the status of a rental order.

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


--4: Calculate total revenue from successful payments.

CREATE PROCEDURE sp_GenerateRevenueReport
AS
BEGIN
    SELECT
        COUNT(*) AS TotalPayments,
        SUM(amount) AS TotalRevenue
    FROM PAYMENT
    WHERE status = 'success';
END;
GO
