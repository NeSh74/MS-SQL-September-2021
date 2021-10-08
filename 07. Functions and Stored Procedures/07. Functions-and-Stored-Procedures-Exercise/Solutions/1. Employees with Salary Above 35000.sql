--USE [SoftUni]

--GO

CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS 
BEGIN
	SELECT [FirstName] AS [First Name],
		   [LastName] AS [Last Name]
	  FROM [Employees]
	 WHERE [Salary] > 35000
END

--GO

--EXEC usp_GetEmployeesSalaryAbove35000 