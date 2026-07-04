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
