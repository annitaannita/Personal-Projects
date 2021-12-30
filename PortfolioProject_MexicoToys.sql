--This is a simple project for personal SQL Exercise
--I use the Mexico Toy Sales Database from Kaggle Datasets
--(All data are fictitious chain of toy stores in Mexico)
--There are four tables that are going to be used : Inventory, Products, Sales, and Store.
SELECT *
FROM PortfolioProject..Inventory

SELECT *
FROM PortfolioProject..Products

SELECT *
FROM PortfolioProject..Sales
ORDER BY Sale_ID;

SELECT *
FROM PortfolioProject..Store;

--First Opened Store
SELECT TOP(1) * 
FROM PortfolioProject..Store
ORDER BY YEAR(Store_Open_Date);

--Last Opened Store
SELECT TOP(1) * 
FROM PortfolioProject..Store
ORDER BY YEAR(Store_Open_Date) DESC;

--Stores Opened before year 2000
SELECT * 
FROM PortfolioProject..Store
WHERE YEAR(Store_Open_Date) < 2000
ORDER BY YEAR(Store_Open_Date);

--Number of Stores for Each City
SELECT Store_City, COUNT(Store_ID) AS Number_Of_Stores
FROM PortfolioProject..Store
GROUP BY Store_City;

--Number of Stores Based on Location
SELECT Store_Location, COUNT(Store_ID) AS Number_Of_Stores
FROM PortfolioProject..Store
GROUP BY Store_Location;

--Best 3 Stores Based On Total_Sales
SELECT TOP(3) st.Store_Name, ROUND(SUM(sl.Units_Sold*p.Product_Price),2) AS Total_Sales
FROM PortfolioProject..Store AS st
FULL OUTER JOIN PortfolioProject..Sales AS sl
ON st.Store_ID = sl.Store_ID
FULL OUTER JOIN PortfolioProject..Products AS p
ON p.Product_ID = sl.Product_ID
GROUP BY st.Store_Name
ORDER BY Total_Sales DESC;

--Overall Average Sales
SELECT ROUND(AVG(sl.Units_Sold*p.Product_Price),2) AS Overall_Avg
FROM PortfolioProject..Sales AS sl
FULL OUTER JOIN PortfolioProject..Products AS p
ON p.Product_ID = sl.Product_ID


--Average Total_Sales of Each Store
SELECT st.Store_Name, ROUND(AVG(sl.Units_Sold*p.Product_Price),2) AS Avg_Sales
FROM PortfolioProject..Store AS st
FULL OUTER JOIN PortfolioProject..Sales AS sl
ON st.Store_ID = sl.Store_ID
FULL OUTER JOIN PortfolioProject..Products AS p
ON p.Product_ID = sl.Product_ID
GROUP BY st.Store_Name
ORDER BY Avg_Sales DESC;

--Best 3 Stores Based On Total_Units_Sold
SELECT TOP(3) st.Store_Name, SUM(sl.Units_Sold) AS Total_Units_Sold
FROM PortfolioProject..Store AS st
FULL OUTER JOIN PortfolioProject..Sales AS sl
ON st.Store_ID = sl.Store_ID
GROUP BY st.Store_Name
ORDER BY Total_Units_Sold DESC;

--Bottom 3 Stores Based On Total_Sales
SELECT TOP(3) st.Store_Name, ROUND(SUM(sl.Units_Sold*p.Product_Price),2) AS Total_Sales
FROM PortfolioProject..Store AS st
FULL OUTER JOIN PortfolioProject..Sales AS sl
ON st.Store_ID = sl.Store_ID
FULL OUTER JOIN PortfolioProject..Products AS p
ON p.Product_ID = sl.Product_ID
GROUP BY st.Store_Name
ORDER BY Total_Sales;

--Bottom 3 Stores Based On Total_Units_Sold
SELECT TOP(3) st.Store_Name, SUM(sl.Units_Sold) AS Total_Units_Sold
FROM PortfolioProject..Store AS st
FULL OUTER JOIN PortfolioProject..Sales AS sl
ON st.Store_ID = sl.Store_ID
GROUP BY st.Store_Name
ORDER BY Total_Units_Sold;

