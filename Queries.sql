-- BASIC QUERIES

-- 1: Retrieve each table
SELECT * FROM [USER];
SELECT * FROM COSTUME;
SELECT * FROM COSTUME_ITEM;
SELECT * FROM COSTUME_IMAGE;
SELECT * FROM ORDER_ITEM;
SELECT * FROM RENTAL_ORDER;
SELECT * FROM PAYMENT;
SELECT * FROM PRICING_POLICY;


-- WHERE QUERIES
-- 2: Retrieves with condition
SELECT * FROM [USER] WHERE status = 'active';
SELECT * FROM [USER] WHERE role = 'customer';
SELECT * FROM COSTUME_ITEM WHERE status = 'available';
SELECT * FROM RENTAL_ORDER WHERE status = 'Active'
SELECT * FROM PAYMENT WHERE status = 'success';


-- ORDER BY QUERIES
-- 3: Order by
-- Display costumes from highest rental fee to lowest.
SELECT * FROM COSTUME ORDER BY dailyRate DESC;

-- Sort users alphabetically.
SELECT * FROM [USER] ORDER BY fullName ASC;

-- Show newest orders first.
SELECT * FROM RENTAL_ORDER ORDER BY orderDate DESC;

-- Display highest payments first.
SELECT * FROM PAYMENT ORDER BY amount DESC;

-- Show latest policies first.
SELECT * FROM PRICING_POLICY ORDER BY effectiveDate DESC;

-- AGGREGATE QUERIES
-- 4: Count
-- Count all registered users.
SELECT COUNT(*) AS TotalUsers FROM [USER];

-- Count rentable costume items.
SELECT COUNT(*) AS AvailableItems FROM COSTUME_ITEM WHERE status = 'available';

-- 5: Calculate Average
-- Calculate average rental price per day.
SELECT AVG(dailyRate) AS AverageDailyRate FROM COSTUME;

-- 6: Find Maximum
-- Find the highest payment.
SELECT MAX(amount) AS HighestPayment FROM PAYMENT;

-- 7: Calculate total
SELECT SUM(amount) AS TotalRevenue FROM PAYMENT WHERE status = 'success';

-- JOIN QUERIES
-- 8: Customer information with rental orders
SELECT u.fullName, ro.orderId, ro.orderDate, ro.status
FROM [USER] u
INNER JOIN RENTAL_ORDER ro ON u.userId = ro.customerId;

-- 9: Staff handling orders
SELECT s.fullName, ro.orderId, ro.status
FROM [USER] s
INNER JOIN RENTAL_ORDER ro ON s.userId = ro.staffId;

-- 10: Costume items with costume names
SELECT ci.itemId, c.name, ci.size, ci.color, ci.status
FROM COSTUME_ITEM ci
INNER JOIN COSTUME c ON ci.costumeId = c.costumeId;

-- 11: Rental orders with pricing policies
SELECT ro.orderId, pp.policyName, pp.lateFeeRate
FROM RENTAL_ORDER ro
INNER JOIN PRICING_POLICY pp ON ro.policyId = pp.policyId;

-- 12: Orders and payments
SELECT ro.orderId, p.paymentId, p.amount, p.status
FROM RENTAL_ORDER ro
INNER JOIN PAYMENT p ON ro.orderId = p.orderId;



-- GROUP BY AND HAVING QUERIES 
-- 13: Number of orders per customer
SELECT customerId, COUNT(*) AS TotalOrders
FROM RENTAL_ORDER
GROUP BY customerId;

-- 14: Customers with at least 1 order
SELECT customerId, COUNT(*) AS TotalOrders
FROM RENTAL_ORDER
GROUP BY customerId
HAVING COUNT(*) >= 1;

-- 15: Total revenue by payment method
SELECT paymentMethod, SUM(amount) AS Revenue
FROM PAYMENT
GROUP BY paymentMethod;

-- 16: Average costume rental price by theme 
SELECT theme, AVG(dailyRate) AS AvgRate
FROM COSTUME
GROUP BY theme;

