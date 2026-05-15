-- ============================================================
--  FILE: 04_business_reports.sql  |  ENGINE: SQL Server (T-SQL)
--  MÔ TẢ: Các câu truy vấn báo cáo kinh doanh cho Cửa hàng Sách
--  LƯU Ý: Chạy SAU khi đã chạy 01, 02, 03
-- ============================================================

USE QL_BANHANG;
GO

-- ============================================================
--  BÁO CÁO 1: TỔNG QUAN DOANH THU
--  Mục đích: Xem nhanh tổng quan toàn bộ hoạt động kinh doanh
-- ============================================================

-- 1.1 Tổng doanh thu, số đơn hàng, giá trị trung bình mỗi đơn
SELECT
    COUNT(*)                                     AS Tong_So_Don,
    SUM(CASE WHEN TrangThaiThanhToan = 'DA_THANH_TOAN' THEN 1 ELSE 0 END)
                                                 AS Don_Da_Thanh_Toan,
    SUM(CASE WHEN TrangThaiThanhToan = 'CHUA_THANH_TOAN' THEN 1 ELSE 0 END)
                                                 AS Don_Chua_Thanh_Toan,
    FORMAT(SUM(ThanhTien), '#,0')                AS Tong_Doanh_Thu,
    FORMAT(AVG(ThanhTien), '#,0')                AS Trung_Binh_Don,
    FORMAT(MAX(ThanhTien), '#,0')                AS Don_Lon_Nhat,
    FORMAT(MIN(ThanhTien), '#,0')                AS Don_Nho_Nhat
FROM DONHANG;
GO

-- 1.2 Doanh thu theo từng ngày (chỉ đơn ĐÃ THANH TOÁN)
SELECT
    CAST(NgayDat AS DATE)                        AS Ngay,
    COUNT(*)                                     AS So_Don,
    FORMAT(SUM(TongTienHang), '#,0')             AS Tong_Tien_Hang,
    FORMAT(SUM(SoTienGiam), '#,0')               AS Tong_Giam_Gia,
    FORMAT(SUM(ThanhTien), '#,0')                AS Doanh_Thu_Thuc
FROM DONHANG
WHERE TrangThaiThanhToan = 'DA_THANH_TOAN'
GROUP BY CAST(NgayDat AS DATE)
ORDER BY Ngay;
GO

-- 1.3 Doanh thu theo tháng (mở rộng khi có dữ liệu nhiều tháng)
SELECT
    YEAR(NgayDat)                                AS Nam,
    MONTH(NgayDat)                               AS Thang,
    COUNT(*)                                     AS So_Don,
    FORMAT(SUM(ThanhTien), '#,0')                AS Doanh_Thu
FROM DONHANG
WHERE TrangThaiThanhToan = 'DA_THANH_TOAN'
GROUP BY YEAR(NgayDat), MONTH(NgayDat)
ORDER BY Nam, Thang;
GO


-- ============================================================
--  BÁO CÁO 2: PHÂN TÍCH SẢN PHẨM BÁN CHẠY
--  Mục đích: Xác định sản phẩm bán chạy để lên kế hoạch nhập hàng
-- ============================================================

-- 2.1 Top 10 sản phẩm bán chạy nhất (theo số lượng)
SELECT TOP 10
    sp.MaSP,
    sp.TenSP,
    sp.MaDanhMuc,
    SUM(ct.SoLuong)                              AS Tong_SL_Ban,
    COUNT(DISTINCT ct.MaDH)                      AS So_Don_Chua,
    FORMAT(SUM((ct.DonGia - ct.GiamGia) * ct.SoLuong), '#,0')
                                                 AS Doanh_Thu_SP
FROM CHITIETDONHANG ct
JOIN SANPHAM sp ON ct.MaSP = sp.MaSP
GROUP BY sp.MaSP, sp.TenSP, sp.MaDanhMuc
ORDER BY Tong_SL_Ban DESC;
GO

-- 2.2 Top 10 sản phẩm theo doanh thu
SELECT TOP 10
    sp.MaSP,
    sp.TenSP,
    sp.MaDanhMuc,
    FORMAT(sp.GiaBan, '#,0')                     AS Gia_Niem_Yet,
    SUM(ct.SoLuong)                              AS Tong_SL_Ban,
    FORMAT(SUM((ct.DonGia - ct.GiamGia) * ct.SoLuong), '#,0')
                                                 AS Doanh_Thu_SP
FROM CHITIETDONHANG ct
JOIN SANPHAM sp ON ct.MaSP = sp.MaSP
GROUP BY sp.MaSP, sp.TenSP, sp.MaDanhMuc, sp.GiaBan
ORDER BY SUM((ct.DonGia - ct.GiamGia) * ct.SoLuong) DESC;
GO

-- 2.3 Sản phẩm CHƯA BÁN ĐƯỢC (tồn kho lâu)
SELECT
    sp.MaSP,
    sp.TenSP,
    sp.MaDanhMuc,
    FORMAT(sp.GiaBan, '#,0')                     AS Gia_Ban
