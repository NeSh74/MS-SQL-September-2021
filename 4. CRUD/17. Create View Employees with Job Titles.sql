--Write a SQL query to create view V_EmployeeNameJobTitle with full employee name and job title. When middle name is NULL replace it with empty string (‘’).

--CREATE VIEW V_EmployeeNameJobTitle
--AS
--SELECT 
--	CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [Full Name],
--	JobTitle
--	FROM Employees

--GO

CREATE VIEW V_EmployeeNameJobTitle
AS
SELECT 
	CONCAT(FirstName, ' ', ISNULL(MiddleName, ''), ' ', LastName) 
	AS [Full Name],
	JobTitle
	FROM Employees