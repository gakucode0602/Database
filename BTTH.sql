use QLDIEM
GO

--BTH3
--1.1
select *
from DMMH

--1.2
select *
from DMMH
where TENMH like N'T%'

--1.3
select HOSV + ' ' + TENSV as HOTENSV,NGAYSINH,PHAI
from DMSV
where TENSV like N'%I'

--1.4
select MAKHOA,TENKHOA
from DMKHOA
where TENKHOA like N'%N%'

--1.5
select *
from DMSV
where HOSV like N'%THỊ%'

--1.6
select MASV,HOSV + ' ' + TENSV,PHAI,HOCBONG
from DMSV
where TENSV like N'[a-m]%'

--1.7
select HOSV + ' ' + TENSV,MAKHOA,NOISINH,HOCBONG
from DMSV
where HOCBONG >= 130000 and NOISINH = N'Hà Nội'

--1.8
select MASV,MAKHOA,PHAI
from DMSV
where MAKHOA in ('AV','VL')

--1.9
select MASV,NGAYSINH,NOISINH,HOCBONG
from DMSV
where NGAYSINH between '01/01/1992' and '05/06/1993'

--1.10
select MASV,NGAYSINH,PHAI,MAKHOA
from DMSV
where HOCBONG between 80000 and 150000

--1.11
select MAMH,TENMH,SOTIET
from DMMH
where SOTIET BETWEEN 30 and 45

--1.12
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HOTENSV,k.TENKHOA,sv.PHAI
from DMSV sv
left join DMKHOA k
on sv.MAKHOA = k.MAKHOA
where sv.PHAI = 0 and sv.MAKHOA in ('av','th')

--1.13 
    -- cach 1 : 
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HOTENSV,sv.PHAI,kq.DIEM
from DMSV sv
left join KETQUA kq
on sv.MASV = kq.MASV
where kq.MAMH = '01' and kq.DIEM <= 5

    -- cach 2
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HOTENSV,sv.PHAI,kq.DIEM
from DMSV sv,KETQUA kq
where (sv.MASV = kq.MASV) and kq.MAMH = '01' and kq.DIEM <= 5

--1.14
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HOTENSV,k.TENKHOA,sv.NOISINH,sv.HOCBONG
from DMSV sv,DMKHOA k
where sv.MAKHOA = k.MAKHOA and sv.MAKHOA = 'AV' and sv.HOCBONG = 0

--2.1
select HOSV + ' ' + TENSV as HOTENSV,NGAYSINH,NOISINH
from DMSV
order by TENSV asc

--2.2
select HOSV + ' ' + TENSV as HOTENSV,NGAYSINH,NOISINH
from DMSV
where TENSV like N'[a-m]%'
order by TENSV asc

--2.3
select MASV,HOSV,TENSV,HOCBONG
from DMSV
order by MASV

--2.4
select HOSV + ' ' + TENSV as HOTENSV,NGAYSINH,HOCBONG
from DMSV
order by NGAYSINH asc,HOCBONG desc

--2.5
select MASV,HOSV + ' ' + TENSV as HOTENSV,MAKHOA,HOCBONG
from DMSV
where HOCBONG > 100000
order by MAKHOA desc

-- BTH 4
--1.1
select HOSV,TENSV,NOISINH,NGAYSINH
from DMSV
where NOISINH = N'Hà Nội' and MONTH(NGAYSINH) = 02

--1.2
alter table DMSV
add Tuoi int 

alter table DMSV
drop column Tuoi;

select HOSV + ' ' + TENSV as HOTENSV,Tuoi = year(getdate()) - year(NGAYSINH),HOCBONG
from DMSV
where year(getdate()) - year(NGAYSINH) >= 20

--1.3
select sv.HOSV + ' ' + sv.TENSV as [HO TEN SV],Tuoi = year(getdate()) - year(NGAYSINH),k.TENKHOA
from DMSV sv,DMKHOA k
where sv.MAKHOA = k.MAKHOA and year(getdate()) - year(NGAYSINH) between 29 and 31

--1.4
select HOSV + ' ' + TENSV as [HO TEN SV],PHAI,datepart(day,NGAYSINH) as Ngaysinh
from DMSV
where datepart("q",NGAYSINH) = 1

--2.1
select MASV,PHAI,MAKHOA,
       case when HOCBONG > 150000 then 'Cao' else 'Thap' end as [Muc hoc bong]
from DMSV

--2.2
select sv.HOSV + ' ' + sv.TENSV as [HO TEN SV],k.MAMH,sv.MAKHOA,k.LANTHI,k.DIEM,case when k.DIEM < 5 then 'Rot' else 'Dau' end as [Ket_qua]
from DMSV sv,KETQUA k
where sv.MASV = k.MASV

--3.1
select count(*) as SLSV
from DMSV

--3.2
select count(*) as SLSV,sum(case when PHAI = 1 then 1 else 0 end) as SVNu
from DMSV

--3.3
select count(sv.MASV) as [So luong],sv.MAKHOA,k.TENKHOA
from DMSV sv,DMKHOA k
where sv.MAKHOA = k.MAKHOA
group by sv.MAKHOA,k.TENKHOA

--3.4
select count(kq.MASV) as [So_luong],mh.TENMH
from DMMH mh,KETQUA kq
where mh.MAMH = kq.MAMH
group by mh.MAMH,mh.TENMH

--3.5
select kq.MASV ,count(distinct kq.MAMH) as [So luong]
from KETQUA kq
group by kq.MASV

--3.6
select k.TENKHOA,max(sv.HOCBONG)
from DMSV sv,DMKHOA k
where sv.MAKHOA = k.MAKHOA
group by sv.MAKHOA,k.TENKHOA

--3.7
select sum(case when PHAI = 0 then 1 else 0 end) as SV_NAM,sum(case when PHAI = 1 then 1 else 0 end) as SV_NU
from DMSV

--3.8
select Tuoi = year(getdate()) - year(sv.NGAYSINH),count(sv.MASV) as So_luong
from DMSV sv
group by year(getdate()) - year(sv.NGAYSINH)

--3.9
select mh.TENMH,sum(case when kq.DIEM >= 5 then 1 else 0 end) as 'Dau',sum(case when kq.DIEM < 5 then 1 else 0 end) as 'Rot'
from KETQUA kq,DMMH mh
where kq.MAMH = mh.MAMH and kq.LANTHI = 1
group by kq.MAMH,mh.TENMH

--BTH 5

--1.1
select year(sv.NGAYSINH) as Nam
from DMSV sv
group by year(sv.NGAYSINH)
having count(sv.MASV) = 2

--1.2
select NOISINH
from DMSV
group by NOISINH
having count(MASV) >= 2;

--1.3
select mh.TENMH,kq.MAMH,count(distinct kq.MASV) as Sl
from KETQUA kq,DMMH mh
where kq.MAMH = mh.MAMH
group by kq.MAMH,mh.TENMH
having count(distinct kq.MASV) >= 3