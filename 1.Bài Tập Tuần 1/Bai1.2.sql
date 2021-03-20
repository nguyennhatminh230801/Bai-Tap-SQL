use master
go

create database DeptEmp
on primary(
	name = DeptEmp_DB,
	filename = 'D:\BaiTapHeQuanTriCSDL\Bai1\Bai1.2\DeptEmp_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = DeptEmp_Log,
	filename = 'D:\BaiTapHeQuanTriCSDL\Bai1\Bai1.2\DeptEmp_Log.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

go

use DeptEmp
go

create table Department(
	DepartmentNo Integer primary key,
	DepartmentName char(25) not null,
	location char(25) not null
)

--drop table Department
create table Employee(
	EmpNo Integer primary key,
	Fname  varchar(15) not null,
	Lname varchar(15) not null,
	Job varchar(25) not null,
	HireDate Datetime not null,
	Salary numeric not null,
	Commision numeric null,
	DepartmentNo Integer not null,
	
	constraint FK_DepartmentNo foreign key(DepartmentNo) references Department(DepartmentNo)
)

--drop table Employee
go

insert into Department values(10, 'Accounting', 'Melbourne')
insert into Department values(20, 'Research', 'Adealide')
insert into Department values(30, 'Sales', 'Sydney')
insert into Department values(40, 'Operations', 'Perth')

--select * from Department
insert into Employee values(1, 'John', 'Smith', 'Clerk', '1980-12-17', 800, null,20)
insert into Employee values(2, 'Peter', 'Allen', 'Salesman', '1981-2-20', 1600, 300,30)
insert into Employee values(3, 'Kate', 'Ward', 'Salesman', '1981-2-22', 1250, 500,30)
insert into Employee values(4, 'Jack', 'Jones', 'Manager', '1981-4-2', 2975,null,20)
insert into Employee values(5, 'Joe', 'Martin', 'Salesman', '1981-9-28', 1250, 1400,30)

--select * from Employee