FROM SANPHAM sp
LEFT JOIN CHITIETDONHANG ct ON sp.MaSP = ct.MaSP
WHERE ct.MaCTDH IS NULL
ORDER BY sp.MaDanhMuc, sp.TenSP;
GO


-- ============================================================
--  BÁO CÁO 3: DOANH THU THEO DANH MỤC SÁCH
--  Mục đích: Biết nhóm sách nào đóng góp nhiều nhất
-- ============================================================

SELECT
    sp.MaDanhMuc                                 AS Danh_Muc,
    COUNT(DISTINCT sp.MaSP)                      AS So_Dau_Sach,
    SUM(ct.SoLuong)                              AS Tong_SL_Ban,
    FORMAT(SUM((ct.DonGia - ct.GiamGia) * ct.SoLuong), '#,0')
                                                 AS Doanh_Thu,
    FORMAT(
        SUM((ct.DonGia - ct.GiamGia) * ct.SoLuong) * 100.0 /
        NULLIF((SELECT SUM((c2.DonGia - c2.GiamGia) * c2.SoLuong) FROM CHITIETDONHANG c2), 0),
        '0.0'
    ) + '%'                                      AS Ty_Trong
FROM CHITIETDONHANG ct
JOIN SANPHAM sp ON ct.MaSP = sp.MaSP
GROUP BY sp.MaDanhMuc
ORDER BY SUM((ct.DonGia - ct.GiamGia) * ct.SoLuong) DESC;
GO


-- ============================================================
--  BÁO CÁO 4: PHÂN TÍCH KHÁCH HÀNG
--  Mục đích: Chăm sóc khách VIP, phát hiện khách tiềm năng
-- ============================================================

-- 4.1 Top 10 khách hàng chi tiêu nhiều nhất
SELECT TOP 10
    kh.MaKH,
    kh.TenKH,
    kh.SoDienThoai,
    kh.DiemTichLuy,
    COUNT(dh.MaDH)                               AS So_Don_Hang,
    FORMAT(SUM(dh.ThanhTien), '#,0')             AS Tong_Chi_Tieu,
    FORMAT(AVG(dh.ThanhTien), '#,0')             AS TB_Moi_Don
FROM KHACHHANG kh
JOIN DONHANG dh ON kh.MaKH = dh.MaKH
WHERE dh.TrangThaiThanhToan = 'DA_THANH_TOAN'
GROUP BY kh.MaKH, kh.TenKH, kh.SoDienThoai, kh.DiemTichLuy
ORDER BY SUM(dh.ThanhTien) DESC;
GO

-- 4.2 Phân loại khách hàng theo mức chi tiêu (RFM đơn giản)
SELECT
    kh.MaKH,
    kh.TenKH,
    kh.DiemTichLuy,
    COUNT(dh.MaDH)                               AS So_Don,
    SUM(dh.ThanhTien)                            AS Tong_Chi,
    CASE
        WHEN SUM(dh.ThanhTien) >= 1000000 THEN N'VIP'
        WHEN SUM(dh.ThanhTien) >= 500000  THEN N'Thân thiết'
        WHEN SUM(dh.ThanhTien) >= 200000  THEN N'Tiềm năng'
        ELSE N'Mới'
    END                                          AS Phan_Loai
FROM KHACHHANG kh
LEFT JOIN DONHANG dh ON kh.MaKH = dh.MaKH
    AND dh.TrangThaiThanhToan = 'DA_THANH_TOAN'
GROUP BY kh.MaKH, kh.TenKH, kh.DiemTichLuy
ORDER BY Tong_Chi DESC;
GO

-- 4.3 Khách hàng chưa từng mua hàng
SELECT
    kh.MaKH,
    kh.TenKH,
    kh.SoDienThoai,
    kh.Email
FROM KHACHHANG kh
LEFT JOIN DONHANG dh ON kh.MaKH = dh.MaKH
WHERE dh.MaDH IS NULL;
GO


-- ============================================================
--  BÁO CÁO 5: PHÂN TÍCH KÊNH BÁN HÀNG
--  Mục đích: So sánh hiệu quả các kênh bán (Online vs Offline)
-- ============================================================

-- 5.1 Doanh thu và số đơn theo từng kênh
SELECT
    KenhBanHang                                  AS Kenh,
    COUNT(*)                                     AS So_Don,
    FORMAT(SUM(ThanhTien), '#,0')                AS Doanh_Thu,
    FORMAT(AVG(ThanhTien), '#,0')                AS TB_Don,
    FORMAT(
        COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM DONHANG), 0),
        '0.0'
    ) + '%'                                      AS Ty_Le_Don
FROM DONHANG
WHERE TrangThaiThanhToan = 'DA_THANH_TOAN'
GROUP BY KenhBanHang
ORDER BY SUM(ThanhTien) DESC;
GO

-- 5.2 So sánh Online vs Offline
SELECT
    CASE
        WHEN KenhBanHang = 'TAI_QUAY' THEN 'OFFLINE'
        ELSE 'ONLINE'
    END                                          AS Hinh_Thuc,
    COUNT(*)                                     AS So_Don,
    FORMAT(SUM(ThanhTien), '#,0')                AS Doanh_Thu,
    FORMAT(AVG(ThanhTien), '#,0')                AS TB_Don
