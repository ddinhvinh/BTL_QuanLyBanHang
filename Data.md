# Cấu trúc Dữ liệu Quản lý Bán hàng

## 1. Khách hàng (KHACHHANG)
Quản lý thông tin người mua để chăm sóc và liên hệ.
* **MaKH**: Mã định danh duy nhất (Primary Key), tự động tăng.
* **TenKH**: Họ và tên khách hàng.
* **SoDienThoai**: Số điện thoại liên lạc (Unique - duy nhất).
* **Email**: Địa chỉ email (Unique - duy nhất).
* **DiaChi**: Địa chỉ cư trú hoặc giao hàng.
* **DiemTichLuy**: Điểm thưởng tích lũy được từ các đơn hàng đã mua.

## 2. Sản phẩm (SANPHAM)
Lưu trữ danh sách mặt hàng sách đang kinh doanh.
* **MaSP**: Mã định danh duy nhất của sản phẩm (Primary Key).
* **TenSP**: Tên tiêu đề sách.
* **MaSKU**: Mã quản lý kho riêng biệt cho từng đầu sách.
* **MaDanhMuc**: Phân loại sách (Văn học, Kinh tế, Khoa học, Thiếu nhi...).
* **GiaBan**: Giá niêm yết của một cuốn sách.
* **MoTa**: Nội dung tóm tắt hoặc thông tin chi tiết về cuốn sách.

## 3. Khuyến mãi (KHUYENMAI)
Quản lý các mã giảm giá và chương trình ưu đãi.
* **MaKM**: Mã quản lý hệ thống (Primary Key).
* **MaCode**: Mã định danh voucher khách nhập (ví dụ: KM50K, SUMMER).
* **TenChuongTrinh**: Tên gọi của chiến dịch khuyến mãi.
* **GiaTriGiam**: Số tiền hoặc giá trị được giảm trừ.
* **NgayBatDau**: Ngày chương trình bắt đầu có hiệu lực.
* **NgayKetThuc**: Ngày hết hạn chương trình.

## 4. Đơn hàng (DONHANG)
Ghi nhận thông tin tổng quát của một giao dịch.
* **MaDH**: Mã hóa đơn duy nhất (Primary Key).
* **MaKH**: Liên kết với khách hàng thực hiện mua (Foreign Key).
* **MaKM**: Mã khuyến mãi được áp dụng cho đơn (Foreign Key - có thể NULL).
* **NgayDat**: Thời điểm tạo đơn hàng.
* **KenhBanHang**: Nơi phát sinh đơn (TAI_QUAY, WEBSITE, SHOPEE, LAZADA, TIKTOK_SHOP).
* **TrangThaiThanhToan**: Tình trạng tiền bạc (CHUA_THANH_TOAN, DA_THANH_TOAN, HOAN_TIEN, HUY).
* **TongTienHang**: Tổng tiền các sản phẩm trước khi giảm giá (Trigger tự động tính).
* **SoTienGiam**: Tổng số tiền được giảm trừ từ mã khuyến mãi.
* **ThanhTien**: Số tiền thực tế khách phải trả (Trigger tự động tính = TongTienHang - SoTienGiam).
* **GhiChu**: Các yêu cầu đặc biệt của khách (Giao giờ hành chính, gói quà...).

## 5. Chi tiết đơn hàng (CHITIETDONHANG)
Lưu thông tin cụ thể từng mặt hàng trong một đơn hàng.
* **MaCTDH**: Mã định danh dòng chi tiết (Primary Key).
* **MaDH**: Thuộc về đơn hàng nào (Foreign Key).
* **MaSP**: Sản phẩm nào được mua (Foreign Key).
* **SoLuong**: Số lượng cuốn sách khách mua cho sản phẩm đó.
* **DonGia**: Giá bán của sản phẩm tại thời điểm chốt đơn.
* **GiamGia**: Số tiền giảm trực tiếp trên mỗi đơn vị sản phẩm (nếu có).
