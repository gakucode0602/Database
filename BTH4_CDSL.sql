use QLDIEM
go

--1.1
select HOSV,TENSV,NOISINH,NGAYSINH
from DMSV
where NOISINH = N'Hà Nội' and MONTH(NGAYSINH) = 2

--1.2
select HOSV + ' ' + TENSV,Tuoi = YEAR(GETDATE()) - YEAR(NGAYSINH),HOCBONG
from DMSV
where year(getdate()) - year(NGAYSINH) >= 20;

--1.3
select sv.HOSV + ' ' + sv.TENSV as HOTENSV,Tuoi = YEAR(GETDATE()) - YEAR(NGAYSINH),k.TENKHOA
from DMSV sv,DMKHOA k
where sv.MAKHOA = k.MAKHOA and YEAR(GETDATE()) - YEAR(NGAYSINH) between 20 and 25;

--1.4
select HOSV + ' ' + TENSV as HOTENSV,PHAI,ngaysinh = DATEPART("q",NGAYSINH)
from DMSV
where year(NGAYSINH) = 1990 and (datepart("q",NGAYSINH) = 1);

--2.1
select MASV,PHAI,MAKHOA,MUCHOCBONG = case when HOCBONG > 150000 then 'Cao'else 'Trung binh' end
from DMSV

--2.2
select sv.HOSV + ' ' + sv.TENSV as HOTENSV,mh.MAMH,k.LANTHI,k.DIEM,ketqua = case when k.DIEM < 5 then 'Truot' else 'Dau' end
from DMSV sv,DMMH mh,KETQUA k
where sv.MASV = k.MASV and k.MAMH = mh.MAMH

--3.1
select count(*) as SLSV
from DMSV

--3.2
select count(MASV) as SLSV,SVNU = sum(case when PHAI = 'True' then 1 else 0 end)
from DMSV

--3.3
select count(sv.MASV) as SLSV,k.TENKHOA
from DMSV sv,DMKHOA k
where sv.MAKHOA = k.MAKHOA
group by sv.MAKHOA,k.TENKHOA

--3.4
select mh.MAMH,TENMH,COUNT(distinct MASV) as SoMH
from DMMH mh,KETQUA k
where mh.MAMH = k.MAMH
group by mh.MAMH,mh.TENMH

--3.5
select kq.MASV ,count(distinct kq.MAMH) as [So luong]
from KETQUA kq
group by kq.MASV

--3.6
select max(HOCBONG) as HocBong,k.TENKHOA
from DMSV sv,DMKHOA k
where k.MAKHOA = sv.MAKHOA
group by k.TENKHOA,sv.MAKHOA

--3.7
select sum(case when PHAI = 0 then 1 else 0 end) as SVNam, sum(case when PHAI = 1 then 1 else 0 end) as SVNu
from DMSV;

--3.8
select count(sv.MASV) as SLSV,Tuoi = YEAR(GETDATE()) - YEAR(NGAYSINH)
from DMSV sv
group by YEAR(GETDATE()) - YEAR(NGAYSINH)

--3.9
select k.MAMH,mh.TENMH,sum(case when k.DIEM < 5 then 1 else 0 end) as 'Rot',sum(case when k.DIEM >= 5 then 1 else 0 end) as 'Dau'
from KETQUA k,DMMH mh
where k.MAMH = mh.MAMH and k.LANTHI = 1
group by k.MAMH,mh.TENMH
