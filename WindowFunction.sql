-- I create a stored procedure that when I execute "Refresh311", The data from table FactInternetSales and  DimProduct with a specific table(FIS.ProductKey, FIS.SalesOrderNumber, DP.EnglishProductName, FIS.UnitPrice) will automatically add to a designated table for product key 311

CREATE PROCEDURE Refresh311
AS
BEGIN
INSERT INTO Practice (ProductKey, SalesOrderNumber, EnglishProductName, UnitPrice)
SELECT
	FIS.ProductKey, FIS.SalesOrderNumber, DP.EnglishProductName, FIS.UnitPrice
FROM 
	FactInternetSales AS FIS
LEFT JOIN 
	DimProduct AS DP
ON 
	FIS.ProductKey = DP.ProductKey
LEFT JOIN 
	practice AS  PRAC
ON 
	FIS.SalesOrderNumber = PRAC.SalesOrderNumber
WHERE 
	FIS.ProductKey = 311 AND PRAC.SalesOrderNumber IS NULL
ORDER BY
	FIS.SalesOrderNumber
END
