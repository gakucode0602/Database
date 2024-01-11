create database QLThueSach
use QLThueSach
go

-- Câu 1 : 
create table Sach(
    MaSach char(10) constraint pk_MaSach primary key,
    TenSach nvarchar(50) not null unique,
    TacGia nvarchar(50) not null,
    TenNXB nvarchar(50) not null,
    GiaMua decimal(8,2) not null,
    GhiChu nvarchar(max)
)

create table KhachHang(
    MaKH int identity(1,1) constraint pk_MaKH primary key,
    TenKH nvarchar(50) not null,
    DiaChi nvarchar(100) not null,
    SoDienThoai nvarchar(12) unique not null,
    LoaiSachYeuThich nvarchar(100) null,
    GhiChu nvarchar(max)
)

create table ThueSach(
    MaKH int,
    MaSach char(10),
    NgayMuonSach datetime default(getdate()),
    NgayTraSach datetime default(getdate()),
    SoTienThu decimal(8,2) not null,
    GhiChu nvarchar(max),
    constraint pk_ThueSach primary key(MaKH,MaSach,NgayMuonSach),
    constraint fk_MaKH foreign key (MaKH) references KhachHang(MaKH),
    constraint fk_MaSach foreign key (MaSach) references Sach(MaSach)
)

insert into KhachHang
values 
('Phi Minh Quang','Dong Nai','123456','Hanh Dong',null),
('Hoang Anh Duy','KonTum','234567','Phieu luu',null),
('Tran Anh Khoi','Nha Trang','345678','Tinh cam',null)

insert into Sach
values 
('A1','Harry Potter','J.K.Rowling','Kim Dong',120000,null),
('A2','Shin','Japan','Kim Dong',150000,null),
('A3','Fairy Tail','Me','Kim Dong',80000,null)

insert into ThueSach
values 
(1,'A1','2023-11-1','2023-12-1',120000,null),
(2,'A3','2023-11-1','2023-12-1',80000,null),
(3,'A2','2023-11-1','2023-12-1',150000,null)

-- Cau 2 :
use AdventureWorks2019
go
-- 1 : 
select sd.ProductID,p.Name,avg(sd.OrderQty) as AverageOfQty
from Sales.SalesOrderDetail sd
join Production.Product p on sd.ProductID = p.ProductID
where sd.UnitPrice < 25
group by sd.ProductID,p.Name
having avg(sd.OrderQty) > 5

-- 2 :
select sc.PersonID,concat(p.FirstName,' ',p.LastName) as FullName,count(sd.SalesOrderID) as CountOfOrders
from Sales.Customer sc 
join Sales.SalesOrderHeader sh on sc.CustomerID = sh.CustomerID
join Sales.SalesOrderDetail sd on sd.SalesOrderID = sh.SalesOrderID
join Person.Person p on sc.PersonID = p.BusinessEntityID
where year(sh.OrderDate) between 2007 and 2008
group by sc.PersonID,concat(p.FirstName,' ',p.LastName)
having count(sd.SalesOrderID) > 25

-- 3 : 
select hd.DepartmentID,hd.GroupName,avg(hep.Rate) as AvgOfRate
from HumanResources.Department hd 
join HumanResources.EmployeeDepartmentHistory hed on hed.DepartmentID = hd.DepartmentID
join HumanResources.EmployeePayHistory hep on hep.BusinessEntityID = hed.BusinessEntityID
group by hd.DepartmentID,hd.GroupName
having avg(hep.Rate) > 30

-- 4 :

-- Cách 1 : Dùng IN 
select pp.ProductID,pp.Name
from Production.Product pp
where pp.Name like 'Long-Sleeve Logo Jersey%' 
and pp.ProductModelID in (
    select *
    from Production.ProductModel ppm
    where ppm.Name like '%Long-Sleeve%'
)

-- cách 2 : Dùng Exist 
select pp.ProductID,pp.Name
from Production.Product pp
where pp.Name like 'Long-Sleeve Logo Jersey%'
and exists (
    select *
    from Production.ProductModel ppm
    where ppm.ProductModelID = pp.ProductModelID
    and ppm.Name like '%Long-Sleeve%'
    )

-- Cách 3 : Cả IN và EXISTS
SELECT ProductID, Name
FROM Production.Product P
WHERE ProductModelID IN (
    SELECT ProductModelID
    FROM Production.ProductModel
    WHERE Name LIKE 'Long-Sleeve Logo Jersey%'
) AND EXISTS (
    SELECT 1
    FROM Production.ProductModel PM
    WHERE PM.ProductModelID = P.ProductModelID
    AND PM.Name LIKE 'Long-Sleeve Logo Jersey%'
);

