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