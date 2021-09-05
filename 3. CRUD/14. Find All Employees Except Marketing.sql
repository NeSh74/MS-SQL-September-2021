--Write a SQL query to find the first and last names of all employees whose department ID is different from 4.

SELECT 
	FirstName, 
	LastName
	FROM Employees
	WHERE DepartmentId != 4

--SELECT 
--	FirstName, 
--	LastName
--	FROM Employees
--	WHERE DepartmentId <> 4