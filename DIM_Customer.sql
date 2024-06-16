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