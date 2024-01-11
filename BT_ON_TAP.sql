use AdventureWorks2019
go 

-- I . Select
-- 1 .
select sh.SalesOrderID,sh.OrderDate,Subtotal = sum(sd.OrderQty * sd.UnitPrice)
from Sales.SalesOrderHeader sh 
join Sales.SalesOrderDetail sd 
on sh.SalesOrderID = sd.SalesOrderID
where month(sh.OrderDate) = 6 and year(sh.OrderDate) = 2008
group by sh.SalesOrderID,sh.OrderDate
having sum(sd.OrderQty * sd.UnitPrice) > 70000


-- 2 .
-- TerritoryID : Là ID chỉ địa bàn lãnh thổ
-- CustomerID : ID của khách hàng
select st.TerritoryID,count(sc.CustomerID) as CountOfCust,sum(sd.OrderQty * sd.UnitPrice) as SubTotal 
from Sales.SalesTerritory st 
join Sales.Customer sc 
on st.TerritoryID = sc.TerritoryID
join Sales.SalesOrderHeader sh
on sc.CustomerID = sh.CustomerID
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID
where st.CountryRegionCode = 'US'
group by st.TerritoryID

-- 3 .
select sod.SalesOrderID,sod.CarrierTrackingNumber,SubTotal = sum(sod.OrderQty * sod.UnitPrice)
from Sales.SalesOrderDetail sod 
where CarrierTrackingNumber like N'4BD%'
group by sod.SalesOrderID,sod.CarrierTrackingNumber

-- 4 .
select p.ProductID,p.Name,avg(sod.OrderQty) as AverageOfQty
from Production.Product p 
join Sales.SalesOrderDetail sod 
on sod.ProductID = p.ProductID
where sod.UnitPrice < 25
group by p.ProductID,p.Name
having avg(sod.OrderQty) > 5

-- 5 .
select he.JobTitle,CountOfPerson=count(he.JobTitle)
from HumanResources.Employee he
group by he.JobTitle
having count(he.JobTitle) > 20

-- 6
select pv.BusinessEntityID,pv.Name,ppd.ProductID,SumOfQty = sum(ppd.OrderQty),SubTotal = sum(ppd.OrderQty * ppd.UnitPrice)
from Purchasing.Vendor pv 
join Purchasing.PurchaseOrderHeader pph
on pv.BusinessEntityID = pph.VendorID
join Purchasing.PurchaseOrderDetail ppd 
on pph.PurchaseOrderID = ppd.PurchaseOrderID
where pv.Name like '%Bicycles'
group by pv.BusinessEntityID,pv.Name,ppd.ProductID
having sum(ppd.OrderQty * ppd.UnitPrice) > 800000

-- 7
select pp.ProductID,pp.Name,countOfOrderID = count(ssd.ProductID),SubTotal = sum(ssd.OrderQty * ssd.UnitPrice)
from Sales.SalesOrderDetail ssd 
join Sales.SalesOrderHeader ssh 
on ssd.SalesOrderID = ssh.SalesOrderID
join Production.Product pp 
on ssd.ProductID = pp.ProductID
where datepart("q",ssh.OrderDate) = 1 and year(ssh.OrderDate) = 2008
group by pp.ProductID,pp.Name
having sum(ssd.OrderQty * ssd.UnitPrice) > 10000

-- 8

select * from Person.Person where FirstName = 'Andrea'
select * from Sales.Customer

select sc.PersonID,concat(pp.FirstName,' ',pp.LastName) as FullName,count(ssh.SalesOrderID) as CountOfOrder
from Person.Person pp 
join Sales.Customer sc
on sc.PersonID = pp.BusinessEntityID
join Sales.SalesOrderHeader ssh
on sc.CustomerID = ssh.CustomerID
where year(ssh.OrderDate) between 2007 and 2008
group by sc.PersonID,concat(pp.FirstName,' ',pp.LastName)
having count(ssh.SalesOrderID) > 25




-- 9
select p.ProductID,p.name,count(ssd.ProductID) as countOfOrder,Year = year(ssh.OrderDate)
from Sales.SalesOrderDetail ssd 
join Sales.SalesOrderHeader ssh 
on ssd.SalesOrderID = ssh.SalesOrderID
join Production.Product p 
on ssd.ProductID = p.ProductID
where p.Name like 'Bike%' or p.Name like 'Sport%'
group by p.ProductID,p.name,year(ssh.OrderDate)
having count(ssd.ProductID) > 500

-- 10
select hd.DepartmentID,hd.Name,avg(hep.Rate)
from HumanResources.Department hd
join HumanResources.EmployeeDepartmentHistory hed 
on hd.DepartmentID = hed.DepartmentID
join HumanResources.EmployeePayHistory hep
on hed.BusinessEntityID = hep.BusinessEntityID
group by hd.DepartmentID,hd.Name
having avg(hep.Rate) > 30

-- II .
-- 1 .
select p.Name, p.ProductID
from Production.Product p
where p.ProductID in (
        select sd.ProductID,count(distinct sd.SalesOrderID)
        from Sales.SalesOrderHeader sh 
        join Sales.SalesOrderDetail sd on sh.SalesOrderID = sd.SalesOrderID
        where month(sh.OrderDate) = 5 and year(sh.OrderDate) = 2011
        group by sd.ProductID
        --having count(distinct sd.SalesOrderID) > 100
        order by count(distinct sd.SalesOrderID) desc
)

-- 2
select p.ProductID,p.Name
from Production.Product p
join Sales.SalesOrderDetail sd on p.ProductID = sd.ProductID
join Sales.SalesOrderHeader sh on sd.SalesOrderID = sh.SalesOrderID
where month(sh.OrderDate) = 5 and year(sh.OrderDate) = 2011
group by p.ProductID,p.Name
having count(distinct sd.SalesOrderID) >= (
        select top 1 count(distinct sd1.SalesOrderID)
        from Sales.SalesOrderDetail sd1 
        join Sales.SalesOrderHeader sh1 on sd1.SalesOrderID = sh1.SalesOrderID
        where month(sh1.OrderDate) = 5 and year(sh1.OrderDate) = 2011
        group by sd1.ProductID
        order by count(distinct sd1.SalesOrderID) desc
)

-- 3 
select *
from INFORMATION_SCHEMA.COLUMNS
where COLUMN_NAME like '%PersonID%'

select * from Person.Person

select top 1 sc.CustomerID,pp.FirstName + ' ' + pp.LastName as Name,count(distinct sd.SalesOrderID) as CountOfOrder
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd on sh.SalesOrderID = sd.SalesOrderID
join Sales.Customer sc on sc.CustomerID = sh.CustomerID
join Person.Person pp on sc.PersonID = pp.BusinessEntityID
group by sc.CustomerID,pp.FirstName + ' ' + pp.LastName
order by count(distinct sd.SalesOrderID) desc

-- 4
select pp.ProductID,pp.Name
from Production.Product pp
where pp.Name like 'Long-Sleeve Logo Jersey%'
and  pp.ProductModelID in (
        select ppm.ProductModelID
        from Production.ProductModel ppm 
        where ppm.Name like '%Long-Sleeve Logo Jersey%'
)