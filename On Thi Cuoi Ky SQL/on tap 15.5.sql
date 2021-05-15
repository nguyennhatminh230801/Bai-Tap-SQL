--Câu 1 (3đ): Tạo csdl QLHANG gồm 3 bảng sau: 
--+ Hang(MaHang,TenHang,DVTinh, SLTon)
--+ HDBan(MaHD,NgayBan,HoTenKhach)
--+ HangBan(MaHD,MaHang,DonGia,SoLuong)
--Nhập dữ liệu cho các bảng: 2 Hang, 2 HDBan và 4 HangBan.

use master
create database QLHANG
use QLHANG

create table Hang(
	MaHang nchar(20) primary key,
	TenHang nvarchar(50),
	DVTinh nvarchar(50),
	SLTon int
)

create table HDBan(
	MaHD nchar(20) primary key,
	NgayBan datetime,
	HoTenKhach nvarchar(50)
)

create table HangBan(
	MaHD nchar(20),
	MaHang nchar(20),
	DonGia money,
	SoLuong int

	constraint PK_MaHD_MaHang primary key(MaHD, MaHang),
	constraint FK_MaHD foreign key(MaHD) references HDBan(MaHD) on update cascade on delete cascade,
	constraint FK_MaHang foreign key(MaHang) references Hang(MaHang) on update cascade on delete cascade
)


insert into Hang values
(N'H01', N'Hàng 1', N'Chiếc', 2000),
(N'H02', N'Hàng 2', N'Chiếc', 2400)

insert into HDBan values
(N'HD01', '2021-5-15', N'Minh'),
(N'HD02', '2021-4-19', N'Linh')

insert into HangBan values
(N'HD01', N'H01', 20000, 100),
(N'HD01', N'H02', 30000, 150),
(N'HD02', N'H01', 40000, 120),
(N'HD02', N'H02', 50000, 110)

select * from Hang
select * from HDBan
select * from HangBan

--Câu 2 (2đ): Hãy tạo View đưa ra 
--mã hóa đơn có tổng tiền bán trên 1 triệu gồm: MaHD,Tổng tiền (tiền=SoLuong*DonGia)

create view Cau2
as
	select MaHD, SUM(SoLuong * DonGia) as N'Tổng Tiền'
	from HangBan
	group by MaHD
	having SUM(SoLuong * DonGia) > 1000000

select * from Cau2

--Câu 3 (2đ): Hãy tạo thủ tục xóa 1 mặt hàng nhập vào từ bàn phím.
create procedure Cau3(@TenHang nvarchar(50))
as
	begin
		delete from Hang where TenHang = @TenHang
	end

execute Cau3 N'Hàng 1'
select * from Hang
select * from HangBan

--Câu 4 (3đ): Hãy tạo trigger khi thêm 1 hóa đơn bán. 
--Nếu ngày bán không là ngày hiện tại thì hiện thông báo

create trigger Cau4
on HDBan
for insert
as	
	begin
		if((select NgayBan from inserted) <> GETDATE())
			begin
				raiserror(N'Ngày Bán Không Đúng Với Ngày Hiện Tại', 16, 1)
				rollback transaction
			end
	end

--TH ko phải ngày hiện tại
insert into HDBan values (N'HD03', '2001-4-19', N'Nam')

--TH đúng
insert into HDBan values (N'HD03', GETDATE(), N'Nam')