-- 17: Number of costumes in each theme
SELECT theme, COUNT(*) AS TotalCostumes
FROM COSTUME
GROUP BY theme;


-- QUERIES CONTAIN SUBQUERIES


-- 18: Costumes with rental price above average
SELECT * FROM COSTUME 
WHERE dailyRate > (SELECT AVG(dailyRate) FROM COSTUME);

-- 19: Customers who have placed orders
SELECT * FROM [USER] 
WHERE userId IN (SELECT customerId FROM RENTAL_ORDER);

-- 20: Customers who never rented
SELECT * FROM [USER] 
WHERE role = 'customer' AND userId NOT IN (SELECT customerId FROM RENTAL_ORDER);

-- 21: Orders with highest total fee
SELECT * FROM RENTAL_ORDER 
WHERE totalFee = (SELECT MAX(totalFee) FROM RENTAL_ORDER);

-- 22: Payments larger than average payment
SELECT * FROM PAYMENT 
WHERE amount > (SELECT AVG(amount) FROM PAYMENT);

-- 23: Most expensive costume
SELECT * FROM COSTUME 
WHERE dailyRate = (SELECT MAX(dailyRate) FROM COSTUME);

-- 24: Orders using newest policy
SELECT * FROM RENTAL_ORDER 
WHERE policyId = (SELECT TOP 1 policyId FROM PRICING_POLICY ORDER BY effectiveDate DESC);

-- 25: Available items belonging to expensive costumes 
SELECT * FROM COSTUME_ITEM
WHERE costumeId IN (SELECT costumeId FROM COSTUME WHERE dailyRate > 150000);

-- 26: Payments for active orders (Sửa 'active' thành 'Active' khớp data mới)
SELECT * FROM PAYMENT 
WHERE orderId IN (SELECT orderId FROM RENTAL_ORDER WHERE status = 'Active');

-- 27: Orders with total fee above average
SELECT * FROM RENTAL_ORDER 
WHERE totalFee > (SELECT AVG(totalFee) FROM RENTAL_ORDER);


-- ADVANCED QUERIES & SUBQUERIES
-- 28: Customers with orders having total fee above average
SELECT u.userId, u.fullName AS username, ro.totalFee
FROM [USER] u
INNER JOIN RENTAL_ORDER ro ON u.userId = ro.customerId
WHERE ro.totalFee > (SELECT AVG(totalFee) FROM RENTAL_ORDER);

-- 29: Costumes rented in the most expensive order
SELECT * FROM COSTUME
WHERE costumeId IN (
   SELECT costumeId FROM COSTUME_ITEM WHERE itemId IN (
       SELECT itemId FROM ORDER_ITEM WHERE orderId = (
           SELECT TOP 1 orderId FROM RENTAL_ORDER ORDER BY totalFee DESC
       )
   )
);

-- 30: Payments related to orders with highest fee
SELECT * FROM PAYMENT 
WHERE orderId IN (SELECT orderId FROM RENTAL_ORDER WHERE totalFee = (SELECT MAX(totalFee) FROM RENTAL_ORDER));

-- 31: Policies used by above-average orders
SELECT * FROM PRICING_POLICY 
WHERE policyId IN (SELECT policyId FROM RENTAL_ORDER WHERE totalFee > (SELECT AVG(totalFee) FROM RENTAL_ORDER));


-- IN, ANY, ALL QUERIES
-- 32: Customers with active orders (Sửa 'active' thành 'Active')
SELECT * FROM [USER] 
WHERE userId IN (SELECT customerId FROM RENTAL_ORDER WHERE status = 'Active');

-- 33: Payments greater than ANY order fee
SELECT * FROM PAYMENT 
WHERE amount > ANY (SELECT totalFee FROM RENTAL_ORDER);

-- 34: Payments greater than ALL order fees
SELECT * FROM PAYMENT 
WHERE amount > ALL (SELECT totalFee FROM RENTAL_ORDER);


