-- OVERVIEW
-- Extracting of basic data about Customers --
-- Extracting and KPI's counting for PowerBI DASHBOARD --
-- Extracting of information about internet sales and reseller data --
-- Extracting of information about products --
-- Extracting of Calendar data --



-- Functions and techniques used in queries:

-- Column filtering with comments
-- CONCAT function to add additional information
-- DATEDIFF function to calculate the age of customers
-- LEFT JOIN command to add information about the city and country for every customer
-- UNION operator to connect two tables together
-- Marking some columns to eliminate ambiguous columns
-- Using ORDER BY command for sorting and clarity
-- Naming columns for identification in POWER BI

-- SQL Subqueries technique for SELECT in SELECT and transparency of the query
-- LEAD function for counting of difference between actual period and previous period
-- CONVERT for converting to concrete data type needed

-- Extracting of basic data about Customers --

SELECT 
  c.[CustomerKey] AS CustomerKey, 
  CONCAT(c.FirstName, ' ', c.Lastname) AS FullName, 
  CASE c.Gender when 'M' then 'Male' when 'F' then 'Female' end as Sex, 
  DATEDIFF(YEAR, c.[Birthdate], GETDATE()) as Age, 
  c.[YearlyIncome], 
  c.[TotalChildren], 
  g.[City] AS City, 
  g.[EnglishCountryRegionName] AS CountryRegionName, 
  'Customer' as Source
  --c.[GeographyKey] AS GeographyKey, 
  --[CustomerAlternateKey], 
  --[Title], 
  --[FirstName] AS FirstName, 
  --[MiddleName] AS MiddleName, 
  --[LastName] AS LastName,
  --[Gender],
  --[NameStyle], 
  --[BirthDate] AS BirthDate, 
  --[MaritalStatus], 
  --[Suffix], 
  --[EmailAddress], 
  --[NumberChildrenAtHome], 
  --[EnglishEducation], 
  --[SpanishEducation], 
  --[FrenchEducation], 
  --[EnglishOccupation], 
  --[SpanishOccupation], 
  --[FrenchOccupation], 
  --[HouseOwnerFlag], 
  --[NumberCarsOwned], 
  --[AddressLine1], 
  --[AddressLine2], 
  --[Phone], 
  --[DateFirstPurchase], 
  --[CommuteDistance]
FROM 
  [AdventureWorksDW2019].[dbo].[DimCustomer] AS c 
  LEFT JOIN [AdventureWorksDW2019].[dbo].[DimGeography] AS g ON c.[GeographyKey] = g.[GeographyKey] 
UNION 
SELECT 
  [ProspectiveBuyerKey] AS CustomerKey, 
  CONCAT(FirstName, ' ', Lastname) AS FullName, 
  CASE Gender when 'M' then 'Male' when 'F' then 'Female' end as Sex, 
  DATEDIFF(YEAR, [Birthdate], GETDATE()) as Age, 
  [YearlyIncome], 
  [TotalChildren], 
  g.[City] AS City, 
  g.[EnglishCountryRegionName] AS CountryRegionName,
  'Prospective' as Source
FROM 
  [AdventureWorksDW2019].[dbo].[ProspectiveBuyer] AS c 
  LEFT JOIN [AdventureWorksDW2019].[dbo].[DimGeography] AS g ON c.[City] = g.[City] 
ORDER BY 
  CustomerKey
  ;


-- Extracting of and KPI's counting for PowerBI DASHBOARD --

SELECT 
  Year, 
  Month, 
  Customers_number, 
  Orders_number, 
  TotalSales, 
  CONVERT(DECIMAL(10, 1), DiffCustNum) / CONVERT(DECIMAL(10, 1), Customers_number) as Churn_rate, 
  AVP, 
  AFP,
  ACL
FROM 
  (
    SELECT 
      Year([OrderDate]) as Year, 
      Month([OrderDate]) as Month, 
      Count(DISTINCT CustomerKey) as Customers_number, 
      Count(DISTINCT SalesOrderNumber) as Orders_number, 
      SUM(SalesAmount) as TotalSales, 
      Count(DISTINCT CustomerKey) - (LEAD(COUNT(DISTINCT CustomerKey), 1,0)
			OVER(ORDER BY Year([OrderDate]), Month([OrderDate]) ASC)) as DiffCustNum, 
      SUM(SalesAmount) / COUNT(SalesOrderNumber) AS AVP,					-- Avarage purchase value (AVP)
      COUNT(SalesOrderNumber) / Count(DISTINCT CustomerKey) AS AFP,				-- Avarage purchase value (AFP)
	  1 / NULLIF(CONVERT(DECIMAL(10, 1), Count(DISTINCT CustomerKey) - (LEAD(COUNT(DISTINCT CustomerKey), 1,0)
			OVER(ORDER BY Year([OrderDate]), Month([OrderDate]) ASC))), 0) AS ACL
    FROM 
      [AdventureWorksDW2019].[dbo].FactInternetSales 
    GROUP BY 
      Year([OrderDate]), 
      Month([OrderDate])
  ) as Agregated 
