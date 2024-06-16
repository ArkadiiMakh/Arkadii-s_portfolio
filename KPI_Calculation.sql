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
							CAST(LAG(Count(DISTINCT CustomerKey), 1, 1) OVER(ORDER BY Year([OrderDate]), Month([OrderDate]) ASC) as FLOAT(2)) as ActiveMemberpreviousMonth,
							Count(DISTINCT SalesOrderNumber) as Nr_of_orders,
							SUM(SalesAmount) as TotalSales
						FROM [AdventureWorksDW2019].[dbo].FactInternetSales 
						GROUP BY Year([OrderDate]), Month([OrderDate])
				) as A
			) as B
		) as C
ORDER BY Year, Month ASC; 
  

