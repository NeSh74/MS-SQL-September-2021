--USE [SoftUni]

SELECT MIN([Average Salary]) AS [MinAverageSalary] 
FROM		(
			SELECT DepartmentID, AVG(Salary) AS [Average Salary] 
			FROM Employees
			GROUP BY DepartmentID
			) 
			AS [AverageSalaryQuery]

--SELECT TOP (1) AVG(Salary) AS [MinAverageSalary] 
--FROM Employees
--GROUP BY DepartmentID
--ORDER BY [MinAverageSalary] ASC

--SELECT   MIN(a.AverageSalary) AS MinAverageSalary
--  FROM 
--  (
--     SELECT e.DepartmentID, 
--            AVG(e.Salary) AS AverageSalary
--       FROM Employees AS e
--   GROUP BY e.DepartmentID
--  ) AS a


