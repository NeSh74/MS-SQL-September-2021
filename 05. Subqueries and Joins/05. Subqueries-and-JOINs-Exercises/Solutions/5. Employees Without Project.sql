--USE [SoftUni]

SELECT TOP(3)
	e.EmployeeID,
	--ep.EmployeeID,
	e.FirstName
	FROM Employees AS e
LEFT OUTER JOIN EmployeesProjects AS ep
ON e.EmployeeID = ep.EmployeeID
WHERE ep.ProjectID IS NULL
--WHERE ep.EmployeeID IS NULL
ORDER BY e.EmployeeID 
