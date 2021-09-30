--USE [SoftUni]

SELECT TOP(50)
	e1.EmployeeID,
	CONCAT(E1.FirstName, ' ', e1.LastName)
	AS [EmpoyeeName],
	CONCAT(e2.FirstName, ' ', e2.LastName)
	AS [ManagerName],
	d.[Name] AS [DepartmentName]
	FROM Employees AS e1
LEFT OUTER JOIN Employees AS e2
ON e1.ManagerID = e2.EmployeeID
INNER JOIN Departments AS d
ON e1.DepartmentID = d.DepartmentID
ORDER BY e1.EmployeeID

--SELECT TOP 50 
--  e.EmployeeID, 
--  e.FirstName + ' ' + e.LastName AS EmployeeName, 
--  m.FirstName + ' ' + m. LastName AS ManagerName,
--  d.Name AS DepartmentName
--FROM Employees AS e
--  LEFT JOIN Employees AS m ON m.EmployeeID = e.ManagerID
--  LEFT JOIN Departments AS d ON d.DepartmentID =       e.DepartmentID
--  ORDER BY e.EmployeeID ASC