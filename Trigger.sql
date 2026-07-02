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

CREATE TRIGGER trg_PreventRentMaintenanceItem
ON ORDER_ITEM
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        INNER JOIN COSTUME_ITEM ci
            ON i.itemId = ci.itemId
        WHERE ci.status = 'maintenance'
    )
    BEGIN
        RAISERROR('Costume item is under maintenance and cannot be rented.',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_PreventDoubleBooking
ON ORDER_ITEM
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        INNER JOIN RENTAL_ORDER newOrder
            ON i.orderId = newOrder.orderId
        INNER JOIN ORDER_ITEM oi
            ON oi.itemId = i.itemId
        INNER JOIN RENTAL_ORDER oldOrder
            ON oi.orderId = oldOrder.orderId
        WHERE
            newOrder.orderId <> oldOrder.orderId
            AND oldOrder.status IN ('Pending','Active')
            AND newOrder.startDate <= oldOrder.endDate
            AND newOrder.endDate >= oldOrder.startDate
    )
    BEGIN
        RAISERROR('This costume item has already been booked for the selected period.',16,1);
        ROLLBACK TRANSACTION;
    END
END;
GO
