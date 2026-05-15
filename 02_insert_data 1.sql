-- ============================================================
--  FILE: 02_insert_data.sql  |  ENGINE: SQL Server (T-SQL)
--  MÔ TẢ: Seed data cho Cửa hàng Sách - 5 bảng
--  LƯU Ý: Chạy SAU khi đã chạy 01_init_structure.sql
-- ============================================================

USE QL_BANHANG;
GO

-- 1. KHACHHANG (15 khách hàng)
INSERT INTO KHACHHANG (TenKH, SoDienThoai, Email, DiaChi, DiemTichLuy) VALUES
(N'Nguyễn Bình Minh', '0901112223', 'minh.nb@gmail.com', N'123 Lê Lợi, Quận 1, TP.HCM', 150),
(N'Trần Thu Hà', '0912223334', 'ha.tt@gmail.com', N'45 Nguyễn Huệ, Quận 1, TP.HCM', 320),
(N'Lê Hoàng Nam', '0923334445', 'nam.lh@outlook.com', N'78 Hai Bà Trưng, Quận 3, TP.HCM', 50),
(N'Phạm Minh Châu', '0934445556', 'chau.pm@yahoo.com', N'10 Đinh Tiên Hoàng, Bình Thạnh', 450),
(N'Hoàng Bảo Long', '0945556667', 'long.hb@gmail.com', N'22 Cách Mạng Tháng 8, Quận 10', 0),
(N'Vũ Tuyết Mai', '0956667778', 'mai.vt@gmail.com', N'55 Võ Văn Kiệt, Quận 5, TP.HCM', 210),
(N'Đặng Anh Tuấn', '0967778889', 'tuan.da@gmail.com', N'88 Trần Hưng Đạo, Quận 1, TP.HCM', 120),
(N'Bùi Phương Linh', '0978889990', 'linh.bp@hotmail.com', N'15 Lý Thường Kiệt, Tân Bình', 85),
(N'Ngô Gia Huy', '0989990001', 'huy.ng@gmail.com', N'66 Phan Đăng Lưu, Phú Nhuận', 600),
(N'Lý Thanh Thảo', '0990001112', 'thao.lt@gmail.com', N'102 Quang Trung, Gò Vấp', 30),
(N'Đỗ Hữu Phước', '0909998887', 'phuoc.dh@gmail.com', N'25 Đường số 7, Quận 7', 180),
(N'Trương Mỹ Tâm', '0918887776', 'tam.tm@gmail.com', N'40 Bà Huyện Thanh Quan, Quận 3', 250),
(N'Phan Thanh Bình', '0927776665', 'binh.pt@gmail.com', N'12 Nguyễn Văn Cừ, Quận 5', 40),
(N'Võ Hoài Nam', '0936665554', 'nam.vh@gmail.com', N'300 Cộng Hòa, Tân Bình', 110),
(N'Nguyễn Khánh Vy', '0945554443', 'vy.nk@gmail.com', N'18 Trường Sa, Bình Thạnh', 500);
GO

