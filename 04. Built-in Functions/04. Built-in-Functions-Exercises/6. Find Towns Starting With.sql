--USE [SoftUni]

SELECT * FROM Towns
--WHERE LEFT([Name], 1) IN ('M', 'K', 'B','E')
--WHERE [Name] LIKE '[MKBE]%'
WHERE SUBSTRING([Name], 1, 1) IN ('M', 'K', 'B','E')
ORDER BY [Name] ASC