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
use AdventureWorks2022
go

-- 1
select sh.TerritoryID,count(distinct sh.CustomerID) as TongSoKhachHang,SubTotal = sum(sd.OrderQty * sd.UnitPrice)
from Sales.SalesOrderHeader sh 
join Sales.SalesOrderDetail sd 
on sh.SalesOrderID = sd.SalesOrderID
join Sales.SalesTerritory st 
on st.TerritoryID = sh.TerritoryID
where st.CountryRegionCode = 'US'
group by sh.TerritoryID

-- 2
select ppr.BusinessEntityID,pv.Name,ppr.ProductID,SumOfQty = sum(sv.OrderQty),SubTotal = sum(sv.OrderQty * sv.UnitPrice)
from Purchasing.ProductVendor ppr
join Purchasing.Vendor pv 
on ppr.BusinessEntityID = pv.BusinessEntityID
join Sales.SalesOrderDetail sv 
on ppr.ProductID = sv.ProductID
where pv.Name like '%Bicycles'
group by ppr.BusinessEntityID,pv.Name,ppr.ProductID
having sum(sv.OrderQty * sv.UnitPrice) > 800000

-- 3
select he.DepartmentID,hd.Name,avg(hep.Rate) as Luong_Trung_Binh
from HumanResources.EmployeeDepartmentHistory he 
join HumanResources.EmployeePayHistory hep 
on he.BusinessEntityID = hep.BusinessEntityID
join HumanResources.Department hd
on hd.DepartmentID = he.DepartmentID
group by he.DepartmentID,hd.Name
having avg(hep.Rate) > 30

-- 4
select * from Sales.SalesOrderDetail
select * from sales.SalesOrderHeader
select * from Production.Product
select * from Hu

select sd.ProductID,p.Name
from Sales.SalesOrderDetail sd 
join sales.SalesOrderHeader sh 
on sd.SalesOrderID = sh.SalesOrderID
join Production.Product p 
on p.ProductID = sd.ProductID
where month(sh.OrderDate) = 7 and year(sh.OrderDate) = 2008
group by sd.ProductID,p.Name

select sd.ProductID,p.Name,sd.OrderQty
from Sales.SalesOrderDetail sd
join sales.SalesOrderHeader sh 
on sd.SalesOrderID = sh.SalesOrderID
join Production.Product p 
on p.ProductID = sd.ProductID
where month(sh.OrderDate) = 7 and year(sh.OrderDate) = 2008 and 
        sd.OrderQty >= (select max(sd1.OrderQty)
                        from Sales.SalesOrderDetail sd1
                        join sales.SalesOrderHeader sh1 
                        on sd1.SalesOrderID = sh1.SalesOrderID
                        where month(sh1.OrderDate) = 7 and year(sh1.OrderDate) = 2008
                        )