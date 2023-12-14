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