-- ============================================================
--  FILE: 03_optimization_logic.sql  |  ENGINE: SQL Server (T-SQL)
--  MÔ TẢ: Index tối ưu + Trigger tự động tính ThanhTien (5 bảng)
--  LƯU Ý: Chạy SAU khi đã chạy 01 và 02
-- ============================================================

USE QL_BANHANG;
GO

-- ============================================================
--  PHẦN 1: CHỈ MỤC (INDEX)
-- ============================================================

-- [1] Tìm đơn hàng theo khách hàng
CREATE INDEX IDX_DH_MAKH      ON DONHANG (MaKH);
GO
-- [2] Báo cáo doanh thu theo ngày
CREATE INDEX IDX_DH_NGAYDAT   ON DONHANG (NgayDat);
GO
-- [3] Lọc đơn theo trạng thái thanh toán
CREATE INDEX IDX_DH_TRANGTHAI ON DONHANG (TrangThaiThanhToan);
GO
-- [4] Phân tích kênh bán hàng theo thời gian (composite)
CREATE INDEX IDX_DH_KENH_NGAY ON DONHANG (KenhBanHang, NgayDat);
GO
-- [5] Join DONHANG → CHITIETDONHANG
CREATE INDEX IDX_CTDH_MADH    ON CHITIETDONHANG (MaDH);
GO
-- [6] Tìm đơn hàng chứa sản phẩm cụ thể
CREATE INDEX IDX_CTDH_MASP    ON CHITIETDONHANG (MaSP);
GO
-- [7] Lọc sản phẩm theo danh mục (nhóm hàng)
CREATE INDEX IDX_SP_DANHMUC   ON SANPHAM (MaDanhMuc);
GO
-- [8] Top khách VIP theo điểm tích lũy
CREATE INDEX IDX_KH_DIEM      ON KHACHHANG (DiemTichLuy DESC);
GO
-- [9] Tìm mã KM còn hiệu lực theo ngày
CREATE INDEX IDX_KM_NGAY      ON KHUYENMAI (NgayBatDau, NgayKetThuc);
GO


-- ============================================================
--  PHẦN 2: TRIGGER — TỰ ĐỘNG TÍNH ThanhTien
--
--  Chiến lược 2 lớp:
--   [Lớp 1] TRG_CTDH_CAP_NHAT: CHITIETDONHANG thay đổi
--           → cập nhật TongTienHang trong DONHANG cha
--   [Lớp 2] TRG_DH_TINH_THANHTIEN: TongTienHang/SoTienGiam đổi
--           → tính ThanhTien = IIF(TongTienHang - SoTienGiam >= 0,
--                                   TongTienHang - SoTienGiam, 0)
--
--  Lưu ý SQL Server:
--   - Không có BEFORE trigger → dùng AFTER trigger
--   - Bảng ảo INSERTED (hàng mới) và DELETED (hàng cũ)
--   - IF UPDATE(col): chỉ chạy khi cột đó thực sự thay đổi
--     (tránh trigger gọi lại chính nó vô hạn lần)
-- ============================================================

-- [Lớp 2] Trigger trên DONHANG
IF OBJECT_ID('TRG_DH_TINH_THANHTIEN', 'TR') IS NOT NULL
    DROP TRIGGER TRG_DH_TINH_THANHTIEN;
GO
CREATE TRIGGER TRG_DH_TINH_THANHTIEN
ON DONHANG
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- Chỉ tính lại khi TongTienHang hoặc SoTienGiam thay đổi
    IF NOT (UPDATE(TongTienHang) OR UPDATE(SoTienGiam))
        RETURN;

    UPDATE dh
    SET dh.ThanhTien = IIF(
        i.TongTienHang - i.SoTienGiam >= 0,
        i.TongTienHang - i.SoTienGiam,
        0
    )
    FROM DONHANG dh
    INNER JOIN inserted i ON dh.MaDH = i.MaDH;
END;
GO

-- [Lớp 1] Trigger trên CHITIETDONHANG
IF OBJECT_ID('TRG_CTDH_CAP_NHAT', 'TR') IS NOT NULL
    DROP TRIGGER TRG_CTDH_CAP_NHAT;
GO
CREATE TRIGGER TRG_CTDH_CAP_NHAT
ON CHITIETDONHANG
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dh
    SET dh.TongTienHang = COALESCE(
        (SELECT SUM((ct.DonGia - ct.GiamGia) * ct.SoLuong)
         FROM CHITIETDONHANG ct WHERE ct.MaDH = dh.MaDH), 0)
    FROM DONHANG dh
    WHERE dh.MaDH IN (
        SELECT MaDH FROM inserted
        UNION
        SELECT MaDH FROM deleted
    );
END;
GO


-- ============================================================
--  PHẦN 3: KIỂM TRA TRIGGER (DEMO)
-- ============================================================

-- Trạng thái hiện tại
SELECT MaDH, TongTienHang, SoTienGiam, ThanhTien FROM DONHANG ORDER BY MaDH;
GO

-- Test 1: Bích (Đơn 2) mua thêm Túi Tote
-- → TongTienHang(DH2): 459k + 129k = 588k
-- → ThanhTien(DH2): 588k - 0 = 588k (tự động)
IF NOT EXISTS (SELECT 1 FROM CHITIETDONHANG WHERE MaDH = 2 AND MaSP = 8)
BEGIN
    INSERT INTO CHITIETDONHANG (MaDH, MaSP, SoLuong, DonGia, GiamGia)
    VALUES (2, 8, 1, 129000.00, 0.00);
END
GO
GO
SELECT MaDH, TongTienHang, SoTienGiam, ThanhTien FROM DONHANG WHERE MaDH = 2;
GO

-- Test 2: Hùng (Đơn 5) áp mã WELCOME50K
-- → ThanhTien(DH5): 389k - 50k = 339k (tự động)
UPDATE DONHANG SET MaKM = 1, SoTienGiam = 50000.00 WHERE MaDH = 5;
GO
SELECT MaDH, TongTienHang, SoTienGiam, ThanhTien FROM DONHANG WHERE MaDH = 5;
GO


-- ============================================================
--  PHẦN 4: TỔNG HỢP INDEX VÀ TRIGGER ĐÃ TẠO
-- ============================================================

SELECT
    t.name  AS Bang,
    i.name  AS Ten_Index,
    c.name  AS Cot,
    i.type_desc AS Kieu_Index
FROM sys.indexes i
JOIN sys.tables        t  ON i.object_id = t.object_id
JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
JOIN sys.columns       c  ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE t.is_ms_shipped = 0 AND i.name IS NOT NULL AND i.type_desc != 'HEAP'
ORDER BY t.name, i.name;
GO

SELECT t.name AS Ten_Trigger, OBJECT_NAME(t.parent_id) AS Tren_Bang
FROM sys.triggers t WHERE t.parent_class = 1
ORDER BY OBJECT_NAME(t.parent_id);
GO

SELECT N'=== Tất cả Index và Trigger đã sẵn sàng! ===' AS Thong_Bao;
GO
