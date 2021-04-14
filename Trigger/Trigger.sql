--phần 5: trigger bẫy lỗi
--trigger là 1 thủ tục ko có tham biến, tự kích hoạt khi chạy
--đoạn lệnh kích hoạt nó
--trigger thường được sử dụng trong việc kiểm soát lỗi, các ràng buộc giữa các bảng
-------------------------------------------------

--cú pháp
--create trigger --tên trigger
--on --bảng ràng buộc
--for --insert/--update/--delete
--as
	--begin
		
	--end

----------------------------------------
-- bảng ràng buộc là bảng mà trigger này gắn vào, mỗi thay đổi trên bảng thì trigger tương ứng sẽ được kích hoạt
-----------------------------------------
--1. for insert
-- đây là trigger kiểm soát việc chèn dữ liệu mới vào bảng nó kiểm soát
--trước khi insert thành công --> trigger insert sẽ được kích hoạt và kiểm soát việc insert vào bảng kiểm soát
--khi đó sẽ có bảng tạm được sinh ra là "inserted", bảng tạm này có cấu trúc tương tự bảng kiểm soát 
--có dữ liệu là dữ liệu chuẩn bị insert

--vd: cho 2 bảng
	-- sanpham(masp, tensp, mausac, soluong, giaban)
	-- hoadon(sohd, masp, soluongban, ngayban)
-----------------------------------------------------
--insert into Hoadon values('HD01', 'SP05', 200, '2020-5-4') --> chưa vào bảng Hoadon --> trigger sẽ được kích hoạt 
--> đưa vào inserted(bảng lưu dữ liệu tạm của câu insert)

--inserted(sohd, masp, soluongban, ngayban)
--inserted('HD01', 'SP05', 200, '2020-5-4')

--VD1 viết 1 trigger kiểm soát việc viết hoadon bán hàng, hãy kiểm tra xem
--MaSP có trong bảng sản phẩm hay không? nếu không thì thông báo, ngược lại
--xem SoLuongBan có đủ hàng hay không? nếu không thì TB, ngược lại cho viết
--Hoadon va cập nhât lại soluong trong bảng SanPham

create trigger VD1_insertHoaDon
on Hoadon
for insert
as
	begin
		declare @MaSP nchar(10)
		set @MaSP = (select MaSP from inserted)

		if(not exists(select * from SanPham where MaSP = @MaSP))
			begin
				raiserror(N'Không có SP này', 16, 1)
				rollback transaction --khôi phục trạng thái ban đấu
			end
		else
			begin
				declare @SoLuongCo int
				declare @SoLuongBan int
				
				set @SoLuongCo = (select SoLuong from SanPham where MaSP = @MaSP)
				set @SoLuongBan = (select SoLuongBan from inserted)

				if(@SoLuongCo < @SoLuongBan)
					begin
						raiserror(N'Không đủ hàng', 16, 1)
						rollback transaction
					end
				else
					begin
						--đã insert được bảng Hóa đơn (cho dòng insert chạy)
						update SanPham
						set SoLuong = @SoLuongCo - @SoLuongBan
						where MaSP = @MaSP
					end
			end
	end

--Lưu ý: chỉ có 1 trigger mỗi loại(insert, delete, ..) cho mỗi bảng

select * from Hoadon
select * from SanPham

insert into Hoadon values('HD04', 'SP02', 3, '2020-5-4')
-----------------------------------------------------------------------
--2.for delete:
--trigger này sẽ kiểm soát việc delete dữ liệu trên bảng kiểm soát
--trước khi delete thành công -- sẽ có 1 bảng tạm được sinh ra có tên là deleted
-- bảng tạm này có cấu trúc tương tự bảng kiểm soát, có dữ liệu là dữ liệu chuẩn bị delete

--VD2: viết trigger kiểm soát việc xóa 1 hóa đơn, hãy update lại số lượng trong bảng
--sanpham

create trigger VD2_deleteTrigger
on Hoadon
for delete
as
	begin
		declare @MaSP nchar(10)
		declare @SoLuongBan int

		set @MaSP = (select MaSP from deleted)
		set @SoLuongBan = (select SoLuongBan from deleted)

		--select @MaSP = MaSP, @SoLuongBan = Soluongban from deleted)

		update SanPham
		set SoLuong = SoLuong + @SoLuongBan
		where MaSP = @MaSP
	end

--test
select * from SanPham
select * from Hoadon

delete from Hoadon where sohd = 'HD02'
--3. for update
--trước khi update thành công, sẽ có 2 bảng đc sinh ra là inserted và deleted (không có updated ;)) )
-- 2 bảng tạm có cấu trúc như nhau, tương tự bảng kiểm soát, có dữ liệu

	--deleted: chứa dữ liệu trước khi update
	--inserted: chứa dữ liệu sau khi update
--------------------------------------------------------------
--VD: Viết trigger kiểm soát việc update dữ liệu bảng Hoadon, hãy kiểm tra xem
--soluong cần update có thỏa mãn không? nếu không thì thông báo

--Hóa đơn mua 100 cái, nhưng cần trả lại 30 cái,
--inserted.soluongban = 70
--deleted.soluongban = 100
--sanpham.soluong = sanpham.soluong + 30

--Hóa đơn mua 70 cái nhưng cần mua thêm 50 cái,
--inserted.soluongban = 120
--deleted.soluongban = 70
--sanpham.soluong = sanpham.soluong - 50

--sanpham.soluong = sanpham.soluong - (sau - truoc)

create trigger VD3_UpdateTrigger
on Hoadon
for update
as
	begin
		declare @MaSP nchar(10)
		declare @SoLuongCo int
		declare @SoLuongTruoc int
		declare @SoLuongSau int
		
		set @MaSP = (select MaSP from inserted) --hoặc deleted
		set @SoLuongCo = (select SoLuong from SanPham where MaSP = @MaSP)
		set @SoLuongTruoc = (select SoLuongBan from deleted)
		set @SoLuongSau = (select SoLuongBan from inserted)

		if(@SoLuongCo < (@SoLuongSau - @SoLuongTruoc))
			begin
				raiserror(N'Không đủ hàng', 16, 1)
				rollback transaction
			end
		else
			begin
				update SanPham  set SoLuong = SoLuong - (@SoLuongSau - @SoLuongTruoc)
				where MaSP = @MaSP
			end
	end

--test
select * from SanPham
select * from Hoadon

update Hoadon set SoLuongBan = 8 where SoHD = N'HD04'

