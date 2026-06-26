

--BASIC QUERIES
--1: Retrieve each tables
SELECT * from [USER]
SELECT * FROM COSTUME
SELECT * FROM COSTUME_ITEM
select * from COSTUME_IMAGE
select * from ORDER_ITEM
SELECT * FROM RENTAL_ORDER
SELECT * FROM PAYMENT
select * from PRICING_POLICY

--WHERE queries
--2: Retrieves with condition
SELECT *
FROM [USER]
WHERE status = 'active'

SELECT *
FROM [USER]
WHERE role = 'customer'

SELECT *
FROM COSTUME_ITEM
WHERE status = 'available'

SELECT *
FROM RENTAL_ORDER
WHERE status = 'active'

SELECT *
FROM PAYMENT
WHERE status = 'success'


--ORDER BY queries
--3 Order by 
SELECT *
FROM COSTUME
ORDER BY dailyRate DESC
--Display costumes from highest rental fee to lowest.

SELECT *
FROM [USER]
ORDER BY fullName ASC
--Sort users alphabetically.

SELECT *
FROM RENTAL_ORDER
ORDER BY orderDate DESC
--Show newest orders first. 

SELECT *
FROM PAYMENT
ORDER BY amount DESC
--Display highest payments first. 

SELECT *
FROM PRICING_POLICY
ORDER BY effectiveDate DESC
--Show latest policies first. 



--AGGREGATE queries

--4: Count  
SELECT COUNT(*) AS TotalUsers
FROM [USER];
--Count all registered users. 
 
SELECT COUNT(*) AS AvailableItems
FROM COSTUME_ITEM
WHERE status = 'available'
--Count rentable costume items. 

--5: calculate Average
SELECT AVG(dailyRate) AS AverageDailyRate
FROM COSTUME
--Calculate average rental price per day. 

--6: find Maximum 
SELECT MAX(amount) AS HighestPayment
FROM PAYMENT;
--Find the highest payment. 

--7: Calculate total 
SELECT SUM(amount) AS TotalRevenue
FROM PAYMENT
WHERE status = 'success'
--Calculate total revenue from successful payments. 



--QUERIES CONTAIN SUBQUERIES
--8: Costumes with rental price above average
SELECT *
FROM COSTUME
WHERE dailyRate >
(
   SELECT AVG(dailyRate)
   FROM COSTUME
);

--9: Customers who have placed orders
SELECT *
FROM [USER]
WHERE userId IN
(
   SELECT customerId
   FROM RENTAL_ORDER
);


--10: Customers who never rented
SELECT *
FROM [USER]
WHERE role = 'customer' and userId NOT IN 
(
   SELECT customerId
   FROM RENTAL_ORDER
);

--11: Orders with highest total fee
SELECT *
FROM RENTAL_ORDER
WHERE totalFee =
(
   SELECT MAX(totalFee)
   FROM RENTAL_ORDER
);

--12: Payments larger than average payment
SELECT *
FROM PAYMENT
WHERE amount >
(
   SELECT AVG(amount)
   FROM PAYMENT
);

--13: Most expensive costume
SELECT *
FROM COSTUME
WHERE dailyRate =
(
   SELECT MAX(dailyRate)
   FROM COSTUME
);

--14: Orders using newest policy
SELECT *
FROM RENTAL_ORDER
WHERE policyId =
(
   SELECT TOP 1 policyId
   FROM PRICING_POLICY
   ORDER BY effectiveDate DESC
);

--15: Available items belonging to expensive costumes
SELECT *
FROM COSTUME_ITEM
WHERE costumeId IN
(
   SELECT costumeId
   FROM COSTUME
   WHERE dailyRate > 500000
);

--16: Payments for active orders
SELECT *
FROM PAYMENT
WHERE orderId IN
(
   SELECT orderId
   FROM RENTAL_ORDER
   WHERE status = 'active'
);

--17: Orders with total fee above average
SELECT *
FROM RENTAL_ORDER
WHERE totalFee >
(
   SELECT AVG(totalFee)
   FROM RENTAL_ORDER
);


--ADVANCED QUERIES
--18: Customers with orders having total fee above average
SELECT 
    u.userId,
    u.fullName AS username,
    ro.totalFee
FROM [USER] u
INNER JOIN RENTAL_ORDER ro ON u.userId = ro.customerId
WHERE ro.totalFee > 
(
    SELECT AVG(totalFee)
    FROM RENTAL_ORDER
);

--19: Costumes rented in the most expensive order
SELECT *
FROM COSTUME
WHERE costumeId IN
(
   SELECT costumeId
   FROM COSTUME_ITEM
   WHERE itemId IN
   (
       SELECT itemId
       FROM ORDER_ITEM
       WHERE orderId =
       (
           SELECT TOP 1 orderId
           FROM RENTAL_ORDER
           ORDER BY totalFee DESC
       )
   )
);
--20: Payments related to orders with highest fee
SELECT *
FROM PAYMENT
WHERE orderId IN
(
   SELECT orderId
   FROM RENTAL_ORDER
   WHERE totalFee =
   (
       SELECT MAX(totalFee)
       FROM RENTAL_ORDER
   )
);

--21: Policies used by above-average orders
SELECT *
FROM PRICING_POLICY
WHERE policyId IN
(
   SELECT policyId
   FROM RENTAL_ORDER
   WHERE totalFee >
   (
       SELECT AVG(totalFee)
       FROM RENTAL_ORDER
   )
)


