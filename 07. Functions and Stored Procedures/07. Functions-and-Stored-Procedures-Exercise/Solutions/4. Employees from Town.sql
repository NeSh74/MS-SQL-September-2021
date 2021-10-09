--USE [SoftUni]

--GO

CREATE PROCEDURE usp_GetEmployeesFromTown @townName VARCHAR(50)
AS 
BEGIN
	SELECT e.[FirstName] AS [First Name],
		   e.[LastName] AS [Last Name]
	  FROM [Employees] AS e
 LEFT JOIN [Addresses] AS a
        ON e.[AddressID] = a.AddressID
 LEFT JOIN [Towns]     AS t
        ON a.[TownID] = t.[TownID]
	 WHERE t.[Name] = @townName
END

--GO

--EXEC usp_GetEmployeesFromTown 'Sofia'