-- 1. Tạo bảng USER
CREATE TABLE [USER] (
    userId INT IDENTITY(1,1) PRIMARY KEY,
    fullName NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    password NVARCHAR(255) NOT NULL,
    role VARCHAR(20),
    address NVARCHAR(255),
    status VARCHAR(20)
);

-- 2. Tạo bảng PRICING_POLICY
CREATE TABLE PRICING_POLICY (
    policyId INT IDENTITY(1,1) PRIMARY KEY,
    policyName NVARCHAR(100),
    lateFeeRate DECIMAL(10,2),
    maxActiveRentals INT,
    effectiveDate DATE,
    createdBy INT,
    
    CONSTRAINT FK_PRICING_POLICY FOREIGN KEY (createdBy) REFERENCES [USER](userId)
);

-- 3. Tạo bảng COSTUME
CREATE TABLE COSTUME (
    costumeId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    characterName NVARCHAR(100),
    theme NVARCHAR(100),
    dailyRate DECIMAL(10,2),
    baseDeposit DECIMAL(10,2)
);

-- 4. Tạo bảng COSTUME_ITEM
CREATE TABLE COSTUME_ITEM (
    itemId INT IDENTITY(1,1) PRIMARY KEY,
    costumeId INT,
    size VARCHAR(10),
    color VARCHAR(20),
    status VARCHAR(20),
    condition VARCHAR(20),
    
    CONSTRAINT FK_COSTUME_ITEM FOREIGN KEY (costumeId) REFERENCES COSTUME(costumeId)
);

-- 5. Tạo bảng COSTUME_IMAGE
CREATE TABLE COSTUME_IMAGE (
    imageId INT IDENTITY(1,1) PRIMARY KEY,
    costumeId INT,
    imageUrl NVARCHAR(MAX),
    thumbnail BIT,
    
    CONSTRAINT FK_COSTUME_IMAGE FOREIGN KEY (costumeId) REFERENCES COSTUME(costumeId)
);

-- 6. Tạo bảng RENTAL_ORDER
CREATE TABLE RENTAL_ORDER (
    orderId INT IDENTITY(1,1) PRIMARY KEY,
    customerId INT,
    staffId INT,
    policyId INT,
    status VARCHAR(20),
    orderDate DATETIME,
    startDate DATE,
    endDate DATE,
    actualReturnDate DATE,
    lateFeePerDay DECIMAL(10,2),
    totalFee DECIMAL(10,2),
    
    CONSTRAINT FK_RENTAL_ORDER_customer FOREIGN KEY (customerId) REFERENCES [USER](userId),
    CONSTRAINT FK_RENTAL_ORDER_staff FOREIGN KEY (staffId) REFERENCES [USER](userId),
    CONSTRAINT FK_RENTAL_ORDER_policy FOREIGN KEY (policyId) REFERENCES PRICING_POLICY(policyId)
);

-- 7. Tạo bảng ORDER_ITEM
CREATE TABLE ORDER_ITEM (
    orderId INT,
    itemId INT,
    statusBefore VARCHAR(20),
    statusAfter VARCHAR(20),
    itemDailyRate DECIMAL(10,2),
    PRIMARY KEY (orderId, itemId),
    
    CONSTRAINT FK_ORDER_ITEM_order FOREIGN KEY (orderId) REFERENCES RENTAL_ORDER(orderId),
    CONSTRAINT FK_ORDER_ITEM_item FOREIGN KEY (itemId) REFERENCES COSTUME_ITEM(itemId)
);

-- 8. Tạo bảng PAYMENT
CREATE TABLE PAYMENT (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    orderId INT,
    paymentDate DATETIME,
    amount DECIMAL(10,2),
    totalLateFee DECIMAL(10,2),
    paymentMethod VARCHAR(50),
    status VARCHAR(20),
    
    CONSTRAINT FK_PAYMENT_order FOREIGN KEY (orderId) REFERENCES RENTAL_ORDER(orderId)
);

--BASIC QUERIES
--1: Retrieve all users
select * from [USER]

--2: Retrieve all costumes
SELECT * FROM COSTUME

--3: Retrieve all costume items 
SELECT * FROM COSTUME_ITEM

--4: Retrieve all rental orders 
SELECT * FROM RENTAL_ORDER

--5: Retrieve all payments
SELECT * FROM PAYMENT

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
