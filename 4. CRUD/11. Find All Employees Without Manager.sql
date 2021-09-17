--Write a SQL query to find first and last names about those employees that does not have a manager. 

SELECT 
	FirstName, 
	LastName
	FROM Employees
	WHERE ManagerID IS NULL	