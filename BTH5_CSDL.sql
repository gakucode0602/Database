use QLDIEM
go

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

--1.4
select kq.MASV,count(kq.MAMH) as SL
from KETQUA kq,DMMH mh
where kq.MAMH = mh.MAMH
group by kq.MASV,kq.MAMH
having count(kq.MAMH) >= 2

--1.5
select sv.MASV,avg(kq.DIEM) as DTB
from KETQUA kq,DMSV sv
where kq.MASV = sv.MASV and sv.PHAI = 'false' and kq.LANTHI = 1
group by sv.MASV
having avg(KQ.DIEM) >= 7.0

--1.6
select sv.MASV,count(kq.MASV) as [So luong mon]
from KETQUA kq,DMSV sv
where kq.MASV = sv.MASV and kq.LANTHI = 1 and kq.DIEM < 5
group by sv.MASV
having count(kq.MASV) >= 2

--1.7
select sv.MAKHOA,count(sv.MASV) as [So luong sinh vien]
from DMSV sv,DMKHOA k
where sv.MAKHOA = k.MAKHOA and sv.PHAI = 0
group by sv.MAKHOA
having count(sv.MASV) >= 2

--1.8
select sv.MAKHOA,count(sv.MASV) as SLSV
from DMSV sv,DMKHOA k
where sv.MAKHOA = k.MAKHOA and sv.HOCBONG between 100000 and 200000
group by sv.MAKHOA
having count(sv.MASV) >= 2

--1.9
select sv.MASV,count(distinct kq.MAMH) as [So luong mon]
from KETQUA kq,DMSV sv
where kq.MASV = sv.MASV and sv.PHAI = 0
group by sv.MASV
having count(distinct kq.MAMH) >= 3

--1.10
select sv.MASV,avg(kq.DIEM) DTB
from KETQUA kq,DMSV sv
where sv.MASV = kq.MASV and kq.DIEM >= 5
group by sv.MASV
having avg(kq.DIEM) >= 7

--1.11
select kq.MAMH,mh.TENMH
from KETQUA kq,DMMH mh
where kq.MAMH = mh.MAMH and kq.MAMH not in (select kq.MAMH from KETQUA kq where kq.LANTHI = 1 and kq.DIEM < 5)
group by kq.MAMH,mh.TENMH

--1.12
select kq.MASV
from KETQUA kq
where kq.LANTHI = 1 and kq.DIEM >= 5
group by kq.MASV
having count(kq.MASV) >= 3

--2.1
select *
from DMSV 
where HOCBONG = (select max(HOCBONG) from DMSV)

--2.2
select *
from KETQUA
where LANTHI = 1 and DIEM = (select max(kq.DIEM) from KETQUA kq where kq.MAMH = '01')

--2.3
select *,Tuoi = year(getdate()) - year(NGAYSINH)
from DMSV
where year(getdate()) - year(NGAYSINH) = (select max(year(getdate()) - year(NGAYSINH)) from DMSV where MAKHOA = 'AV')

--2.4
select *
from DMSV
where MASV != 'A01' and NOISINH = (select NOISINH from DMSV where MASV = 'A01')

--2.5
select sv.*,kq.DIEM
from DMSV sv,KETQUA kq
where sv.MASV = kq.MASV and sv.MAKHOA = 'AV' and kq.DIEM = (select kq.DIEM from KETQUA kq where kq.MAMH = '05' and kq.LANTHI = 1)

--2.6
select sv.*,kq.DIEM,kq.LANTHI
from KETQUA kq,DMSV sv
where kq.MASV = sv.MASV and kq.LANTHI = 2 and kq.MAMH = '01' and kq.DIEM = (select max(kq.DIEM) from KETQUA kq where kq.LANTHI = 1 and kq.MAMH = '01')

--2.7
select sv.*,kq.DIEM,kq.LANTHI
from DMSV sv,KETQUA kq
where sv.MASV = kq.MASV and kq.LANTHI = 2 and kq.MAMH = '01' and kq.DIEM > (select max(kq.DIEM) from KETQUA kq where kq.MAMH = '01' and kq.LANTHI = 1)

--2.8
select *
from DMSV
where HOCBONG > (select max(HOCBONG) from DMSV where MAKHOA = 'AV')