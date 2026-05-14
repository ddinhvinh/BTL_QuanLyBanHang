-- ============================================================
--  FILE: 02_insert_data.sql  |  ENGINE: SQL Server (T-SQL)
--  MÔ TẢ: Seed data — 5 bảng
--  LƯU Ý: Chạy SAU khi đã chạy 01_init_structure.sql
-- ============================================================

USE QL_BANHANG;
GO

-- 1. KHACHHANG
INSERT INTO KHACHHANG (TenKH, SoDienThoai, Email, DiaChi, DiemTichLuy) VALUES
(N'Nguyễn Văn An',   '0901234567', 'an.nguyen@gmail.com',  N'12 Lê Lợi, Q1, TP.HCM',          150),
(N'Trần Thị Bích',   '0912345678', 'bich.tran@gmail.com',  N'45 Nguyễn Huệ, Q1, TP.HCM',      320),
(N'Lê Minh Cường',   '0923456789', 'cuong.le@outlook.com', N'78 Hai Bà Trưng, Q3, TP.HCM',      80),
(N'Phạm Thị Dung',   '0934567890', 'dung.pham@yahoo.com',  N'10 Đinh Tiên Hoàng, Bình Thạnh',  500),
(N'Hoàng Quốc Hùng', '0945678901', 'hung.hoang@gmail.com', N'22 Cách Mạng Tháng 8, Q10',         0),
(N'Nguyễn Thị Mai',  '0956789012', 'mai.nguyen@gmail.com', N'33 Võ Văn Kiệt, Q5, TP.HCM',     210);
GO

-- 2. SANPHAM (MaDanhMuc là chuỗi văn bản trực tiếp)
INSERT INTO SANPHAM (TenSP, MaSKU, MaDanhMuc, GiaBan, MoTa) VALUES
(N'Áo Sơ Mi Trắng Nam Slim Fit', 'SKU-AM-001', N'Áo Nam',    299000.00, N'Cotton 100%, form slim fit'),
(N'Áo Polo Nam Kẻ Sọc',          'SKU-AM-002', N'Áo Nam',    249000.00, N'Pique co giãn 4 chiều'),
(N'Quần Jean Nam Skinny',         'SKU-QN-001', N'Quần Nam',  459000.00, N'Denim cao cấp, co giãn'),
(N'Quần Short Nam Kaki',          'SKU-QN-002', N'Quần Nam',  199000.00, N'Kaki mềm mại, thoáng mát'),
(N'Áo Dài Tay Nữ Chiffon',       'SKU-AN-001', N'Áo Nữ',    320000.00, N'Chiffon nhẹ nhàng, thanh lịch'),
(N'Áo Thun Nữ Basic',             'SKU-AN-002', N'Áo Nữ',    159000.00, N'Cotton 100%, dễ mix & match'),
(N'Quần Tây Nữ Ống Suông',        'SKU-QNU-01', N'Quần Nữ',  389000.00, N'Vải tây cao cấp, không nhăn'),
(N'Túi Tote Canvas Unisex',       'SKU-PK-001', N'Phụ Kiện', 129000.00, N'Canvas bền chắc, họa tiết độc đáo');
GO

-- 3. KHUYENMAI
INSERT INTO KHUYENMAI (MaCode, TenChuongTrinh, GiaTriGiam, NgayBatDau, NgayKetThuc) VALUES
('WELCOME50K',   N'Chào mừng khách mới - Giảm 50k',   50000.00, '2026-01-01', '2026-12-31'),
('SUMMER2026',   N'Hè Rực Rỡ - Giảm 10%',                10.00, '2026-06-01', '2026-08-31'),
('BLACKFRI100K', N'Black Friday - Giảm 100k',         100000.00, '2026-11-28', '2026-11-30'),
('MEMBER20',     N'Thành viên thân thiết - Giảm 20%',    20.00, '2026-01-01', '2026-12-31'),
('FLASHSALE30K', N'Flash Sale cuối tuần - Giảm 30k',  30000.00, '2026-05-17', '2026-05-18');
GO

-- 4. DONHANG
INSERT INTO DONHANG (MaKH, MaKM, NgayDat, KenhBanHang, TrangThaiThanhToan, TongTienHang, SoTienGiam, ThanhTien, GhiChu) VALUES
(1, 1,    '2026-04-10 09:30:00', 'WEBSITE',     'DA_THANH_TOAN',   598000.00,  50000.00, 548000.00, N'Giao trước 17h'),
(2, NULL, '2026-04-15 14:00:00', 'TAI_QUAY',    'DA_THANH_TOAN',   459000.00,      0.00, 459000.00, NULL),
(3, 5,    '2026-05-03 20:00:00', 'SHOPEE',       'DA_THANH_TOAN',   249000.00,  30000.00, 219000.00, N'Shopee freeship'),
(4, 4,    '2026-05-08 11:15:00', 'WEBSITE',      'DA_THANH_TOAN',   708000.00, 141600.00, 566400.00, N'KH VIP, gói quà'),
(5, NULL, '2026-05-10 16:45:00', 'LAZADA',       'CHUA_THANH_TOAN', 389000.00,      0.00, 389000.00, NULL),
(6, NULL, '2026-05-12 10:00:00', 'TAI_QUAY',     'DA_THANH_TOAN',   447000.00,      0.00, 447000.00, N'Mua sinh nhật'),
(1, NULL, '2026-05-14 08:00:00', 'TIKTOK_SHOP',  'CHUA_THANH_TOAN', 129000.00,      0.00, 129000.00, N'Đơn livestream');
GO

-- 5. CHITIETDONHANG
INSERT INTO CHITIETDONHANG (MaDH, MaSP, SoLuong, DonGia, GiamGia) VALUES
(1, 1, 1, 299000.00, 0.00),
(1, 2, 1, 249000.00, 0.00),
(2, 3, 1, 459000.00, 0.00),
(3, 2, 1, 249000.00, 0.00),
(4, 5, 1, 320000.00, 0.00),
(4, 7, 1, 389000.00, 0.00),
(5, 7, 1, 389000.00, 0.00),
(6, 6, 2, 159000.00, 0.00),
(6, 8, 1, 129000.00, 0.00),
(7, 8, 1, 129000.00, 0.00);
GO

-- XAC NHAN
SELECT N'=== Seed data chèn thành công! ===' AS Thong_Bao;
SELECT 'KHACHHANG'     AS Bang, COUNT(*) AS So_Ban_Ghi FROM KHACHHANG     UNION ALL
SELECT 'SANPHAM',               COUNT(*)               FROM SANPHAM        UNION ALL
SELECT 'KHUYENMAI',             COUNT(*)               FROM KHUYENMAI      UNION ALL
SELECT 'DONHANG',               COUNT(*)               FROM DONHANG        UNION ALL
SELECT 'CHITIETDONHANG',        COUNT(*)               FROM CHITIETDONHANG;
GO
