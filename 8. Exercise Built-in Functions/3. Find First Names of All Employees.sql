--USE [SoftUni]

SELECT Firstname FROM Employees
WHERE DepartmentID IN (3, 10) AND 
	--DATEPART(YEAR, HireDate)
	YEAR(HireDate)
	BETWEEN 1955 AND 2005