-- Data from kaggle : https://www.kaggle.com/datasets/danielfesalbon/covid-19-global-reports-early-march-2022

-- Create Database
CREATE DATABASE COVID_19_Global_Reports_early_March_2022

-- Calculate the comfirmed cases in Canada and display the Cumulative Cumulative Confirmed Cases
SELECT 
	[Country/Region], 
	Date, 
	SUM(Confirmed) AS Confirmed,
	SUM(SUM(Confirmed)) OVER (ORDER BY date) AS Cumulative_Confirmed_Cases
FROM  covid_19_clean_complete_2022
WHERE [Country/Region] = 'Canada'
GROUP BY [Country/Region], date
ORDER BY date

-- Calculate the death cases in Canada and display the Cumulative Cumulative death Cases
SELECT 
	[Country/Region], 
	Date, 
	SUM(Deaths) AS Deaths,
	SUM(SUM(Deaths)) OVER (ORDER BY date) AS Cumulative_Deaths_Cases
FROM  covid_19_clean_complete_2022
WHERE [Country/Region] = 'Canada'
GROUP BY [Country/Region], date
ORDER BY date

-- Calculate the recovered cases in Canada and display the Cumulative Cumulative recovered Cases
SELECT 
	[Country/Region], 
	Date, 
	SUM(recovered) AS recovered,
	SUM(SUM(recovered)) OVER (ORDER BY date) AS Cumulative_Recovered_Cases
FROM  covid_19_clean_complete_2022
WHERE [Country/Region] = 'Canada'
GROUP BY [Country/Region], date
ORDER BY date

-- Calculate the active cases in Canada and display the Cumulative Cumulative active Cases
WITH CTE AS (
SELECT 
	[Country/Region], 
	Date, 
	SUM(SUM(Confirmed)) OVER (ORDER BY date) AS Cumulative_Confirmed_Cases,
	SUM(SUM(recovered)) OVER (ORDER BY date) AS Cumulative_Recovered_Cases,
	SUM(SUM(Deaths)) OVER (ORDER BY date) AS Cumulative_Deaths_Cases
FROM  covid_19_clean_complete_2022
WHERE [Country/Region] = 'Canada'
GROUP BY [Country/Region], date, Active
)

SELECT *, (Cumulative_Confirmed_Cases - Cumulative_Recovered_Cases - Cumulative_Deaths_Cases) AS Cumulative_Active_Cases
FROM CTE

-- Create a stored procedure that generate the Cumulative Confirmed Cases via country
CREATE PROCEDURE Get_Cumulative_Confirmed_Cases @Country NVARCHAR(50)
AS
BEGIN
SELECT 
	[Country/Region], 
	Date, 
	SUM(Confirmed) AS Confirmed,
	SUM(SUM(Confirmed)) OVER (ORDER BY date) AS Cumulative_Confirmed_Cases
FROM  covid_19_clean_complete_2022
WHERE [Country/Region] = @Country
GROUP BY [Country/Region], date
ORDER BY date
END
	-- Sample Query
EXEC Get_Cumulative_Confirmed_Cases @Country = 'Canada'
EXEC Get_Cumulative_Confirmed_Cases @Country = 'Cuba'

-- Create a stored procedure that generate the Cumulative Death Cases via country
CREATE PROCEDURE Get_Cumulative_Deaths_Cases @Country NVARCHAR(50)
AS
BEGIN
SELECT 
	[Country/Region], 
	Date, 
	SUM(Deaths) AS Deaths,
	SUM(SUM(Deaths)) OVER (ORDER BY date) AS Cumulative_Deaths_Cases
FROM  covid_19_clean_complete_2022
WHERE [Country/Region] = @Country
GROUP BY [Country/Region], date
ORDER BY date
END

	-- Sample Query
EXEC Get_Cumulative_Deaths_Cases @Country = 'Canada'
EXEC Get_Cumulative_Deaths_Cases @Country = 'US'

-- Create a stored procedure that generate the Cumulative Recoverd Cases via country
CREATE PROCEDURE Get_Cumulative_Recovered_Cases @Country NVARCHAR(50)
AS
BEGIN
SELECT 
	[Country/Region], 
	Date, 
	SUM(recovered) AS recovered,
	SUM(SUM(recovered)) OVER (ORDER BY date) AS Cumulative_Recovered_Cases
FROM  covid_19_clean_complete_2022
WHERE [Country/Region] = @Country
GROUP BY [Country/Region], date
ORDER BY date
END

	-- Sample Queries
EXEC Get_Cumulative_Recovered_Cases @Country = 'Cambodia'
EXEC Get_Cumulative_Recovered_Cases @Country = 'Cabo Verde'

-- Create a stored procedure that Calculate the active cases in the country and display the Cumulative Cumulative active Cases
CREATE PROCEDURE Get_Cumulative_Active_Cases @Country NVARCHAR(50)
AS
BEGIN
WITH CTE AS (
SELECT 
	[Country/Region], 
	Date, 
	SUM(SUM(Confirmed)) OVER (ORDER BY date) AS Cumulative_Confirmed_Cases,
	SUM(SUM(recovered)) OVER (ORDER BY date) AS Cumulative_Recovered_Cases,
	SUM(SUM(Deaths)) OVER (ORDER BY date) AS Cumulative_Deaths_Cases
FROM  covid_19_clean_complete_2022
WHERE [Country/Region] = @Country
GROUP BY [Country/Region], date, Active
)

SELECT *, (Cumulative_Confirmed_Cases - Cumulative_Recovered_Cases - Cumulative_Deaths_Cases) AS Cumulative_Active_Cases
FROM CTE
END
	-- Sample Query
EXEC Get_Cumulative_Active_Cases @Country = 'US'
EXEC Get_Cumulative_Active_Cases @Country = 'Burundi'