-- 2. SANPHAM (30 sản phẩm thuộc nhiều danh mục)
INSERT INTO SANPHAM (TenSP, MaSKU, MaDanhMuc, GiaBan, MoTa) VALUES
-- Văn học
(N'Nhà Giả Kim', 'BOOK-VH-001', N'Văn học', 79000.00, N'Tiểu thuyết của Paulo Coelho'),
(N'Mắt Biếc', 'BOOK-VH-002', N'Văn học', 110000.00, N'Truyện dài của Nguyễn Nhật Ánh'),
(N'Số Đỏ', 'BOOK-VH-003', N'Văn học', 65000.00, N'Tác phẩm tiêu biểu của Vũ Trọng Phụng'),
(N'Rừng Na Uy', 'BOOK-VH-004', N'Văn học', 125000.00, N'Tiểu thuyết Haruki Murakami'),
(N'Đất Rừng Phương Nam', 'BOOK-VH-005', N'Văn học', 95000.00, N'Tác phẩm của Đoàn Giỏi'),
(N'Hai Đứa Trẻ', 'BOOK-VH-006', N'Văn học', 45000.00, N'Truyện ngắn Thạch Lam'),
-- Kinh tế
(N'Đắc Nhân Tâm', 'BOOK-KT-001', N'Kinh tế', 86000.00, N'Dale Carnegie - Nghệ thuật ứng xử'),
(N'Cha Giàu Cha Nghèo', 'BOOK-KT-002', N'Kinh tế', 159000.00, N'Robert Kiyosaki - Tư duy tài chính'),
(N'Kinh tế học cơ bản', 'BOOK-KT-003', N'Kinh tế', 250000.00, N'Giáo trình kinh tế nhập môn'),
(N'Tư duy nhanh và chậm', 'BOOK-KT-004', N'Kinh tế', 199000.00, N'Daniel Kahneman'),
(N'Khởi nghiệp tinh gọn', 'BOOK-KT-005', N'Kinh tế', 145000.00, N'Eric Ries'),
(N'Người giàu nhất thành Babylon', 'BOOK-KT-006', N'Kinh tế', 75000.00, N'George S. Clason'),
-- Kỹ năng
(N'7 Thói quen hiệu quả', 'BOOK-KN-001', N'Kỹ năng', 185000.00, N'Stephen Covey'),
(N'Đọc vị bất kỳ ai', 'BOOK-KN-002', N'Kỹ năng', 98000.00, N'David J. Lieberman'),
(N'Sức mạnh của thói quen', 'BOOK-KN-003', N'Kỹ năng', 135000.00, N'Charles Duhigg'),
(N'Kỹ năng giao tiếp 101', 'BOOK-KN-004', N'Kỹ năng', 55000.00, N'John C. Maxwell'),
(N'Lập kế hoạch cuộc đời', 'BOOK-KN-005', N'Kỹ năng', 120000.00, N'Cẩm nang phát triển bản thân'),
(N'Làm chủ tư duy', 'BOOK-KN-006', N'Kỹ năng', 140000.00, N'Adam Khoo'),
-- Thiếu nhi
(N'Dế Mèn Phiêu Lưu Ký', 'BOOK-TN-001', N'Thiếu nhi', 55000.00, N'Tô Hoài'),
(N'Harry Potter - Tập 1', 'BOOK-TN-002', N'Thiếu nhi', 220000.00, N'J.K. Rowling'),
(N'Kính Vạn Hoa - Tập 1', 'BOOK-TN-003', N'Thiếu nhi', 85000.00, N'Nguyễn Nhật Ánh'),
(N'Hoàng Tử Bé', 'BOOK-TN-004', N'Thiếu nhi', 68000.00, N'Antoine de Saint-Exupéry'),
(N'Truyện cổ Grimm', 'BOOK-TN-005', N'Thiếu nhi', 115000.00, N'Tuyển tập cổ tích thế giới'),
(N'Doraemon - Tập 1', 'BOOK-TN-006', N'Thiếu nhi', 25000.00, N'Fujiko F. Fujio'),
-- Khoa học
(N'Lược sử thời gian', 'BOOK-KH-001', N'Khoa học', 145000.00, N'Stephen Hawking'),
(N'Vũ trụ', 'BOOK-KH-002', N'Khoa học', 280000.00, N'Carl Sagan'),
(N'Sapiens - Lược sử loài người', 'BOOK-KH-003', N'Khoa học', 290000.00, N'Yuval Noah Harari'),
(N'Nguồn gốc các loài', 'BOOK-KH-004', N'Khoa học', 175000.00, N'Charles Darwin'),
(N'Hố đen', 'BOOK-KH-005', N'Khoa học', 90000.00, N'Kiến thức thiên văn cơ bản'),
(N'Gen - Lịch sử thân mật', 'BOOK-KH-006', N'Khoa học', 260000.00, N'Siddhartha Mukherjee');
GO

-- 3. KHUYENMAI (7 chương trình khuyến mãi)
INSERT INTO KHUYENMAI (MaCode, TenChuongTrinh, GiaTriGiam, NgayBatDau, NgayKetThuc) VALUES
('Giam20k', N'Ưu đãi tháng 5', 20000.00, '2026-05-01', '2026-05-31'),
('SanhDieu', N'Sách văn học - Giảm 10k', 10000.00, '2026-01-01', '2026-12-31'),
('KM50K', N'Khách hàng mới - Giảm 50k', 50000.00, '2026-01-01', '2026-12-31'),
('SummerSale', N'Hè rực rỡ - Giảm 100k', 100000.00, '2026-06-01', '2026-08-31'),
('FlashSale', N'Giờ vàng giá sốc', 30000.00, '2026-05-15', '2026-05-20'),
('VIP200K', N'Tri ân khách hàng VIP', 200000.00, '2026-05-01', '2026-05-31'),
('TriAn', N'Ngày hội đọc sách', 40000.00, '2026-04-20', '2026-04-25');
GO

