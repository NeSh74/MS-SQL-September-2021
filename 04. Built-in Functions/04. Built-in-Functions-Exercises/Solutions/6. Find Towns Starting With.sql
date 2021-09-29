--  SELECT [TownID],
--		 [Name]
--    FROM [Towns]
--   WHERE LEFT([Name], 1) IN ('M', 'K', 'B','E')
--ORDER BY [Name]

--SELECT [TownID],
--		 [Name]
--    FROM [Towns]
--   WHERE [Name] LIKE '[MKBE]%'
--ORDER BY [Name]

  SELECT * FROM Towns
   WHERE SUBSTRING([Name], 1, 1) IN ('M', 'K', 'B','E')
ORDER BY [Name] ASC