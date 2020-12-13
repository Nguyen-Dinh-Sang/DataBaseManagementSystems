create table PHONGMAY(
	maphong INT IDENTITY(1,1) PRIMARY KEY,
	tenphong NVARCHAR(100),
	tenngql NVARCHAR(100)
)

create table MONHOC(
	mamh INT IDENTITY(1,1) PRIMARY KEY,
	tenmh NVARCHAR(100),
	thoiluong NVARCHAR(100)
)

create table DANGKY(
	maphong INT,
	mamh INT,
	ngaydk DATE default getdate()
)

insert into PHONGMAY(tenphong, tenngql)
values('phong 1', 'quan ly 1')


insert into PHONGMAY(tenphong, tenngql)
values('phong 2', 'quan ly 2')


insert into PHONGMAY(tenphong, tenngql)
values('phong 3', 'quan ly 3')


insert into MONHOC(tenmh, thoiluong)
values('mon hoc 1', 'thoi luong 1')

insert into MONHOC(tenmh, thoiluong)
values('mon hoc 2', 'thoi luong 2')

insert into MONHOC(tenmh, thoiluong)
values('mon hoc 3', 'thoi luong 3')
go

insert into DANGKY(mamh, maphong)
values(1,1)

insert into DANGKY(mamh, maphong)
values(1,2)
insert into DANGKY(mamh, maphong)
values(3,3)
insert into DANGKY(mamh, maphong)
values(3,1)
go

ALTER PROCEDURE sp_KiemTra
@maphong INT, @mamh INT
AS
BEGIN
	--a
	IF EXISTS(
		SELECT 1 
		FROM PHONGMAY AS pm, MONHOC AS mh
		WHERE pm.maphong = @maphong AND mh.mamh = @mamh
	)
		PRINT N'2 Mã hợp lệ'
	ELSE 
		BEGIN
			PRINT N'2 Mã không hợp lệ'
			RETURN 0
		END

	-- b
	IF EXISTS(
		SELECT 1
		FROM DANGKY
		WHERE mamh = @mamh and maphong = @maphong
	)
		BEGIN
			PRINT N'Môn học đã đăng ký phòng máy'
			SELECT mh.tenmh AS	N'Tên môn học', pm.tenphong AS N'Tên phòng máy', dk.ngaydk AS N'Ngày Đăng Ký', pm.tenngql AS N'Tên người quản lý phòng máy'
			FROM PHONGMAY AS pm, MONHOC AS mh, DANGKY AS dk
			WHERE dk.mamh = @mamh and dk.maphong = @maphong and pm.maphong = @maphong and mh.mamh = @mamh
		END
	ELSE
		PRINT N'Môn học có mã ' + cast(@mamh AS varchar(100))
		+ ' không có đăng ký phòng máy có mã ' + cast(@maphong AS varchar(100))
END

execute sp_KiemTra @maphong = 2, @mamh = 3

select *
from DANGKY
go






ALTER TRIGGER trg_Monhoc
ON MONHOC
FOR UPDATE
AS
BEGIN
	IF UPDATE(tenmh)
	BEGIN
		IF EXISTS(
			SELECT 1
			FROM INSERTED AS i, DELETED AS d
			WHERE i.tenmh != d.tenmh AND i.tenmh NOT IN (SELECT tenmh
														 FROM MONHOC											             
														 WHERE mamh != i.mamh) 
		)
			PRINT N'Tên môn học mới hợp lệ'
		ELSE
			BEGIN
				PRINT N'Tên môn học mới không hợp lệ'
				ROLLBACK TRAN
			END
	END
END

update MONHOC set tenmh = 'mon hoc 11'
where mamh = 1

select *
from MONHOC




go
create table NXB(
	maNXB INT IDENTITY(1,1) PRIMARY KEY,
	tenNXB NVARCHAR(100),
	diachi NVARCHAR(100)
)

create table Sach(
	masach INT IDENTITY(1,1) PRIMARY KEY,
	tensach NVARCHAR(100),
	gia NVARCHAR(100),
	maNXB INT,
	namXB NVARCHAR(100)
)

create table TacGia(
	maTG INT IDENTITY(1,1) PRIMARY KEY,
	tenTG NVARCHAR(100),
	dienthoai NVARCHAR(100),
)

create table Sach_TacGia(
	maTG INT,
	masach INT	
)

go

ALTER PROCEDURE sp_KiemTra
@masach INT, @maTG INT
AS
BEGIN
	--a
	IF EXISTS(
		SELECT 1 
		FROM Sach AS s, TacGia AS tg
		WHERE s.masach = @masach AND tg.maTG = @maTG
	)
		PRINT N'2 Mã hợp lệ'
	ELSE 
		BEGIN
			PRINT N'2 Mã không hợp lệ'
			RETURN 0
		END

	-- b
	IF EXISTS(
		SELECT 1
		FROM Sach_TacGia
		WHERE maTG = @maTG and masach = @masach
	)
		BEGIN
			PRINT N'Tác giả đã có sách'
			SELECT tg.tenTG AS	N'Tên tác giả', s.tensach AS N'Tên sách', nxb.tenNXB AS N'Nhà xuất bản', s.namXB AS N'Năm xuất bản'
			FROM TacGia AS tg, Sach AS s, NXB AS nxb, Sach_TacGia AS stg
			WHERE stg.maTG = @maTG and stg.masach = @masach and tg.maTG = @maTG and s.masach = @masach
				and nxb.maNXB = s.maNXB
		END
	ELSE
		PRINT N'Tác giả có mã ' + cast(@maTG AS varchar(100))
		+ ' không có sách có mã ' + cast(@masach AS varchar(100))
END

execute sp_KiemTra @masach = 2, @maTG = 1

insert into NXB(tenNXB, diachi)
values('nha xuat ban 1', 'dia chi 1')

insert into NXB(tenNXB, diachi)
values('nha xuat ban 2', 'dia chi 2')

insert into NXB(tenNXB, diachi)
values('nha xuat ban 3', 'dia chi 3')


go

insert into Sach(tensach, gia, maNXB, namXB)
values('ten sach 1', 'gia 1', 1, '2020')

insert into TacGia(tenTG, dienthoai)
values('tac gia 1', 'dien thoai 1')

insert into TacGia(tenTG, dienthoai)
values('tac gia 2', 'dien thoai 2')


insert into Sach_TacGia(masach, maTG)
values(1, 1)

insert into Sach(tensach, gia, maNXB, namXB)
values('ten sach 2', 'gia 2', 2, '2021')


go

ALTER TRIGGER trg_NhaXBX
ON NXB
AFTER UPDATE
AS
BEGIN
	IF UPDATE(tenNXB)
	BEGIN
		IF EXISTS(
			SELECT 1
			FROM INSERTED AS i, DELETED AS d
			WHERE i.tenNXB != d.tenNXB AND i.tenNXB NOT IN (SELECT tenNXB
														 FROM NXB											             
														 WHERE maNXB != i.maNXB) 
		)
			PRINT N'Tên nhà xuất bản hợp lệ'
		ELSE
			BEGIN
				PRINT N'Tên nhà xuất bản không hợp lệ'
				ROLLBACK TRAN
			END
	END
END

update NXB set tenNXB = 'mon hoc 1A1'
where maNXB = 1

SELECT *
FROM NXB