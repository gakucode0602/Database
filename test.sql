SELECT ProductID, Name AS Product_Name
FROM Production.Product 
WHERE ProductID IN (
        SELECT OD.ProductID
        FROM Sales.SalesOrderDetail OD
        JOIN Sales.SalesOrderHeader SOH ON OD.SalesOrderID = SOH.SalesOrderID
        WHERE YEAR(SOH.OrderDate) = 2011 AND MONTH(SOH.OrderDate) = 7
        GROUP BY OD.ProductID
        HAVING COUNT(DISTINCT SOH.SalesOrderID) > 100
)