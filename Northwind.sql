use Northwind
go


-- BTH 2

-- 1
-- Decartes
select c.*,o.*
from Customers c,Orders o 

-- Using join
select c.*,o.*
from Customers c
join Orders o
on c.CustomerID = o.CustomerID

-- 2
select c.CustomerID,c.CompanyName,c.ContactName,c.Address,c.City
from Customers c
where c.City = 'London' or c.Country = 'France'

-- 3
select *
from Customers
where (Country = 'USA' and ContactTitle = 'Sales Manager') or (Country = 'Mexico' and ContactTitle = 'Owner')

-- 4
select *
from Customers
where (Country = 'USA' and ContactTitle  like'%Manager%') or (Country <> 'Mexico' and ContactTitle = 'Owner')


-- 5
select o.OrderID,o.OrderDate,c.CompanyName,e.LastName
from Orders o
join Customers c 
on o.CustomerID = c.CustomerID
join Employees e 
on o.EmployeeID = e.EmployeeID
where month(o.OrderDate) <= 6 and year(o.OrderDate) = 1997

-- 6
select o.OrderID,o.OrderDate,o.CustomerID,o.EmployeeID
from Orders o
where month(o.OrderDate) = 2 and year(o.OrderDate) = 1997

-- 7
select OrderID,OrderDate,Freight
from Orders
where OrderID = 2 and year(OrderDate) = 1997 and ShipCountry = 'UK' 

-- 8
select p.ProductID,p.ProductName
from Products p 
where p.ProductName like 'Ch%'

-- 9
select p.ProductID,p.UnitPrice,p.UnitsInStock
from Products p
where p.Discontinued = 1 and p.UnitsInStock > 0

-- 10
select c.CompanyName,c.ContactName,c.Country,c.Phone,c.Fax
from Customers c
where c.Country <> 'USA'

-- 11
select c.CompanyName,c.ContactName,c.Country,c.Phone,c.Fax
from Customers c 
where c.Country not in ('Brazil','Italy','Spain','Venezuela','UK')

-- 12
select o.OrderID,o.CustomerID,o.EmployeeID,o.OrderDate,o.ShipCountry,o.ShippedDate,o.Freight
from Orders o
where (o.ShipCountry = 'USA' and o.Freight > 300) or (o.ShipCountry = 'Argetina' and o.Freight < 5)

-- 13
select o.OrderID,o.CustomerID,o.EmployeeID,o.OrderDate,o.ShipCountry,o.ShippedDate,o.Freight
from Orders o
where (o.ShipCountry = 'USA' and o.Freight > 300) or (o.ShipCountry = 'Argetina' and o.Freight < 5)

-- 14
select o.OrderID,o.OrderDate,o.CustomerID,o.EmployeeID,o.Freight, NewFreight = o.Freight * 1.1
from Orders o
where month(o.OrderDate) = 4 and year(o.OrderDate) = 1997 

-- 15
select p.ProductID,p.ProductName,s.ContactName,p.UnitPrice,p.UnitsInStock,Total = p.UnitPrice * p.UnitsInStock,s.Fax
from Products p 
join Suppliers s 
on p.SupplierID = s.SupplierID
where p.Discontinued = 1

-- 16
select e.TitleOfCourtesy + left(e.LastName,1) + ' ' + e.FirstName as Name,e.HireDate,e.BirthDate,e.HomePhone
from Employees e
where year(e.HireDate) <= 1993

-- 17
select o.OrderID,o.OrderDate,c.CompanyName,e.LastName
from Orders o
join Customers c 
on o.CustomerID = c.CustomerID
join Employees e 
on o.EmployeeID = e.EmployeeID
where month(o.OrderDate) = 4

-- 18
select o.OrderID,o.OrderDate,c.CompanyName,e.LastName
from Orders o
join Customers c 
on o.CustomerID = c.CustomerID
join Employees e 
on o.EmployeeID = e.EmployeeID
where (year(o.OrderDate) % 2) = 0

-- 19
select o.OrderID,o.OrderDate,c.CompanyName,e.LastName
from Orders o
join Customers c 
on o.CustomerID = c.CustomerID
join Employees e 
on o.EmployeeID = e.EmployeeID
where day(o.OrderDate) in (5,13,14,23)

-- 20
select o.OrderID,p.ProductName,p.UnitPrice,o.Quantity,[Thanh tien] = p.UnitPrice * o.Quantity,o.Discount,[Tien giam gia] = (p.UnitPrice * o.Quantity) * o.Discount,[Tien phai tra] = (p.UnitPrice * o.Quantity) - ((p.UnitPrice * o.Quantity) * o.Discount)
from [Order Details] o
join Products p 
on o.ProductID = p.ProductID

