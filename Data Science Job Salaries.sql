-- Downloaded data from kaggle 9/28/2023
  -- https://www.kaggle.com/datasets/ruchi798/data-science-job-salaries

-- Create a database
CREATE DATABASE Data_Science_Job_Salaries;

-- NEXT Import the data

-- Use the database
USE Data_Science_Job_Salaries

-- Rename the imported table
EXEC sp_rename 'ds_salaries$','ds_salaries'

-- Query all the informaation inside the [ds_salaries]
SELECT *
FROM ds_salaries

-- Display all the job title
SELECT 
	DISTINCT(job_title)
FROM 
    ds_salaries

-- Count the employee each jobtitle
SELECT 
	DISTINCT(job_title),
	COUNT(job_title) AS Employee_Count
FROM 
    ds_salaries
GROUP BY 
    job_title
ORDER BY 
    COUNT(job_title) DESC

-- Display the average salary max, min and avg salary in USD per job title(Grouped)
SELECT 
	DISTINCT(job_title),
	MIN(salary_in_usd) [Minimum_Salary(USD)],
	MAX(salary_in_usd) [Maximum_Salary(USD)],
	AVG(salary_in_usd) [AVG_Salary(USD)]
FROM 
    ds_salaries
GROUP BY 
    job_title

-- Display the average salary max, min and avg salary in USD per job title(Partition)
SELECT 
	job_title,
	MIN(salary_in_usd) OVER (PARTITION BY job_title) AS [Minimum_Salary(USD)],
	MAX(salary_in_usd) OVER (PARTITION BY job_title) AS [Maximum_Salary(USD)],
	AVG(salary_in_usd) OVER (PARTITION BY job_title) AS [Average_Salary(USD)]
FROM 
    ds_salaries

-- Count the employee each residence
SELECT 
	DISTINCT(employee_residence) AS Residence,
	COUNT(*) AS Employee_Count
FROM 
	ds_salaries
GROUP BY
	employee_residence
ORDER BY
	COUNT(*) DESC

-- Rank the jobs in US residence based on employee count
WITH CTE AS (
SELECT
	DISTINCT(job_title),
	COUNT(*) AS Employee_Count,
	employee_residence
FROM
	ds_salaries
WHERE
	employee_residence = 'US'
GROUP BY 
	job_title, employee_residence
)

SELECT
	job_title,
	Employee_count,
	RANK() OVER (ORDER BY Employee_count DESC, job_title)
FROM 
	CTE
