

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


  -- Rest columns --

  --[DueDateKey], 
  --[ShipDateKey], 
  --[PromotionKey], 
  --[CurrencyKey], 
  --[SalesOrderLineNumber], 
  --[RevisionNumber], 
  --[ExtendedAmount], 
  --[UnitPriceDiscountPct], 
  --[DiscountAmount], 
  --[TotalProductCost], 
  --[CarrierTrackingNumber], 
  --[CustomerPONumber], 
  --[DueDate],
  --[ProductStandardCost],
  --[PromotionKey], 
  --[RevisionNumber], 
  --[SalesOrderLineNumber],