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

  -- Rest columns --

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
  --[Style],
  --[SizeRange], 
  --[Weight], 
  --[DaysToManufacture],
  --[SafetyStockLevel], 
  --[ReorderPoint], 
  --[SpanishProductName], 
  --[FrenchProductName], 
  --[StandardCost], 
  --[FinishedGoodsFlag],
  --[ListPrice],
  --[WeightUnitMeasureCode], 
  --[SizeUnitMeasureCode],
