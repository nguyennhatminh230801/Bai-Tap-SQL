use master

create database QLHANG

use QLHANG

create table VatTu(
	MaVT nchar(20) primary key,
	TenVT nvarchar(50),
	DVTinh nvarchar(50),
	SLCon int
)

create table HDBan(
	MaHD nchar(20) primary key,
	NgayXuat date,
	HoTenKhach nvarchar(50)
)

create table HangXuat(
	MaHD nchar(20),
	MaVT nchar(20),
	DonGia money,
	SLBan int

	constraint PK_MaVT_MaHD primary key(MaVT, MaHD),
	constraint FK_MaVT foreign key (MaVT) references VatTu(MaVT) on update cascade on delete cascade,
	constraint FK_MaHD foreign key (MaHD) references HDBan(MaHD) on update cascade on delete cascade
)

insert into VatTu values
(N'VT01', N'Vật Tư 1', N'Chiếc', 200),
(N'VT02', N'Vật Tư 2', N'Chiếc', 200)

insert into HDBan values
(N'HD01', '2021-5-13', N'Minh'),
(N'HD02', '2021-4-19', N'Linh')

insert into HangXuat values
(N'HD01', N'VT01', 500000, 200),
(N'HD01', N'VT02', 400000, 200),
(N'HD02', N'VT01', 300000, 200),
(N'HD02', N'VT02', 500000, 200)

select * from VatTu
select * from HDBan
select * from HangXuat

create view Cau2
as
	select top 1 MaHD, SUM(DonGia * SLBan) as N'Tổng Tiền'
	from HangXuat
	group by MaHD
	order by SUM(DonGia * SLBan) desc

select * from Cau2

create function Cau3(@MaHD nchar(20))
returns @BangKQ table(MaHD nchar(20),
					  NgayXuat date,
					  MaVT nchar(20),
					  DonGia money,
					  SLBan int, 
					  NgayThu nvarchar(50))
as
	begin
		insert into @BangKQ
		select HDBan.MaHD, NgayXuat, MaVT, DonGia, SLBan, case DATEPART(WEEKDAY, NgayXuat)
														  when 1 then N'Chủ Nhật'
														  when 2 then N'Thứ 2'
														  when 3 then N'Thứ 3'
														  when 4 then N'Thứ 4'
														  when 5 then N'Thứ 5'
														  when 6 then N'Thứ 6'
														  when 7 then N'Thứ 7'
														  end
		from HangXuat inner join HDBan
		on HangXuat.MaHD = HDBan.MaHD
		where HDBan.MaHD = @MaHD
		return
	end

select * from dbo.Cau3(N'HD01')

create procedure Cau4(@Thang int, @Nam int)
as
	begin
		select SUM(DonGia * SLBan) as N'Tổng Tiền'
		from HangXuat inner join HDBan
		on HangXuat.MaHD = HDBan.MaHD
		where YEAR(NgayXuat) = @Nam and MONTH(NgayXuat) = @Thang
	end

execute Cau4 5, 2021