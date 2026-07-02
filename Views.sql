
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


