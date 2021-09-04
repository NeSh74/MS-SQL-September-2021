--Write a SQL query to find the full name of all employees whose salary is 25000, 14000, 12500 or 23600. Full Name is combination of first, middle and last name (separated with single space) and they should be in one column called “Full Name”.

SELECT 
	CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [Full Name] 
	FROM Employees
	WHERE Salary IN (25000, 14000, 12500, 23600)	