# Cấu trúc Dữ liệu Quản lý Bán hàng

## 1. Khách hàng (KHACHHANG)
Quản lý thông tin người mua để chăm sóc và liên hệ.
* **MaKH**: Mã định danh duy nhất phân biệt từng khách.
* **TenKH**, **SoDienThoai**, **Email**, **DiaChi**: Thông tin liên lạc cơ bản.
* **DiemTichLuy**: Điểm thưởng khi mua hàng dùng cho các chương trình khách hàng thân thiết.

## 2. Sản phẩm (SANPHAM)
Lưu trữ danh sách mặt hàng đang kinh doanh.
* **MaSP**: Mã định danh duy nhất của sản phẩm.
* **TenSP**: Tên hiển thị của sản phẩm.
* **MaSKU**: Mã vạch hoặc mã phân loại nội bộ (Stock Keeping Unit).
* **MaDanhMuc**: Mã chỉ định sản phẩm thuộc nhóm hàng nào (ví dụ: Áo Nam, Quần Nữ, Phụ Kiện).
* **GiaBan**: Giá bán niêm yết hiện tại.

## 3. Khuyến mãi (KHUYENMAI)
Quản lý các voucher, chiến dịch ưu đãi.
* **MaKM**: Mã hệ thống dùng để quản lý chiến dịch.
* **MaCode**: Chuỗi ký tự khách hàng nhập để áp dụng ưu đãi (ví dụ: GIAM50K, BLACKFRIDAY).
* **GiaTriGiam**: Mức ưu đãi (có thể là tiền mặt hoặc %).
* **NgayBatDau**, **NgayKetThuc**: Thời hạn có hiệu lực của mã giảm giá.

## 4. Đơn hàng (DONHANG)
Ghi nhận tổng quan về một lần giao dịch của khách.
* **MaDH**: Mã số duy nhất của hóa đơn.
* **MaKH**, **MaKM**: Liên kết để biết đơn hàng này của khách nào và có áp dụng mã khuyến mãi nào không.
* **NgayDat**, **KenhBanHang**: Thời điểm và nơi chốt đơn (Web/Shopee/Tại quầy).
* **TrangThaiThanhToan**: Theo dõi việc khách đã trả tiền hay chưa.
* **TongTienHang**: Tổng cộng tiền các món hàng (chưa trừ ưu đãi) — Trigger tự động tính từ CHITIETDONHANG.
* **SoTienGiam**: Số tiền được trừ đi nhờ áp dụng mã MaKM.
* **ThanhTien**: Số tiền cuối cùng thực tế khách phải trả — Trigger tự động tính = TongTienHang - SoTienGiam.

## 5. Chi tiết đơn hàng (CHITIETDONHANG)
Liệt kê chi tiết bên trong một đơn hàng khách đã mua những mặt hàng cụ thể nào (vì một đơn có thể chứa nhiều mặt hàng khác nhau).
* **MaCTDH**: Định danh cho từng dòng chi tiết trong giỏ hàng.
* **MaDH**, **MaSP**: Cho biết dòng này thuộc hóa đơn nào và mua sản phẩm gì.
* **SoLuong**: Khách mua mấy cái cho mặt hàng này.
* **DonGia**: Giá của mặt hàng được chốt ngay tại lúc tạo đơn (snapshot — không đổi khi giá SP thay đổi sau).
* **GiamGia**: Mức giảm trực tiếp ngay trên mặt hàng đó (nếu cửa hàng có chương trình sale riêng cho sản phẩm, độc lập với voucher toàn đơn).
