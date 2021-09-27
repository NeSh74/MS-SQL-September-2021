   SELECT [FirstName],
		  [LastName]
	 FROM [Employees]
	--WHERE LEN([LastName]) IN (5) 
	WHERE LEN([LastName]) = 5