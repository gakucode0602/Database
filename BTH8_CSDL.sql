create table SinhVien_KetQua(
    MASV nchar(3),
    HOSV nvarchar(30) null,
    TENSV nvarchar(10) null,
    SoMonHoc int
);
insert into SinhVien_KetQua(MASV,HOSV,TENSV,SoMonHoc)
       select s.MASV,HOSV,TENSV,count(distinct MAMH)
       from DMSV s,KETQUA k
       where s.MASV = k.MASV
       group by s.MASV,HOSV,TENSV

--1.2
alter table DMKHOA
add SISO int;

update DMKHOA
set SISO = (select count(*)
            from DMSV
            where MAKHOA = 'VL')
where MAKHOA = 'VL'

-- 1.3
alter table KETQUA
add HOCBONG int null;

update KETQUA
set HOCBONG = 0
where MASV in (select kq1.MASV
               from KETQUA kq1
               where kq1.DIEM < 5 and kq1.LANTHI = 1
               group by kq1.MASV
               having count(kq1.MAMH) >= 2)

--1.4
update KETQUA
set DIEM = least(DIEM + 1,5)
where LANTHI = 2 and DIEM < 5

--1.5
update KETQUA
set HOCBONG = HOCBONG + 1000000
where MASV in (select kq1.MASV
               from KETQUA kq1
               where LANTHI = 1 and kq1.MASV not in (select kq2.MASV from KETQUA kq2 where kq2.LANTHI = 1 and kq2.DIEM < 5 and kq1.MASV = kq2.MASV)
               group by kq1.MASV
               having avg(kq1.DIEM) >= 7)

--1.6
delete from DMSV
where MASV not in (select distinct MASV from KETQUA)

--1.7
delete from DMMH
where MAMH not in (select distinct MAMH from KETQUA);

--2.1
-- Must create the view command in only one batch SQL
create view VCAU1 as   
select * from DMSV where MAKHOA = 'AV' with check option;

select *
from VCAU1
insert into VCAU1
values('C02','John','Wick',0,'2003-2-6','America','AV',0)

--2.2
create view V_dskhongrot as
select MASV,HOSV,TENSV,PHAI
from DMSV
where MASV in (select MASV from KETQUA group by MASV having min(DIEM) >= 5)

select * from V_dskhongrot

--2.3
create view V_VP_AND_DB as
select * from DMSV where MASV in (select distinct MASV
                                  from KETQUA
                                  where MAMH = '01' and MASV in (select MASV
                                                                 from KETQUA
                                                                 where MAMH = '05'));

--2.4
create view V_MAX_SCORE as
select sv.MASV,sv.HOSV + ' ' + sv.TENSV as HO_TEN_SV,mh.TENMH,kq.DIEM from DMSV sv,KETQUA kq,DMMH mh where sv.MASV = kq.MASV and kq.MAMH = mh.MAMH and kq.DIEM >= ( select max(DIEM) from KETQUA kq1 where kq.MASV = kq1.MASV group by kq1.MASV)

select * from V_MAX_SCORE

--2.5
create view V_NU as
select MAKHOA from DMKHOA where MAKHOA in (select MAKHOA
                                           from DMKHOA
                                            where MAKHOA in (select sv.MAKHOA from DMSV sv group by sv.MAKHOA having sum(case when sv.PHAI = 1 then 1 else 0 end) = 2))

select * from V_NU

--2.6
create view V_OPTION as
select *
from KETQUA
where (LANTHI = 1 and DIEM > 5) or (MAMH <> '05')