-- 4. DONHANG (25 đơn hàng)
-- Lưu ý: TongTienHang và ThanhTien sẽ được Trigger tính lại, ở đây để mẫu.
INSERT INTO DONHANG (MaKH, MaKM, NgayDat, KenhBanHang, TrangThaiThanhToan, TongTienHang, SoTienGiam, ThanhTien, GhiChu) VALUES
(1, NULL, '2026-05-10 08:30:00', 'TAI_QUAY', 'DA_THANH_TOAN', 0, 0, 0, N'Khách lấy tại quầy'),
(2, 1, '2026-05-11 09:15:00', 'WEBSITE', 'DA_THANH_TOAN', 0, 20000, 0, N'Giao giờ hành chính'),
(3, NULL, '2026-05-11 14:20:00', 'SHOPEE', 'DA_THANH_TOAN', 0, 0, 0, N'Shopee Express'),
(4, 3, '2026-05-12 10:00:00', 'WEBSITE', 'CHUA_THANH_TOAN', 0, 50000, 0, N'Đơn hàng đầu tiên'),
(5, NULL, '2026-05-12 16:45:00', 'LAZADA', 'DA_THANH_TOAN', 0, 0, 0, NULL),
(6, 2, '2026-05-13 11:30:00', 'TIKTOK_SHOP', 'DA_THANH_TOAN', 0, 10000, 0, N'Gói quà tặng'),
(7, NULL, '2026-05-13 15:00:00', 'TAI_QUAY', 'DA_THANH_TOAN', 0, 0, 0, NULL),
(8, 5, '2026-05-14 19:20:00', 'WEBSITE', 'CHUA_THANH_TOAN', 0, 30000, 0, N'Giao gấp'),
(9, 6, '2026-05-14 20:10:00', 'WEBSITE', 'DA_THANH_TOAN', 0, 200000, 0, N'Khách VIP'),
(10, NULL, '2026-05-15 08:00:00', 'SHOPEE', 'DA_THANH_TOAN', 0, 0, 0, NULL),
(11, 1, '2026-05-15 09:45:00', 'LAZADA', 'DA_THANH_TOAN', 0, 20000, 0, NULL),
(12, NULL, '2026-05-15 10:30:00', 'TIKTOK_SHOP', 'DA_THANH_TOAN', 0, 0, 0, N'Mua tặng sinh nhật'),
(13, NULL, '2026-05-15 13:15:00', 'TAI_QUAY', 'DA_THANH_TOAN', 0, 0, 0, NULL),
(14, 5, '2026-05-15 14:00:00', 'WEBSITE', 'CHUA_THANH_TOAN', 0, 30000, 0, NULL),
(15, 3, '2026-05-15 15:30:00', 'WEBSITE', 'DA_THANH_TOAN', 0, 50000, 0, N'Gói quà đẹp'),
(1, NULL, '2026-05-15 16:00:00', 'LAZADA', 'DA_THANH_TOAN', 0, 0, 0, NULL),
(2, 5, '2026-05-15 17:20:00', 'SHOPEE', 'CHUA_THANH_TOAN', 0, 30000, 0, NULL),
(4, NULL, '2026-05-15 18:00:00', 'TAI_QUAY', 'DA_THANH_TOAN', 0, 0, 0, NULL),
(6, NULL, '2026-05-15 19:30:00', 'WEBSITE', 'DA_THANH_TOAN', 0, 0, 0, NULL),
(9, 5, '2026-05-15 20:00:00', 'TIKTOK_SHOP', 'DA_THANH_TOAN', 0, 30000, 0, NULL),
(15, NULL, '2026-05-15 21:00:00', 'WEBSITE', 'DA_THANH_TOAN', 0, 0, 0, NULL),
(3, 1, '2026-05-15 21:30:00', 'LAZADA', 'DA_THANH_TOAN', 0, 20000, 0, NULL),
(7, NULL, '2026-05-15 22:00:00', 'SHOPEE', 'CHUA_THANH_TOAN', 0, 0, 0, NULL),
(11, NULL, '2026-05-15 22:30:00', 'WEBSITE', 'DA_THANH_TOAN', 0, 0, 0, NULL),
(13, 5, '2026-05-15 23:00:00', 'TAI_QUAY', 'DA_THANH_TOAN', 0, 30000, 0, NULL);
GO

