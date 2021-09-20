--Write a SQL query to find last 7 hired employees. Select their first, last name and their hire date.

SELECT 
	TOP(7) 
	FirstName,
	LastName,
	HireDate
	FROM Employees
	ORDER BY HireDate DESC