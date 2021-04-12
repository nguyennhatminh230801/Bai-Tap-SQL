use master

create database QLBH
on primary(
	name = 'QLBH_DB',
	filename = 'C:\Users\Admin\Desktop\Bai Tap Tuan 10\QLBH_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)
log on(
	name = 'QLBH_Log',
	filename = 'C:\Users\Admin\Desktop\Bai Tap Tuan 10\QLBH_LOG.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

use QLBH

create table MatHang(
	MaHang nchar(10) primary key,
	TenHang nvarchar(30),
	SoLuong int
)

create table NhatKyBanHang(
	STT int,
	Ngay datetime,
	NguoiMua nvarchar(30),
	MaHang nchar(10) primary key,
	SoLuong int,
	GiaBan money

	constraint FK_MaHang foreign key(MaHang) references MatHang(MaHang)
)

insert into MatHang values(N'1', N'Keo', 100)
insert into MatHang values(N'2', N'Banh', 200)
insert into MatHang values(N'3', N'Thuoc', 100)

select * from MatHang
select * from NhatKyBanHang

--a. trg_nhatkybanhang_insert. Trigger này có chức năng tự động
--giảm số lượng hàng hiện có (Trong bảng MATHANG) khi một
--mặt hàng nào đó được bán (tức là khi câu lệnh INSERT được thực
--thi trên bảng NHATKYBANHANG).

create trigger trg_nhatkybanhang_insert
on NhatKyBanHang
for insert
as
	begin
		update MatHang
		set MatHang.SoLuong = MatHang.SoLuong - inserted.SoLuong
		from MatHang inner join inserted
		on MatHang.MaHang = inserted.MaHang
	end

--TH test
select * from MatHang
select * from NhatKyBanHang

insert into NhatKyBanHang(ngay, nguoimua, mahang, soluong,
giaban) values('1999-2-9','ab','2',30,50)

select * from MatHang
select * from NhatKyBanHang

--b. trg_nhatkybanhang_update_soluong được kích hoạt khi ta tiến
--hành cập nhật cột SOLUONG cho một bản ghi của bảng
--NHATKYBANHANG (lưu ý là chỉ cập nhật đúng một bản ghi).

create trigger trg_nhatkybanhang_update_soluong
on NhatKyBanHang
for update
as
	begin
		update MatHang
		set MatHang.SoLuong = MatHang.SoLuong - (inserted.SoLuong - deleted.Soluong)
		from deleted inner join inserted
		on deleted.MaHang = inserted.MaHang
		inner join MatHang
		on MatHang.MaHang = inserted.MaHang
	end

--test
select * from MatHang
select * from NhatKyBanHang

update NhatKyBanHang 
set SoLuong = SoLuong + 20
where MaHang = '2'

select * from MatHang
select * from NhatKyBanHang

--c. Trigger dưới đây được kích hoạt khi câu lệnh INSERT được sử dụng
--để bổ sung một bản ghi mới cho bảng NHATKYBANHANG. Trong
--trigger này kiểm tra điều kiện hợp lệ của dữ liệu là số lượng hàng bán
--ra phải nhỏ hơn hoặc bằng số lượng hàng hiện có. Nếu điều kiện này
--không thoả mãn thì huỷ bỏ thao tác bổ sung dữ liệu.

create trigger CauC
on NhatKyBanHang
for insert
as
	begin
		declare @SoLuongBan int
		declare @SoLuongCo int

		set @SoLuongBan = (select SoLuong from inserted)
		set @SoLuongCo = (select MatHang.SoLuong from MatHang inner join inserted on MatHang.MaHang = inserted.MaHang)

		if(@SoLuongBan > @SoLuongCo)
			begin
				raiserror(N'Không đủ số lượng để xuất', 16, 1)
				rollback transaction
			end
		else
			begin
				update MatHang
				set MatHang.SoLuong = MatHang.SoLuong - inserted.SoLuong
				from MatHang inner join inserted
				on MatHang.MaHang = inserted.MaHang
			end
	end

--test cau C
select * from MatHang
select * from NhatKyBanHang

insert into NhatKyBanHang values (2, '2021-4-12', N'Nguyễn Nhật Minh', N'3', 30, 50000)

select * from MatHang
select * from NhatKyBanHang

--d. Trigger dưới đây nhằm để kiểm soát lỗi update bảng
--nhatkybanhang, nếu update >1 bản ghi thì thông báo lỗi(Trigger
--chỉ làm trên 1 bản ghi), quay trở về. Ngược lại thì update lại số
--lượng cho bảng mathang.

create trigger trg_update_onerecord
on NhatKyBanHang
for update
as
	begin
		if((select COUNT(*) from inserted) > 1)
			begin
				raiserror(N'Không sửa quá 1 dòng lệnh', 16, 1)
				rollback transaction
			end
		else
			begin
				update MatHang
				set MatHang.MaHang = MatHang.MaHang - (inserted.SoLuong - deleted.SoLuong)
				from deleted inner join inserted
				on deleted.MaHang = inserted.MaHang
				inner join MatHang
				on MatHang.MaHang = inserted.MaHang
			end
	end
	
--test

select * from MatHang
select * from NhatKyBanHang

update NhatKyBanHang
set SoLuong = SoLuong + 20

select * from MatHang
select * from NhatKyBanHang

--e. Hay tao Trigger xoa 1 ban ghi bang nhatkybanhang, neu xoa nhieu hon
--1 record thi hay thong bao loi xoa ban ghi, nguoc lai hay update bang
--mathang voi cot so luong tang len voi ma hang da xoa o bang
--nhatkybanhang.

create trigger XoaBanGhi
on NhatKyBanHang
for delete
as
	begin
		if((select COUNT(*) from deleted) > 1)
			begin
				raiserror(N'Chỉ được phép xóa 1 bản ghi', 16, 1)
				rollback transaction
			end
		else
			begin
				update MatHang
				set MatHang.SoLuong = MatHang.SoLuong + deleted.SoLuong
				from MatHang inner join deleted
				on MatHang.MaHang = deleted.MaHang
			end
	end

--test

select * from MatHang
select * from NhatKyBanHang

delete from NhatKyBanHang 
where MaHang = '2'

select * from MatHang
select * from NhatKyBanHang

--f. Tạo Trigger cập nhật bảng nhật ký bán hàng, nếu cập nhật nhiều hơn
--1 bản ghi thông báo lỗi và phục hồi phiên giao dịch, ngược lại kiểm
--tra xem nếu giá trị số lượng cập nhật <giá trị số lượng có thì thông báo
--lỗi sai cập nhật, ngược lại nếu nếu giá trị số lượng cập nhật =giá trị số
--lượng có thì thông báo không cần cập nhật ngược lại thì hãy cập nhật
--giá trị.

alter trigger update_nhatkybanhang
on NhatKyBanHang
for update
as
	begin
		if((select COUNT(*) from inserted) > 1)
			begin
				raiserror(N'Chỉ được phép cập nhật 1 bản ghi', 16, 1)
				rollback transaction
			end
		else
			begin
				declare @MaHang nchar(10)
				declare @SoLuongTruoc int
				declare @SoLuongSau int
				declare @SoLuongCo int

				set @MaHang = (select MaHang from inserted)
				set @SoLuongTruoc = (select SoLuong from deleted where MaHang = @MaHang)
				set @SoLuongSau = (select SoLuong from inserted where MaHang = @MaHang)
				set @SoLuongCo = (select SoLuong from MatHang where MaHang = @MaHang)

				if(@SoLuongCo >= (@SoLuongSau - @SoLuongTruoc))
					begin
						update MatHang
						set SoLuong = SoLuong - (@SoLuongSau - @SoLuongTruoc)
						where MaHang = @MaHang
					end
				else
					begin
						raiserror(N'Không đủ số lượng để xuất', 16, 1)
						rollback transaction
					end
			end
	end
select * from MatHang
select * from NhatKyBanHang

update NhatKyBanHang
set SoLuong = SoLuong + 30
where MaHang = '3'
select * from MatHang
select * from NhatKyBanHang