use master
go

create database QLBanHang 
on primary(
	name = QLBanHang_DB,
	filename = 'C:\Users\Administrator\Desktop\9.Bai Tap Tuan 9\QLBanHang_db1.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = QLBanHang_log,
	filename = 'C:\Users\Administrator\Desktop\9.Bai Tap Tuan 9\QLBanHang_log1.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

go
use QLBanHang

create table HangSX(
	MaHangSX nchar(10) primary key,
	TenHang nvarchar(20),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30)
)

create table SanPham(
	MaSP nchar(10) primary key,
	MaHangSX nchar(10),
	TenSP nvarchar(20),
	SoLuong int,
	MauSac nvarchar(20),
	GiaBan money,
	DonViTinh nchar(10),
	MoTa nvarchar(max)

	constraint FK_MaHangSX foreign key(MaHangSX) references HangSX(MaHangSX)
)

create table NhanVien(
	MaNV nchar(10) primary key,
	TenNV nvarchar(20),
	GioiTinh nchar(10),
	DiaChi nvarchar(30),
	SoDT nvarchar(20),
	Email nvarchar(30),
	TenPhong nvarchar(30)
)

create table PNhap(
	SoHDN nchar(10) primary key,
	NgayNhap date,
	MaNV nchar(10)

	constraint FK_MaNV foreign key(MaNV) references NhanVien(MaNV)
)

create table Nhap(
	SoHDN nchar(10),
	MaSP nchar(10),
	SoLuongN int,
	DonGiaN money

	constraint PK_SoHDN_MaSP primary key(SoHDN, MaSP),
	constraint FK_MaSP foreign key(MaSP) references SanPham(MaSP),
	constraint FK_SoHDN foreign key(SoHDN) references PNhap(SoHDN)
)

create table PXuat(
	SoHDX nchar(10) primary key,
	NgayXuat date,
	MaNV nchar(10)

	constraint FK_MaNV_1 foreign key(MaNV) references NhanVien(MaNV)
)

create table Xuat(
	SoHDX nchar(10),
	MaSP nchar(10),
	SoLuongX int

	constraint PK_SoHDX_MaSP primary key(SoHDX, MaSP),
	constraint FK_MaSP_1 foreign key(MaSP) references SanPham(MaSP),
	constraint FK_SoHDX foreign key(SoHDX) references PXuat(SoHDX)
)

insert into HangSX values(N'H01', N'Samsung', N'Korea', N'011-08271717', N'ss@gmail.com.kr')
insert into HangSX values(N'H02', N'OPPO', N'China', N'081-08626262', N'oppo@gmail.com.cn')
insert into HangSX values(N'H03', N'Vinfone', N'Việt nam', N'084-098262626', N'vf@gmail.com.vn')

