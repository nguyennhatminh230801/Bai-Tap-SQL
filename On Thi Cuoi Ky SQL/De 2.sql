use master

create database QLBenhVien
on primary(
	name = QLBenhVien_DB,
	filename = 'C:\Users\Admin\Desktop\SQL Practice\QLBenhVien_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = QLBenhVien_log,
	filename = 'C:\Users\Admin\Desktop\SQL Practice\QLBenhVien_log.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

use QLBenhVien

create table BenhVien(
	MaBV nchar(20) primary key,
	TenBV nvarchar(50),
	DiaChi nvarchar(100),
	DienThoai nvarchar(15)
)

create table KhoaKham(
	MaKhoa nchar(20) primary key,
	TenKhoa nvarchar(50),
	SoBenhNhan int,
	MaBV nchar(20)

	constraint FK_MaBV foreign key(MaBV) references BenhVien(MaBV)
)

create table BenhNhan(
	MaBN nchar(20) primary key,
	HoTen nvarchar(50),
	NgaySinh date,
	GioiTinh nvarchar(4),
	SoNgayNV int,
	MaKhoa nchar(20)

	constraint FK_MaKhoa foreign key(MaKhoa) references KhoaKham(MaKhoa)
)

insert into BenhVien values(N'BV01', N'Bệnh Viên 1', N'Hà Nội', N'123456778')
insert into BenhVien values(N'BV02', N'Bệnh Viên 2', N'Hà Nội', N'123456778')

insert into KhoaKham values(N'K01', N'Khoa 1', 23, N'BV01')
insert into KhoaKham values(N'K02', N'Khoa 2', 23, N'BV01')

insert into BenhNhan values(N'BN01', N'Nguyễn Văn A', '2021-5-5', N'Nữ', 5, N'K01')
insert into BenhNhan values(N'BN02', N'Nguyễn Văn B', '2021-5-5', N'Nữ', 10, N'K02')
insert into BenhNhan values(N'BN03', N'Nguyễn Văn C', '2021-5-5', N'Nữ', 20, N'K01')
insert into BenhNhan values(N'BN04', N'Nguyễn Văn D', '2021-5-5', N'Nam', 15, N'K02')
insert into BenhNhan values(N'BN05', N'Nguyễn Văn E', '2021-5-5', N'Nam', 35, N'K01')

select * from BenhVien
select * from KhoaKham
select * from BenhNhan

create view Cau2
as
	select KhoaKham.MaKhoa, TenKhoa, COUNT(*) as N'Số Người Nữ'
	from BenhNhan inner join KhoaKham
	on BenhNhan.MaKhoa = KhoaKham.MaKhoa
	where GioiTinh = N'Nữ'
	group by KhoaKham.MaKhoa, TenKhoa
	
select * from Cau2

create function Cau3(@TenKhoa nvarchar(50))
returns money
as
	begin
		declare @ketqua money
		set @ketqua = (select SUM(SoNgayNV * 60000)
					   from BenhNhan inner join KhoaKham
					   on BenhNhan.MaKhoa = KhoaKham.MaKhoa
					   where TenKhoa = @TenKhoa)
		return @ketqua
	end

select dbo.Cau3(N'Khoa 1') as N'Tổng Tiền'

create trigger Cau4
on BenhNhan
for insert
as
	begin
		if((select SoBenhNhan
			from KhoaKham inner join inserted
			on inserted.MaKhoa = KhoaKham.MaKhoa) > 50)
			begin
				raiserror(N'Số Lượng Bệnh Nhân Của Khoa Đã Đạt Mức Tối Đa(50 người)!Không Thể Thêm Vào', 16, 1)
				rollback transaction
			end
		else
			begin
				update KhoaKham
				set SoBenhNhan = SoBenhNhan + 1
				from KhoaKham inner join inserted
				on KhoaKham.MaKhoa = inserted.MaKhoa
			end
	end

select * from KhoaKham
select * from BenhNhan

insert into BenhNhan values(N'BN06', N'Nguyễn Văn F', '2021-5-5', N'Nam', 40, N'K01')