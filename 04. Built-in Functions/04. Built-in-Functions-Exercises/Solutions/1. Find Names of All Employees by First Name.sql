--USE [SoftUni]

--SELECT [FirstName], [LastName] FROM [Employees]
--WHERE LEFT([FirstName], 2) = 'Sa'

--SELECT [FirstName], [LastName] FROM [Employees]
--WHERE SUBSTRING([FirstName], 1, 2) = 'Sa'

SELECT [Firstname], [LastName] FROM [Employees]
--WHERE [FirstName] LIKE 'SA%'
WHERE [FirstName] LIKE 'SA%'