--select * from HangSX
insert into NhanVien values(N'NV01',N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội',N'0982626521',N'thu@gmail.com',N'Kế toán')
insert into NhanVien values(N'NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh',N'0972525252',N'nam@gmail.com',N'Vật tư')
insert into NhanVien values(N'NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội',N'0328388388',N'hb@gmail.com',N'Kế toán')

--select * from NhanVien

insert into SanPham values(N'SP01', N'H02', N'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp')
insert into SanPham values(N'SP02', N'H01', N'Galaxy Note11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp')
insert into SanPham values(N'SP03', N'H02', N'F3 lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông')
insert into SanPham values(N'SP04', N'H03', N'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông')
insert into SanPham values(N'SP05', N'H01', N'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp')

--select * from SanPham

insert into PNhap values(N'N01', '2019-2-5', N'NV01')
insert into PNhap values(N'N02', '2020-4-7', N'NV02')
insert into PNhap values(N'N03', '2019-5-17', N'NV02')
insert into PNhap values(N'N04', '2019-3-22', N'NV03')
insert into PNhap values(N'N05', '2019-7-7', N'NV01')

--select * from PNhap

insert into Nhap values(N'N01', N'SP02', 10, 17000000)
insert into Nhap values(N'N02', N'SP01', 30,  6000000)
insert into Nhap values(N'N03', N'SP04', 20, 1200000)
insert into Nhap values(N'N04', N'SP01', 10, 6200000)
insert into Nhap values(N'N05', N'SP05', 20, 7000000)

--select * from Nhap

insert into PXuat values(N'X01', '2020-6-14', N'NV02')
insert into PXuat values(N'X02', '2019-3-5', N'NV03')
insert into PXuat values(N'X03', '2019-12-12', N'NV01')
insert into PXuat values(N'X04', '2019-6-2', N'NV02')
insert into PXuat values(N'X05', '2019-5-18', N'NV01')

--select * from PNhap

insert into Xuat values(N'X01', N'SP03', 5)
insert into Xuat values(N'X02', N'SP01', 3)
insert into Xuat values(N'X03', N'SP02', 1)
insert into Xuat values(N'X04', N'SP03', 2)
insert into Xuat values(N'X05', N'SP05', 1)

--a. Viết thủ tục thêm mới nhân viên bao gồm các tham số: MaNV, TenNV, GioiTinh, 
--DiaChi, SoDT, Email, TenPhong và 1 biến Flag, Nếu Flag=0 thì nhập mới, ngược lại thì 
--cập nhật thông tin nhân viên theo mã. Hãy kiểm tra:
-- GioiTinh nhập vào có phải là Nam hoặc Nữ không, nếu không trả về mã lỗi 1.
-- Ngược lại nếu thỏa mãn thì cho phép nhập và trả về mã lỗi 0.

create procedure CauA(@MaNV nchar(10), 
				      @TenNV nvarchar(20), 
					  @GioiTinh nchar(10), 
					  @DiaChi nvarchar(30), 
					  @SoDT nvarchar(20), 
					  @Email nvarchar(30), 
					  @TenPhong nvarchar(30),
					  @Flag int,
					  @Error int output)
as
	begin
		if(@GioiTinh <> N'Nam' and @GioiTinh <> N'Nữ')
			begin
				set @Error = 1;
			end
		else
			begin
				set @Error = 0;
				if(@Flag = 0)
					begin
						insert into NhanVien values(@MaNV, @TenNV, @GioiTinh, @DiaChi, @SoDT, @Email, @TenPhong)
					end
				else
					begin
						update NhanVien
						set TenNV = @TenNV, GioiTinh = @GioiTinh, 
							DiaChi = @DiaChi, SoDT = @SoDT, Email = @Email,
							TenPhong = @TenPhong
						where MaNV = @MaNV
					end
			end
	end

declare @ErrorA int

--Sai Thông Tin Giới Tính
execute CauA N'NV06', N'Nguyễn Văn A', N'NonSexual', N'Hà Nội', '1234567890', 'VanA@gmail.com', N'Hành Chính', 0, @ErrorA output

--Thêm mới
execute CauA N'NV06', N'Nguyễn Văn A', N'Nam', N'Hà Nội', '1234567890', 'VanA@gmail.com', N'Hành Chính', 0, @ErrorA output

--Sửa đổi
execute CauA N'NV06', N'Nguyễn Văn A', N'Nam', N'Hà Nội', '12345678901', 'VanA@gmail.com', N'Hành Chính', 1, @ErrorA output

select @ErrorA as N'Kiểm Tra Kết Qủa'

--delete from NhanVien where MaNV = N'NV06'

--b. Viết thủ tục thêm mới sản phẩm với các tham biến MaSP, TenHang, TenSP, SoLuong, 
--MauSac, GiaBan, DonViTinh, MoTa và 1 biến Flag. Nếu Flag=0 thì thêm mới sản phẩm, 
--ngược lại cập nhật sản phẩm. Hãy kiểm tra:
-- Nếu TenHang không có trong bảng HangSX thì trả về mã lỗi 1
-- Nếu SoLuong <0 thì trả về mã lỗi 2
-- Ngược lại trả về mã lỗi 0.
create procedure CauB(@MaSP nchar(10),
					  @MaHangSX nchar(10),
					  @TenSP nvarchar(20),
					  @SoLuong int,
					  @MauSac nvarchar(20),
					  @GiaBan money,
					  @DonViTinh nchar(10),
					  @MoTa nvarchar(max),
					  @Flag int,
					  @Error int output)
as
	begin
		
	end
--c. Viết thủ tục xóa dữ liệu bảng NhanVien với tham biến là manv. Nếu manv chưa có thì 
--trả về 1, ngược lại xóa NhanVien với NhanVien bị xóa là manv và trả về 0. (Lưu ý: xóa 
--NhanVien thì phải xóa các bảng Nhap, Xuat mà nhân viên này tham gia).

--d. Viết thủ tục xóa dữ liệu bảng SanPham với tham biến là MaSP. Nếu MaSP chưa có thì 
--trả về 1, ngược lại xóa SanPham với SanPham bị xóa là MaSP và trả về 0. (Lưu ý: xóa 
--SanPham thì phải xóa các bảng Nhap, Xuat mà SanPham này cung ứng).

--e. Tạo thủ tục nhập liệu cho bảng HangSX, với các tham biến truyền vào MaHangSX, 
--TenHang, DiaChi, SoDT, Email. Hãy kiểm tra xem TenHang đã tồn tại trước đó hay chưa, 
--nếu rồi trả về mã lỗi 1? Nếu có rồi thì không cho nhập và trả về mã lỗi 0.

--f. Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến SoHDN, MaSP, manv, 
--NgayNhap, SoLuongN, DonGiaN. Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay 
--không, nếu không trả về 1? manv có tồn tại trong bảng NhanVien hay không nếu không trả
--về 2? ngược lại thì hãy kiểm tra: Nếu SoHDN đã tồn tại thì cập nhật bảng Nhap theo 
--SoHDN, ngược lại thêm mới bảng Nhap và trả về mã lỗi 0.

--g. Viết thủ tục nhập dữ liệu cho bảng Xuat với các tham biến SoHDX, MaSP, manv, 
--NgayXuat, SoLuongX. Kiểm tra xem MaSP có tồn tại trong bảng SanPham hay không nếu 
--không trả về 1? manv có tồn tại trong bảng NhanVien hay không nếu không trả về 2? 
--SoLuongX <= SoLuong nếu không trả về 3? ngược lại thì hãy kiểm tra: Nếu SoHDX đã 
--tồn tại thì cập nhật bảng Xuat theo SoHDX, ngược lại thêm mới bảng Xuat và trả về mã 
--lỗi 0.
