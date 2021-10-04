--USE [SoftUni]

SELECT TOP(10) e.[FirstName],
			   e.[LastName],
			   e.[DepartmentID]
			FROM [Employees] AS e
		   WHERE [Salary] > (
		  SELECT AVG(esub.[Salary]) AS [DepartmentAverageSalary]
			FROM [Employees] AS esub
		   WHERE esub.[DepartmentID] = e.[DepartmentID]
		GROUP BY esub.[DepartmentID]
							)
		ORDER BY e.[DepartmentID]