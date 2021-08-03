--Working with the SuperMart DB

SELECT * FROM Customer
SELECT * FROM Product
SELECT * FROM Sales

--Demonstrating Joins
SELECT * FROM Product AS prod
FULL OUTER JOIN Sales  AS sale
ON
prod.Product_ID = sale.Product_ID 

--Lets check the data types of the various columns in our tables
SELECT * FROM INFORMATION_SCHEMA.TABLES
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

--Lets change the data type of some columns in the sales table

ALTER TABLE Sales
ALTER column Profit float

ALTER TABLE Sales
ALTER column Quantity int

ALTER TABLE Sales
ALTER column Discount float

SELECT * FROM INFORMATION_SCHEMA.COLUMNS

--Using Aggregate Functions
SELECT DISTINCT(prod.Category), Sum(sale.Quantity) AS TotalNumberSold,SUM(sale.Sales) AS TotalAmountSold FROM Product AS prod
FULL OUTER JOIN Sales  AS sale
ON
prod.Product_ID = sale.Product_ID

GROUP BY prod.Category
order by TotalAmountSold DESC


--More on Aggregate Functions

--Lets calculate the quantity of items sold and the total Amount made food items where no profit was made
SELECT DISTINCT(prod.Category), Sum(sale.Quantity) AS TotalNumberSold,SUM(sale.Sales) AS TotalAmountSold FROM Product AS prod
FULL OUTER JOIN Sales  AS sale
ON
prod.Product_ID = sale.Product_ID
WHERE sale.Profit < 0
GROUP BY prod.Category
order by TotalAmountSold DESC

--Lets calculate the quantity of items sold and the total Amount made food items where Profit profit was made
SELECT DISTINCT(prod.Category), Sum(sale.Quantity) AS TotalNumberSold,SUM(sale.Sales) AS TotalAmountSold 
FROM Product AS prod
FULL OUTER JOIN Sales  AS sale
ON
prod.Product_ID = sale.Product_ID
WHERE sale.Profit > 0
GROUP BY prod.Category
order by TotalAmountSold DESC

SELECT * FROM Customer
SELECT * FROM Product
SELECT * FROM Sales

--Lets Extract the Total Number of item bought per customer and the Total Amount Made

SELECT  DISTINCT(Customer_Name), City,State, SUM(sal.Quantity) As TotalQuantityPurchased, SUM(sal.Sales) AS TotalAmount
FROM Customer AS Cust
JOIN Sales AS sal
ON Cust.Customer_ID = sal.Customer_ID
GROUP BY Customer_Name, City, State
Order by TotalAmount DESC

--FROM The Query Above, we can see that Sean Miller from North Carolina carried out the most  purchase
-- Now let see the types of items he bought

--First let get the Customer_ID Of the Customer 
SELECT Customer_ID FROM Customer
WHERE Customer_Name = 'Sean Miller'
--SM-20320

SELECT * FROM Product
SELECT * FROM Sales

SELECT DISTINCT(prod.Sub_Category), Sum(sal.Quantity) AS TotalNumberSold, SUM(sal.Sales) AS TotalAmountSold 
FROM Product AS prod
FULL OUTER JOIN Sales  AS sal
ON
prod.Product_ID = sal.Product_ID
WHERE sal.Customer_ID = 'SM-20320'
GROUP BY prod.Sub_Category
order by TotalAmountSold DESC

--Using VIEWS

--Let's get the Total Quantity and Amount of sales per State
CREATE VIEW SalesPerState AS
SELECT  DISTINCT(State), SUM(sal.Quantity) As TotalQuantityPurchased, SUM(sal.Sales) AS TotalAmount
FROM Customer AS Cust
JOIN Sales AS sal
ON Cust.Customer_ID = sal.Customer_ID
GROUP BY State

SELECT * FROM Customer

--Let's get the Total Quantity and Amount of sales per Region
CREATE VIEW SalesPerRegion AS
SELECT  DISTINCT(Region), SUM(sal.Quantity) As TotalQuantityPurchased, SUM(sal.Sales) AS TotalAmount
FROM Customer AS Cust
JOIN Sales AS sal
ON Cust.Customer_ID = sal.Customer_ID
GROUP BY Region

SELECT * FROM SalesPerState
order by TotalAmount asc

SELECT * FROM Customer

--Lets Determine The Number of Customers that sold per State, their Quantity and Amount Sold
SELECT DISTINCT(cust.State), COUNT(cust.Customer_Name) As CustomerCount,
SUM(sal.Quantity) As TotalQuantitySold, SUM(sal.Sales) As TotalAmountSold
FROM Customer as cust
JOIN Sales as sal
ON cust.Customer_ID = sal.Customer_ID
GROUP BY State
ORDER BY TotalAmountSold DESC

SELECT * FROM Sales

--Lets create a new column, to hold just the year various items were ordered,
--So we can determine the quantity of items ordered per year and the amount sold

--First lets try to seperate the year from the date.
--SELECT NewOrder_Date, LEFT(NewOrder_Date, CHARINDEX('-',NewOrder_Date)-1)
--FROM Sales 

--Now lets create a new column in the Sales table, to hold the various Years

ALTER TABLE Sales
Add YearOrdered int 

Update Sales
SET YearOrdered =  LEFT(NewOrder_Date, CHARINDEX('-',NewOrder_Date)-1)
FROM Sales

--Lets Preview the Sales Table
SELECT * from Sales

SELECT YearOrdered, SUM(Quantity) AS QuantitySold, SUM(Sales) AS TotalSales
FROM Sales
GROUP BY YearOrdered
ORDER BY YearOrdered

SELECT * FROM Customer
SELECT * FROM Sales

--Runs correct
--Let's look at the daily Commulative State contribution to total Sales per Day
SELECT  State, sal.Order_Date, sal.Sales, SUM(Sales)
OVER (PARTITION BY State order by sal.Order_Date, Cust.State, sal.Sales ) AS RollingTotalSales
FROM Customer AS Cust
JOIN Sales AS sal
ON Cust.Customer_ID = sal.Customer_ID
order by State, sal.Order_Date 

--Lets look at the MTD(Month To Date) AND YTD(Year To Date) Cummulative sales

SELECT Order_Date, Sales, SUM(Sales)
OVER (PARTITION BY Year(Order_Date), Month(Order_Date) ORDER BY Order_Date,  sales) AS MTD,
SUM(Sales) OVER (PARTITION BY Year(Order_Date) ORDER BY Order_Date,  sales) AS YTD
FROM Sales





