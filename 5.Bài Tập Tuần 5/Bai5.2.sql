use master
go

create database QLSV
on primary(
	name = 'QLSV_DB',
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 5\QLSV_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = 'QLSV_log',
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 5\QLSV_log.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

use QLSV
create table Lop(
	MaLop nchar(10) primary key not null,
	TenLop nvarchar(20) not null,
	Phong nchar(10)
)

create table SV(
	MaSV nchar(10) primary key not null,
	TenSV nvarchar(30) not null,
	MaLop nchar(10) not null

	constraint FK_MaLop foreign key(MaLop) references Lop(MaLop)
)


insert into Lop values(N'1', N'CĐ', N'1')
insert into Lop values(N'2', N'ĐH', N'2')
insert into Lop values(N'3', N'LT', N'2')
insert into Lop values(N'4', N'CH', N'4')

insert into SV values(N'1', N'A', N'1')
insert into SV values(N'2', N'B', N'2')
insert into SV values(N'3', N'C', N'1')
insert into SV values(N'4', N'D', N'3')

--1. Viết hàm thống kê xem mỗi lớp có bao nhiêu sinh viên với malop là tham số truyền vào từ bàn phím.
create function ThongKe(@MaLop nchar(10))
returns int
as
begin
		declare @Soluong int
		set @Soluong = (select COUNT(SV.MaSV) 
						from SV inner join Lop 
						on SV.MaLop = Lop.MaLop 
						where Lop.MaLop = @MaLop 
						group by Lop.TenLop)
		return @Soluong
end

select dbo.ThongKe(N'1') as 'Số Lượng Sinh Viên'

--2. Đưa ra danh sách sinh viên(masv,tensv) học lớp với tenlop được truyền vào từ bàn phím.
create function DSSV(@Tenlop nvarchar(30))
returns @BangDSSV table(MaSV nchar(10), TenSV nvarchar(30))
as
	begin 
		insert into @BangDSSV 
		select MaSV, TenSV 
		from SV inner join Lop 
		on SV.MaLop = Lop.MaLop 
		where Lop.TenLop = @Tenlop
		return
	end

select * from dbo.DSSV(N'ĐH')

--3. Đưa ra hàm thống kê sinhvien: malop,tenlop,soluong sinh viên trong lớp, với tên lớp
--được nhập từ bàn phím. Nếu lớp đó chưa tồn tại thì thống kê tất cả các lớp, ngược lại nếu
--lớp đó đã tồn tại thì chỉ thống kê mỗi lớp đó.

create function Cau3(@Tenlop nvarchar(30))
returns @ThongKeSV table(MaLop nchar(10), TenLop nvarchar(20), Soluong int)
as
	begin
		if(not exists(select MaLop from Lop where TenLop = @Tenlop))
			insert into @ThongKeSV 
			select Lop.MaLop, Lop.TenLop, count(SV.MaSV) 
			from Lop inner join SV on Lop.MaLop = SV.MaLop 
			group by Lop.MaLop, Lop.TenLop
		else
			insert into @ThongKeSV 
			select Lop.MaLop, TenLop, count(SV.MaSV) 
			from Lop inner join SV 
			on Lop.MaLop = SV.MaLop 
			where Lop.TenLop = @TenLop 
			group by Lop.MaLop, Lop.TenLop
			return
	end

select * from dbo.Cau3(N'ĐH')

--4. Đưa ra phòng học của tên sinh viên nhập từ bàn phím.
create function Cau4(@Tensv nvarchar(30))
returns nvarchar(30)
as
	begin
		declare @PhongHoc nvarchar(30)
		set @PhongHoc = (select Phong 
						 from Lop inner join SV
						 on Lop.MaLop = SV.MaLop
						 where TenSV = @Tensv)
		return @PhongHoc
	end

select dbo.Cau4(N'A') as N'Phòng Học'

--5. Đưa ra thống kê masv,tensv, tenlop với tham biến nhập từ bàn phím là phòng. Nếu phòng
--không tồn tại thì đưa ra tất cả các sinh viên và các phòng. Neu phòng tồn tại thì đưa ra các
--sinh vien của các lớp học phòng đó (Nhiều lớp học cùng phòng).

create function Cau5(@phong nchar(10))
returns @ThongKeSinhVien table(MaSV nchar(10), TenSV nvarchar(30), TenLop nvarchar(30))
as
	begin
		if(not exists(select Phong from Lop where Phong = @phong))
			insert into @ThongKeSinhVien
			select SV.MaSV, SV.TenSV, Lop.TenLop
			from SV inner join Lop
			on SV.MaLop = Lop.MaLop
		else
			insert into @ThongKeSinhVien
			select SV.MaSV, SV.TenSV, Lop.TenLop
			from SV inner join Lop
			on SV.MaLop = Lop.MaLop
			where Phong = @phong
			return
	end

select * from dbo.Cau5(N'3')

--6. Viết hàm thống kê xem mỗi phòng có bao nhiêu lớp học. Nếu phòng không tồn tại trả về giá trị 0.
create function Cau6(@phong nvarchar(30))
returns int
as
	begin
		declare @Soluong int
		if(not exists(select Phong from Lop where Phong = @phong))
			set @Soluong = 0
		else
			set @Soluong = (select count(*) 
							from SV inner join Lop
							on SV.MaLop = Lop.MaLop
							where Phong = @phong
							group by Lop.MaLop)
			return @Soluong
	end

--drop function Cau6
select dbo.Cau6(N'1') as N'Số lớp học'