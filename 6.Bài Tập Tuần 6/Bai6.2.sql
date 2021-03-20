use master
go

create database QLBanHang 
on primary(
	name = QLBanHang_DB,
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 6\QLBanHang_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = QLBanHang_log,
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 6\QLBanHang_Log.ldf',
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

-- THỰC HÀNH TẠO VIEW
-- B. Đưa ra thông tin MaSP, TenSP, TenHang,SoLuong, MauSac, GiaBan, DonViTinh, MoTa của các sản phẩm 

create view CauB1
as
	select MaSP, TenSP, TenHang, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
	from SanPham inner join HangSX
	on SanPham.MaHangSX = HangSX.MaHangSX

select * from CauB1

--C. Đưa ra thông tin các sản phẩm có trong cữa hàng do công ty có tên hãng là Samsung sản xuất.
create view CauC1
as
	select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
	from SanPham inner join HangSX
	on SanPham.MaHangSX = HangSX.MaHangSX
	where TenHang = N'Samsung'

select * from CauC1

----D. Đưa ra thông tin các nhân viên Nữ ở phòng ‘Kế toán’.
create view CauD1
as
	select * from NhanVien
	where GioiTinh = N'Nữ' and TenPhong = N'Kế Toán'

select * from CauD1

--E. Đưa ra thông tin phiếu nhập gồm: SoHDN, MaSP, TenSP, TenHang, SoLuongN, DonGiaN, TienNhap=SoLuongN*DonGiaN, MauSac, DonViTinh, NgayNhap, TenNV, TenPhong
create view CauE1
as
	select PNhap.SoHDN, SanPham.MaSP, TenSP, TenHang, SoLuongN, DonGiaN, SoLuongN * DonGiaN as 'TienNhap', MauSac, DonViTinh, NgayNhap, TenNV, TenPhong
	from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
			  inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
			  inner join NhanVien on PNhap.MaNV = NhanVien.MaNV
			  inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX

select * from CauE1

--F. Đưa ra thông tin phiếu xuất gồm: SoHDX, MaSP, TenSP, TenHang, SoLuongX, GiaBan, tienxuat=SoLuongX*GiaBan, MauSac, DonViTinh, NgayXuat, TenNV, TenPhong trong tháng 06 năm 2020
create view CauF1
as
	select Xuat.SoHDX, SanPham.MaSP, TenSP, TenHang, SoLuongX, GiaBan, SoLuongX * GiaBan as 'TienXuat', MauSac, DonViTinh, NgayXuat, TenNV, TenPhong
	from Xuat inner join SanPham on Xuat.MaSP = SanPham.MaSP
			  inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
			  inner join NhanVien on PXuat.MaNV = NhanVien.MaNV
			  inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
	where MONTH(NgayXuat) = 6 and YEAR(NgayXuat) = 2020

select * from CauF1

--G. Đưa ra các thông tin về các hóa đơn mà hãng Samsung đã nhập trong năm 2020, gồm: SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong.
create view CauG1
as
	select Nhap.SoHDN, SanPham.MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
	from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
			  inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
			  inner join NhanVien on PNhap.MaNV = NhanVien.MaNV
			  inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX
	where TenHang = N'Samsung' and YEAR(NgayNhap) = 2020

select * from CauG1

--H. Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2020
create view H1
as
	select top 10 Xuat.SoHDX, NgayXuat, SoLuongX
	from Xuat inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
	where YEAR(NgayXuat) = 2020

select * from H1

--J. Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng Samsung.
create view J1
as
	select MaSP, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa
	from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
	where TenHang = N'Samsung' and GiaBan between 100000 and 500000

select * from J1

--K. Tính tổng tiền đã nhập trong năm 2020 của hãng Samsung.
create view K1
as
	select SUM(SoLuongN * DonGiaN) as N'Tổng Tiền Nhập'
	from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
			  inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
			  inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
	where YEAR(NgayNhap) = 2020 and TenHang = N'Samsung'

select * from K1

--H. Thống kê tổng tiền đã xuất trong ngày 14/06/2020.
create view H1
as
	select SUM(SoLuongX * GiaBan) as N'Tổng Tiền Xuát'
	from Xuat inner join SanPham on Xuat.MaSP = SanPham.MaSP
	inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
	where NgayXuat = '2020-6-14'

select * from H1

--L. Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020.
create view L1
as
	select Nhap.SoHDN, NgayNhap
	from Nhap inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
	where YEAR(NgayNhap) = 2020 and SoLuongN * DonGiaN = (select MAX(SoLuongN * DonGiaN) 
															from Nhap inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
															where Year(NgayNhap) = 2020)

select * from H1

--N. Đưa ra MaSP,TenSP của các sản phẩm do công ty ‘Samsung’ sản xuất do nhân viên có mã ‘NV01’ nhập.
create view N1
as
	select SanPham.MaSP, TenSP
	from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
				 inner join Nhap on SanPham.MaSP = Nhap.MaSP
				 inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
	where TenHang = N'Samsung' and MaNV = N'NV01'

select * from N1

--P. Đưa ra SoHDN,MaSP,SoLuongN,ngayN của mặt hàng có MaSP là ‘SP02’, được nhân viên ‘NV02’ xuất.
create view P1
as
	select Nhap.SoHDN, Nhap.MaSP, SoLuongN, NgayNhap
	from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
			  inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
	where SanPham.MaSP = N'SP02' and MaNV = N'NV02'

select * from P1

--Q. Đưa ra MaNV, TenNV đã xuất mặt hàng có mã ‘SP02’ ngày ‘03-02-2020’
create view Q1
as
	select NhanVien.MaNV, TenNV
	from NhanVien inner join PXuat on NhanVien.MaNV = PXuat.MaNV
				  inner join Xuat on PXuat.SoHDX = Xuat.SoHDX
	where NgayXuat = '2020-2-3' and MaSP = N'SP02'

select * from Q1

--A. Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
create view A2
as
	select HangSX.MaHangSX, TenHang, count(*) as N'Số Lượng SP'
	from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
	group by HangSX.MaHangSX, TenHang

select * from A2

--B. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020.
create view B2
as
	select SanPham.MaSP, TenSP, sum(SoLuongN * DonGiaN) as N'Tổng Tiền Nhập'
	from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
			  inner join PNhap on PNhap.SoHDN = Nhap.SoHDN
	where year(NgayNhap) = 2020
	group by SanPham.MaSP, TenSP

select * from B2

--C. Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 10.000 sản phẩm của hãng Samsung.
create view C2
as
	select SanPham.MaSP, TenSP, sum(SoLuongX) as N'Tổng số lượng xuất'
	from Xuat inner join SanPham on Xuat.MaSP = SanPham.MaSP
			  inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX
			  inner join PXuat on PXuat.SoHDX = Xuat.SoHDX
	where YEAR(NgayXuat) = 2020 and TenHang = N'Samsung'
	group by SanPham.MaSP, TenSP
	having SUM(SoLuongX) >= 10000

select * from C2
--D. Thống Kê Số Lượng Nhân Viên Nam Mỗi Phòng Ban
create view D2
as
	select MaNV, TenNV, TenPhong, COUNT(*) as N'Số Nhân Viên Mỗi Phòng Ban'
	from NhanVien
	where GioiTinh = N'Nam'
	group by MaNV, TenNV, TenPhong

select * from D2
--E. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
create view E2
as
	select TenHang, SUM(SoLuongN) as N'Tổng Số Lượng Nhâp'
	from PNhap inner join Nhap on Nhap.SoHDN = PNhap.SoHDN
			   inner join SanPham on SanPham.MaSP = Nhap.MaSP
			   inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX
	where YEAR(NgayNhap) = 2018
	group by TenHang

select * from E2
--F. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu.
create view F2
as
	select MaNV, sum(SoLuongX * GiaBan) as N'Tổng Lượng Tiền Xuất'
	from PXuat inner join Xuat on PXuat.SoHDX = Xuat.SoHDX
			   inner join SanPham on Xuat.MaSP = SanPham.MaSP
	where YEAR(NgayXuat) = 2018
	group by MaNV
select * from F2

--G. Hãy Đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 8 – năm 2018 có tổng giá trị lớn hơn 100.000
create view G2
as
	select MaNV, sum(SoLuongN * GiaBan) as N'Tổng Lượng Tiền Nhập'
	from PNhap inner join Nhap on PNhap.SoHDN = Nhap.SoHDN
				inner join SanPham on Nhap.MaSP = SanPham.MaSP
	where YEAR(NgayNhap) = 2018 and MONTH(NgayNhap) = 8
	group by MaNV
	having sum(SoLuongN * GiaBan) > 100000

select * from G2

--H.Hãy Đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.
create view H2
as
	select SanPham.MaSP, TenSP
	from SanPham inner join Nhap on SanPham.MaSP = Nhap.MaSP
	where SanPham.MaSP not in (select MaSP from Xuat)
select * from H2
--I. Hãy Đưa ra danh sách các sản phẩm đã nhập năm 2020 và đã xuất năm 2020.
create view I2
as
	select SanPham.MaSP, TenSP
	from SanPham inner join Nhap on SanPham.MaSP = Nhap.MaSP
				inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
	where YEAR(NgayNhap) = 2020 and SanPham.MaSP in (select SanPham.MaSP 
														from SanPham inner join Xuat on SanPham.MaSP = Nhap.MaSP
																	 inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
														where YEAR(NgayXuat) = 2020)
select * from I2