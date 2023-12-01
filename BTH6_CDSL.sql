-- BTH 6

--1.1
select *
from DMSV
where NOISINH in (select NOISINH from DMSV where TENSV like N'Hải')
and TENSV not like N'Hải'

--1.2
-- approach 1 :  using all
select *
from DMSV
where HOCBONG > all(select HOCBONG from DMSV where MAKHOA = 'AV')
and MAKHOA != 'AV'

--approach 2 : using max
select *
from DMSV
where HOCBONG > (select max(HOCBONG) from DMSV where MAKHOA = 'AV')
and MAKHOA != 'AV'

--1.3
select * from DMSV
where HOCBONG > any(select HOCBONG from DMSV where MAKHOA = 'AV')
and MAKHOA != 'AV'

--1.4
select kq1.*
from KETQUA kq1
where kq1.MAMH = '01' and kq1.LANTHI = 2 and kq1.DIEM >= (select max(kq2.DIEM) from KETQUA kq2 where kq2.MAMH = '01' and kq2.LANTHI = 1 and kq1.MASV != kq2.MASV)

--1.5
select sv.HOSV + ' ' + sv.TENSV as HO_TEN_SV,mh.TENMH,kq1.DIEM
from KETQUA kq1,DMSV sv,DMMH mh
where 
kq1.MASV = sv.MASV and
kq1.MAMH = mh.MAMH and
kq1.DIEM >= all(select kq2.DIEM from KETQUA kq2 where kq1.MAMH = kq2.MAMH and kq2.MASV = kq1.MASV)

--1.6
select kq1.MAMH,count(distinct kq1.MASV) as sl,mh.TENMH
from KETQUA kq1,DMMH mh
where kq1.MAMH = mh.MAMH
group by kq1.MAMH,mh.TENMH
having count(distinct kq1.MASV) >= all(select count(distinct kq2.MASV) from KETQUA kq2 group by kq2.MAMH)

--1.7
select sv1.MAKHOA,count(sv1.MASV) as So_luong
from DMSV sv1
where PHAI = '0'
group by sv1.MAKHOA
order by count(sv1.MASV) asc

--1.8
select sv1.MAKH,sum(case when sv1.HOCBONG > 0 then 1 else 0 end) SLHB
from DMSV sv1
where sv1.HOCBONG > 0
group by sv1.MAKH
having sum(case when HOCBONG > 0 then 1 else 0 end) >= all(select sum(case when sv1.HOCBONG > 0 then 1 else 0 end) SLHB from DMSV sv1 where sv1.HOCBONG > 0 group by sv1.MAKH)
union
select sv2.MAKH,sum(case when sv2.HOCBONG = 0 then 0 else 1 end) SLHB
from DMSV sv2
group by sv2.MAKH
having sum(case when sv2.HOCBONG = 0 then 0 else 1 end) = 0

--1.9
select MAMH,count(MASV) as SL
from KETQUA
where LANTHI = 1 and DIEM < 5
group by MAMH
having count(MASV) >= all(select count(MASV) from KETQUA where LANTHI = 1 and DIEM < 5 group by MAMH)

--1.10
select top 3 MASV,count(distinct MAMH) as SO_LUONG_MON
from KETQUA
group by MASV
order by count(distinct MAMH) desc

--2.1
select mh.TENMH,count(distinct kq.MASV) as SLSV
from DMMH mh
left join KETQUA kq
on mh.MAMH = kq.MAMH
group by mh.TENMH

--2.2
select k.TENKHOA,count(sv.MASV) as SLSV
from DMKHOA k
left join DMSV sv
on sv.MAKHOA = k.MAKHOA
group by k.TENKHOA

--2.3
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HO_TEN_SV,count(distinct kq.MAMH) as SL_MON
from DMSV sv
left join KETQUA kq
on sv.MASV = kq.MASV
group by sv.MASV,sv.HOSV + ' ' + sv.TENSV
