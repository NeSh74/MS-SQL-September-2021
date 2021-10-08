--USE [SoftUni]

--GO

CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber @minSalary DECIMAL(18, 4)
AS 
BEGIN
	SELECT [FirstName] AS [First Name],
		   [LastName] AS [Last Name]
	  FROM [Employees]
	 WHERE [Salary] >= @minSalary
END

--GO

--EXEC usp_GetEmployeesSalaryAboveNumber 48100