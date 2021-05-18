use master

create database QLBanHang

use QLBanHang

create table CongTy(
	MaCongTy nchar(20) primary key,
	TenCongTy nvarchar(50),
	DiaChi nvarchar(100)
)

create table SanPham(
	MaSanPham nchar(20) primary key,
	TenSanPham nvarchar(50),
	SoLuongCo int,
	GiaBan money
)

create table CungUng(
	MaCongTy nchar(20),
	MaSanPham nchar(20),
	SoLuongCungUng int,
	NgayCungUng date,

	constraint PK_MaCT_MaSP primary key(MaCongTy, MaSanPham),
	constraint FK_MaCT foreign key(MaCongTy) references CongTy(MaCongTy) ,
	constraint FK_MaSP foreign key(MaSanPham) references SanPham(MaSanPham)
)

insert into CongTy values
(N'CT01', N'Công Ty 1', N'Thanh Hóa'),
(N'CT02', N'Công Ty 2', N'Hà Nội'),
(N'CT03', N'Công Ty 3', N'Hà Nội')

insert into SanPham values
(N'SP01', N'Sản Phẩm 1', 1000, 500000),
(N'SP02', N'Sản Phẩm 2', 2000, 300000),
(N'SP03', N'Sản Phẩm 3', 1400, 400000)

insert into CungUng values
(N'CT01', N'SP01', 100, '2021-5-18'),
(N'CT02', N'SP01', 120, '2021-5-18'),
(N'CT02', N'SP02', 140, '2021-4-18'),
(N'CT03', N'SP02', 110, '2021-4-18'),
(N'CT03', N'SP03', 190, '2021-4-18')

select * from CongTy
select * from SanPham
select * from CungUng

--Câu 2 : Tạo Hàm Đưa ra TenSP, soluong, giaban
--        Với đầu vào là TenCT, ngaycungung nhập vào từ bàn phím
create function Cau2(@TenCongTy nvarchar(50), @NgayCungUng date)
returns @BangKQ table (TenSP nvarchar(50), 
					   SoLuong int, 
					   GiaBan money)
as
	begin
		insert into @BangKQ
		select TenSanPham, SoLuongCo, GiaBan
		from CongTy inner join CungUng
		on CongTy.MaCongTy = CungUng.MaCongTy
		inner join SanPham
		on SanPham.MaSanPham = CungUng.MaSanPham
		where TenCongTy = @TenCongTy and NgayCungUng = @NgayCungUng
		return
	end

select * from dbo.Cau2(N'Công Ty 1', '2021-5-18')

--Cau3 viết thủ tục thêm mới 1 công ty với MaCT, TenCT, DiaChi nhập từ bàn phím
-- nếu tenCT đã tồn tại thì trả về 1, ngược lại trả về 0 và cho phép thêm mới

create procedure Cau3(@MaCongTy nchar(20),
				      @TenCongTy nvarchar(50),
					  @DiaChi nvarchar(100),
					  @KetQua int output)
as
	begin
		if(exists(select * from CongTy where TenCongTy = @TenCongTy))
			begin
				set @KetQua = 1
			end
		else
			begin
				set @KetQua = 0
				insert into CongTy values(@MaCongTy, @TenCongTy, @DiaChi)
			end
	end

--test
declare @answer int
execute Cau3 N'CT04', N'Công Ty 4', N'Thanh Hóa', @answer output
select @answer as N'Kết Qủa'

-- câu 4 : tạo trigger update trên bảng cung ứng cập nhật lại số lượng cung ứng,
--         kiểm tra số lượng cung ứng mới - số lượng cung ứng cũ <= số lượng có hay không,
--		   thỏa mãn thì cập nhật không thì đưa ra thông báo

alter trigger Cau4
on CungUng
for update
as
	begin
		declare @MaSP nchar(20) = (select MaSanPham from inserted)
		declare @SoLuongMoi int = (select SoLuongCungUng from inserted)
		declare @SoLuongCu int = (select SoLuongCungUng from deleted)
		declare @SoLuongCo int = (select SoLuongCo from SanPham where MaSanPham = @MaSP)
		
		if((@SoLuongMoi - @SoLuongCu) <= @SoLuongCo)
			begin
				update SanPham
				set SoLuongCo = SoLuongCo - (@SoLuongMoi - @SoLuongCu)
				where MaSanPham = @MaSP
			end
		else
			begin
				raiserror(N'Không Đủ Hàng', 16, 1)
				rollback transaction
			end
	end

--TEST CAU 4
select * from SanPham
select * from CungUng

update CungUng 
set SoLuongCungUng = SoLuongCungUng + 80
where MaCongTy = N'CT02' and MaSanPham = N'SP01'

select * from SanPham
select * from CungUng