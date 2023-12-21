-- STEP 1 : CREATE DATABASE
create database QLDA

use QLDA
go

-- STEP 2 : CREATE TABLE
create table PHONGBAN(
    MAPB int constraint pk_MAPB primary key,
    TENPB varchar(10) unique,
    TRPHONG char(9),
    NGNHANCHUC datetime default(getdate())
)

create table NHANVIEN(
    MANV char(9) constraint pk_MANV primary key,
    HONV varchar(15) not null,
    TENDEM varchar(15) not null,
    TEN varchar(15) not null,
    NGSINH datetime default(getdate()),
    DIACHI varchar(50),
    GTINH char(3) check ( GTINH in ('Nam','Nu')),
    LUONG int not null,
    MAGSAT char(9) constraint fk_MAGSAT foreign key (MAGSAT) references NHANVIEN(MANV),
    PHONG int constraint fk_PHONG foreign key (PHONG) references PHONGBAN(MAPB)
)

create table DUAN(
    MADA int constraint pk_MADA primary key,
    TENDA varchar(15) not null,
    DIADIEM varchar(15),
    PHONGQL int constraint fk_PHONGQL foreign key (PHONGQL) references PHONGBAN(MAPB)
)

create table PHANCONG(
    MANV char(9) constraint fk_MANV_PHANCONG foreign key (MANV) references NHANVIEN(MANV),
    MADA int constraint fk_MADA foreign key (MADA) references DUAN(MADA),
    SOGIO decimal(3,1) not null
)

create table THANNHAN(
    MANV char(9),
    TENTN char(15) not null,
    GTINH char(3) check (GTINH in ('Nam','Nu')),
    NGSINH datetime default(getdate()),
    QUANHE varchar(10) not null,
    constraint pk_MANV_TENTN primary key (MANV,TENTN),
    constraint fk_MANV_THANNHAN foreign key (MANV) references NHANVIEN(MANV)
)

create table DIADIEM_PHONG(
    MAPB int,
    DIADIEM varchar(15),
    constraint pk_MAPB_DIADIEM primary key (MAPB,DIADIEM),
    constraint fk_MAPB_DDP foreign key (MAPB) references PHONGBAN(MAPB)
)

-- STEP 3 : MODIFY THE DATABASE
alter table PHONGBAN
add NAMTL int

alter table PHONGBAN
alter column NAMTL smallint

exec sp_rename 'PHONGBAN.NAMTL','NAMTHANHLAP'

alter table PHONGBAN
add constraint PB_NAMTL_CK check(NAMTHANHLAP >= 1990)

alter table PHONGBAN
drop PB_NAMTL_CK

alter table PHONGBAN
drop column NAMTHANHLAP

-- STEP 4 : insert, delete
insert into PHONGBAN
values
('5','Nghien cuu',NULL,'06/22/1988'),
('4','Hanh chinh',NULL,'01/01/1995') ,
('1','Giam doc',NULL,'06/19/1981')

select * from PHONGBAN

