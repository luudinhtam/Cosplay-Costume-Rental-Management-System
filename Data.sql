-- 1. NHẬP DỮ LIỆU BẢNG [USER] (Có Admin, Staff và Khách thuê)
INSERT INTO [USER] (fullName, email, phone, password, role, address, status) VALUES
(N'Nguyễn Trọng Phúc', 'phucnt@fpt.edu.vn', '0912345678', 'password123', 'admin', N'Thủ Đức, TP. HCM', 'active'),
(N'Lưu Đình Tâm', 'tamld@fpt.edu.vn', '0923456789', 'password123', 'staff', N'Quận 9, TP. HCM', 'active'),
(N'Cao Quốc Việt', 'vietcq@fpt.edu.vn', '0934567890', 'password123', 'staff', N'Bình Thạnh, TP. HCM', 'active'),
(N'Đoàn Vinh Quang', 'quangdv@gmail.com', '0945678901', 'hashed_pass1', 'customer', N'Quận 7, TP. HCM', 'active'),
(N'Trần Minh Hoàng', 'hoangtm@gmail.com', '0956789012', 'hashed_pass2', 'customer', N'Quận 1, TP. HCM', 'active'),
(N'Lê Thị Mai', 'mailt@gmail.com', '0967890123', 'hashed_pass3', 'customer', N'Gò Vấp, TP. HCM', 'active'),
(N'Phạm Anh Tú', 'tupa@gmail.com', '0978901234', 'hashed_pass4', 'customer', N'Tân Bình, TP. HCM', 'active'),
(N'Nguyễn Hải Yến', 'yennh@gmail.com', '0989012345', 'hashed_pass5', 'customer', N'Phú Nhuận, TP. HCM', 'active'),
(N'Vũ Hoàng Long', 'longvh@gmail.com', '0990123456', 'hashed_pass6', 'customer', N'Quận 3, TP. HCM', 'active'),
(N'Đặng Thu Thảo', 'thaodt@gmail.com', '0901234567', 'hashed_pass7', 'customer', N'Quận 2, TP. HCM', 'active');

-- 2. NHẬP DỮ LIỆU BẢNG PRICING_POLICY (Do Admin hoặc Staff tạo - userId từ 1 đến 3)
INSERT INTO PRICING_POLICY (policyName, lateFeeRate, maxActiveRentals, effectiveDate, createdBy) VALUES
(N'Chính sách Ngày thường', 50000.00, 3, '2026-01-01', 1),
(N'Chính sách Lễ hội Halloween', 80000.00, 5, '2026-10-25', 1),
(N'Chính sách Tết Cosplay', 70000.00, 4, '2026-02-10', 2),
(N'Chính sách Ưu đãi Thành viên', 40000.00, 6, '2026-03-01', 3);

-- 3. NHẬP DỮ LIỆU BẢNG COSTUME (Các mẫu thiết kế trang phục gốc)
INSERT INTO COSTUME (name, characterName, theme, dailyRate, baseDeposit) VALUES
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
(2, 'XL', 'Emerald Black', 'maintenance', '99% New'),
(3, 'M', 'White and Red', 'rented', '85% New'),
(4, 'S', 'Evening Purple', 'available', '100% New'),
(5, 'M', 'Checkered Blue', 'available', '92% New'),
(6, 'L', 'Dark Green', 'rented', '99% New'),
(7, 'M', 'Red and Blue Pants', 'available', '90% New'),
(7, 'L', 'Red and Blue Pants', 'available', '88% New');




-- 5. NHẬP DỮ LIỆU BẢNG COSTUME_IMAGE (Link ảnh đi kèm)
INSERT INTO COSTUME_IMAGE (costumeId, imageUrl, thumbnail) VALUES
(1, 'https://storage.cosplay.com/ayaka_front.jpg', 1),
(1, 'https://storage.cosplay.com/ayaka_back.jpg', 0),
(2, 'https://storage.cosplay.com/gojo_main.jpg', 1),
(3, 'https://storage.cosplay.com/minato_cloak.jpg', 1),
(4, 'https://storage.cosplay.com/violet_dress.jpg', 1),
(5, 'https://storage.cosplay.com/tanjirou_haori.jpg', 1),
(6, 'https://storage.cosplay.com/jiyan_armor.jpg', 1),
(7, 'https://storage.cosplay.com/luffy_wano.jpg', 1);

-- 6. NHẬP DỮ LIỆU BẢNG RENTAL_ORDER (Đơn hàng tổng quát)
-- Khách thuê (customerId): 4 -> 10. Nhân viên duyệt (staffId): 2 hoặc 3. Chính sách (policyId): 1 -> 4.
INSERT INTO RENTAL_ORDER (customerId, staffId, policyId, status, orderDate, startDate, endDate, actualReturnDate, lateFeePerDay, totalFee) VALUES
(4, 2, 1, 'Completed', '2026-06-01 08:30:00', '2026-06-02', '2026-06-05', '2026-06-05', 50000.00, 450000.00),
(5, 2, 1, 'Active', '2026-06-18 14:20:00', '2026-06-19', '2026-06-22', NULL, 50000.00, 360000.00),
(6, 3, 1, 'Completed', '2026-06-05 10:00:00', '2026-06-06', '2026-06-08', '2026-06-10', 50000.00, 360000.00), -- Trễ 2 ngày
(7, 3, 4, 'Pending', '2026-06-21 16:45:00', '2026-06-23', '2026-06-25', NULL, 40000.00, 440000.00),
(8, 2, 1, 'Cancelled', '2026-06-10 09:15:00', '2026-06-12', '2026-06-14', NULL, 50000.00, 0.00),
(9, 2, 1, 'Active', '2026-06-19 11:00:00', '2026-06-20', '2026-06-23', NULL, 50000.00, 660000.00);

-- 7. NHẬP DỮ LIỆU BẢNG ORDER_ITEM (Chi tiết từng món đồ được thuê trong mỗi đơn hàng)
-- orderId tham chiếu từ bảng 6, itemId tham chiếu từ bảng 4
INSERT INTO ORDER_ITEM (orderId, itemId, statusBefore, statusAfter, itemDailyRate) VALUES
(1, 2, '90% New', '90% New, stable', 150000.00), -- Đơn 1 thuê món 2
(2, 5, '85% New', NULL, 200000.00),              -- Đơn 2 thuê món 5
(3, 2, '92% New', '90% New', 150000.00),         -- Đơn 3 thuê món 2 (đã trả)
(3, 1, '95% New', '95% New', 150000.00),         -- Đơn 3 thuê thêm món 1
(4, 6, '100% New', NULL, 180000.00),             -- Đơn 4 thuê món 6
(6, 8, '99% New', NULL, 220000.00);              -- Đơn 6 thuê món 8

-- 8. NHẬP DỮ LIỆU BẢNG PAYMENT (Hóa đơn thanh toán của các đơn hàng)
INSERT INTO PAYMENT (orderId, paymentDate, amount, totalLateFee, paymentMethod, status) VALUES
(1, '2026-06-05 17:00:00', 450000.00, 0.00, 'MoMo', 'Paid'),
(2, '2026-06-18 14:30:00', 200000.00, 0.00, 'VCB Digibank', 'Partial'), -- Mới cọc trước một phần
(3, '2026-06-10 11:15:00', 460000.00, 100000.00, 'Cash', 'Paid'),      -- Có cộng 100k tiền trễ hạn 2 ngày
(4, NULL, 0.00, 0.00, 'ShopeePay', 'Unpaid');
