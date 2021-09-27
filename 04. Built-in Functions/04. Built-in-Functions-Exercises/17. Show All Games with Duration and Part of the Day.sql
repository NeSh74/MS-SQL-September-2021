  SELECT [Name] 
      AS [Game],
		 CASE 
			 WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12  THEN 'Morning'
			 WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
			 ELSE 'Evening'
    END 
	 AS [Part of the Day],
		CASE
			WHEN [Duration] <=3 THEN 'Extra Short'
			WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
			WHEN [Duration] > 6 THEN 'Long'
			ELSE 'Extra Long'
		END 
	AS [Duration]
    FROM [Games] AS g
ORDER BY [Game], [Duration], [Part of the Day]

--USE [Diablo]

