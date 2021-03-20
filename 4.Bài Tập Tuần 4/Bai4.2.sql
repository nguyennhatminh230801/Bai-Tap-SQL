use master
go

create database QLBanHang 
on primary(
	name = QLBanHang_DB,
	filename = 'C:\Users\Admin\Desktop\Bài Tập SQL Tuần 4\QLBanHang_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = QLBanHang_log,
	filename = 'C:\Users\Admin\Desktop\Bài Tập SQL Tuần 4\QLBanHang_Log.ldf',
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

insert into NhanVien values(N'NV01',N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội',N'0982626521',N'thu@gmail.com',N'Kế toán')
insert into NhanVien values(N'NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh',N'0972525252',N'nam@gmail.com',N'Vật tư')
insert into NhanVien values(N'NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội',N'0328388388',N'hb@gmail.com',N'Kế toán')

insert into SanPham values(N'SP01', N'H02', N'F1 Plus', 100, N'Xám', 7000000, N'Chiếc', N'Hàng cận cao cấp')
insert into SanPham values(N'SP02', N'H01', N'Galaxy Note11', 50, N'Đỏ', 19000000, N'Chiếc', N'Hàng cao cấp')
insert into SanPham values(N'SP03', N'H02', N'F3 lite', 200, N'Nâu', 3000000, N'Chiếc', N'Hàng phổ thông')
insert into SanPham values(N'SP04', N'H03', N'Vjoy3', 200, N'Xám', 1500000, N'Chiếc', N'Hàng phổ thông')
insert into SanPham values(N'SP05', N'H01', N'Galaxy V21', 500, N'Nâu', 8000000, N'Chiếc', N'Hàng cận cao cấp')

insert into PNhap values(N'N01', '2019-2-5', N'NV01')
insert into PNhap values(N'N02', '2020-4-7', N'NV02')
insert into PNhap values(N'N03', '2019-5-17', N'NV02')
insert into PNhap values(N'N04', '2019-3-22', N'NV03')
insert into PNhap values(N'N05', '2019-7-7', N'NV01')

insert into Nhap values(N'N01', N'SP02', 10, 17000000)
insert into Nhap values(N'N02', N'SP01', 30,  6000000)
insert into Nhap values(N'N03', N'SP04', 20, 1200000)
insert into Nhap values(N'N04', N'SP01', 10, 6200000)
insert into Nhap values(N'N05', N'SP05', 20, 7000000)

insert into PXuat values(N'X01', '2020-6-14', N'NV02')
insert into PXuat values(N'X02', '2019-3-5', N'NV03')
insert into PXuat values(N'X03', '2019-12-12', N'NV01')
insert into PXuat values(N'X04', '2019-6-2', N'NV02')
insert into PXuat values(N'X05', '2019-5-18', N'NV01')

insert into Xuat values(N'X01', N'SP03', 5)
insert into Xuat values(N'X02', N'SP01', 3)
insert into Xuat values(N'X03', N'SP02', 1)
insert into Xuat values(N'X04', N'SP03', 2)
insert into Xuat values(N'X05', N'SP05', 1)

--A. Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩm
select HangSX.MaHangSX, TenHang, count(*) as N'Số Lượng SP'
from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
group by HangSX.MaHangSX, TenHang

--B. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020.
select SanPham.MaSP, TenSP, sum(SoLuongN * DonGiaN) as N'Tổng Tiền Nhập'
from Nhap inner join SanPham on Nhap.MaSP = SanPham.MaSP
		  inner join PNhap on PNhap.SoHDN = Nhap.SoHDN
where year(NgayNhap) = 2020
group by SanPham.MaSP, TenSP

--C. Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 10.000 sản phẩm của hãng Samsung.
select SanPham.MaSP, TenSP, sum(SoLuongX) as N'Tổng số lượng xuất'
from Xuat inner join SanPham on Xuat.MaSP = SanPham.MaSP
		  inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX
		  inner join PXuat on PXuat.SoHDX = Xuat.SoHDX
where YEAR(NgayXuat) = 2020 and TenHang = N'Samsung'
group by SanPham.MaSP, TenSP
having SUM(SoLuongX) >= 10000

--D. Thống Kê Số Lượng Nhân Viên Nam Mỗi Phòng Ban
select MaNV, TenNV, TenPhong, COUNT(*) as N'Số Nhân Viên Mỗi Phòng Ban'
from NhanVien
where GioiTinh = N'Nam'
group by MaNV, TenNV, TenPhong

--E. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
select TenHang, SUM(SoLuongN) as N'Tổng Số Lượng Nhâp'
from PNhap inner join Nhap on Nhap.SoHDN = PNhap.SoHDN
		   inner join SanPham on SanPham.MaSP = Nhap.MaSP
		   inner join HangSX on HangSX.MaHangSX = SanPham.MaHangSX
where YEAR(NgayNhap) = 2018
group by TenHang

--F. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu.
select MaNV, sum(SoLuongX * GiaBan) as N'Tổng Lượng Tiền Xuất'
from PXuat inner join Xuat on PXuat.SoHDX = Xuat.SoHDX
		   inner join SanPham on Xuat.MaSP = SanPham.MaSP
where YEAR(NgayXuat) = 2018
group by MaNV

--G. Hãy Đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 8 – năm 2018 có tổng giá trị lớn hơn 100.000
select MaNV, sum(SoLuongN * GiaBan) as N'Tổng Lượng Tiền Nhập'
from PNhap inner join Nhap on PNhap.SoHDN = Nhap.SoHDN
			inner join SanPham on Nhap.MaSP = SanPham.MaSP
where YEAR(NgayNhap) = 2018 and MONTH(NgayNhap) = 8
group by MaNV
having sum(SoLuongN * GiaBan) > 100000

--H.Hãy Đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ.
select SanPham.MaSP, TenSP
from SanPham inner join Nhap on SanPham.MaSP = Nhap.MaSP
where SanPham.MaSP not in (select MaSP from Xuat)

--I. Hãy Đưa ra danh sách các sản phẩm đã nhập năm 2020 và đã xuất năm 2020.
select SanPham.MaSP, TenSP
from SanPham inner join Nhap on SanPham.MaSP = Nhap.MaSP
			inner join PNhap on Nhap.SoHDN = PNhap.SoHDN
where YEAR(NgayNhap) = 2020 and SanPham.MaSP in (select SanPham.MaSP 
													from SanPham inner join Xuat on SanPham.MaSP = Nhap.MaSP
																 inner join PXuat on Xuat.SoHDX = PXuat.SoHDX
													where YEAR(NgayXuat) = 2020)
--J. Hãy Đưa ra danh sách các nhân viên vừa nhập vừa xuất
select distinct PNhap.MaNV, TenNV
from PNhap inner join NhanVien on PNhap.MaNV = NhanVien.MaNV
where PNhap.MaNV in (select MaNV from PXuat)

--K. Hãy Đưa ra danh sách các nhân viên không tham gia việc nhập và xuất
select distinct MaNV
from NhanVien
where MaNV not in (select PNhap.MaNV
					from PNhap inner join NhanVien on PNhap.MaNV = NhanVien.MaNV
					where PNhap.MaNV in (select MaNV from PXuat))