-- 21
select o.OrderID,p.ProductName,p.UnitPrice,o.Quantity,[Thanh tien] = p.UnitPrice * o.Quantity,o.Discount,[Tien giam gia] = (p.UnitPrice * o.Quantity) * o.Discount,[Tien phai tra] = (p.UnitPrice * o.Quantity) - ((p.UnitPrice * o.Quantity) * o.Discount)
from [Order Details] o
join Products p 
on o.ProductID = p.ProductID
where o.Discount > 0 and (p.UnitPrice * o.Quantity) - ((p.UnitPrice * o.Quantity) * o.Discount) < 50

-- 22
select count(p.ProductID) as So_luong_SP,max(p.UnitPrice) as Don_cao_nhat,min(p.UnitPrice),avg(p.UnitPrice) as Gia_TB
from Products p

-- 23
select count(p.ProductID) as So_luong_SP,max(p.UnitPrice) as Don_cao_nhat,min(p.UnitPrice),avg(p.UnitPrice) as Gia_TB
from Products p
group by p.CategoryID

-- 24
select o.ShipCountry,count(o.ShipCountry) as So_luong
from Orders o 
where o.ShipCountry in ('Belgium','Canada','UK')
group by o.ShipCountry

-- 25
select p.CategoryID,avg(p.UnitPrice) as Gia_TB 
from Products p 
group by p.CategoryID
having avg(p.UnitPrice) >= 30

-- 26
select p.CategoryID,avg(p.UnitPrice) as Giatrungbinh
from Products p
where p.UnitPrice > 30
group by p.CategoryID

-- 27
select c.CategoryName, sales = p.UnitPrice * o.Discount * (1-o.Discount)
from Categories c 
join Products p 
on c.CategoryID = p.CategoryID
join [Order Details] o
on  o.ProductID = p.ProductID

-- 28

select c.CompanyName,o.Freight,p.UnitPrice * od.Quantity * (1 - od.Discount) as Sales_Total ,
       o.Freight /  (p.UnitPrice * od.Quantity * (1 - od.Discount)) as [Percent]
from Customers c
join Orders o
on c.CustomerID = o.CustomerID
join [Order Details] od 
on od.OrderID = o.OrderID 
join Products p 
on p.ProductID = od.ProductID

-- BTH 3

-- 1 / Make Table
select * from Customers

-- 3.1
select *
into CacKhachHangMy
from Customers 
where Country  = 'USA'

select * from CacKhachHangMy
select * from Orders
select * from [Order Details]

-- 3.2
select top 5 e.EmployeeID,e.FirstName + ' ' + e.LastName as Name,count(o.EmployeeID) as Total_Orders
into Tim5NhanVienGioi
from Orders o 
join Employees e 
on o.EmployeeID = e.EmployeeID
group by e.EmployeeID,e.FirstName + ' ' + e.LastName
order by count(o.EmployeeID) desc

select * from Tim5NhanVienGioi

-- 3.3
select top 10 c.CustomerID,c.CompanyName,c.Address + ' ' + c.City + ' ' + c.Country as Address,count(o.CustomerID) as Total_Orders
into Tim10KhachHang
from Customers c
join Orders o
on c.CustomerID = o.CustomerID
group by c.CustomerID,c.CompanyName,c.Address + ' ' + c.City + ' ' + c.Country
order by count(o.CustomerID) desc

select * from Tim10KhachHang

-- 3.4
select * from Products

select top 5 o.ShipCountry--,count(od.ProductID) as Total_Products
into TimTop5QGMuaHang
from Orders o 
join [Order Details] od 
on o.OrderID = od.OrderID
group by o.ShipCountry
order by count(od.ProductID) desc



-- 3.5
select top 5 o.ShipCountry--,count(od.ProductID) as Total_Products
into Tim5QGItMuaHang
from Orders o 
join [Order Details] od 
on o.OrderID = od.OrderID
group by o.ShipCountry
order by count(od.ProductID) asc

select * from Tim5QGItMuaHang

-- 2 / update table
-- 1
update Customers
set Country = N'Mỹ'
where Country = 'USA'
select * from Customers

-- 2
update Customers
set Country = (case when Country = 'Germany' then N'Đức' when Country = 'France' then N'Pháp' end)
where Country in ('Germany','France')

-- 3