insert into NHANVIEN
values
('888665555', 'Le','Van','Bo', '11/10/1937','45 Ho Van Hue, Phu Nhuan, TPHCM', 'Nam',
55000,NULL,1 ),
('333445555', 'Phan','Van','Nghia', '12/08/1955','63 Tran Huy Lieu, Phu Nhuan, TPHCM',
'Nam', 40000,'888665555',5 ),
('123456789', 'Nguyen','Bao','Hung', '01/09/1965','73 Phan Dang Luu, Phu Nhuan, TPHCM',
'Nam', 30000,'333445555',5 ),
('666884444', 'Tran','Van','Nam', '09/15/1962','97 Dien Bien Phu, Binh Thanh, TPHCM',
'Nam', 38000,'333445555',5 ),
('453453453', 'Hoang','Kim','Yen', '07/31/1972','56 Thich Quang Duc, Phu Nhuan, TPHCM',
'Nu', 25000,'333445555',5 ),
('987654321', 'Du','Thi','Hau', '06/20/1941','29 Bach Dang, Tan Binh, TPHCM', 'Nu',
43000,'888665555',4 ),
('999887777', 'Au','Thi','Vuong', '01/19/1968','32 Cao Ba Nha, Q1, TPHCM', 'Nu',
25000,'987654321',4 ),
('987987987', 'Nguyen','Van','Giap', '03/29/1969','98 Huynh Van Banh, Phu Nhuan,
TPHCM', 'Nam', 25000,'987654321',4 ) 

SELECT * FROM NHANVIEN

insert into DIADIEM_PHONG
values
(1, 'Phu Nhuan'),
(4, 'Go Vap'),
(5, 'Tan Binh'),
(5, 'Phu Nhuan'),
(5, 'Thu Duc')

select * from DIADIEM_PHONG

insert into DUAN
values
(1,'San pham X', 'Tan Binh', 5),
(2,'San pham y', 'Thu Duc', 5),
(3,'San pham Z', 'Phu Nhuan', 5),
(10,'Tin hoc hoa', 'Go Vap', 4),
(20,'Tai to chuc', 'Phu Nhuan', 1),
(30,'Phuc Loi', 'Go Vap', 4)

select * from DUAN

alter table PHANCONG
alter column SOGIO decimal(3,1)

insert into PHANCONG
values 
('123456789',1,32.5),
('123456789',2,7.5),
('666884444',3,40.0),
('453453453',1,20.0),
('453453453',2,20.0),
('333445555',2,10.0),
('333445555',3,10.0),
('333445555',10,10.0),
('333445555',20,10.0),
('999887777',30,30.0),
('999887777',10,10.0),
('987987987',10,35.0),
('987987987',30,5.0),
('987654321',30,20.0),
('987654321',20,15.0),
('888665555',20,NULL)

insert into THANNHAN
values 
('333445555','Anh','Nu','04/05/1986','Con gai'),
('333445555','The','Nam','10/25/1983','Con trai'),
('333445555','Loi','Nu','05/03/1958','Vo'),
('987654321','An','Nam','02/28/1942','Chong'),
('123456789','Minh','Nam','01/04/1988','Con trai'),
('123456789','Anh','Nu','12/30/1988','Con gai'),
('123456789','Yen','Nu','05/05/1967','Vo')

-- update PHONGBAN
update PHONGBAN
set TRPHONG = '333445555'
where MAPB = 5

UPDATE PHONGBAN
SET TrPhong = '987654321'
WHERE MaPB = 4

UPDATE PHONGBAN
SET TrPhong = '888665555'
WHERE MaPB = 1

UPDATE PHONGBAN
SET NgNhanChuc = '06/25/1989'
WHERE MaPB = 5

UPDATE NHANVIEN
SET Luong = Luong+1000
WHERE Phong=5

DELETE FROM DIADIEM_PHONG
WHERE MaPB=5

INSERT INTO DIADIEM_PHONG
VALUES(5, 'Tan Binh')
INSERT INTO DIADIEM_PHONG
VALUES(5, 'Phu Nhuan')
INSERT INTO DIADIEM_PHONG
VALUES(5, 'Thu Duc')

-- BTH 9
-- 1
select * from NHANVIEN

-- 2
select HONV + ' ' + TENDEM + ' ' + TEN as HO_TEN_NV
from NHANVIEN

-- 3
select *
from NHANVIEN
where PHONG = '5'

-- 4
select * from PHONGBAN

select nv.*
from NHANVIEN nv, PHONGBAN pb
where nv.PHONG = pb.MAPB and pb.TENPB <> N'Dieu hanh'

-- 5
select nv.*
from NHANVIEN nv,PHONGBAN pb 
where nv.PHONG = pb.MAPB
and pb.TENPB = 'Dieu hanh'

-- 6
select * from DUAN
select nv.*
from NHANVIEN nv 
left join DUAN da
on nv.PHONG = da.PHONGQL
where da.MADA = 3

-- 7
select MADA,TENDA
from DUAN
where DIADIEM = 'Phu Nhuan'

--8
select *
from NHANVIEN
where DIACHI like '%Phu Nhuan%'

-- 9
select *
from NHANVIEN
where GTINH = 'Nam' and LUONG <= 30000

-- 10
select *
from NHANVIEN
where GTINH = 'Nam' and LUONG > 30000

-- 11
select count(MANV) as SLNV,avg(LUONG) as LUONG_TB
from NHANVIEN

-- 12
select *
from NHANVIEN
where DIACHI like '%TPHCM%'

-- 13
select MANV,(LUONG * 0.6) as Thuong
from NHANVIEN

-- 14
select nv.HONV + ' ' + nv.TENDEM + ' ' +nv.TEN as Ho_ten_truong_phong
from NHANVIEN nv,PHONGBAN pb 
where nv.MANV = pb.TRPHONG
and pb.TENPB = 'Nghien cuu'

-- 16
select distinct nv.MANV
from THANNHAN tn,NHANVIEN nv,DUAN da 
where tn.MANV = nv.MANV and nv.PHONG = da.PHONGQL

-- 17
select da.MADA,nv.HONV + ' ' + nv.TEN
from NHANVIEN NV
join DUAN da  
on da.PHONGQL = nv.PHONG
where nv.HONV = 'Nguyen'

-- 18
select *
from NHANVIEN
where year(NGSINH) = 1950

-- 19
select *
from NHANVIEN nv 
join PHONGBAN pb 
on nv.PHONG = pb.MAPB
where nv.GTINH = 'Nu' and pb.TENPB = 'Nghien cuu'

-- 20
select MANV,TEN,PHONG,NGSINH
from NHANVIEN
order by PHONG desc,NGSINH asc

-- 21
update NHANVIEN
set LUONG = LUONG + LUONG * 0.1
WHERE MANV in (select nv.MANV from NHANVIEN nv join DUAN da on da.PHONGQL = nv.PHONG where da.TENDA = 'San pham X')

select * from NHANVIEN

-- 22
select MANV,year(getdate()) - year(NGSINH) Tuoi
from NHANVIEN
where year(getdate()) - year(NGSINH) >= 40

-- 23
select nv.MANV 
from NHANVIEN nv
join DUAN da 
on da.PHONGQL = nv.PHONG
where GTINH = 'Nu' and da.MADA = 1

-- 24
select MANV
from NHANVIEN
where MANV not in (select tn.MANV from THANNHAN tn)

-- 25
select *
from NHANVIEN
where LUONG between 30000 and 40000

-- 26
select nv1.TEN,nv1.LUONG
from NHANVIEN nv1
where nv1.LUONG in (select nv2.LUONG from NHANVIEN nv2 where nv2.MANV <> nv1.MANV)

-- 27
select nv.HONV + ' ' + nv.TENDEM + ' ' +nv.TEN as HO_TEN,count(da.MADA) as SO_LUONG_DA
from NHANVIEN nv 
join DUAN da 
on da.PHONGQL = nv.PHONG
group by nv.HONV + ' ' + nv.TENDEM + ' ' +nv.TEN

-- 28
select nv.HONV + ' ' + nv.TENDEM + ' ' +nv.TEN as Ho_ten_truong_phong
from NHANVIEN nv,PHONGBAN pb 
where nv.MANV = pb.TRPHONG

-- 29
select nv.HONV + ' ' + nv.TENDEM + ' ' +nv.TEN as HO_TEN
from NHANVIEN nv
join THANNHAN tn 
on nv.MANV = tn.MANV
where nv.NGSINH = tn.NGSINH

-- 30
select nv.HONV + ' ' + nv.TENDEM + ' ' +nv.TEN as HO_TEN,nv.LUONG,nv.PHONG
from NHANVIEN nv
where nv.PHONG = 4 or nv.LUONG > 35000

-- 31
select avg(nv.LUONG) as Luong_Greater_t10
from NHANVIEN nv 
join PHANCONG pc 
on pc.MANV = nv.MANV
where pc.SOGIO > 10

-- 32
select pb.TENPB, sum(nv.LUONG) as Tong_luong
from NHANVIEN nv 
join PHONGBAN pb
on nv.PHONG = pb.MAPB
group by pb.TENPB

-- 33
select max(LUONG) as Luong_cao_nhat
from NHANVIEN

-- 34
select count(tn.MANV) as So_than_nhan
from THANNHAN tn 
join NHANVIEN nv 
on tn.MANV = nv.MANV
where nv.HONV = 'Nguyen' and nv.TENDEM = 'Bao' and nv.TEN = 'Hung'

-- 35
select *
from NHANVIEN
where MANV not in (select pc.MANV from PHANCONG pc)

-- 36
select pb.TENPB, count(nv.MANV) as SLNV,sum(nv.LUONG) as Tong_Luong
from NHANVIEN nv 
join PHONGBAN pb
on nv.PHONG = pb.MAPB
group by pb.TENPB

-- 37
select pb.TENPB,count(nv.MANV) as SLNV,avg(nv.LUONG) as Luong_TB
from NHANVIEN nv 
join PHONGBAN pb 
on nv.PHONG = pb.MAPB
group by pb.TENPB

-- 38
select pb.TENPB,avg(nv.LUONG) as Luong_TB
from NHANVIEN nv 
join PHONGBAN pb 
on nv.PHONG = pb.MAPB
group by pb.TENPB
having avg(nv.LUONG) > 30000

-- 39
select tn1.MANV
from THANNHAN tn1
group by tn1.MANV
having count(tn1.MANV) >= all(select count(tn2.MANV) from THANNHAN tn2 group by tn2.MANV)

-- 40
select *
from NHANVIEN
where MANV in (
    select tn1.MANV
    from THANNHAN tn1
    group by tn1.MANV
    having count(tn1.MANV) >= all(select count(tn2.MANV) from THANNHAN tn2 group by tn2.MANV))

-- 41
select HONV + ' ' + TENDEM + ' ' + TEN as HO_TEN_NV
from NHANVIEN
where MANV not in (select pc.MANV from PHANCONG pc)

-- 42
select pb.TENPB,count(nv.MANV) as SLNV
from PHONGBAN pb 
join NHANVIEN nv 
on nv.PHONG = pb.MAPB
group by pb.TENPB
having count(nv.MANV) > 3

-- 43 ????
select * from DUAN
select * from PHONGBAN
select * from DIADIEM_PHONG
select * from PHANCONG
select * from NHANVIEN


-- 44
select pb.MAPB,count(nv.MANV) as SLNV
from PHONGBAN pb 
join NHANVIEN nv 
on pb.MAPB = nv.PHONG
group by pb.MAPB
having sum(nv.LUONG) > 30000 and count(nv.MANV) >= 3

-- 45
select  nv.HONV + ' ' + nv.TENDEM + ' ' +nv.TEN as HO_TEN,sum(pc.SOGIO) as Tong_Gio
from NHANVIEN nv
join PHANCONG pc
on nv.MANV = pc.MANV
group by nv.HONV + ' ' + nv.TENDEM + ' ' +nv.TEN
having count(nv.MANV) >= 2
order by nv.HONV + ' ' + nv.TENDEM + ' ' +nv.TEN asc

-- 46
select nv.HONV + ' ' + nv.TENDEM + ' ' + nv.TEN as HO_TEN,BO_PHAN = case when nv.MANV = pb.TRPHONG then pb.TENPB else NULL end
from NHANVIEN nv
join PHONGBAN pb
on nv.PHONG = pb.MAPB

-- 47
select da.TENDA,sum(pc.SOGIO) as Tong_Thoi_Gian
from DUAN da 
join PHANCONG pc 
ON da.MADA = pc.MADA
group by da.TENDA

-- 48
select da.MADA,pb.MAPB
from DUAN da
join PHONGBAN pb 
on da.PHONGQL = pb.MAPB
where da.DIADIEM = 'Phu Nhuan'

-- 49
select nv.HONV + ' ' + nv.TENDEM + ' ' + nv.TEN as HO_TEN,nv.NGSINH,nv.DIACHI
from PHONGBAN pb 
join NHANVIEN nv  
on nv.MANV = pb.TRPHONG

-- 50
select nv.HONV + ' ' + nv.TENDEM + ' ' + nv.TEN as HO_TEN
from NHANVIEN nv,PHANCONG pc,DUAN da 
where nv.MANV = pc.MANV and nv.PHONG = da.PHONGQL and nv.PHONG = 5 and pc.SOGIO > 10 and da.TENDA = 'San pham X'



