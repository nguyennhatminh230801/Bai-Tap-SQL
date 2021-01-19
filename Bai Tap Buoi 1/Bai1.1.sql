use master
go
create database MarkManagement
  on primary(
	name = Mark_Management_DB,
	filename = 'D:\BaiTapHeQuanTriCSDL\Bai1\MarkManagement_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
  )
  log on(
	name = Mark_Management_Log,
	filename = 'D:\BaiTapHeQuanTriCSDL\Bai1\MarkManagement_Log.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
 )
 
go

use MarkManagement
go
 
create table Students(
	StudentID nvarchar(12) primary key,
	StudentName nvarchar(25) not null,
	DateofBirth datetime not null,
	email nvarchar(40),
	phone nvarchar(12) null,
	class nvarchar(10)
)
 
--drop table Students
go
 
create table Subjects(
	SubjectID nvarchar(10) primary key,
	SubjectName nvarchar(25) not null
)
 
go
 
--drop table Subjects
 
create table Mark(
	StudentID nvarchar(12),
	SubjectID nvarchar(10),
	Date datetime,
	Theory tinyint,
	Practical tinyint
	constraint PK_Mark primary key(StudentID, SubjectID),
	constraint FK_Student foreign key(StudentID) references Students(StudentID),
	constraint FK_Subject foreign key(SubjectID) references Subjects(SubjectID)
)
 
--drop table Mark
go
insert into Students values(N'AV0807005', N'Mail Trung Hiếu', '1989-10-11', N'trunghieu@yahoo.com', N'0904115116', N'AV1')
insert into Students values(N'AV0807006', N'Nguyễn Quý Hùng', '1988-12-2', N'quyhung@yahoo.com', N'0955667787', N'AV2')
insert into Students values(N'AV0807007', N'Đỗ Đắc Huỳnh', '1990-1-2', N'dachuynh@yahoo.com', N'0988574747', N'AV2')
insert into Students values(N'AV0807009', N'An Đăng Khuê',  '1986-3-6', N'dangkhue@yahoo.com', N'0986757463', N'AV1')
insert into Students values(N'AV0807010', N'Nguyễn T. Tuyết Lan', '1989-7-12', N'tuyetlan@gmail.com', N'0983310342', N'AV2')
insert into Students values(N'AV0807011', N'Đinh Phụng Long',  '1990-12-2', N'phunglong@yahoo.com',N'',N'AV1')
insert into Students values(N'AV0807012', N'Nguyễn Tuấn Nam',  '1990-3-2', N'tuannam@yahoo.com',N'',N'AV1')
 
--delete from Students
--select * from Students
go
 
insert into Subjects values(N'S001', N'SQL')
insert into Subjects values(N'S002', N'Java Simplefield')
insert into Subjects values(N'S003', N'Active Server Page')
go
 
--select * from Subjects
insert into Mark values(N'AV0807005', N'S001', '2008-5-6', 8, 25)
insert into Mark values(N'AV0807006', N'S002', '2008-5-6', 16, 30)
insert into Mark values(N'AV0807007', N'S001', '2008-5-6', 10, 25)
insert into Mark values(N'AV0807009', N'S003', '2008-5-6', 7, 13)
insert into Mark values(N'AV0807010', N'S003', '2008-5-6', 9, 16)
insert into Mark values(N'AV0807011', N'S002', '2008-5-6', 8, 30)
insert into Mark values(N'AV0807012', N'S001', '2008-5-6', 7, 31)
insert into Mark values(N'AV0807009', N'S003', '2008-6-6', 11, 20)
insert into Mark values(N'AV0807010', N'S001', '2008-6-6', 7, 6)
go

--delete from Mark
--select * from Mark