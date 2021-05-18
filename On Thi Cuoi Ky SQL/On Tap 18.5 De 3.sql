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
	constraint FK_MaKhoa foreign key(MaKhoa) references Khoa(MaKhoa) on update cascade on delete cascade
)

create table SinhVien(
	MaSV nchar(20) primary key,
	HoTen nvarchar(50),
	NgaySinh date,
	GioiTinh bit,
	MaLop nchar(20)

	constraint FK_MaLop foreign key(MaLop) references Lop(MaLop) on update cascade on delete cascade
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

create function Cau2(@TenKhoa nvarchar(50))
returns @BangKQ table(MaLop nchar(20),
					 TenLop nvarchar(50),
					 SiSo int)
as
	begin
		insert into @BangKQ
		select MaLop, TenLop, SiSo
		from Khoa inner join Lop
		on Khoa.MaKhoa = Lop.MaKhoa
		where TenKhoa = @TenKhoa
		return
	end

select * from dbo.Cau2(N'Khoa 1')

create procedure Cau3(@MaSV nchar(20),
					  @HoTen nvarchar(50),
					  @NgaySinh date,
					  @GioiTinh bit,
					  @TenLop nvarchar(50))
as
	begin
		if(not exists(select * from Lop where TenLop = @TenLop))
			begin
				print N'Chưa Tồn Tại ' + @TenLop + ' trong CSDL'
			end
		else
			begin
				declare @MaLop nchar(20) = (select MaLop from Lop where TenLop = @TenLop)
				insert into SinhVien values(@MaSV, @HoTen, @NgaySinh, @GioiTinh, @MaLop)
			end
	end

--test
execute Cau3 N'SV08', N'Sinh Viên 8', '2001-6-1', 0, N'Lớp 1'
select * from SinhVien

create trigger Cau4
on SinhVien
for update
as
	begin
		declare @SiSoLopDen int = (
			select SiSo
			from Lop inner join inserted
			on Lop.MaLop = inserted.MaLop
		)

		if(@SiSoLopDen >= 80)
			begin
				raiserror(N'Lớp Chuyển Đến Đã Đầy! Vui Lòng Chọn Lớp Khác', 16, 1)
				rollback transaction
			end
		else
			begin
				if(exists(select * from Lop inner join inserted on Lop.MaLop = inserted.MaLop))--Kiểm tra mã lớp đến
					begin
						if(not exists(select * from inserted inner join deleted on inserted.MaLop = deleted.MaLop))
							begin
								update Lop
								set SiSo = SiSo + 1
								from Lop inner join inserted
								on Lop.MaLop = inserted.MaLop

								update Lop
								set SiSo = SiSo - 1
								from Lop inner join deleted
								on Lop.MaLop = deleted.MaLop
							end
					end
				else
					begin
						raiserror(N'Không tồn tại lớp chuyển đến', 16, 1)
						rollback transaction
					end
			end
	end

--test
select * from SinhVien
select * from Lop

update SinhVien set MaLop = N'L01' where MaSV = N'SV02'
select * from SinhVien
select * from Lop