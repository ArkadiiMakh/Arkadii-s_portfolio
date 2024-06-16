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

  -- Rest columns --

  --[WeekNumberOfYear], 
  --[DayNumberOfWeek], 
  --[SpanishDayNameOfWeek], 
  --[FrenchDayNameOfWeek], 
  --[DayNumberOfMonth], 
  --[DayNumberOfYear], 
  --[SpanishMonthName], 
  --[FrenchMonthName], 
  --[CalendarQuarter], 
  --[CalendarSemester], 
  --[FiscalQuarter], 
  --[FiscalYear], 
  --[FiscalSemester] 