-- 5. CHITIETDONHANG (Mỗi đơn 2-5 sản phẩm)
-- Tổng cộng khoảng 75-80 dòng chi tiết
INSERT INTO CHITIETDONHANG (MaDH, MaSP, SoLuong, DonGia, GiamGia) VALUES
-- DH1
(1, 1, 1, 79000, 0), (1, 7, 2, 86000, 5000),
-- DH2
(2, 2, 1, 110000, 0), (2, 20, 1, 220000, 0), (2, 13, 1, 185000, 10000),
-- DH3
(3, 3, 2, 65000, 0), (3, 8, 1, 159000, 0),
-- DH4
(4, 25, 1, 145000, 0), (4, 26, 1, 280000, 0), (4, 27, 1, 290000, 0),
-- DH5
(5, 4, 1, 125000, 0), (5, 14, 1, 98000, 0),
-- DH6
(6, 1, 3, 79000, 0), (6, 19, 1, 55000, 0), (6, 21, 1, 85000, 0), (6, 24, 1, 25000, 0),
-- DH7
(7, 5, 2, 95000, 0), (7, 15, 1, 135000, 0),
-- DH8
(8, 2, 1, 110000, 0), (8, 6, 2, 45000, 0), (8, 12, 1, 75000, 0),
-- DH9
(9, 27, 1, 290000, 0), (9, 28, 1, 175000, 0), (9, 29, 1, 90000, 0), (9, 30, 1, 260000, 0), (9, 11, 2, 145000, 0),
-- DH10
(10, 24, 5, 25000, 0), (10, 22, 1, 68000, 0),
-- DH11
(11, 7, 1, 86000, 0), (11, 8, 1, 159000, 0), (11, 9, 1, 250000, 0),
-- DH12
(12, 20, 1, 220000, 0), (12, 21, 2, 85000, 0), (12, 23, 1, 115000, 10000),
-- DH13
(13, 16, 2, 55000, 0), (13, 17, 1, 120000, 0),
-- DH14
(14, 10, 1, 199000, 0), (14, 18, 1, 140000, 0), (14, 1, 1, 79000, 0),
-- DH15
(15, 20, 2, 220000, 20000), (15, 25, 1, 145000, 0),
-- DH16
(16, 2, 1, 110000, 0), (16, 3, 1, 65000, 0), (16, 4, 1, 125000, 0),
-- DH17
(17, 7, 1, 86000, 0), (17, 13, 1, 185000, 0),
-- DH18
(18, 1, 1, 79000, 0), (18, 5, 1, 95000, 0), (18, 19, 1, 55000, 0),
-- DH19
(19, 27, 1, 290000, 0), (19, 20, 1, 220000, 0),
-- DH20
(20, 11, 1, 145000, 0), (20, 12, 1, 75000, 0), (20, 14, 1, 98000, 0),
-- DH21
(21, 2, 2, 110000, 0), (21, 10, 1, 199000, 0),
-- DH22
(22, 25, 1, 145000, 0), (22, 26, 1, 280000, 0),
-- DH23
(23, 8, 1, 159000, 0), (23, 15, 1, 135000, 0), (23, 1, 1, 79000, 0),
-- DH24
(24, 20, 1, 220000, 0), (24, 21, 1, 85000, 0),
-- DH25
(25, 27, 1, 290000, 0), (25, 30, 1, 260000, 0), (25, 7, 1, 86000, 0);
GO

-- XÁC NHẬN DỮ LIỆU
SELECT N'=== Seed data chèn thành công! ===' AS Thong_Bao;
SELECT 'KHACHHANG' AS Bang, COUNT(*) AS So_Ban_Ghi FROM KHACHHANG UNION ALL
SELECT 'SANPHAM', COUNT(*) FROM SANPHAM UNION ALL
SELECT 'KHUYENMAI', COUNT(*) FROM KHUYENMAI UNION ALL
SELECT 'DONHANG', COUNT(*) FROM DONHANG UNION ALL
SELECT 'CHITIETDONHANG', COUNT(*) FROM CHITIETDONHANG;
GO
