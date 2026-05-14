-- ============================================================
--  FILE: 01_init_structure.sql  |  ENGINE: SQL Server (T-SQL)
--  MÔ TẢ: Tạo Database QL_BANHANG và 5 bảng theo chuẩn 3NF
-- ============================================================

-- Chuyển sang master TRƯỚC khi DROP
-- (tránh lỗi "cannot drop database currently in use")
USE master;
GO

-- Xóa database cũ và tạo lại sạch
IF DB_ID('QL_BANHANG') IS NOT NULL
BEGIN
    ALTER DATABASE QL_BANHANG SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QL_BANHANG;
END
GO

CREATE DATABASE QL_BANHANG
    COLLATE Vietnamese_CI_AS;
GO

USE QL_BANHANG;
GO

-- ============================================================
--  BẢNG 1: KHACHHANG
--  - Email, SoDienThoai: UNIQUE để dùng làm định danh phụ
--  - DiemTichLuy >= 0: khách không thể "nợ điểm"
-- ============================================================
CREATE TABLE KHACHHANG (
    MaKH        INT             NOT NULL IDENTITY(1,1),
    TenKH       NVARCHAR(100)   NOT NULL,
    SoDienThoai VARCHAR(15)     NOT NULL,
    Email       VARCHAR(150)    NOT NULL,
    DiaChi      NVARCHAR(255)   NULL,
    DiemTichLuy INT             NOT NULL DEFAULT 0,

    CONSTRAINT PK_KHACHHANG  PRIMARY KEY (MaKH),
    CONSTRAINT UQ_KH_SDT     UNIQUE (SoDienThoai),
    CONSTRAINT UQ_KH_EMAIL   UNIQUE (Email),
    CONSTRAINT CHK_KH_DIEM   CHECK  (DiemTichLuy >= 0)
);
GO

-- ============================================================
--  BẢNG 2: SANPHAM
--  - MaSKU: UNIQUE — mỗi sản phẩm có mã kho riêng biệt
--  - MaDanhMuc: VARCHAR lưu tên nhóm hàng trực tiếp
--  - GiaBan >= 0: không có sản phẩm giá âm
-- ============================================================
CREATE TABLE SANPHAM (
    MaSP        INT             NOT NULL IDENTITY(1,1),
    TenSP       NVARCHAR(200)   NOT NULL,
    MaSKU       VARCHAR(50)     NOT NULL,
    MaDanhMuc   NVARCHAR(100)   NULL,
    GiaBan      DECIMAL(18,2)   NOT NULL DEFAULT 0.00,
    MoTa        NVARCHAR(MAX)   NULL,

    CONSTRAINT PK_SANPHAM   PRIMARY KEY (MaSP),
    CONSTRAINT UQ_SP_SKU    UNIQUE (MaSKU),
    CONSTRAINT CHK_SP_GIA   CHECK (GiaBan >= 0)
);
GO

-- ============================================================
--  BẢNG 3: KHUYENMAI
--  - MaCode: UNIQUE — mỗi voucher có mã riêng biệt
--  - GiaTriGiam > 0: phải có giá trị mới là khuyến mãi
--  - NgayKetThuc > NgayBatDau: khoảng thời gian hợp lệ
-- ============================================================
CREATE TABLE KHUYENMAI (
    MaKM            INT             NOT NULL IDENTITY(1,1),
    MaCode          VARCHAR(50)     NOT NULL,
    TenChuongTrinh  NVARCHAR(150)   NOT NULL,
    GiaTriGiam      DECIMAL(18,2)   NOT NULL,
    NgayBatDau      DATETIME        NOT NULL,
    NgayKetThuc     DATETIME        NOT NULL,

    CONSTRAINT PK_KHUYENMAI   PRIMARY KEY (MaKM),
    CONSTRAINT UQ_KM_MACODE   UNIQUE (MaCode),
    CONSTRAINT CHK_KM_GIATRI  CHECK (GiaTriGiam > 0),
    CONSTRAINT CHK_KM_NGAY    CHECK (NgayKetThuc > NgayBatDau)
);
GO

