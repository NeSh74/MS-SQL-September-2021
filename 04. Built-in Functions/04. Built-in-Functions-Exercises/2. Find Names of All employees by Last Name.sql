--USE [SoftUni]

--SELECT [FirstName], [LastName], CHARINDEX('ei', [LastName]) FROM [Employees]
--I VARIANT

--SELECT [FirstName], [LastName] FROM [Employees]
--WHERE CHARINDEX('ei', [LastName]) <> 0

--II VARIANT

SELECT [FirstName], [LastName] FROM [Employees]
WHERE [LastName] LIKE '%ei%'

