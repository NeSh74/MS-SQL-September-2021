--Write a SQL query to find first 10 started projects. Select all information about them and sort them by start date, then by name.

SELECT TOP(10) *
	FROM Projects
	ORDER BY StartDate ASC, [Name] ASC