-- ============================================================
--  BẢNG 4: DONHANG
--  FK → KHACHHANG: ON DELETE NO ACTION (= RESTRICT)
--    Không xóa được khách khi còn đơn hàng → bảo vệ lịch sử
--  FK → KHUYENMAI: ON DELETE SET NULL
--    Xóa chương trình KM → đơn hàng vẫn giữ nguyên SoTienGiam
-- ============================================================
CREATE TABLE DONHANG (
    MaDH               INT             NOT NULL IDENTITY(1,1),
    MaKH               INT             NOT NULL,
    MaKM               INT             NULL,
    NgayDat            DATETIME        NOT NULL DEFAULT GETDATE(),
    KenhBanHang        VARCHAR(50)     NOT NULL DEFAULT 'TAI_QUAY',
    TrangThaiThanhToan VARCHAR(30)     NOT NULL DEFAULT 'CHUA_THANH_TOAN',
    TongTienHang       DECIMAL(18,2)   NOT NULL DEFAULT 0.00,
    SoTienGiam         DECIMAL(18,2)   NOT NULL DEFAULT 0.00,
    ThanhTien          DECIMAL(18,2)   NOT NULL DEFAULT 0.00,
    GhiChu             NVARCHAR(500)   NULL,

    CONSTRAINT PK_DONHANG        PRIMARY KEY (MaDH),
    CONSTRAINT CHK_DH_TONGTIEN   CHECK (TongTienHang >= 0),
    CONSTRAINT CHK_DH_SOGIAMGIA  CHECK (SoTienGiam >= 0),
    CONSTRAINT CHK_DH_THANHTIEN  CHECK (ThanhTien >= 0),
    CONSTRAINT CHK_DH_KENH       CHECK (KenhBanHang IN
        ('TAI_QUAY','WEBSITE','SHOPEE','LAZADA','TIKTOK_SHOP')),
    CONSTRAINT CHK_DH_TRANGTHAI  CHECK (TrangThaiThanhToan IN
        ('CHUA_THANH_TOAN','DA_THANH_TOAN','HOAN_TIEN','HUY')),

    CONSTRAINT FK_DH_KHACHHANG
        FOREIGN KEY (MaKH) REFERENCES KHACHHANG (MaKH)
        ON DELETE NO ACTION   -- RESTRICT: bảo vệ lịch sử giao dịch
        ON UPDATE CASCADE,

    CONSTRAINT FK_DH_KHUYENMAI
        FOREIGN KEY (MaKM) REFERENCES KHUYENMAI (MaKM)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
GO

-- ============================================================
--  BẢNG 5: CHITIETDONHANG
--  FK → DONHANG:  ON DELETE CASCADE — dọn sạch chi tiết khi hủy đơn
--  FK → SANPHAM:  ON DELETE NO ACTION — bảo vệ lịch sử mua hàng
--  UQ (MaDH, MaSP): mỗi sản phẩm chỉ xuất hiện 1 lần trong 1 đơn
-- ============================================================
CREATE TABLE CHITIETDONHANG (
    MaCTDH  INT             NOT NULL IDENTITY(1,1),
    MaDH    INT             NOT NULL,
    MaSP    INT             NOT NULL,
    SoLuong INT             NOT NULL DEFAULT 1,
    DonGia  DECIMAL(18,2)   NOT NULL,
    GiamGia DECIMAL(18,2)   NOT NULL DEFAULT 0.00,

    CONSTRAINT PK_CHITIETDONHANG PRIMARY KEY (MaCTDH),
    CONSTRAINT UQ_CTDH_DH_SP     UNIQUE (MaDH, MaSP),
    CONSTRAINT CHK_CTDH_SOLUONG  CHECK (SoLuong >= 1),
    CONSTRAINT CHK_CTDH_DONGIA   CHECK (DonGia >= 0),
    CONSTRAINT CHK_CTDH_GIAMGIA  CHECK (GiamGia >= 0 AND GiamGia <= DonGia),

    CONSTRAINT FK_CTDH_DONHANG
        FOREIGN KEY (MaDH) REFERENCES DONHANG (MaDH)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT FK_CTDH_SANPHAM
        FOREIGN KEY (MaSP) REFERENCES SANPHAM (MaSP)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);
GO

-- ============================================================
--  XÁC NHẬN
-- ============================================================
SELECT N'=== Tạo cấu trúc thành công! ===' AS Thong_Bao;
SELECT TABLE_NAME AS Ten_Bang
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
