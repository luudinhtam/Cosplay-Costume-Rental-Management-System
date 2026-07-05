CREATE DATABASE DBI202Project

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



--DATA
DROP TABLE [USER]
drop table PRICING_POLICY
drop table COSTUME
drop table COSTUME_IMAGE
drop table COSTUME_ITEM
drop table ORDER_ITEM
drop table PAYMENT
drop table RENTAL_ORDER




-- 1. NHẬP DỮ LIỆU BẢNG [USER] (Có Admin, Staff và Khách thuê)
INSERT INTO [USER] (fullName, email, phone, password, role, address, status) VALUES
(N'Nguyễn Trọng Phúc', 'phucnt@fpt.edu.vn', '0912345678', 'password123', 'admin', N'Thủ Đức, TP. HCM', 'active'),
(N'Đoàn Vinh Quang', 'quangdv@gmail.com', '0945678901', 'hashed_pass1', 'staff', N'Quận 7, TP. HCM', 'active'),
(N'Lưu Đình Tâm', 'tamld@fpt.edu.vn', '0923456789', 'password123', 'staff', N'Quận 9, TP. HCM', 'active'),
(N'Cao Quốc Việt', 'vietcq@fpt.edu.vn', '0934567890', 'password123', 'staff', N'Bình Thạnh, TP. HCM', 'active'),
(N'Bùi Thị Thanh', 'thanhbt@gmail.com', '0911223344', 'hashed_pass8', 'customer', N'Quận 4, TP. HCM', 'inactive'),
(N'Hoàng Ngọc Bảo', 'baohn@gmail.com', '0922334455', 'hashed_pass9', 'customer', N'Quận 8, TP. HCM', 'inactive'),
(N'Trịnh Cẩm Ly', 'lytc@gmail.com', '0944556677', 'hashed_pass10', 'customer', N'Quận 12, TP. HCM', 'inactive'),
(N'Ngô Tuấn Anh', 'anhnt@gmail.com', '0955667788', 'hashed_pass11', 'customer', N'Quận 5, TP. HCM', 'inactive'),
(N'Trần Minh Hoàng', 'hoangtm@gmail.com', '0956789012', 'hashed_pass2', 'customer', N'Quận 1, TP. HCM', 'active'),
(N'Lê Thị Mai', 'mailt@gmail.com', '0967890123', 'hashed_pass3', 'customer', N'Gò Vấp, TP. HCM', 'active'),
(N'Phạm Anh Tú', 'tupa@gmail.com', '0978901234', 'hashed_pass4', 'customer', N'Tân Bình, TP. HCM', 'active'),
(N'Nguyễn Hải Yến', 'yennh@gmail.com', '0989012345', 'hashed_pass5', 'customer', N'Phú Nhuận, TP. HCM', 'active'),
(N'Vũ Hoàng Long', 'longvh@gmail.com', '0990123456', 'hashed_pass6', 'customer', N'Quận 3, TP. HCM', 'active'),
(N'Đặng Thu Thảo', 'thaodt@gmail.com', '0901234567', 'hashed_pass7', 'customer', N'Quận 2, TP. HCM', 'active'),
(N'Đinh Văn Mạnh', 'manhdv@fpt.edu.vn', '0933445566', 'password123', 'customer', N'Quận 10, TP. HCM', 'inactive');





-- 2. NHẬP DỮ LIỆU BẢNG PRICING_POLICY (Do Admin tạo - userId là 1)
INSERT INTO PRICING_POLICY (policyName, lateFeeRate, maxActiveRentals, effectiveDate, createdBy) VALUES
(N'Chính sách Ngày thường', 50000.00, 3, '2026-01-01', 1),
(N'Chính sách Lễ hội Halloween', 80000.00, 5, '2026-10-25', 1),
(N'Chính sách Tết Cosplay', 70000.00, 4, '2026-02-10', 1),
(N'Chính sách Ưu đãi Thành viên', 40000.00, 6, '2026-03-01', 1);


-- 3. NHẬP DỮ LIỆU BẢNG COSTUME (Các mẫu thiết kế trang phục gốc)
INSERT INTO COSTUME (name, characterName, theme, dailyRate, baseDeposit) VALUES
(N'Trang phục Vệ Binh Tinh Tú', N'Ahri', N'League of Legends', 160000.00, 550000.00),
(N'Đồng phục Tử Thần', N'Kurosaki Ichigo', N'Bleach', 140000.00, 450000.00),
(N'Võ phục trường Quy Lão', N'Son Goku', N'Dragon Ball', 110000.00, 350000.00),
(N'Trang phục Kimono Genshin Impact', N'Kamisato Ayaka', N'Genshin Impact', 150000.00, 500000.00),
(N'Đồng phục Học viện Jujutsu', N'Gojo Satoru', N'Jujutsu Kaisen', 120000.00, 400000.00),
(N'Giáp Hokage Đệ Tứ', N'Namikaze Minato', N'Naruto', 200000.00, 700000.00),
(N'Váy dạ hội quý phái', N'Violet', N'Arena of Valor', 180000.00, 600000.00),
(N'Trang phục Thợ săn Quỷ', N'Kamado Tanjirou', N'Demon Slayer', 130000.00, 450000.00),
(N'Battle Suit Wuthering Waves', N'Jiyan', N'Wuthering Waves', 220000.00, 800000.00),
(N'Trang phục thuyền trưởng', N'Monkey D. Luffy', N'One Piece', 100000.00, 300000.00);

