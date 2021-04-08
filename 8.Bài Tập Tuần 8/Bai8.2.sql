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
	TenCv nvarchar(30)
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

--a. Viết thủ tục SP_Them_Nhan_Vien, biết tham biến là MaNV, MaCV,
--TenNV,Ngaysinh,LuongCanBan,NgayCong,PhuCap. Kiểm tra MaCV có tồn tại
--trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho thêm nhân viên
--mới, nếu không thì đưa ra thông báo.

create procedure SP_Them_Nhan_Vien(@MaNV nvarchar(4),
								   @MaCV nvarchar(2),
					               @TenNV nvarchar(30),
	                               @NgaySinh datetime,
	                               @LuongCanBan float,
	                               @NgayCong int,
	                               @PhuCap float)
as
	begin
		if(not exists(select * from Chucvu where MaCV = @MaCV))
			begin
				print N'Mã Chức Vụ ' + @MaCV + ' không tồn tại trong bảng Chức Vụ'
			end
		else
			begin
				insert into Nhanvien values(@MaNV, @MaCV, @TenNV, @NgaySinh, @LuongCanBan, @NgayCong, @PhuCap)
				print N'Thêm mới thành công'
			end
	end

execute SP_Them_Nhan_Vien N'NV06', N'TQ', N'Nguyễn Nhật Minh', '2001-8-23 11:30:00', 5000000, 30, 1000000
select * from Nhanvien

--b. Viết thủ tục SP_CapNhat_Nhan_Vien ( không cập nhật mã), biết tham biến là
--MaNV, MaCV, TenNV, Ngaysinh, LuongCanBan, NgayCong, PhuCap. Kiểm tra
--MaCV có tồn tại trong bảng tblChucVu hay không? nếu thỏa mãn yêu cầu thì cho
--cập nhật, nếu không thì đưa ra thông báo.

create procedure SP_CapNhat_Nhan_Vien(@MaNV nvarchar(4),
									  @MaCV nvarchar(2),
					                  @TenNV nvarchar(30),
	                                  @NgaySinh datetime,
	                                  @LuongCanBan float,
	                                  @NgayCong int,
	                                  @PhuCap float)
as
	begin
		if(not exists(select * from Chucvu where MaCV = @MaCV))
			begin
				print N'Không tồn tại ' + @MaCV + ' trong bảng Chức vụ'
			end
		else
			begin
				update Nhanvien 
				set MaCV = @MaCV, TenNV = @TenNV, NgaySinh = @NgaySinh, LuongCanBan = @LuongCanBan, NgayCong = @NgayCong, PhuCap = @PhuCap
				where MaNV = @MaNV
				print N'Chỉnh sửa thành công'
			end
	end

execute SP_CapNhat_Nhan_Vien N'NV01', N'GD', N'Nguyễn Văn Mạnh', '2001-10-9 12:00:00', 10000000, 30, 5000000
select * from Nhanvien

--c. Viết thủ tục SP_LuongLN với Luong=LuongCanBan*NgayCong PhuCap, biết thủ tục trả về, không truyền tham biến.

create procedure SP_LuongLN(@ketqua int output)
as
	begin
		if(not exists(select LuongCanBan * NgayCong + PhuCap from Nhanvien))
			begin
				set @ketqua = 0
			end
		else
			begin
				set @ketqua = 1

				declare @trave table(MaNV nchar(10), TienLuong money)
				insert into @trave
				select MaNV, LuongCanBan * NgayCong + PhuCap from Nhanvien

				select * from @trave
			end
		
		return @ketqua
	end

declare @kq int
execute SP_LuongLN @kq output
select @kq as 'Bảng lương Nhân Viên'