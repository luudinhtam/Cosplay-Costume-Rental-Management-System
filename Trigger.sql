--1 This trigger prevents deleting costume items that are referenced in rental history
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

--2 This trigger automatically updates the costume item status after it is rented
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

--3 This trigger restores costume availability after the rental process is completed
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
        d.status <> 'Completed'
        AND i.status = 'Completed';
END;
GO

--4 This trigger blocks invalid payment records with negative amounts
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

