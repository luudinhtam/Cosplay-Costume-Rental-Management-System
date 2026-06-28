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
