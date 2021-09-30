--USE [SoftUni]

--Check AddressID If There Are Null
--SELECT * FROM [Employees] 
--WHERE [AddressID] IS NULL

SELECT TOP(5)
			e.[EmployeeId],
		    e.[JobTitle],
		    e.[AddressID],
		    a.[AddressText]
	   FROM [Employees] AS e
  LEFT JOIN [Addresses] AS a
   	     ON e.[AddressID] = a.[AddressID]
   ORDER BY [AddressID]

--NO NULL AND CAN BE WITH INNER.OTHERWISE LEFT
--SELECT TOP(5)
--			 e.[EmployeeID], 
--			 e.[JobTitle], 
--			 e.[AddressID], 
--			 a.[AddressText] 
--		FROM [Employees] AS e
--  INNER JOIN [Addresses] AS a
--		  ON e.[AddressID] = a.[AddressID]
--	ORDER BY e.[AddressID] ASC