-- Top 10 Most Favorite Products Based on Units_Sold in 2017
SELECT TOP(10) p.Product_Name, SUM(sl.Units_Sold) AS Total_Units_Sold
FROM PortfolioProject..Products AS p
FULL JOIN PortfolioProject..Sales AS sl
ON p.Product_ID = sl.Product_ID
WHERE Year(Date_Of_Transaction) = '2017'
GROUP BY p.Product_Name
ORDER BY Total_Units_Sold DESC;

--Top 10 Stores with the most stock units on hand
SELECT TOP(10) st.Store_Name, SUM(i.Stock_On_Hand) AS Total_Units_Stock
FROM PortfolioProject..Store AS st
FULL OUTER JOIN PortfolioProject..Inventory AS i
ON st.Store_ID = i.Store_ID
GROUP BY st.Store_Name
ORDER BY Total_Units_Stock DESC;

--Total Units_Sold for each month and year
SELECT  Year(Date_of_Transaction) AS Year_Transaction, MONTH(Date_of_Transaction) AS Monthly_Transaction, SUM(Units_Sold) AS Total_Units_Sold
FROM PortfolioProject..Sales
GROUP BY Year(Date_of_Transaction), MONTH(Date_of_Transaction)
ORDER BY Year(Date_of_Transaction), MONTH(Date_of_Transaction);

--Total Sales For Each Month and Year Order By Highest Sales
SELECT YEAR(Date_of_Transaction) AS Year_Transaction, MONTH(Date_of_Transaction) AS Monthly_Transaction, ROUND(SUM(sl.Units_Sold*p.Product_Price),2) AS Total_Sales
FROM PortfolioProject..Sales AS sl 
FULL OUTER JOIN PortfolioProject..Products AS p
ON p.Product_ID = sl.Product_ID
GROUP BY YEAR(Date_of_Transaction), MONTH(Date_of_Transaction)
ORDER BY Total_Sales DESC;

--Total Profit for Each Month Order By Highest Profit
SELECT YEAR(Date_of_Transaction) AS Year_Transaction, MONTH(Date_of_Transaction) AS Monthly_Transaction, ROUND(SUM(sl.Units_Sold*(p.Product_Price-p.Product_Cost)),2) AS Total_Profit
FROM PortfolioProject..Sales AS sl 
FULL OUTER JOIN PortfolioProject..Products AS p
ON p.Product_ID = sl.Product_ID
GROUP BY YEAR(Date_of_Transaction), MONTH(Date_of_Transaction)
ORDER BY YEAR(Date_of_Transaction), MONTH(Date_of_Transaction);

--MAXIMUM PROFIT Using Subquery
SELECT MAX(Total_Profit) AS Max_Total_Profit
FROM (SELECT YEAR(Date_of_Transaction) AS Year_Transaction, MONTH(Date_of_Transaction) AS Monthly_Transaction, ROUND(SUM(sl.Units_Sold*(p.Product_Price-p.Product_Cost)),2) AS Total_Profit
FROM PortfolioProject..Sales AS sl 
FULL OUTER JOIN PortfolioProject..Products AS p
ON p.Product_ID = sl.Product_ID
GROUP BY YEAR(Date_of_Transaction), MONTH(Date_of_Transaction)
) AS Subquery;

--MAXIMUM PROFIT Using CTEs
WITH Subs AS
(
SELECT YEAR(Date_of_Transaction) AS Year_Transaction, MONTH(Date_of_Transaction) AS Monthly_Transaction, ROUND(SUM(sl.Units_Sold*(p.Product_Price-p.Product_Cost)),2) AS Total_Profit
FROM PortfolioProject..Sales AS sl 
FULL OUTER JOIN PortfolioProject..Products AS p
ON p.Product_ID = sl.Product_ID
GROUP BY YEAR(Date_of_Transaction), MONTH(Date_of_Transaction)
)

SELECT MAX(Total_Profit) AS Max_Total_Profit
FROM Subs;
