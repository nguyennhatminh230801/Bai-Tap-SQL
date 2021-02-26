use master

create database QLKHO
on primary(
	name = 'QLKHO_DB',
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 5\QLKHO_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = 'QLKHO_log',
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 5\QLKHO_log.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

use QLKHO
create table Ton(
	MaVT nvarchar(10) primary key not null,
	TenVT nvarchar(20) not null,
	SoLuongT int
)

create table Nhap(
	SoHDN nvarchar(10) not null,
	MaVT nvarchar(10) not null,
	SoluongN int,
	DongiaN money,
	NgayN date

	constraint PK_SoHDN_MaVT primary key(SoHDN, MaVT),
	constraint FK_MaVT_Nhap foreign key(MaVT) references Ton(MaVT)
)

create table Xuat(
	SoHDX nvarchar(10) not null,
	MaVT nvarchar(10) not null,
	SoluongX int,
	DongiaX money ,
	NgayX date

	constraint PK_SoHDX_MaVT primary key(SoHDX, MaVT),
	constraint FK_MaVT_Xuat foreign key(MaVT) references Ton(MaVT)
)

insert into Ton values(N'VT01', N'Xi Măng', 100)
insert into Ton values(N'VT02', N'Cốt thép', 200)
insert into Ton values(N'VT03', N'Máy Dập', 120)
insert into Ton values(N'VT04', N'Gương', 50)
insert into Ton values(N'VT05', N'Gạch', 390)

insert into Nhap values(N'N01', 'VT01', 200, 50000, '2021-2-24')
insert into Nhap values(N'N02', 'VT04', 1000, 30000, '2021-2-25')
insert into Nhap values(N'N03', 'VT03', 280, 40000, '2021-8-23')

insert into Xuat values(N'X01', 'VT04', 500, 40000, '2021-3-25')
insert into Xuat values(N'X02', 'VT05', 190, 90000, '2021-8-23')

--Câu 2: Thống kê tiền bán theo mã vật tư gồm MaVT, TenVT, TienBan (TienBan=SoLuongX*DonGiaX)
create view CAU2
as
	select Ton.MaVT,TenVT, SUM(SoluongX * DongiaX) as N'Tiền Bán'
	from Xuat inner join Ton on Xuat.MaVT = Ton.MaVT
	group by Ton.MaVT,TenVT

select * from CAU2

--Câu 3- Thống kê soluongxuat theo tên vattu
create view CAU3
as
	select Ton.MaVT, Ton.TenVT, SUM(SoluongX) as N'Tổng Số Lượng Xuất'
	from Ton inner join Xuat on Ton.MaVT = Xuat.MaVT
	group by Ton.MaVT, Ton.TenVT

select * from CAU3

--Câu 4 - Thống kê soluongnhap theo tên vật tư
create view CAU4
as
	select Ton.MaVT, Ton.TenVT, SUM(SoluongN) as N'Tổng Số Lượng Nhập'
	from Ton inner join Nhap on Ton.MaVT = Nhap.MaVT
	group by Ton.MaVT, Ton.TenVT

select * from CAU4

--Câu 5- Đưa ra tổng soluong còn trong kho biết còn = nhap – xuất + tồn theo từng nhóm vật tư
create view CAU5
as
	select Ton.MaVT, Ton.TenVT, SUM(SoluongN) - SUM(SoluongX) + SUM(SoLuongT) as 'Tổng Số Luọng'
	from Ton inner join Xuat on Ton.MaVT = Xuat.MaVT
			 inner join Nhap on Ton.MaVT = Nhap.MaVT
	group by Ton.MaVT, Ton.TenVT

select * from CAU5