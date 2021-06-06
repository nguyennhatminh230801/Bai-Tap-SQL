use master

create database QLBanHang

use QLBanHang

create table CongTy(
    MaCongTy nchar(50) primary key,
    TenCongTy nvarchar(100),
    DiaChi nvarchar(500)
)

create table SanPham(
    MaSanPham nchar(50) primary key,
    TenSanPham nvarchar(100),
    SoLuongCo int,
    GiaBan money
)

create table CungUng(
    MaCongTy nchar(50),
    MaSanPham nchar(50) ,
    SoLuongCungUng int,
    NgayCungUng date

    constraint PK_MaCT_MaSP primary key(MaCongTy, MaSanPham),
    constraint FK_MaCT foreign key(MaCongTy) references CongTy(MaCongTy),
    constraint FK_MaSP foreign key(MaSanPham) references SanPham(MaSanPham)
)

insert into CongTy values (N'CT01', N'Công Ty 1', N'Hà Nội')
insert into CongTy values (N'CT02', N'Công Ty 2', N'Thanh Hóa')
insert into CongTy values (N'CT03', N'Công Ty 3', N'Hà Nội')

insert into SanPham values (N'SP01', N'Sản Phẩm 1', 1000, 250000)
insert into SanPham values (N'SP02', N'Sản Phẩm 2', 1200, 260000)
insert into SanPham values (N'SP03', N'Sản Phẩm 3', 1400, 270000)

insert into CungUng values (N'CT01', N'SP01', 2000, '2021-6-6')
insert into CungUng values (N'CT02', N'SP02', 2300, '2021-6-6')
insert into CungUng values (N'CT03', N'SP03', 2200, '2021-6-6')
insert into CungUng values (N'CT01', N'SP02', 2500, '2021-6-6')
insert into CungUng values (N'CT03', N'SP01', 2700, '2021-6-6')

select * from CongTy
select * from SanPham
select * from CungUng

--cau 2
create function Cau2(@TenCongTy nvarchar(100), 
                     @NgayCungUng date)
returns @BangKQ table(TenSanPham nvarchar(100),
                      SoLuongCo int,
                      GiaBan money)
as
    begin
        insert into @BangKQ
        select TenSanPham, SoLuongCo, GiaBan
        from SanPham inner join CungUng
        on SanPham.MaSanPham = CungUng.MaSanPham
        inner join CongTy
        on CongTy.MaCongTy = CungUng.MaCongTy
        where TenCongTy = @TenCongTy and NgayCungUng = @NgayCungUng
        return
    end

--test cau 2
select * from dbo.Cau2(N'Công Ty 1', '2021-6-6')

--Câu 3
create procedure Cau3(@MaCongTy nvarchar(50),
                      @TenCongTy nvarchar(100),
                      @DiaChi nvarchar(500),
                      @KQ int output)
as
    begin
        if(exists( select * from CongTy where TenCongTy = @TenCongTy))
            begin
                set @KQ = 1
            end
        else
            begin
                insert into CongTy values(@MaCongTy, @TenCongTy, @DiaChi)
                set @KQ = 0
            end
    end

--test câu 3
--TH tồn tại Tên CT(kết quả bằng 1)
declare @answer int
execute Cau3 N'CT04', N'Công Ty 1', N'Thanh Hóa', @answer output
select @answer as N'Kết Qủa'

--TH thêm mới (kết quả bằng 0)
declare @answer int
execute Cau3 N'CT04', N'Công Ty 4', N'Thanh Hóa', @answer output
select @answer as N'Kết Qủa'

--Câu 4
create trigger Cau4
on CungUng
for update
as  
    begin
        declare @SoLuongCungUngMoi int
        declare @SoLuongCungUngCu int 
        declare @SoLuongCo int 

        set @SoLuongCungUngMoi = (
            select SoLuongCungUng from inserted
        )

        set @SoLuongCungUngCu = (
            select SoLuongCungUng from deleted
        )

        set @SoLuongCo = (
            select SoLuongCo
            from SanPham inner join inserted
            on SanPham.MaSanPham = inserted.MaSanPham
        )

        if(@SoLuongCungUngMoi - @SoLuongCungUngCu <= @SoLuongCo)
            begin
                update SanPham
                set SoLuongCo = SoLuongCo - (@SoLuongCungUngMoi - @SoLuongCungUngCu)
                from SanPham inner join inserted
                on SanPham.MaSanPham = inserted.MaSanPham
            end
        else 
            begin
                raiserror(N'Không Đủ Số Lượng Để Xuất Mặt Hàng', 16, 1)
                rollback transaction
            end
    end

--test câu 4
--Trước khí chạy
select * from CungUng
select * from SanPham

--test trigger
update CungUng 
set SoLuongCungUng = SoLuongCungUng + 300
where MaCongTy = N'CT03' and MaSanPham = N'SP01'

-- sau khi chạy
select * from CungUng
select * from SanPham
