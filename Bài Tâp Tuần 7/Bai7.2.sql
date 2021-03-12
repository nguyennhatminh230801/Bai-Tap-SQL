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

--a. Hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím.
create function CauA(@TenHang nvarchar(20))
returns @BangA table (
				MaSP nchar(10), 
				TenSP nvarchar(20),
				SoLuong int,
				MauSac nvarchar(20),
				GiaBan money,
				DonViTinh nvarchar(10),
				MoTa nvarchar(max))
as
	begin
		insert into @BangA 
		select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
		from SanPham inner join HangSX
		on SanPham.MaHangSX = HangSX.MaHangSX
		where TenHang = @TenHang
		
		return
	end

select * from CauA(N'Samsung')

--b. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được nhập từ ngày x đến ngày y, với x,y nhập từ bàn phím.
create function CauB(@x date, @y date)
returns @BangB table(
					MaSP nchar(10),
					TenSP nvarchar(20),
					TenHang nvarchar(20),
					NgayNhap date,
					SoLuongN int,
					DonGiaN money
					)
as
	begin
		insert into @BangB
		select SanPham.MaSP, TenSP, TenHang, NgayNhap, SoLuongN, DonGiaN
		from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
				  inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
		          inner join PNhap on PNhap.SoHDN = Nhap.SoHDN
		where NgayNhap between @x and @y
		return
	end

select * from CauB('2019-2-5' ,'2020-6-14')

--c. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn,
--nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm có SoLuong = 0, ngược lại lựa chọn
--=1 thì Đưa ra danh sách các sản phẩm có SoLuong >0.

create function CauC(@TenHang nvarchar(20), @Option int)
returns @BangC table(
				MaSP nchar(10), 
				TenSP nvarchar(20),
				SoLuong int,
				MauSac nvarchar(20),
				GiaBan money,
				DonViTinh nvarchar(10),
				MoTa nvarchar(max))
as
	begin
		if(@Option = 0)
			insert into @BangC
			select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
			from SanPham inner join HangSX
			on SanPham.MaHangSX = HangSX.MaHangSX
			where TenHang = @TenHang and SoLuong = 0
		else
			insert into @BangC
			select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
			from SanPham inner join HangSX
			on SanPham.MaHangSX = HangSX.MaHangSX
			where TenHang = @TenHang and SoLuong > 0
			return
	end

select * from CauC(N'Samsung', 0)
select * from CauC(N'Samsung', 1)

--d. Hãy xây dựng hàm Đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím.
create function CauD(@TenPhong nvarchar(30))
returns @BangD table(MaNV nchar(10),
					TenNV nvarchar(20),
					GioiTinh nchar(10),
					DiaChi nvarchar(30),
					SoDT nvarchar(20),
					Email nvarchar(30),
					TenPhong nvarchar(30))
as
	begin
		insert into @BangD
		select * from NhanVien
		where TenPhong = @TenPhong
		return
	end

select * from CauD(N'Kế Toán')

--e. Hãy tạo hàm Đưa ra danh sách các hãng sản xuất có địa chỉ nhập vào từ bàn phím (Lưu ý – Dùng hàm Like để lọc).
create function CauE(@DiaChi nvarchar(30))
returns @BangE table(
					MaHangSX nchar(10),
					TenHang nvarchar(20),
					DiaChi nvarchar(30),
					SoDT nvarchar(20),
					Email nvarchar(30)
					)
as
	begin
		insert into @BangE
		select * from HangSX
		where DiaChi like '%' + @DiaChi + '%'
		return
	end

select * from CauE(N'V')

--f. Hãy viết hàm Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được xuất từ năm x đến năm y, với x,y nhập từ bàn phím.
create function CauF(@x int, @y int)
returns @BangF table(
					MaSP nchar(10),
					TenSP nvarchar(20),
					TenHang nvarchar(20),
					NgayNhap date,
					SoLuongN int,
					DonGiaN money
					)
