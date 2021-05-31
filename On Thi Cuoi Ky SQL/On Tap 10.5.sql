--Câu 1 (3đ): Tạo csdl QLHANG gåm 3 bảng sau: 
-- + Hang(MaHang,TenHang,DVTinh, SLTon)
-- + HDBan(MaHD,NgayBan,HoTenKhach)
-- + HangBan(MaHD,MaHang,DonGia,SoLuong)
-- Nhập dữ liệu cho các bảng: 2 Hang, 2 HDBan và 4 HangBan.

use master

create database QLHANG

use QLHANG

create table Hang(
	MaHang nchar(20) primary key,
	TenHang nvarchar(50),
	DVTinh nvarchar(30),
	SLTon int
)

create table HDBan(
	MaHD nchar(20) primary key,
	NgayBan date,
	HoTenKhach nvarchar(50)
)

create table HangBan(
	MaHD nchar(20),
	MaHang nchar(20),
	DonGia money,
	SoLuong int

	constraint PK_MaHD_MaHang primary key(MaHD, MaHang),
	constraint FK_MaHD foreign key(MaHD) references HDBan(MaHD),
	constraint FK_MaHang foreign key(MaHang) references Hang(MaHang)
)

insert into Hang values
(N'H01', N'Hàng 1', N'Chiếc', 200),
(N'H02', N'Hàng 2', N'Chiếc', 200)

insert into HDBan values
(N'HD01', '2021-5-10', N'Nguyễn Nhật Minh'),
(N'HD02', '2021-4-19', N'Linh')

insert into HangBan values
(N'HD01', N'H01', 50000, 20),
(N'HD01', N'H02', 50000, 20),
(N'HD02', N'H01', 50000, 20),
(N'HD02', N'H02', 50000, 20)

select * from Hang
select * from HDBan
select * from HangBan
-- Câu 2 (2đ): Hãy tạo View đưa ra thống kê tiền hàng bán 
---theo từng hóa đơn gồm: MaHD,NgayBan,Tổng tiền (tiền=SoLuong*DonGia)

create view Cau2
as
	select HangBan.MaHD, NgayBan, SUM(SoLuong * DonGia) as N'Tổng Tiền'
	from HangBan inner join HDBan
	on HangBan.MaHD = HDBan.MaHD
	group by HangBan.MaHD, NgayBan

select * from Cau2
-- Câu 3 (2đ): Hãy tạo thủ tục lưu trữ tìm kiếm hàng theo tháng và năm
--(Với 2 tham số vào là: Thang và Nam). 
--Kết quả tìm được sẽ đưa ra một danh sách gồm: MaHang, TenHang, NgayBan, SoLuong, NgayThu.
--Trong đó: Cột NgayThu sẽ là: chủ nhật, thứ hai, ..., thứ bảy (dựa vào giá trị của cột NgayBan)

create procedure Cau3(@Thang int, @Nam int)
as
	begin
		select Hang.MaHang, TenHang, NgayBan, SoLuong, case DATEPART(WEEKDAY, NgayBan)
													   when 1 then N'Chủ Nhật'
													   when 2 then N'Thứ 2'
													   when 3 then N'Thứ 3'
													   when 4 then N'Thứ 4'
													   when 5 then N'Thứ 5'
													   when 6 then N'Thứ 6'
													   when 7 then N'Thứ 7'
													   end as N'Ngày Bán'
		from HangBan inner join HDBan
		on HangBan.MaHD = HDBan.MaHD
		inner join Hang
		on Hang.MaHang = HangBan.MaHang
		where YEAR(NgayBan) = @Nam and MONTH(NgayBan) = @Thang
	end

execute Cau3 5, 2021

--Câu 4 (3đ): Hãy tạo Trigger để tự động giảm số lượng tồn (SLTon) trong bảng Hang, 
--mỗi khi thêm mới dữ liệu cho bảng HangBan. (Đưa ra thông báo lỗi nếu SoLuong>SLTon) 

create trigger Cau4
on HangBan
for insert
as
	begin
		declare @SLTon int = (
			select SLTon
			from Hang inner join inserted
			on Hang.MaHang = inserted.MaHang
		)

		declare @SoLuong int = (
			select SoLuong from inserted
		)

		if(@SoLuong > @SLTon)
			begin
				raiserror(N'Không đủ Số Lượng', 16, 1)
				rollback transaction
			end
		else
			begin
				update Hang
				set SLTon = SLTon - inserted.MaHang
				from Hang inner join inserted
				on Hang.MaHang = inserted.MaHang
			end
	end