-- 4. NHẬP DỮ LIỆU BẢNG COSTUME_ITEM (Món đồ cụ thể trong kho tương ứng với costumeId)
INSERT INTO COSTUME_ITEM (costumeId, size, color, status, condition) VALUES
(1, 'S', 'Light Blue', 'available', '95% New'),
(1, 'M', 'Light Blue', 'rented', '90% New'),
(2, 'L', 'Emerald Black', 'available', '98% New'),
(2, 'XL', 'Emerald Black', 'unavailable', '99% New'),
(3, 'M', 'White and Red', 'rented', '85% New'),
(4, 'S', 'Evening Purple', 'available', '100% New'),
(5, 'M', 'Checkered Blue', 'unavailable', '92% New'),
(6, 'L', 'Dark Green', 'rented', '99% New'),
(7, 'M', 'Red and Blue Pants', 'available', '90% New'),
(7, 'L', 'Red and Blue Pants', 'available', '88% New'),
(8, 'S', 'Pink and White', 'available', '100% New'),   
(8, 'M', 'Pink and White', 'rented', '95% New'),        
(9, 'L', 'Black', 'available', '98% New'),              
(9, 'XL', 'Black', 'unavailable', 'Missing belt'),      
(10, 'M', 'Orange and Blue', 'available', '90% New'),   
(10, 'L', 'Orange and Blue', 'rented', '85% New');      



-- 5. NHẬP DỮ LIỆU BẢNG COSTUME_IMAGE (Link ảnh đi kèm)
INSERT INTO COSTUME_IMAGE (costumeId, imageUrl, thumbnail) VALUES
(1, 'https://storage.cosplay.com/ayaka_front.jpg', 1),
(1, 'https://storage.cosplay.com/ayaka_back.jpg', 0),
(2, 'https://storage.cosplay.com/gojo_main.jpg', 1),
(3, 'https://storage.cosplay.com/minato_cloak.jpg', 1),
(4, 'https://storage.cosplay.com/violet_dress.jpg', 1),
(5, 'https://storage.cosplay.com/tanjirou_haori.jpg', 1),
(6, 'https://storage.cosplay.com/jiyan_armor.jpg', 1),
(7, 'https://storage.cosplay.com/luffy_wano.jpg', 1),
(8, 'https://storage.cosplay.com/ahri_starguardian_front.jpg', 1),
(8, 'https://storage.cosplay.com/ahri_starguardian_back.jpg', 0),
(9, 'https://storage.cosplay.com/ichigo_shinigami.jpg', 1),
(10, 'https://storage.cosplay.com/goku_turtle.jpg', 1);


-- 6. NHẬP DỮ LIỆU BẢNG RENTAL_ORDER (Đơn hàng tổng quát)
-- Khách thuê (customerId): 4 -> 10. Nhân viên duyệt (staffId): 2 hoặc 3. Chính sách (policyId): 1 -> 4.
INSERT INTO RENTAL_ORDER (customerId, staffId, policyId, status, orderDate, startDate, endDate, actualReturnDate, lateFeePerDay, totalFee) VALUES
(4, 2, 1, 'Returned', '2026-06-01 08:30:00', '2026-06-02', '2026-06-05', '2026-06-05', 50000.00, 450000.00),
(5, 2, 1, 'Active', '2026-06-18 14:20:00', '2026-06-19', '2026-06-22', NULL, 50000.00, 360000.00),
(6, 3, 1, 'Returned', '2026-06-05 10:00:00', '2026-06-06', '2026-06-08', '2026-06-10', 50000.00, 360000.00), -- Trễ 2 ngày
(7, 3, 4, 'Pending', '2026-06-21 16:45:00', '2026-06-23', '2026-06-25', NULL, 40000.00, 440000.00),
(8, 2, 1, 'Cancelled', '2026-06-10 09:15:00', '2026-06-12', '2026-06-14', NULL, 50000.00, 0.00),
(9, 2, 1, 'Active', '2026-06-19 11:00:00', '2026-06-20', '2026-06-23', NULL, 50000.00, 660000.00),
(10, 3, 1, 'Returned', '2026-06-25 09:00:00', '2026-06-26', '2026-06-27', '2026-06-27', 50000.00, 300000.00), -- Trả đúng hạn
(4, 2, 4, 'Active', '2026-07-01 10:30:00', '2026-07-02', '2026-07-05', NULL, 40000.00, 520000.00),             -- Đang thuê bằng chính sách ưu đãi thành viên
(8, 3, 1, 'Pending', '2026-07-02 08:15:00', '2026-07-04', '2026-07-05', NULL, 50000.00, 260000.00),              -- Đơn mới đặt chờ xử lý
(7, 2, 1, 'Returned', '2026-06-20 14:00:00', '2026-06-21', '2026-06-22', '2026-06-24', 50000.00, 400000.00);    -- Trả trễ 2 ngày



