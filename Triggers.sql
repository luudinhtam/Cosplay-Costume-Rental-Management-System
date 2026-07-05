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


--4 
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


