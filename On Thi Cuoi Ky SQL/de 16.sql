use master

create database QLSACH

use QLSACH

create table NXB(
	MaNXB nchar(20) primary key,
	TenNXB nvarchar(50)
)

create table TG(
	MaTG nchar(20) primary key,
	TenTG nvarchar(50)
)

create table Sach(
	MaSach nchar(20) primary key,
	TenSach nvarchar(50),
	SLCo int,
	MaTG nchar(20),
	MaNXB nchar(20),
	NgayXB date

	constraint FK_MaTG foreign key(MaTG) references TG(MaTG),
	constraint FK_MaNXB foreign key(MaNXB) references NXB(MaNXB)
)

insert into	NXB values
(N'NXB1', N'Nha� Xu��t Ba�n 1'),
(N'NXB2', N'Nha� Xu��t Ba�n 2')

insert into TG values
(N'TG1', N'Ta�c gia� 1'),
(N'TG2', N'Ta�c gia� 2')

insert into Sach values
(N'S01', N'Sa�ch 1', 1000, N'TG1', N'NXB1', '2021-5-27'),
(N'S02', N'Sa�ch 2', 1100, N'TG1', N'NXB2', '2021-5-27'),
(N'S03', N'Sa�ch 3', 1400, N'TG2', N'NXB1', '2021-5-27'),
(N'S04', N'Sa�ch 4', 1600, N'TG2', N'NXB2', '2021-5-27'),
(N'S05', N'Sa�ch 5', 1900, N'TG1', N'NXB2', '2021-5-27')

select * from Sach
select * from TG
select * from NXB

--cau 2
create view Cau2
as
	select TG.MaTG, TenTG, COUNT(*) as N'S�� sa�ch'
	from TG inner join Sach
	on TG.MaTG = Sach.MaTG
	group by TG.MaTG, TenTG

select * from Cau2

--cau 3
create function Cau3(@MaTG nchar(20))
returns @BangKQ table(MaTG nchar(20),
					  TenTG nvarchar(50),
					  SoSachDaViet int)
as
	begin
		insert into @BangKQ
		select TG.MaTG, TenTG, COUNT(*)
		from TG inner join Sach
		on TG.MaTG = Sach.MaTG
		where TG.MaTG = @MaTG
		group by TG.MaTG, TenTG
		return
	end

select * from dbo.Cau3(N'TG1')

--cau 4
create trigger Cau4
on Sach
for insert
as
	begin
		declare @NgayXB date = (select NgayXB from inserted)
		declare @NgayHienTai date = (select CONVERT(date, GETDATE()))
		
		if(@NgayXB > @NgayHienTai)
			begin
				raiserror(N'Nga�y Xu��t Ba�n Kh�ng Th�� Sau Nga�y Hi��n Ta�i! Y�u C��u Nh��p La�i', 16, 1)
				rollback transaction
			end
	end

select * from Sach

--TH l��i th��i gian
insert into Sach values (N'S06', N'Sa�ch 6', 100, N'TG1', N'NXB1', '2021-8-23')

--TH �u�ng
insert into Sach values (N'S06', N'Sa�ch 6', 100, N'TG1', N'NXB1', '2021-5-27')
select * from Sach