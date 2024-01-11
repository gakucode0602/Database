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
select c.TerritoryID,count(c.CustomerID) as CountOfCust,sum(sd.OrderQty * sd.UnitPrice) as SubTotal
from Sales.Customer c 
join Sales.SalesTerritory st on c.TerritoryID = st.TerritoryID
join Sales.SalesOrderHeader sh on sh.CustomerID = c.CustomerID
join Sales.SalesOrderDetail sd on sh.SalesOrderID = sd.SalesOrderID
where st.CountryRegionCode = 'US'
group by c.TerritoryID

-- 2.2
select pv.BusinessEntityID,pv.Name,ppd.ProductID,SumOfQty = sum(ppd.OrderQty),SubTotal = sum(ppd.OrderQty * ppd.UnitPrice)
from Purchasing.Vendor pv 
join Purchasing.PurchaseOrderHeader pph on pv.BusinessEntityID = pph.VendorID
join Purchasing.PurchaseOrderDetail ppd on pph.PurchaseOrderID = ppd.PurchaseOrderID
where pv.Name like '%Bicycles'
group by pv.BusinessEntityID,pv.Name,ppd.ProductID
having sum(ppd.OrderQty * ppd.UnitPrice) > 800000

-- 2.3
select hd.DepartmentID,hd.Name,avg(he.Rate) as AvgofRate
from HumanResources.Department hd 
join HumanResources.EmployeeDepartmentHistory hed on hd.DepartmentID = hed.DepartmentID
join HumanResources.EmployeePayHistory he on he.BusinessEntityID = hed.BusinessEntityID
group by hd.DepartmentID,hd.Name
having avg(he.Rate) > 30

-- 2.4
select p.ProductID,p.Name
from Production.Product p
join Sales.SalesOrderDetail sd on sd.ProductID = p.ProductID
join Sales.SalesOrderHeader sh on sh.SalesOrderID = sd.SalesOrderID
where month(sh.OrderDate) = 5 and year(sh.OrderDate) = 2014
group by p.ProductID,p.Name
having count(distinct sd.SalesOrderID) >= all(
    select top 1 count(distinct sd1.SalesOrderID)
    from Sales.SalesOrderDetail sd1
    join Sales.SalesOrderHeader sh1 on sd1.SalesOrderID = sh1.SalesOrderID
    where month(sh1.OrderDate) = 5 and year(sh1.OrderDate) = 2014
    group by sd1.ProductID
    order by count(distinct sd1.SalesOrderID) desc
)
