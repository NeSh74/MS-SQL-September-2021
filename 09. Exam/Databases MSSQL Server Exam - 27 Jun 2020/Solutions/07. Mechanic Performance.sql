 SELECT [Mechanic],
	    AVG([DaysWorked]) AS [Average Days]
		FROM( 
			SELECT m.[MechanicId],
				   CONCAT(m.[FirstName], ' ', m.[LastName]) AS [Mechanic],
                   j.[JobId],
                   DATEDIFF(DAY, j.[IssueDate], j.[FinishDate]) AS [DaysWorked]
			  FROM [Mechanics] AS m
			  JOIN [Jobs] AS j
                ON m.[MechanicId] = j.[MechanicId]
             WHERE j.[Status] = 'Finished'
			 ) AS [DaysWorkedSubQuery]
GROUP BY [Mechanic], [MechanicId]
ORDER BY [MechanicId] 