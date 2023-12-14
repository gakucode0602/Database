use QLDIEM
go

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

-- example
select KETQUA.MASV,count(distinct KETQUA.MAMH) as So_mon from KETQUA left join DMSV on KETQUA.MASV = DMSV.MASV group by KETQUA.MASV

select DMMH.TENMH,count(distinct KETQUA.MASV) as sl from DMMH left join KETQUA on DMMH.MAMH = KETQUA.MAMH group by DMMH.TENMH having count(distinct KETQUA.MASV) >= 3


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
select MAKHOA
from DMSV
where HOCBONG > 0
group by MAKHOA
having count(MASV) >= all(select count(MASV) from DMSV where HOCBONG > 0 group by MAKHOA)
UNION
select MAKHOA
from DMSV
group by MAKHOA
having MAKHOA NOT IN (select MAKHOA from DMSV where HOCBONG > 0)

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

-- BTH 7:
use QLDIEM
go
-- 1.1
select MASV,HOSV + ' ' + TENSV as HO_TEN_SV
from DMSV
where MASV not in (select MASV from KETQUA where MAMH = '01')

-- 1.2
select kq1.*
from KETQUA kq1
where kq1.LANTHI = 2 and kq1.MASV not in (select kq2.MASV from KETQUA kq2 where kq2.LANTHI = 1)

--1.3
select distinct mh.TENMH
from DMMH mh 
join KETQUA kq
on mh.MAMH = kq.MAMH
where kq.MASV not in (select kq1.MASV from KETQUA kq1 join DMSV sv on sv.MASV = kq1.MASV where sv.MAKHOA = 'AV')

--1.4
select distinct sv.MASV,sv.HOSV + ' ' + sv.TENSV as HO_TEN_SV,sv.MAKHOA
from DMSV sv
join KETQUA kq
on sv.MASV = kq.MASV
where sv.MAKHOA = 'AV' and sv.MASV not in
(
    select sv1.MASV
    from DMSV sv1
    join KETQUA kq1
    on sv1.MASV = kq1.MASV
    where sv1.MAKHOA = 'AV' and kq1.MAMH = '05'
)

--1.5
select mh.TENMH
from DMMH mh
join KETQUA kq
on kq.MAMH = mh.MAMH
where kq.MASV not in (select kq1.MASV from KETQUA kq1 where kq1.DIEM < 5 and kq1.LANTHI = 1)

--1.6
select k.TENKHOA
from DMKHOA k
join DMSV sv 
on k.MAKHOA = sv.MAKHOA
where k.MAKHOA <> all(select MAKHOA from DMSV where PHAI = '1')

--1.7
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HO_TEN_SV
from DMSV sv
where sv.MAKHOA = 'AV' and sv.HOCBONG > 0
union
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HO_TEN_SV
from DMSV sv
join KETQUA kq
on sv.MASV = kq.MASV
where kq.MASV <> all(select MASV from KETQUA where DIEM < 5)

--1.8
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HO_TEN_SV
from DMSV sv
where sv.HOCBONG = 0
union
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HO_TEN_SV
from DMSV sv
join KETQUA kq
on sv.MASV = kq.MASV
where (kq.DIEM < 5 and kq.LANTHI = 1 and kq.MASV not in (select kq2.MASV from KETQUA kq2 where kq2.LANTHI = 2))
or (kq.DIEM < 5 and kq.LANTHI = 2)

--2.1
select *
from DMMH k1
where not exists (select * -- create the table that exists a student 
                           -- that doesn't learn any subject
                           -- -> if any students exist in this table which means that there is a subject is not learned by
                           --    all student
                from DMSV s 
                where exists (select * -- create the table that consists student which is actually learning
                                 from KETQUA k2
                                  where k2.MASV = s.MASV
                                  /*and k2.MAMH = k1.MAMH)*/))


--2.2
select distinct kq1.MASV,kq1.MAMH from KETQUA kq1 where kq1.MASV <> 'A02' and not exists(select mh.*
                                              from DMMH mh
                                              where mh.MAMH = kq1.MAMH
                                              and not exists (select * 
                                                              from KETQUA kq 
                                                              where kq.MASV = 'A02' and kq.MAMH = mh.MAMH))

--2.3
select * from DMSV sv1 where sv1.MASV <> 'A02' and not exists (select *
                                                               from KETQUA kq1
                                                               where not exists (select *
                                                                                 from KETQUA kq2
                                                                                 where kq1.MAMH = kq2.MAMH and kq2.MASV = 'A02'))
