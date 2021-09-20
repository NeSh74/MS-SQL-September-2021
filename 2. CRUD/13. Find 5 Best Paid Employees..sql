--Write SQL query to find first and last names about 5 best paid Employees ordered descending by their salary.

SELECT TOP(5)
	FirstName, 
	LastName
	FROM Employees
	ORDER BY Salary DESC