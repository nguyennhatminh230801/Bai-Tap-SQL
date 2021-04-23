use master

create database QLBanHang

use QLBanHang

create table Hang(
	MaHang nchar(10) primary key,
	TenHang nvarchar(30),
	SoLuong int,
	GiaBan money
)

create table HoaDon(
	MaHD nchar(10) primary key,
	MaHang nchar(10),
	SoLuongBan int,
	NgayBan date

	constraint FK_MaHang foreign key(MaHang) references Hang(MaHang)
)

insert into Hang values(N'H01', N'Ti Vi', 200, 5000000)
insert into Hang values(N'H02', N'Tủ Lạnh', 200, 5000000)
insert into Hang values(N'H03', N'Điều Hòa', 200, 5000000)
insert into Hang values(N'H04', N'Bình Nóng Lạnh', 200, 5000000)
insert into Hang values(N'H05', N'Máy Giặt', 200, 5000000)


--delete from HoaDon
--delete from Hang

--Bài 1. Hãy tạo 1 trigger insert HoaDon, hãy kiểm tra xem mahang cần mua có tồn
--tại trong bảng HANG không, nếu không hãy đưa ra thông báo.
-- Nếu thỏa mãn hãy kiểm tra xem: soluongban <= soluong? Nếu không hãy
--đưa ra thông báo.
-- Ngược lại cập nhật lại bảng HANG với: soluong = soluong - soluongban

create trigger insert_Hoadon
on HoaDon
for insert
as
	begin
		if(not exists(select * from Hang inner join inserted on Hang.MaHang = inserted.MaHang))
			begin
				raiserror(N'Không tồn tại trong bảng Hàng',16,1)
				rollback transaction--quay về trạng thái ban đầu
			end
		else
			begin
				declare @SoLuong int = (select SoLuong 
										from Hang inner join inserted 
										on Hang.MaHang = inserted.MaHang)
				declare @SoLuongBan int = (select SoLuongBan from inserted)

				if(@SoLuongBan <= @SoLuong)
					begin
						update Hang
						set Hang.SoLuong = Hang.SoLuong - inserted.SoLuongBan
						from Hang inner join inserted
						on Hang.MaHang = inserted.MaHang
					end
				else
					begin
						raiserror(N'Không đủ Hàng',16,1)
						rollback transaction--quay về trạng thái ban đầu
					end
			end
		end

--test bài 1
select * from Hang
select * from HoaDon

--TH không tồn tại mặt hàng
insert into HoaDon values(N'HD06', N'H06', 300, '2021-4-5')

--TH không đủ số lượng
insert into HoaDon values(N'HD06', N'H05', 300, '2021-4-5')

--TH thông thường
insert into HoaDon values(N'HD06', N'H05', 10, '2021-4-5')

select * from Hang
select * from HoaDon

--Bài 2. Viết trigger kiểm soát việc Delete bảng HOADON, Hãy cập nhật lại soluong
--trong bảng HANG với: SOLUONG =SOLUONG + DELETED.SOLUONGBAN

create trigger Bai2 --nên làm lại bằng cách inner join để với trường hợp nhiều hóa đơn
on HoaDon
for delete
as
	begin
		update Hang
		set SoLuong = SoLuong + deleted.SoLuongBan 
		from Hang inner join deleted
		on Hang.MaHang = deleted.MaHang
	end

--TH test bài 2
select * from Hang
select * from HoaDon

delete from HoaDon where MaHD = N'HD06'

select * from HoaDon
select * from Hang

--Bài 3. Hãy viết trigger kiểm soát việc Update bảng HOADON. Khi đó hãy update
--lại soluong trong bảng HANG.

--note:
--+) deleted: data trước update
--+) inserted: data sau update

create trigger Bai3
on HoaDon
for update
as
	begin
		declare @SoLuongTruoc int
		declare @SoLuongSau int

		set @SoLuongTruoc = (select SoLuongBan from deleted)
		set @SoLuongSau = (select SoLuongBan from inserted)

		update Hang
		set SoLuong = SoLuong - (@SoLuongSau - @SoLuongTruoc)
		from Hang inner join inserted
		on Hang.MaHang = inserted.MaHang
	end

--test bai 3
select * from Hang
select * from HoaDon

update HoaDon set SoLuongBan = SoLuongBan + 15 where MaHD = 'HD06'

select * from HoaDon