as
	begin
		insert into @BangF
		select SanPham.MaSP, TenSP, TenHang, NgayNhap, SoLuongN, DonGiaN
		from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
				  inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
		          inner join PNhap on PNhap.SoHDN = Nhap.SoHDN
		where YEAR(NgayNhap) between @x and @y
		return
	end

select * from CauF(2019, 2020)

--g. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn,
--nếu lựa chọn = 0 thì Đưa ra danh sách các sản phẩm đã được nhập, ngược lại lựa chọn =1
--thì Đưa ra danh sách các sản phẩm đã được xuất.
create function CauG(@TenHang nvarchar(20), @Option int)
returns @BangG table(
					MaSP nchar(10),
					MaHangSX nchar(10),
					TenSP nvarchar(20),
					MauSac nvarchar(20),
					GiaBan money,
					DonViTinh nchar(10),
					MoTa nvarchar(max)
					)
as 
	begin
		if(@Option = 0)
			insert into @BangG
			select SanPham.MaSP, SanPham.MaHangSX, TenSP, MauSac, GiaBan, DonViTinh, MoTa
			from SanPham inner join Nhap on SanPham.MaSP = Nhap.MaSP
						 inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
			where TenHang = @TenHang
		else
			insert into @BangG
			select SanPham.MaSP, SanPham.MaHangSX, TenSP, MauSac, GiaBan, DonViTinh, MoTa
			from SanPham inner join Xuat on SanPham.MaSP = Xuat.MaSP
						 inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
			where TenHang = @TenHang
			return
	end

select * from CauG(N'Samsung', 0)
select * from CauG(N'Samsung', 1)

--h. Hãy xây dựng hàm Đưa ra danh sách các nhân viên đã nhập hàng vào ngày được đưa vào từ bàn phím
create function CauH(@NgayNhap date)
returns @BangH table(
					MaNV nchar(10),
					TenNV nvarchar(20),
					GioiTinh nchar(10),
					DiaChi nvarchar(30),
					SoDT nvarchar(20),
					Email nvarchar(30),
					TenPhong nvarchar(30)
					)
as
	begin
		insert into @BangH
		select NhanVien.MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong
		from NhanVien inner join PNhap on NhanVien.MaNV = PNhap.MaNV
					  inner join Nhap on PNhap.SoHDN = Nhap.SoHDN
		where NgayNhap = @NgayNhap 
		return
	end

select * from CauH('2020-4-7')

--i. Hãy xây dựng hàm Đưa ra danh sách các sản phẩm có giá bán từ x đến y, do công ty z
--sản xuất, với x,y,z nhập từ bàn phím.
 create function CauI(@GiaBan1 money, @GiaBan2 money, @TenHang nvarchar(20))
 returns @BangI table(
					 MaSP nchar(10),
					 MaHangSX nchar(10),
					 TenSP nvarchar(20),
					 SoLuong int,
					 MauSac nvarchar(20),
					 GiaBan money,
					 DonViTinh nchar(10),
					 MoTa nvarchar(max)
					 )
as
	begin
		insert into @BangI
		select MaSP, SanPham.MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
		from SanPham inner join HangSX
		on SanPham.MaHangSX = HangSX.MaHangSX
		where TenHang = @TenHang and GiaBan between @GiaBan1 and @GiaBan2
		return
	end

select * from CauI(7000000, 19000000, N'Samsung')

--j. Hãy xây dựng hàm không tham biến Đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng
create function CauJ()
returns @BangJ table(
					 MaSP nchar(10),
					 MaHangSX nchar(10),
					 TenSP nvarchar(20),
					 SoLuong int,
					 MauSac nvarchar(20),
					 GiaBan money,
					 DonViTinh nchar(10),
					 MoTa nvarchar(max),
					 TenHang nvarchar(20)
					 )
as
	begin
		insert into @BangJ
		select MaSP, SanPham.MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa, TenHang
		from SanPham inner join HangSX
		on SanPham.MaHangSX = HangSX.MaHangSX
		return
	end

select * from CauJ()