use master

create database QLKHO
on primary(
	name = 'QLKHO_DB',
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 6\QLKHO_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = 'QLKHO_log',
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 6\QLKHO_log.ldf',
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

--Câu 2. đưa ra tên vật tư số lượng tồn nhiều nhất
create view CAU2
as
	select TenVT from Ton 
	where SoLuongT = (select MAX(SoLuongT) from Ton)

select * from CAU2

--Câu 3. đưa ra các vật tư có tổng số lượng xuất lớn hơn 100
create view CAU3
as
	select Ton.MaVT, Ton.TenVT, SUM(SoluongX) as 'Tổng số lượng xuất'
	from Ton inner join Xuat on Ton.MaVT = Xuat.MaVT
	group by Ton.MaVT, Ton.TenVT
	having SUM(SoluongX) >= 100

select * from CAU3

--Câu 4. Tạo view đưa ra tháng xuất, năm xuất, tổng số lượng xuất thống kê theo tháng và năm xuất
create view CAU4
as
	select MONTH(NgayX) as N'Tháng Xuất', YEAR(NgayX) as N'Năm xuất', SUM(SoluongX) as 'Tổng số lượng xuất'
	from Xuat
	group by MONTH(NgayX), YEAR(NgayX)

select * from CAU4

--Câu 5. tạo view đưa ra mã vật tư. tên vật tư. số lượng nhập. số lượng xuất. đơn giá N. đơn giá X. ngày nhập. Ngày xuất.
create view CAU5
as
	select Ton.MaVT, Ton.TenVT, SoluongN, SoluongX, DongiaN, DongiaX, NgayN, NgayX
	from Ton inner join Nhap on Ton.MaVT = Nhap.MaVT
			 inner join Xuat on Ton.MaVT = Xuat.MaVT

select * from CAU5

--Câu 6. Tạo view đưa ra mã vật tư. tên vật tư và tổng số lượng còn lại trong kho. biết còn lại = SoluongN-SoLuongX+SoLuongT theo từng loại Vật tư trong năm 2015
create view CAU6
as
	select Ton.MaVT, Ton.TenVT, SUM(SoluongN) - SUM(SoluongX) + SUM(SoLuongT) as N'Số lượng còn lại trong kho'
	from Ton inner join Nhap on Ton.MaVT = Nhap.MaVT
			 inner join Xuat on Ton.MaVT = Xuat.MaVT
	where YEAR(NgayX) = 2015
	group by Ton.MaVT, Ton.TenVT

select * from CAU6