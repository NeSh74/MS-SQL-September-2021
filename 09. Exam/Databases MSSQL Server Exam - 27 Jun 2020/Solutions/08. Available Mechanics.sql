--Very hard way
SELECT CONCAT([FirstName], ' ', [LastName]) AS [Available]
FROM (
        SELECT m1.[MechanicId], [FirstName], [LastName],
                  (SELECT COUNT(*) FROM [Mechanics] AS m
                    LEFT JOIN [Jobs] AS j
                    ON m.[MechanicId] = j.[MechanicId]
                    WHERE m.[MechanicId] = m1.[MechanicId]
                  ) AS [All Jobs Count],
                  (SELECT COUNT(*) FROM [Mechanics] AS m
                    LEFT JOIN [Jobs] AS j
                    ON m.[MechanicId] = j.[MechanicId]
                    WHERE m.[MechanicId] = m1.[MechanicId] AND (j.[Status] = 'Finished' OR j.[Status] IS NULL)
                  ) AS [Finished Jobs Count]
             FROM [Mechanics] AS m1
        LEFT JOIN [Jobs] AS j
               ON m1.[MechanicId] = j.[MechanicId]
     ) AS [JobsCountSubQuery]
WHERE [All Jobs Count] = [Finished Jobs Count]
GROUP BY [FirstName], [LastName], [MechanicId]
ORDER BY [MechanicId]
 
---Very simple way
SELECT CONCAT([FirstName], ' ',[LastName]) AS [Available] 
  FROM [Mechanics]
 WHERE [MechanicId] NOT IN (
                                SELECT [MechanicId] FROM [Jobs]
                                WHERE [Status] = 'In Progress' 
                                GROUP BY [MechanicId]
                            )