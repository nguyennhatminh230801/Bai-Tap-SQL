use master
create database QLSinhVien
use QLSinhVien

create table Khoa(
	MaKhoa nchar(20) primary key,
	TenKhoa nvarchar(50)
)

create table Lop(
	MaLop nchar(20) primary key,
	TenLop nvarchar(50),
	SiSo int default 0,
	MaKhoa nchar(20)
	constraint FK_MaKhoa foreign key(MaKhoa) references Khoa(MaKhoa)
)

create table SinhVien(
	MaSV nchar(20) primary key,
	HoTen nvarchar(50),
	NgaySinh date,
	GioiTinh bit,
	MaLop nchar(20)

	constraint FK_MaLop foreign key(MaLop) references Lop(MaLop)
)

insert into Khoa values
(N'K01', N'Khoa 1'),
(N'K02', N'Khoa 2')

insert into Lop values
(N'L01', N'Lớp 1', 70, N'K01'),
(N'L02', N'Lớp 2', 70, N'K01')

insert into SinhVien values
(N'SV01', N'Sinh Viên 1', '2001-8-23', 0, N'L01'),
(N'SV02', N'Sinh Viên 2', '2001-9-3', 1, N'L02'),
(N'SV03', N'Sinh Viên 3', '2001-10-21', 1, N'L01'),
(N'SV04', N'Sinh Viên 4', '2001-4-19', 0, N'L02'),
(N'SV05', N'Sinh Viên 5', '2001-12-26', 1, N'L01'),
(N'SV06', N'Sinh Viên 6', '2001-5-1', 0, N'L02'),
(N'SV07', N'Sinh Viên 7', '2001-5-18', 0, N'L01')

select * from Khoa
select * from Lop
select * from SinhVien

--delete from SinhVien
--delete from Lop
--delete from Khoa

create view Cau2
as
	select TenKhoa, COUNT(*) as N'Số Lớp'
	from Khoa inner join Lop
	on Khoa.MaKhoa = Lop.MaKhoa
	group by TenKhoa

select * from Cau2

create function Cau3(@MaKhoa nchar(20))
returns @BangKQ table (MaSV nchar(20),
		              HoTen nvarchar(50),
					  NgaySinh date,
					  GioiTinh nvarchar(5),
					  TenLop nvarchar(50),
					  TenKhoa nvarchar(50))
as
	begin
		insert into @BangKQ
		select MaSV, HoTen, NgaySinh, case GioiTinh
									  when 0 then N'Nữ'
									  else N'Nam'
									  end,
			   TenLop, TenKhoa
		from SinhVien inner join Lop
		on SinhVien.MaLop = Lop.MaLop
		inner join Khoa
		on Lop.MaKhoa = Khoa.MaKhoa
		return
	end

select * from dbo.Cau3(N'K01')

create procedure Cau4(@TuTuoi int, @DenTuoi int, @TenLop nvarchar(50))
as
	begin
		select MaSV, HoTen, NgaySinh, TenLop, TenKhoa, YEAR(GETDATE()) - YEAR(NgaySinh) as N'Tuổi'
		from SinhVien inner join Lop
		on SinhVien.MaLop = Lop.MaLop
		inner join Khoa
		on Lop.MaKhoa = Khoa.MaKhoa
		where TenLop = @TenLop and YEAR(GETDATE()) - YEAR(NgaySinh) between @TuTuoi and @DenTuoi
	end

execute Cau4 20, 23, N'Lớp 1'