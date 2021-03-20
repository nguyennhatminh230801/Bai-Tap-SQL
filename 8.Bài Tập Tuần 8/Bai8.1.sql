use master
go

create database QLTruongHoc
on primary(
	name = QLTruongHoc_DB,
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 8\QLTruongHoc_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = QLTruongHoc_Log,
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 8\QLTruongHoc_Log.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

use QLTruongHoc
go
create table Khoa(
	Makhoa nvarchar(10) primary key not null,
	Tenkhoa nvarchar(50) not null,
	Dienthoai nvarchar(20)
)
go

create table Lop(
	Malop nvarchar(10) primary key not null,
	Tenlop nvarchar(50) not null,
	Khoa nvarchar(20),
	Hedt nvarchar(20),
	Namnhaphoc int,
	Makhoa nvarchar(10),

	constraint FK_Makhoa foreign key(Makhoa) references Khoa(Makhoa)
)
go

--Bài tập 1, Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến:
--makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa,
--nếu đã tồn tại đưa ra thông báo, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2
--trường hợp

create procedure Baitap1(@Makhoa nvarchar(10), 
						 @Tenkhoa nvarchar(50), 
						 @Dienthoai nvarchar(20))
as
	begin
		if(exists(select * from Khoa where Tenkhoa = @Tenkhoa))
			begin
				print 'Khoa ' + @Tenkhoa + ' đã tồn tại trong cơ sở dữ liệu'
			end
		else
			begin
				insert into Khoa values(@Makhoa, @Tenkhoa, @Dienthoai)
				print 'Đã thêm ' + @Tenkhoa + ' vào cơ sở dữ liệu'
			end
	end

select * from Khoa
execute Baitap1 N'CNTT', N'Công Nghệ Thông Tin', N'12345678'

--Bài tập 2. Hãy viết thủ tục nhập dữ liệu cho bảng Lop với các tham biến Malop,
--Tenlop, Khoa,Hedt,Namnhaphoc,Makhoa nhập từ bàn phím.
-- Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì thông báo
-- Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì thông báo
-- Nếu đầy đủ thông tin thì cho nhập

create procedure Baitap2(@Malop nvarchar(10), 
						 @Tenlop nvarchar(50), 
						 @Khoa nvarchar(20), 
						 @Hedt nvarchar(20), 
						 @Namnhaphoc int, 
						 @Makhoa nvarchar(10))
as
	begin
		if(exists(select * from Lop where Tenlop = @Tenlop))
			begin
				print 'Lớp ' + @Tenlop + ' đã tồn tại trong bảng Lớp'
			end
		else
			if(not exists(select * from Khoa where Makhoa = @Makhoa))
				begin
					print 'Mã khoa ' + @Makhoa + ' chưa tồn tại trong bảng Khoa'
				end
			else
				begin
					insert into Lop values(@Malop, @Tenlop, @Khoa, @Hedt, @Namnhaphoc, @Makhoa)
					print 'Thêm mới thành công'
				end
	end

select * from Lop
select * from Khoa
execute Baitap2 N'KTPM1', N'Kĩ thuật phần mềm 1', N'K14', N'Đại Học', 2019, N'CNTT'

--Bài tập 3, Viết thủ tục nhập dữ liệu vào bảng KHOA với các tham biến:
--makhoa,tenkhoa, dienthoai, hãy kiểm tra xem tên khoa đã tồn tại trước đó hay chưa,
--nếu đã tồn tại trả về giá trị 0, nếu chưa tồn tại thì nhập vào bảng khoa, test với 2
--trường hợp.

create procedure Baitap3(@Makhoa nvarchar(10), 
                         @Tenkhoa nvarchar(50), 
						 @Dienthoai nvarchar(20),
						 @Ketqua int output)
as
	begin
		if(exists(select * from Khoa where Tenkhoa = @Tenkhoa))
			begin
				set @Ketqua = 0
			end
		else
			begin
				insert into Khoa values(@Makhoa, @Tenkhoa, @Dienthoai)
			end
		return @Ketqua
	end

declare @KQ int
execute Baitap3 N'CNTT1', N'Công Nghệ Thông Tin 2', N'123456789', @KQ output
select @KQ as N'Kết quả'

--Bài tập 4. Hãy viết thủ tục nhập dữ liệu cho bảng lop với các tham biến
--malop,tenlop,khoa,hedt,namnhaphoc,makhoa.
-- Kiểm tra xem tên lớp đã có trước đó chưa nếu có thì trả về 0.
-- Kiểm tra xem makhoa này có trong bảng khoa hay không nếu không có thì tra ve 1.
-- Nếu đầy đủ thông tin thì cho nhập và trả về 2

create procedure Baitap4(@Malop nvarchar(10), 
						 @Tenlop nvarchar(50), 
						 @Khoa nvarchar(20), 
						 @Hedt nvarchar(20), 
						 @Namnhaphoc int, 
						 @Makhoa nvarchar(10),
						 @KQ int output)
as
	begin	
		if(exists(select * from Lop where Tenlop = @Tenlop))
			begin
				set @KQ = 0
			end
		else
			if(not exists(select * from Khoa where Makhoa = @Makhoa))
				begin
					set @KQ = 1
				end
			else
				begin
					insert into Lop values(@Malop, @Tenlop, @Khoa, @Hedt, @Namnhaphoc, @Makhoa)
					set @KQ = 2
				end
		return @KQ
	end

declare @Ketqua int
execute Baitap4 N'KTPM2', N'Kĩ thuật phần mềm 2', N'K14', N'Đại Học', 2019, N'CNTT', @Ketqua output
select @Ketqua as N'Kết quả'