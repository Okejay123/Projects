USE SuperMart
GO

SELECT * FROM Customer
SELECT * FROM Sales
SELECT * FROM Product

--FIRST LETS GET THE SALES CARRIED OUT IN 2015 & 2016
SELECT Order_Date, Sales
FROM Sales
WHERE YEAR(Order_Date) IN (2015,2016)

--LETS GET THE AMOUNT SOLD, BASED ON YEAR AND MONTH
SELECT YEAR(Order_Date) AS [Year], MONTH(Order_Date) AS [Month], SUM(sales) AS Amount
FROM Sales
WHERE YEAR(Order_Date) IN (2015, 2016)
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date)

--LETS GET A COMPARISM OF THE CURRENT MONTH SALES AND THE PREVIOUS MONTH SALES

SELECT  YEAR(Order_Date) AS [Year], MONTH(Order_Date) AS [Month], SUM(sales) AS Amount,
LAG(SUM(Sales)) OVER (ORDER BY YEAR(Order_Date), MONTH(Order_Date)) AS [Previous Month Amount]
FROM Sales
WHERE YEAR(Order_Date) IN (2015, 2016)
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date)

/*RANDOM NOTE:
The LAG Function used above, takes 2 Arguements, i.e LAG(SUM(Sales)), offset) as seen in the example
above, no offset was defined, as such, it took the default value of 1, that is why we could compare the current
Month, with the previous month,

If we want to compare the same months of different Year, we would then have to specify an offset value of 12
*/

--LETS GET A COMPARISM OF MONTHLY SALES, BASED OF VARIOUS YEARS

SELECT  YEAR(Order_Date) AS [Year], MONTH(Order_Date) AS [Month], SUM(sales) AS Amount,
LAG(SUM(Sales),12) OVER (ORDER BY YEAR(Order_Date), MONTH(Order_Date)) AS [Previous Year Amount],

SUM(sales) -
LAG(SUM(Sales),12) OVER (ORDER BY YEAR(Order_Date), MONTH(Order_Date)) AS [Sales Difference]

FROM Sales
WHERE YEAR(Order_Date) IN (2015, 2016)
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY YEAR(Order_Date), MONTH(Order_Date)
