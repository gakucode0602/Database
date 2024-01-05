-- Cau 1
create database QLThuePhong

use QLThuePhong
go

create table PHONG(
    MaPhong char(10) constraint pk_MaPhong primary key,
    SoGiuong int identity(1,1) unique,
    HoTenNV nvarchar(50) not null,
    GiaTien decimal(8,2) not null,
    GhiChu nvarchar(max)
)

create table KHACHHANG(
    MaKH int identity(1,1) constraint pk_MaKH primary key,
    TenKH nvarchar(50) not null unique,
    DiaChi nvarchar(100) not null,
    SDT nvarchar(12) not null,
    GhiChu nvarchar(max)
)

create table THUE_PHONG(
    MaKH int,
    MaPhong char(10),
    NgayLayPhong datetime default(getdate()),
    NgayTraPhong datetime default(getdate()),
    SoTienDaTra decimal(8,2) not null,
    GhiChu nvarchar(max)
    constraint pk_ThuePhong primary key(MaKH,MaPhong,NgayLayPhong),
    constraint fk_MaKH foreign key (MaKH) references KHACHHANG(MaKH),
    constraint fk_MaPhong foreign key (MaPhong) references PHONG(MaPhong)
)


-- Cau 2
use AdventureWorks2019
go 

-- 2.1
select st.TerritoryID,count(sh.TerritoryID) as CountOfCust,SubTotal = sum(sd.OrderQty * sd.UnitPrice)
from Sales.SalesTerritory st 
join Sales.SalesOrderHeader sh 
on st.TerritoryID = sh.TerritoryID
join Sales.SalesOrderDetail sd 
on sd.SalesOrderID = sh.SalesOrderID
where st.CountryRegionCode = 'US'
group by st.TerritoryID
order by st.TerritoryID asc

-- 2.2

select ppv.BusinessEntityID,pv.Name,ppv.ProductID,SumOfQty = sum(ppo.OrderQty),SubTotal = sum(ppo.OrderQty * ppo.UnitPrice)
from Purchasing.ProductVendor ppv
join Purchasing.Vendor pv 
on ppv.BusinessEntityID = pv.BusinessEntityID
join Purchasing.PurchaseOrderDetail ppo
on ppv.ProductID = ppo.ProductID
where pv.Name like '%Bicycles'
group by ppv.BusinessEntityID,pv.Name,ppv.ProductID
having sum(ppo.OrderQty * ppo.UnitPrice) > 800000

-- 2.3
select hd.DepartmentID,hd.Name,avg(he.Rate) as AvgofRate
from HumanResources.Department hd 
join HumanResources.EmployeeDepartmentHistory hed
on hd.DepartmentID = hed.DepartmentID
join HumanResources.EmployeePayHistory he 
on he.BusinessEntityID = hed.BusinessEntityID
group by hd.DepartmentID,hd.Name
having avg(he.Rate) > 30

-- 2.4
select * from Sales.SalesOrderDetail

select p.ProductID,p.Name
from Production.Product p
join Sales.SalesOrderDetail sd
on p.ProductID = sd.ProductID
join Sales.SalesOrderHeader sh
on sh.SalesOrderID = sd.SalesOrderID
where month(sh.OrderDate) = 7 and year(sh.OrderDate) = 2011
group by p.ProductID,p.Name
having count(sd.OrderQty) >= (select top 1 count(sd1.OrderQty)
                                from Production.Product p1
                                join Sales.SalesOrderDetail sd1
                                on p1.ProductID = sd1.ProductID
                                join Sales.SalesOrderHeader sh1
                                on sh1.SalesOrderID = sd1.SalesOrderID
                                where month(sh1.OrderDate) = 7 and year(sh1.OrderDate) = 2011
                                group by p1.ProductID,p1.Name
                                order by count(sd1.OrderQty) desc)