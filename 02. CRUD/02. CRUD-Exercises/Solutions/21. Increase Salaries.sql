--SELECT * FROM [Departments]

--SELECT [Salary] FROM [Employees]
 --WHERE [DepartmentID] IN (1, 2, 4, 11)

UPDATE [Employees]
   SET [SALARY] += [Salary] * 0.12
 WHERE [DepartmentID] IN (1, 2, 4, 11)

 SELECT [Salary] FROM [Employees]
