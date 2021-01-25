use master
go
--A. Tạo CSDL có tên DeptEmp
create database DeptEmp
on primary(
	name = DeptEmp_DB,
	filename = 'D:\BaiTapHeQuanTriCSDL\Bai 3\DeptEmp_DB.mdf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)

log on(
	name = DeptEmp_log,
	filename = 'D:\BaiTapHeQuanTriCSDL\Bai 3\DeptEmp_log.ldf',
	size = 10mb,
	maxsize = 100mb,
	filegrowth = 10mb
)


go

use DeptEmp
go
--B. Tạo các bảng dữ liệu sau trong CSDL vừa tạo với các chỉ định ràng buộc tương ứng
create table Department(
	DepartmentNo Integer primary key,
	DepartmentName char(25) not null,
	Location char(25) not null
)

go

create table Employee(
	EmpNo Integer primary key,
	Fname varchar(15) not null,
	Lname varchar(15) not null,
	Job varchar(25) not null,
	Hiredate datetime not null,
	Salary numeric not null,
	Commision numeric,
	DepartmentNo Integer,

	constraint FK_DepartmentNo foreign key(DepartmentNo) references Department(DepartmentNo)
)


--C. Chèn dữ liệu sau đây vào các bảng trên
insert into Department values(10, 'Accounting', 'Melbourne')
insert into Department values(20, 'Research', 'Adealide')
insert into Department values(30, 'Sales' , 'Sydney')
insert into Department values(40, 'Operations', 'Perth')

insert into Employee values(1, 'John' , 'Smith' , 'Clerk' , '1980-12-17', 800 , null , 20)
insert into Employee values(2, 'Peter', 'Allen', 'Salesman', '1981-11-20' , 1600, 300 , 30)
insert into Employee values(3, 'Kate', 'Ward' ,'Salesman', '1981-11-22', 1250 ,500 , 30)
insert into Employee values(4, 'Jack' , 'Jones', 'Manager', '1981-7-2' , 2975 , null, 20)
insert into Employee values(5, 'Joe' , 'Martin' , 'Salesman', '1981-09-28', 1250 , 1400, 30)

--D. Thực hiện các truy vấn sau trên cơ sở dữ liệu trên:

--1. Hiển thị nội dung bảng Department
select * from Department

--2. Hiển thị nội dung bảng Employee
select * from Employee

--3. Hiển thị employee number, employee first name và employee last name từ bảng Employee mà employee first name có tên là ‘Kate’.
select EmpNo, Fname, Lname 
from Employee
where Fname like 'Kate'

--4. Hiển thị ghép 2 trường Fname và Lname thành Full Name, Salary, 10%Salary (tăng 10% so với lương ban đầu).
select Fname + ' ' + Lname as 'Full Name' , Salary, Salary + (10 * Salary / 100) as 'Tăng 10% so với lương ban đầu' 
from Employee

--5. Hiển thị Fname, Lname, HireDate cho tất cả các Employee có HireDate là năm 1981 và sắp xếp theo thứ tự tăng dần của Lname.
select Fname, Lname, Hiredate 
from Employee
where YEAR(Hiredate) = 1981
order by Lname ASC

--6. Hiển thị trung bình(average), lớn nhất (max) và nhỏ nhất(min) của lương(salary) cho từng phòng ban trong bảng Employee.
select AVG(Salary) as 'Trung Bình Lương', MAX(Salary) as 'Lương Lớn Nhất', Min(Salary) as 'Lương Nhỏ Nhất' 
from Employee
group by DepartmentNo

--7. Hiển thị DepartmentNo và số người có trong từng phòng ban có trong bảng Employee.
select DepartmentNo, COUNT(DepartmentNo) as 'Số người' 
from Employee
group by DepartmentNo

--8. Hiển thị DepartmentNo, DepartmentName, FullName (Fname và Lname), Job, Salary trong bảng Department và bảng Employee.
select Department.DepartmentNo, DepartmentName, Fname + ' ' + Lname as 'Full Name', Job, Salary 
from Department inner join Employee
on Department.DepartmentNo = Employee.DepartmentNo

--9. Hiển thị DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Department và bảng Employee.
select Department.DepartmentNo,	DepartmentName, Location , COUNT(*) as 'Số Lượng'
from Employee inner join Department
on Employee.DepartmentNo = Department.DepartmentNo
group by Department.DepartmentNo, DepartmentName, Location 

--10. Hiển thị tất cả DepartmentNo, DepartmentName, Location và số người có trong từng phòng ban của bảng Department và bảng Employee
select Department.DepartmentNo,	DepartmentName, Location , COUNT(*) as 'Số Lượng'
from Employee inner join Department
on Employee.DepartmentNo = Department.DepartmentNo
group by Department.DepartmentNo, DepartmentName, Location