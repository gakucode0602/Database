-- Cau 1
create database QLThueBang;

use QLThueBang
go

create table BANG(
    MaBang char(10) constraint pk_MaBang primary key,
    TenBang nvarchar(50) not null unique,
    TheLoai nvarchar(20) not null,
    NuocSX nvarchar(20),
    GiaMua decimal(8,2) not null,
    GhiChu nvarchar(MAX)
)

create table KhachHang(
    MaKH int IDENTITY(1,1) constraint pk_MaKH primary key(MaKH),
    TenKH nvarchar(50) unique,
    DiaChi nvarchar(100),
    SoDT nvarchar(12) unique,
    TheLoaiYT nvarchar(20),
    GhiChu nvarchar(MAX)
)

create table ThueBang(
    MaKH int,
    MaBang char(10),
    NgayThue datetime,
    NgayTra datetime,
    SoTienThu decimal(8,2) not null,
    GhiChu nvarchar(max),
    constraint pk_TB primary key(MaKH,MaBang,NgayThue),
    constraint fk_KH foreign key (MaKH) references KhachHang(MaKH),
    constraint fk_B foreign key (MaKH) references KhachHang(MaKH),
)

insert into BANG
values 
('01','Avenger','Hanh Dong','USA',10000,null),
('02','Deadpool','Gay can','USA',10000,'18+'),
('03','Friends','Hai','USA',10000,null)

select * from BANG

insert into KhachHang
values 
('LeBron James','Lakers','12345','Hanh Dong',null),
('Giannis','Buck','23456','Hai',null),
('Curry','Golden state','34567','Tinh cam',null)

select * from KhachHang

insert into ThueBang
values 
(2,'01','12-23-2023','12-30-2023',10000,null),
(1,'03','11-23-2022','12-30-2023',10000,null),
(1,'01','12-23-2023','12-30-2023',10000,null),
(3,'02','12-23-2023','12-30-2023',10000,null)

select * from ThueBang

-- Cau 2
use AdventureWorks2022
go

-- 2.1
select s.SalesOrderID,s.OrderDate,Subtotal = sum(so.OrderQty * so.UnitPrice)
from Sales.SalesOrderHeader s
join Sales.SalesOrderDetail so 
on so.SalesOrderID = s.SalesOrderID
where year(s.OrderDate) = 2008 and month(s.OrderDate) = 6
group by s.SalesOrderID,s.OrderDate
having sum(so.OrderQty * so.UnitPrice) > 70000

-- 2.2
select * from HumanResources.Employee

select e.JobTitle,CountOfPerson = count(*)
from HumanResources.Employee e
group by e.JobTitle
having count(e.BusinessEntityID) > 20

-- 2.3
select ss.ProductID,p.Name,CountOrderQty = sum(ss.OrderQty),Year = year(sh.OrderDate)
from Sales.SalesOrderDetail ss 
join Production.Product p 
on p.ProductID = ss.ProductID
join Sales.SalesOrderHeader sh
on ss.SalesOrderID = sh.SalesOrderID
where p.Name like 'Bike%' or p.Name like 'Sport%'
group by ss.ProductID,p.Name,year(sh.OrderDate)
having sum(ss.OrderQty) > 500

-- 2.4
select p.Name,ss.ProductID
from Sales.SalesOrderDetail ss 
join Production.Product p 
on p.ProductID = ss.ProductID
join Sales.SalesOrderHeader sh
on ss.SalesOrderID = sh.SalesOrderID
where month(sh.OrderDate) = 7 and year(sh.OrderDate) = 2008
group by ss.ProductID,p.Name
having sum(ss.OrderQty) > 100
<<<<<<< HEAD

select * from Person.Person
=======
>>>>>>> 73d3f669ed74c5604e12f0314aea205e1942b207
