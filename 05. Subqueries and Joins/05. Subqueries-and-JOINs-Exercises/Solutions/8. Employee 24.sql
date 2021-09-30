--USE [SoftUni]

SELECT
	       e.[EmployeeID],
		   e.[FirstName],
		   CASE
			   WHEN YEAR(P.[StartDate]) >= 2005 THEN NULL
			   ELSE p.[Name] 
		   END AS [ProjectName]
	  FROM [Employees] AS e
--LEFT JOIN [EmployeesProjects] AS ep
INNER JOIN [EmployeesProjects] AS ep
	  ON e.[EmployeeID] = ep.[EmployeeID]
INNER JOIN [Projects] AS p
	 ON ep.[ProjectID] = p.[ProjectID]
   WHERE e.[EmployeeID] = 24
  