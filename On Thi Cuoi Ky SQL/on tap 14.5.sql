--Câu 1 (3đ): Tạo csdl QLBenhVien gồm 3 bảng: 
--+ BenhVien(MaBV,TenBV)
--+ KhoaKham(MaKhoa, TenKhoa, SoBenhNhan, MaBV)
--+ BenhNhan(MaBN,HoTen,NgaySinh,GioiTinh(bit),SoNgayNV, MaKhoa)
--Nhập dữ liệu cho các bảng: 2 Bệnh viện, 2 KhoaKham, 7 BenhNhan. 
use master
create database QLBenhVien
use QLBenhVien

create table BenhVien(
	MaBV nchar(20) primary key,
	TenBV nvarchar(50)
)

create table KhoaKham(
	MaKhoa nchar(20) primary key,
	TenKhoa nvarchar(50),
	SoBenhNhan int,
	MaBV nchar(20)

	constraint FK_MaBV foreign key(MaBV) references BenhVien(MaBV) on update cascade on delete cascade
)

create table BenhNhan(
	MaBN nchar(20),
	HoTen nvarchar(50),
	NgaySinh date,
	GioiTinh bit,
	SoNgayNV int,
	MaKhoa nchar(20),

	constraint FK_MaKhoa foreign key (MaKhoa) references KhoaKham(MaKhoa) on update cascade on delete cascade
)

insert into BenhVien values
(N'BV01', N'Bệnh Viện 1'),
(N'BV02', N'Bệnh Viện 2')

insert into KhoaKham values
(N'K01', N'Khoa 1', 20, N'BV01'),
(N'K02', N'Khoa 2', 50, N'BV02')

insert into BenhNhan values
(N'BN01', N'Nguyễn Văn A', '2001-8-23', 0, 50, N'K01'),
(N'BN02', N'Nguyễn Văn B', '2001-9-25', 1, 20, N'K01'),
(N'BN03', N'Nguyễn Văn C', '2001-10-2', 0, 30, N'K02'),
(N'BN04', N'Nguyễn Văn D', '2001-9-14', 1, 35, N'K02'),
(N'BN05', N'Nguyễn Văn E', '2001-12-26', 0, 10, N'K01'),
(N'BN06', N'Nguyễn Văn F', '2001-7-21', 1, 5, N'K02'),
(N'BN07', N'Nguyễn Văn G', '2001-4-19', 0, 15, N'K01')

select * from BenhVien
select * from KhoaKham
select * from BenhNhan

delete from BenhNhan
delete from KhoaKham
--Câu 2 (2đ): Hãy tạo View đưa ra thống kê số bệnh nhân Nữ
--của từng khoa khám gồm các thông tin: MaKhoa, TenKhoa, Số_người.
create view Cau2
as
	select KhoaKham.MaKhoa, TenKhoa, COUNT(*) as N'Sô Người'
	from KhoaKham inner join BenhNhan
	on KhoaKham.MaKhoa = BenhNhan.MaKhoa
	where GioiTinh = 0
	group by KhoaKham.MaKhoa, TenKhoa

select * from Cau2
--Câu 3 (2đ): Hãy tạo thủ tục lưu trữ in ra 
--tổng số tiền thu được của từng khoa khám bệnh là bao nhiêu?
--(Với tham số vào là: MaKhoa, Tien=SoNgayNV*80000).
create procedure Cau3(@MaKhoa nchar(20))
as
	begin
		select SUM(SoNgayNV * 80000) as N'Tổng Số Tiền'
		from BenhNhan
		where MaKhoa = @MaKhoa
	end

execute Cau3 N'K01'
--Câu 4 (3đ): Hãy tạo Trigger để tự động tăng số bệnh nhân trong bảng KhoaKham, 
--mỗi khi thêm mới dữ liệu cho bảng BenhNhan. Nếu số bệnh nhân trong 1 khoa khám >100 
--thì không cho thêm và đưa ra cảnh báo

create trigger Cau4
on BenhNhan
for insert
as
	begin
		if((select SoBenhNhan 
			from inserted inner join KhoaKham
			on inserted.MaKhoa = KhoaKham.MaKhoa) > 100)
			begin
				raiserror(N'Khoa đã đầy bệnh nhân', 16, 1)
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

insert into BenhNhan values(N'BN08', null, null, 0, 10, N'K01')

select * from KhoaKham
select * from BenhNhan