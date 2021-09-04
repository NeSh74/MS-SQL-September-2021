--Write a SQL query to find the first name, last name and job title of all employees whose salary is in the range [20000, 30000].

--I VARIANT
--SELECT 
--	FirstName, 
--	LastName, 
--	JobTitle 
--	FROM Employees
--	WHERE Salary >= 20000 AND  Salary <= 30000 

--II VARIANT
SELECT 
	FirstName, 
	LastName, 
	JobTitle 
	FROM Employees
	WHERE Salary BETWEEN 20000 AND 30000 