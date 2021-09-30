--USE [SoftUni]

    SELECT 
	       e.[FirstName], 
	       e.[LastName], 
	       e.[HireDate],
	       d.[Name] AS [DeptName]
      FROM [Employees] AS e
INNER JOIN [Departments] AS d
    --JOIN [Departments] AS d
        ON (e.[DepartmentId] = d.[DepartmentId]
       AND e.[HireDate] > '1/1/1999'
       AND d.[Name] IN ('Sales', 'Finance'))
  ORDER BY e.[HireDate] ASC