-- 7. NHẬP DỮ LIỆU BẢNG ORDER_ITEM (Chi tiết từng món đồ được thuê trong mỗi đơn hàng)
-- orderId tham chiếu từ bảng 6, itemId tham chiếu từ bảng 4
INSERT INTO ORDER_ITEM (orderId, itemId, statusBefore, statusAfter, itemDailyRate) VALUES
-- Đơn 1 (Returned - Đã trả): Có ghi nhận trạng thái sau khi thuê
(1, 2, '90% New', '90% New, stable', 150000.00),
-- Đơn 2 (Active - Đang thuê): Chưa trả đồ nên statusAfter = NULL
(2, 5, '85% New', NULL, 200000.00),
-- Đơn 3 (Returned - Đã trả trễ 2 ngày): Ghi nhận tình trạng đồ hao mòn
(3, 3, '98% New', '95% New, stable', 120000.00),
-- Đơn 4 (Pending - Đang chờ xử lý): Mới lên đơn, statusAfter = NULL
(4, 6, '100% New', NULL, 180000.00),
-- Đơn 5 (Cancelled - Đã hủy): Đơn bị hủy nên đồ không được sử dụng, statusAfter = NULL
(5, 7, '92% New', NULL, 130000.00),
-- Đơn 6 (Active - Đang thuê): Khách đang giữ đồ, statusAfter = NULL
(6, 8, '99% New', NULL, 220000.00),
-- Đơn 7 (Returned - Đã trả đúng hạn): Đồ còn nguyên vẹn
(7, 9, '90% New', '90% New', 100000.00),
-- Đơn 8 (Active - Đang thuê): Đơn này khách thuê 2 món đồ (Ahri và Ayaka)
(8, 12, '95% New', NULL, 160000.00),
(8, 1, '95% New', NULL, 150000.00),
-- Đơn 9 (Pending - Chờ xử lý): Đặt bộ đồ Goku, statusAfter = NULL
(9, 15, '90% New', NULL, 110000.00),
-- Đơn 10 (Returned - Đã trả trễ hạn): Thuê 2 món, có 1 món hơi bẩn sau khi trả
(10, 10, '88% New', 'Minor dirt', 100000.00),
(10, 4, '99% New', '99% New', 120000.00);


-- 8. NHẬP DỮ LIỆU BẢNG PAYMENT (Hóa đơn thanh toán của các đơn hàng)
INSERT INTO PAYMENT (orderId, paymentDate, amount, totalLateFee, paymentMethod, status) VALUES
-- Đơn 1: Đã trả đúng hạn (tổng phí 450k)
(1, '2026-06-05 10:00:00', 450000.00, 0.00, 'MoMo', 'success'),
-- Đơn 2: Đang thuê (Active), mới đặt cọc trước một phần (200k)
(2, '2026-06-18 14:30:00', 200000.00, 0.00, 'VCB Digibank', 'pending'),
-- Đơn 3: Đã trả nhưng trễ 2 ngày (phí thuê 360k + phạt 100k = 460k)
(3, '2026-06-10 11:15:00', 460000.00, 100000.00, 'Cash', 'success'),
-- Đơn 4: Đang chờ xử lý (Pending), chưa thanh toán
(4, NULL, 0.00, 0.00, 'ShopeePay', 'pending'),
-- Đơn 5: Đã hủy (Cancelled), không có giao dịch
(5, '2026-06-10 10:00:00', 0.00, 0.00, 'ZaloPay', 'cancel'),
-- Đơn 6: Đang thuê (Active), mới đặt cọc trước một phần (300k)
(6, '2026-06-19 11:15:00', 300000.00, 0.00, 'MoMo', 'pending'),
-- Đơn 7: Đã trả đúng hạn (tổng phí 300k)
(7, '2026-06-27 10:00:00', 300000.00, 0.00, 'MB Bank', 'success'),
-- Đơn 8: Đang thuê bằng thẻ thành viên (Active), mới cọc trước (250k)
(8, '2026-07-01 11:00:00', 250000.00, 0.00, 'Cash', 'pending'),
-- Đơn 9: Mới đặt đang chờ xử lý (Pending), chưa thanh toán
(9, NULL, 0.00, 0.00, 'VCB Digibank', 'pending'),
-- Đơn 10: Đã trả nhưng trễ 2 ngày (phí thuê 400k + phạt 100k = 500k)
(10, '2026-06-24 14:30:00', 500000.00, 100000.00, 'ZaloPay', 'success');