FROM DONHANG
WHERE TrangThaiThanhToan = 'DA_THANH_TOAN'
GROUP BY
    CASE
        WHEN KenhBanHang = 'TAI_QUAY' THEN 'OFFLINE'
        ELSE 'ONLINE'
    END
ORDER BY Doanh_Thu DESC;
GO


-- ============================================================
--  BÁO CÁO 6: PHÂN TÍCH KHUYẾN MÃI
--  Mục đích: Đánh giá hiệu quả chương trình giảm giá
-- ============================================================

-- 6.1 Tổng hợp hiệu quả từng chương trình khuyến mãi
SELECT
    km.MaKM,
    km.MaCode,
    km.TenChuongTrinh,
    FORMAT(km.GiaTriGiam, '#,0')                 AS Gia_Tri_Giam,
    COUNT(dh.MaDH)                               AS So_Don_Ap_Dung,
    FORMAT(SUM(dh.SoTienGiam), '#,0')            AS Tong_Tien_Giam,
    FORMAT(SUM(dh.ThanhTien), '#,0')             AS Doanh_Thu_Don_KM,
    CASE
        WHEN km.NgayKetThuc < GETDATE() THEN N'Đã hết hạn'
        WHEN km.NgayBatDau > GETDATE()  THEN N'Chưa bắt đầu'
        ELSE N'Đang hoạt động'
    END                                          AS Trang_Thai
FROM KHUYENMAI km
LEFT JOIN DONHANG dh ON km.MaKM = dh.MaKM
GROUP BY km.MaKM, km.MaCode, km.TenChuongTrinh,
         km.GiaTriGiam, km.NgayBatDau, km.NgayKetThuc
ORDER BY So_Don_Ap_Dung DESC;
GO

-- 6.2 Tỉ lệ đơn có sử dụng khuyến mãi vs không
SELECT
    CASE WHEN MaKM IS NOT NULL THEN N'Có KM' ELSE N'Không KM' END AS Loai,
    COUNT(*)                                     AS So_Don,
    FORMAT(SUM(ThanhTien), '#,0')                AS Doanh_Thu,
    FORMAT(
        COUNT(*) * 100.0 / NULLIF((SELECT COUNT(*) FROM DONHANG), 0),
        '0.0'
    ) + '%'                                      AS Ty_Le
FROM DONHANG
GROUP BY CASE WHEN MaKM IS NOT NULL THEN N'Có KM' ELSE N'Không KM' END;
GO


-- ============================================================
--  BÁO CÁO 7: TRẠNG THÁI ĐƠN HÀNG
--  Mục đích: Theo dõi đơn chưa thanh toán, cần nhắc nhở
-- ============================================================

-- 7.1 Tổng hợp theo trạng thái
SELECT
    TrangThaiThanhToan                           AS Trang_Thai,
    COUNT(*)                                     AS So_Don,
    FORMAT(SUM(ThanhTien), '#,0')                AS Tong_Gia_Tri
FROM DONHANG
GROUP BY TrangThaiThanhToan
ORDER BY So_Don DESC;
GO

-- 7.2 Danh sách đơn hàng CHƯA THANH TOÁN (cần theo dõi)
SELECT
    dh.MaDH,
    kh.TenKH,
    kh.SoDienThoai,
    dh.NgayDat,
    dh.KenhBanHang,
    FORMAT(dh.ThanhTien, '#,0')                  AS Thanh_Tien,
    DATEDIFF(DAY, dh.NgayDat, GETDATE())         AS So_Ngay_Cho
FROM DONHANG dh
JOIN KHACHHANG kh ON dh.MaKH = kh.MaKH
WHERE dh.TrangThaiThanhToan = 'CHUA_THANH_TOAN'
ORDER BY dh.NgayDat ASC;
GO


-- ============================================================
--  BÁO CÁO 8: THỐNG KÊ TỔNG HỢP DASHBOARD
--  Mục đích: Các con số chính hiển thị trên dashboard quản lý
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM KHACHHANG)             AS Tong_Khach_Hang,
    (SELECT COUNT(*) FROM SANPHAM)               AS Tong_San_Pham,
    (SELECT COUNT(*) FROM DONHANG)               AS Tong_Don_Hang,
    (SELECT COUNT(*) FROM DONHANG
     WHERE TrangThaiThanhToan = 'DA_THANH_TOAN') AS Don_Hoan_Thanh,
    (SELECT FORMAT(SUM(ThanhTien), '#,0')
     FROM DONHANG
     WHERE TrangThaiThanhToan = 'DA_THANH_TOAN') AS Tong_Doanh_Thu,
    (SELECT COUNT(*) FROM KHUYENMAI
     WHERE NgayBatDau <= GETDATE()
       AND NgayKetThuc >= GETDATE())             AS KM_Dang_Hoat_Dong;
GO

SELECT N'=== Tất cả báo cáo đã chạy thành công! ===' AS Thong_Bao;
GO
