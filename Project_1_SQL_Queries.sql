------------------------------------------------------------------------------------------------------------------------------
-- Project 1: Customer Segmentation and Lifetime Value Analysis based on sample DB --
------------------------------------------------------------------------------------------------------------------------------
-- KPI Calculation --

-- Functions and techniques used in queries:

-- SQL Subqueries technique for SELECT in SELECT and transparency of the query
-- LAG function for counting of difference between the actual period and the previous period
-- CONCAT function for year and month get-together for data modeling in PowerBI
-- RIGHT function for adding zeros for standard length
-- CASE expression for returning values from conditions
-- ABS function used to get absolute value
-- CAST function for setting the required datatype
-- CONVERT for converting to concrete data type needed
-- Year or Month function for extracting year or month from column with dates
-- Count together with group by function for counting requred values in groups
-- ALIAS using for columns defining


SELECT
	Year, 
	Month,
	CONCAT(Year, RIGHT('00' + CAST(Month as VARCHAR(2)), 2)) as YearMonth,
	ActiveMember as Nr_of_customers, 
	Nr_of_orders, 
	TotalSales,
	Churn_rate,
	AVP, 
	AFP,
	CASE WHEN ACL IS NULL THEN 0 ELSE ACL END as ACL,
	CASE WHEN (AVP * AFP * ACL) IS NULL THEN 0 ELSE ABS(AVP * AFP * ACL) END  as CLV
FROM (	
	SELECT
	  Year, 
	  Month, 
	  ActiveMember, 
	  Nr_of_orders, 
	  TotalSales,
	  Churn_rate,
	  AVP, 
	  AFP,
	  CASE WHEN Churn_rate = 0 THEN NULL ELSE 1 / Churn_rate END as ACL
	FROM (	SELECT 
			Year, 
			Month, 
			ActiveMember, 
			Nr_of_orders, 
			TotalSales,
			CAST(((ActiveMemberpreviousMonth - ActiveMember) / ActiveMemberpreviousMonth) as FLOAT(2)) as Churn_rate,
			TotalSales / Nr_of_orders AS AVP,												-- Avarage purchase value (AVP)
			Nr_of_orders / ActiveMember AS AFP				-- Avarage purchase value (AFP)
			FROM (		SELECT
							Year([OrderDate]) as Year, 
							Month([OrderDate]) as Month, 
							CAST(Count(DISTINCT CustomerKey) as FLOAT(2)) as ActiveMember,
							CAST(LAG(Count(DISTINCT CustomerKey), 1, 1) 
							OVER(ORDER BY Year([OrderDate]), Month([OrderDate]) ASC) as FLOAT(2)) as ActiveMemberpreviousMonth,
							Count(DISTINCT SalesOrderNumber) as Nr_of_orders,
							SUM(SalesAmount) as TotalSales
						FROM [AdventureWorksDW2019].[dbo].FactInternetSales 
						GROUP BY Year([OrderDate]), Month([OrderDate])
				) as A
			) as B
		) as C
ORDER BY Year, Month ASC; 
 
 
 ------------------------------------------------------------------------------------------------------------------------------

 -- Extracting of basic data about Customers --

-- Basic functions and techniques used:

-- CONCAT function to add additional information
-- DATEDIFF function to calculate the age of customers
-- LEFT JOIN command to add information about the city and country for every customer
-- Marking some columns to eliminate ambiguous columns
-- Using ORDER BY command for sorting and clarity
-- Naming columns for identification in POWER BI
-- Column filtering with comments
-- UNION operator to connect two tables together (additional query bellow)

SELECT 
  c.[CustomerKey] AS CustomerKey, 
  CONCAT(c.FirstName, ' ', c.Lastname) AS FullName, 
  CASE c.Gender when 'M' then 'Male' when 'F' then 'Female' end as Sex,
  c.[Birthdate] AS BirthDate,
  DATEDIFF(YEAR, c.[Birthdate], GETDATE()) as Age, 
  c.[YearlyIncome], 
  c.[TotalChildren], 
  g.[City] AS City, 
  g.[EnglishCountryRegionName] AS CountryRegionName,
  [DateFirstPurchase]
FROM 
  [AdventureWorksDW2019].[dbo].[DimCustomer] AS c 
  LEFT JOIN [AdventureWorksDW2019].[dbo].[DimGeography] AS g ON c.[GeographyKey] = g.[GeographyKey] 
ORDER BY 
  CustomerKey
  ;


------------------------------------------------------------------------------------------------------------------------------

-- Extracting of basic data about products --

-- Basic functions and techniques used:

-- CONCAT function to add additional information
-- DATEDIFF function to calculate the age of customers
-- LEFT JOIN command to add information about the city and country for every customer
-- Marking some columns to eliminate ambiguous columns
-- Using ORDER BY command for sorting and clarity
-- Naming columns for identification in POWER BI
-- Column filtering with comments
-- UNION operator to connect two tables together (additional query bellow)


SELECT 
  p.[ProductKey], 
  p.[ProductSubcategoryKey], 
  p.[EnglishProductName], 
  p.[Color], 
  p.[Size], 
  p.[ProductLine], 
  p.[DealerPrice], 
  p.[Class], 
  p.[ModelName], 

  ISNULL (p.Status, 'Obsolete') AS [Product Status],
  psk.EnglishProductSubcategoryName as [Sub Category],
  pck.EnglishProductCategoryName as [Product Category]
FROM 
  [AdventureWorksDW2019].[dbo].[DimProduct] AS p 
  LEFT JOIN [AdventureWorksDW2019].[dbo].DimProductSubcategory AS psk ON psk.ProductSubcategoryKey = p.ProductSubcategoryKey 
  LEFT JOIN [AdventureWorksDW2019].[dbo].DIMproductcategory AS pck ON psk.Productcategorykey = pck.productcategorykey
  ;



------------------------------------------------------------------------------------------------------------------------------

   -- Extracting of basic data about sales --
   
  SELECT 
  [ProductKey], 
  [OrderDateKey],
  [OrderQuantity],
  [CustomerKey] AS Customer_Reseller_key, 
  [SalesTerritoryKey], 
  [SalesOrderNumber], 
  [UnitPrice], 
  [SalesAmount], 
  [TaxAmt], 
  [Freight], 
  [OrderDate], 
  [ShipDate],
  'Internet_customer' AS Source
FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales]
  UNION
SELECT
  [ProductKey], 
  [OrderDateKey],
  [OrderQuantity],
  [ResellerKey] as Customer_Reseller_key, 
  [SalesTerritoryKey], 
  [SalesOrderNumber], 
  [UnitPrice], 
  [SalesAmount], 
  [TaxAmt], 
  [Freight], 
  [OrderDate], 
  [ShipDate],
  'Resseller' AS Source
  FROM 
  [AdventureWorksDW2019].[dbo].[FactResellerSales]
  ;



 ------------------------------------------------------------------------------------------------------------------------------

   -- Extracting of calendar data --

  SELECT 
	[DateKey],
	SUBSTRING(CAST(DateKey as VARCHAR(8)), 1, 6) AS YearMonth,
	[FullDateAlternateKey], 
	[EnglishDayNameOfWeek], 
	[CalendarYear],
	SUBSTRING([EnglishMonthName], 1, 3) AS ShortMonth,
	[MonthNumberOfYear]
	FROM 
  [AdventureWorksDW2019].[dbo].[DimDate];