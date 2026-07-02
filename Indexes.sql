
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
