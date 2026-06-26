

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
--6: Active users 
SELECT *
FROM [USER]
WHERE status = 'active'

--7: Customers only 
SELECT *
FROM [USER]
WHERE role = 'customer'


--8: Available costume items 
SELECT *
FROM COSTUME_ITEM
WHERE status = 'available'

--9: Orders currently active 
SELECT *
FROM RENTAL_ORDER
WHERE status = 'active'

--10: Successful payments 
SELECT *
FROM PAYMENT
WHERE status = 'success'



--ORDER BY queries
--11: Costumes sorted by daily rate (high to low) 
SELECT *
FROM COSTUME
ORDER BY dailyRate DESC
--Display costumes from highest rental fee to lowest.

--12: Users sorted by full name 
SELECT *
FROM [USER]
ORDER BY fullName ASC
--Sort users alphabetically.

--13: Rental orders sorted by order date 
SELECT *
FROM RENTAL_ORDER
ORDER BY orderDate DESC
--Show newest orders first. 

--14: Payments sorted by amount 
SELECT *
FROM PAYMENT
ORDER BY amount DESC
--Display highest payments first. 

--15: Pricing policies sorted by effective date 
SELECT *
FROM PRICING_POLICY
ORDER BY effectiveDate DESC
--Show latest policies first. 



--AGGREGATE queries

--16: Count total users 
SELECT COUNT(*) AS TotalUsers
FROM [USER];
--Count all registered users. 

--17: Count available costume items 
SELECT COUNT(*) AS AvailableItems
FROM COSTUME_ITEM
WHERE status = 'available'
--Count rentable costume items. 

--18: Average costume rental price
SELECT AVG(dailyRate) AS AverageDailyRate
FROM COSTUME
--Calculate average rental price per day. 

--19: Maximum payment amount 
SELECT MAX(amount) AS HighestPayment
FROM PAYMENT;
--Find the highest payment. 

--20: Total revenue 
SELECT SUM(amount) AS TotalRevenue
FROM PAYMENT
WHERE status = 'success'
--Calculate total revenue from successful payments. 



--QUERIES CONTAIN SUBQUERIES
--21: Costumes with rental price above average
SELECT *
FROM COSTUME
WHERE dailyRate >
(
   SELECT AVG(dailyRate)
   FROM COSTUME
);

--22: Customers who have placed orders
SELECT *
FROM [USER]
WHERE userId IN
(
   SELECT customerId
   FROM RENTAL_ORDER
);


--23: Customers who never rented
SELECT *
FROM [USER]
WHERE role = 'customer' and userId NOT IN 
(
   SELECT customerId
   FROM RENTAL_ORDER
);

--24: Orders with highest total fee
SELECT *
FROM RENTAL_ORDER
WHERE totalFee =
(
   SELECT MAX(totalFee)
   FROM RENTAL_ORDER
);

--25: Payments larger than average payment
SELECT *
FROM PAYMENT
WHERE amount >
(
   SELECT AVG(amount)
   FROM PAYMENT
);

--26: Most expensive costume
SELECT *
FROM COSTUME
WHERE dailyRate =
(
   SELECT MAX(dailyRate)
   FROM COSTUME
);

--27: Orders using newest policy
SELECT *
FROM RENTAL_ORDER
WHERE policyId =
(
   SELECT TOP 1 policyId
   FROM PRICING_POLICY
   ORDER BY effectiveDate DESC
);

--28: Available items belonging to expensive costumes
SELECT *
FROM COSTUME_ITEM
WHERE costumeId IN
(
   SELECT costumeId
   FROM COSTUME
   WHERE dailyRate > 500000
);

--29: Payments for active orders
SELECT *
FROM PAYMENT
WHERE orderId IN
(
   SELECT orderId
   FROM RENTAL_ORDER
   WHERE status = 'active'
);

--30: Orders with total fee above average
SELECT *
FROM RENTAL_ORDER
WHERE totalFee >
(
   SELECT AVG(totalFee)
   FROM RENTAL_ORDER
);


--ADVANCED QUERIES
--31: Customers with orders having total fee above average
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

--32: Costumes rented in the most expensive order
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
--33: Payments related to orders with highest fee
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

--34: Policies used by above-average orders
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