ORDER BY 
  Year, 
  Month ASC
  ;
   


-- Extracting of information about internet sales and reseller data --

  SELECT 
  [ProductKey], 
  [OrderDateKey], 
  --[DueDateKey], 
  --[ShipDateKey], 
  [CustomerKey] as Customer_Reseller_key, 
  --[PromotionKey], 
  --[CurrencyKey], 
  [SalesTerritoryKey], 
  [SalesOrderNumber], 
  --[SalesOrderLineNumber], 
  --[RevisionNumber], 
  --[OrderQuantity], 
  [UnitPrice], 
  --[ExtendedAmount], 
  --[UnitPriceDiscountPct], 
  --[DiscountAmount], 
  --[ProductStandardCost], 
  --[TotalProductCost], 
  [SalesAmount], 
  [TaxAmt], 
  [Freight], 
  --[CarrierTrackingNumber], 
  --[CustomerPONumber], 
  [OrderDate], 
  --[DueDate], 
  [ShipDate] 
FROM 
  [AdventureWorksDW2019].[dbo].[FactInternetSales] 
UNION 
SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [ResellerKey] as Customer_Reseller_key, 
  [SalesTerritoryKey], 
  [SalesOrderNumber], 
  [UnitPrice], 
  [SalesAmount], 
  [TaxAmt], 
  [Freight], 
  [OrderDate], 
  [ShipDate] 
FROM 
  [AdventureWorksDW2019].[dbo].[FactResellerSales]
  ;

-- Extracting of information about products --

  SELECT 
  p.[ProductKey], 
  --[ProductAlternateKey], 
  p.[ProductSubcategoryKey], 
  --[WeightUnitMeasureCode], 
  --[SizeUnitMeasureCode], 
  p.[EnglishProductName], 
  --[SpanishProductName], 
  --[FrenchProductName], 
  --[StandardCost], 
  --[FinishedGoodsFlag], 
  p.[Color], 
  --[SafetyStockLevel], 
  --[ReorderPoint], 
  --[ListPrice], 
  p.[Size], 
  --[SizeRange], 
  --[Weight], 
  --[DaysToManufacture], 
  p.[ProductLine], 
  p.[DealerPrice], 
  p.[Class], 
  --[Style], 
  p.[ModelName], 
  --[LargePhoto], 
  --[EnglishDescription], 
  --[FrenchDescription], 
  --[ChineseDescription], 
  --[ArabicDescription], 
  --[HebrewDescription], 
  --[ThaiDescription], 
  --[GermanDescription], 
  --[JapaneseDescription], 
  --[TurkishDescription], 
  --[StartDate], 
  --[EndDate],
  ISNULL (p.Status, 'Obsolete') AS [Product Status],
  psk.EnglishProductSubcategoryName as [Sub Category],
  pck.EnglishProductCategoryName as [Product Category]
FROM 
  [AdventureWorksDW2019].[dbo].[DimProduct] AS p 
  LEFT JOIN [AdventureWorksDW2019].[dbo].DimProductSubcategory AS psk ON psk.ProductSubcategoryKey = p.ProductSubcategoryKey 
  LEFT JOIN [AdventureWorksDW2019].[dbo].DIMproductcategory AS pck ON psk.Productcategorykey = pck.productcategorykey
  ;


-- Extracting of Calendar data --

  SELECT 
  [DateKey], 
  [FullDateAlternateKey], 
  [DayNumberOfWeek], 
  [EnglishDayNameOfWeek], 
  --[SpanishDayNameOfWeek], 
  --[FrenchDayNameOfWeek], 
  --[DayNumberOfMonth], 
  --[DayNumberOfYear], 
  [WeekNumberOfYear], 
  [EnglishMonthName], 
  --[SpanishMonthName], 
  --[FrenchMonthName], 
  [MonthNumberOfYear], 
  --[CalendarQuarter], 
  [CalendarYear] 
  --[CalendarSemester], 
  --[FiscalQuarter], 
  --[FiscalYear], 
  --[FiscalSemester] 
FROM 
  [AdventureWorksDW2019].[dbo].[DimDate]