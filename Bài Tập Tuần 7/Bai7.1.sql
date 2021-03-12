use master
go

create database QLBanHang 
on primary(
	name = QLBanHang_DB,
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 7\QLBanHang_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = QLBanHang_log,
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 7\QLBanHang_Log.ldf',
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

--select * from Xuat

--a. Hãy xây dựng hàm Đưa ra tên HangSX khi nhập vào MaSP từ bàn phím
create function CauA(@MaSP nchar(10))
returns nvarchar(20)
as
	begin
		declare @TenHang nvarchar(20)
		set @TenHang = (select TenHang
						from HangSX inner join SanPham
						on HangSX.MaHangSX = SanPham.MaHangSX
						where MaSP = @MaSP)
		return @TenHang
	end

select dbo.CauA(N'SP01') as N'Tên Hãng Sản Xuất'

--b. Hãy xây dựng hàm đưa ra tổng giá trị nhập từ năm nhập x đến năm nhập y, với x, y được nhập vào từ bàn phím.
alter function CauB(@x int, @y int)
returns int
as 
	begin
		declare @TongTien int
		declare @DapAn int
		set @TongTien = (select sum(SoLuongN * DonGiaN)
						 from Nhap inner join PNhap
						 on Nhap.SoHDN = PNhap.SoHDN
						 where YEAR(NgayNhap) between @x and @y)
		if(@TongTien is null)
			set @TongTien = 0

		return @TongTien
	end

--TH Null
select dbo.CauB(2016, 2017) as N'Tổng Giá Trị Nhập'

--TH Not null
select dbo.CauB(2019, 2020) as N'Tổng Giá Trị Nhập'

--c. Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm y, với x,y nhập từ bàn phím.
create function CauC(@TenSP nvarchar(20), @Nam int)
returns int
as 
	begin
		declare @TongNhap int
		declare @TongXuat int
		declare @ThayDoi int

		set @TongNhap = (select sum(SoLuongN)
						 from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
								   inner join PNhap on PNhap.SoHDN = Nhap.SoHDN
						 where TenSP = @TenSP and YEAR(NgayNhap) = @Nam)
		set @TongXuat = (select sum(SoLuongX)
						 from Xuat inner join SanPham on Xuat.MaSP = SanPham.MaSP
						           inner join PXuat on PXuat.SoHDX = Xuat.SoHDX
						 where TenSP = @TenSP and YEAR(NgayXuat) = @Nam)
		if(@TongNhap is null)
			set @TongNhap = 0
		if(@TongXuat is null)
			set @TongXuat = 0
		set @ThayDoi = @TongNhap - @TongXuat
		return @ThayDoi
	end

select dbo.CauC(N'Galaxy Note11', 2020) as N'Tổng Số Lượng Thay Đổi'

--d. Hãy xây dựng hàm Đưa ra tổng giá trị nhập từ ngày nhập x đến ngày nhập y, với x, y được nhập vào từ bàn phím
create function CauD(@NgayNhap1 date, @NgayNhap2 date)
returns int
as 
	begin
		declare @TongNhap int
		set @TongNhap = (select sum(DonGiaN * SoLuongN)
						 from Nhap inner join PNhap
						 on Nhap.SoHDN = PNhap.SoHDN
						 where NgayNhap between @NgayNhap1 and @NgayNhap2)
		if(@TongNhap is null)
			set @TongNhap = 0
		return @TongNhap
	end

select dbo.CauD('2019-2-5', '2020-6-14') as N'Tổng giá trị Nhập'

--e. Hãy xây dựng hàm Đưa ra tổng giá trị xuất của hãng tên hãng là A, trong năm tài khóa x, với A, x được nhập từ bàn phím.
create function CauE(@TenHang nvarchar(20), @Nam int)
returns int
as 
	begin
		declare @TongXuat int
		
		set @TongXuat = (select sum(GiaBan * SoLuongX)
						 from Xuat inner join SanPham on Xuat.MaSP = SanPham.MaSP
						           inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
								   inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
						 where TenHang = @TenHang and YEAR(NgayXuat) = @Nam)
		if(@TongXuat is null)
			set @TongXuat = 0
		return @TongXuat
	end

select dbo.CauE(N'Samsung', 2019) as N'Tổng Giá Trị Xuất'

--f. Hãy xây dựng hàm thống kê số lượng nhân viên mỗi phòng với tên phòng nhập từ bàn phím.
create function CauF(@TenPhong nvarchar(30))
returns int
as
	begin
		declare @SoLuong int
		set @SoLuong = (select count(MaNV)
						from NhanVien
						where TenPhong = @TenPhong)
		if(@SoLuong is null)
			set @SoLuong = 0
		return @SoLuong
	end

select dbo.CauF(N'Kế toán') as N'Số Lượng Nhân Viên'

--g. Hãy viết hàm thống kê xem tên sản phẩm x đã xuất được bao nhiêu sản phẩm trong ngày y, với x,y nhập từ bản phím.
create function CauG(@TenSP nvarchar(20), @Ngay date)
returns int 
as
	begin
		declare @SoLuongXuat int
		set @SoLuongXuat = (select SUM(SoLuongX)
							from Xuat inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
									  inner join SanPham on Xuat.MaSP = SanPham.MaSP
							where TenSP = @TenSP and NgayXuat = @Ngay)
		if(@SoLuongXuat is null)
			set @SoLuongXuat = 0

		return @SoLuongXuat
	end

select dbo.CauG(N'Galaxy Note11', '2019-12-12') as N'Số lượng sản phẩm xuất'

--h. Hãy viết hàm trả về số diện thoại của nhân viên đã xuất số hóa đơn x, với x nhập từ bàn phím.
create function CauH(@SoHoaDonXuat nchar(10))
returns nvarchar(20)
as
	begin
		declare @SoDienThoai nvarchar(20)
		set @SoDienThoai = (select SoDT
							from PXuat inner join NhanVien
							on PXuat.MaNV = NhanVien.MaNV
							where SoHDX = @SoHoaDonXuat)
		return @SoDienThoai
	end

select dbo.CauH('X01') as N'Số Điện Thoại'

--i. Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm y, với x,y nhập từ bàn phím.
create function CauI(@TenSP nvarchar(20), @Nam int)
returns int
as
	begin
		declare @TongNhap int
		declare @TongXuat int
		declare @ThayDoi int

		set @TongNhap = (select SUM(SoLuongN)
						from SanPham inner join Nhap on SanPham.MaSP = Nhap.MaSP
									 inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
						where TenSP = @TenSP and YEAR(NgayNhap) = @Nam)

		set @TongXuat = (select SUM(SoLuongX)
						 from SanPham inner join Xuat on SanPham.MaSP = Xuat.MaSP
									  inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
						 where TenSP = @TenSP and YEAR(NgayXuat) = @Nam)
		if(@TongNhap is null)
			set @TongNhap = 0
		if(@TongXuat is null)
			set @TongXuat = 0

		set @ThayDoi = @TongNhap - @TongXuat
		
		return @ThayDoi
	end

select dbo.CauI(N'F3 lite', 2019) as N'Thay đổi'

--j. Hãy viết hàm thống kê tổng số lượng sản phầm của hãng x, với tên hãng nhập từ bàn phím
create function CauJ(@TenHang nvarchar(20))
returns int
as 
	begin
		declare @TongSoLuongSanPham int
		
		set @TongSoLuongSanPham = (select SUM(SoLuongN) - SUM(SoLuongX) + SUM(SoLuong)
								   from SanPham inner join Nhap on SanPham.MaSP = Nhap.MaSP
												inner join Xuat on SanPham.MaSP = Xuat.MaSP
												inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
								   where TenHang = @TenHang)

		if(@TongSoLuongSanPham is null)
			set @TongSoLuongSanPham = 0
		return @TongSoLuongSanPham
	end

select dbo.CauJ(N'Samsung') as N'Tổng Số Lượng Sản Phẩm'