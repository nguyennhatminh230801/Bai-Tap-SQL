use master
go

create database QLNV
on primary(
	name = QLNV_DB,
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 8\QLNV_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = QLNV_log,
	filename = 'C:\Users\Admin\Desktop\BTVN Tuan 8\QLNV_log.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

use QLNV
create table Chucvu(
	MaCV nvarchar(2) primary key not null,
	TenCV nvarchar(30)
)

create table Nhanvien(
	MaNV nvarchar(4) primary key not null,
	MaCV nvarchar(2),
	TenNV nvarchar(30),
	NgaySinh datetime,
	LuongCanBan float,
	NgayCong int,
	PhuCap float,

	constraint FK_MaCV foreign key(MaCV) references Chucvu(MaCV)
)

insert into Chucvu values(N'BV', N'Bảo vệ')
insert into Chucvu values(N'GD', N'Giám đốc')
insert into Chucvu values(N'HC', N'Hành Chính')
insert into Chucvu values(N'KT', N'Kế toán')
insert into Chucvu values(N'TQ', N'Thủ Qũy')
insert into Chucvu values(N'VS', N'Vệ Sinh')


insert into Nhanvien values(N'NV01', N'GD', N'Nguyễn Văn An', '1977-12-12 12:00:00', 700000, 25, 500000)
insert into Nhanvien values(N'NV02', N'BV', N'Bùi Văn Tí', '1978-10-10 12:00:00', 400000, 24, 100000)
insert into Nhanvien values(N'NV03', N'KT', N'Trần Thanh Nhật', '1977-9-9 12:00:00', 600000, 26, 400000)
insert into Nhanvien values(N'NV04', N'VS', N'Nguyễn Thị Út', '1980-10-10 12:00:00', 300000, 26, 300000)
insert into Nhanvien values(N'NV05', N'HC', N'Lê Thị Hà', '1979-10-10 12:00:00', 500000, 27, 200000)

--1. Tạo thủ tục có tham số đưa vào là MaNV, MaCV, TenNV, NgaySinh,
--LuongCB, NgayCong, PhucCap. Trước khi chèn một bản ghi mới vào bảng
--NHANVIEN với danh sách giá trị là giá trị của các biến phải kiểm tra xem
--MaCV đã tồn tại bên bảng ChucVu chưa, nếu chưa trả ra 0.

create procedure Cau1( @MaNV nvarchar(4),
					  @MaCV nvarchar(2),
					  @TenNV nvarchar(30),
					  @NgaySinh datetime,
					  @LuongCanBan float,
					  @NgayCong int,
					  @PhuCap float,
					  @ketqua int output)
as
	begin
		if(not exists(select * from Chucvu where MaCV = @MaCV))
			begin
				set @ketqua = 0
			end
		else
			begin
				insert into Nhanvien values(@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap)
			end
		return @ketqua
	end

declare @ketqua int
execute Cau1 N'NV07', N'HC', N'Nguyễn Thành Nam', '2001-9-20 12:00:00', 10000000, 27, 500000, @ketqua output
select @ketqua as N'Kết quả'

select * from Nhanvien

--2. Sửa thủ tục ở câu một kiểm tra xem thêm MaNV được chèn vào có trùng với
--MaNV nào đó có trong bảng không. Nếu MaNV đã tồn tại trả ra 0, nếu MaCV
--chưa tồn tại trả ra 1. Ngược lại cho phép chèn bản ghi.

alter procedure Cau1( @MaNV nvarchar(4),
					  @MaCV nvarchar(2),
					  @TenNV nvarchar(30),
					  @NgaySinh datetime,
					  @LuongCanBan float,
					  @NgayCong int,
					  @PhuCap float,
					  @ketqua int output)
as
	begin
		if(not exists(select * from Chucvu where MaCV = @MaCV))
			begin
				set @ketqua = 1
			end
		else
			if(exists(select * from Nhanvien where MaNV = @MaNV))
				begin
					set @ketqua = 0
				end
			else
				begin
					insert into Nhanvien values(@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap)
				end
		return @ketqua
	end

declare @ketqua int
execute Cau1 N'NV06', N'GD', N'Nguyễn Văn Mạnh', '2001-10-21 12:00:00', 5000000, 27, 500000, @ketqua output
select @ketqua as N'Kết quả'
select * from Nhanvien

--3. Tạo SP cập nhật trường NgaySinh cho các nhân viên (thủ tục có hai tham số
--đầu vào gồm mã nhân viên, Ngaysinh). Nếu không tìm thấy bản ghi cần cập
--nhật trả ra giá trị 0. Ngược lại, cho phép cập nhật.

create procedure Cau3(@MaNV nvarchar(4),
					  @Ngaysinh datetime,
					  @ketqua int output)
as
	begin
		if(not exists(select * from Nhanvien where MaNV = @MaNV))
			begin
				set @ketqua = 0
			end
		else
			begin
				update Nhanvien set Ngaysinh = @Ngaysinh where MaNV = @MaNV
			end
		return @ketqua
	end

declare @answer int
execute Cau3 N'NV06', '2001-4-19 12:30:00', @answer output
select @answer as N'Kết quả'
select * from Nhanvien