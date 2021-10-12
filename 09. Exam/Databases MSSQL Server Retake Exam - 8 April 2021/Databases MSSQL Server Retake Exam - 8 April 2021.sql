--CREATE DATABASE [Service]

--USE [Service]

--1. DDL (30 pts)

CREATE TABLE [Users]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Username] NVARCHAR(30) UNIQUE NOT NULL,
	[Password] NVARCHAR(50) NOT NULL,
	[Name] NVARCHAR(50),
	[Birthdate] DATETIME,
	[Age] INT CHECK([Age] >= 14 AND [Age] <= 110), --[Age] INT CHECK([Age] BETWEEN 18 AND 110),
	[Email] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Departments]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE [Employees]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[FirstName] NVARCHAR(25),
	[LastName] NVARCHAR(25),
	[Birthdate] DATETIME,
	[Age] INT CHECK([Age] >= 18 AND [Age] <= 110),
	[DepartmentId] INT REFERENCES [Departments]([Id])
)

CREATE TABLE [Categories]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(50) NOT NULL,
	[DepartmentId] INT NOT NULL REFERENCES [Departments]([Id]) 
)

CREATE TABLE [Status]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[Label] NVARCHAR(30) NOT NULL
)

CREATE TABLE [Reports]
(
	[Id] INT PRIMARY KEY IDENTITY,
	[CategoryId] INT NOT NULL REFERENCES [Categories]([Id]),
	[StatusId] INT NOT NULL REFERENCES [Status]([Id]),
	[OpenDate] DATETIME NOT NULL,
	[CloseDate] DATETIME,
	[Description] NVARCHAR(200) NOT NULL,
	[UserId] INT NOT NULL REFERENCES [Users]([Id]),
	[EmployeeId] INT REFERENCES [Employees]([Id])
)

--2. Insert

INSERT INTO [Employees]([FirstName], [LastName], [Birthdate], [DepartmentId])
VALUES
('Marlo',	'O''Malley',	'1958-9-21',	1),
('Niki',	'Stanaghan',	'1969-11-26',	4),
('Ayrton',	'Senna',	'1960-03-21',	9),
('Ronnie',	'Peterson',	'1944-02-14',	9),
('Giovanna',	'Amati',	'1959-07-20',	5)

INSERT INTO [Reports]([CategoryId],	[StatusId],	[OpenDate],	[CloseDate], [Description],	[UserId],	[EmployeeId])
VALUES
(1,	1,	'2017-04-13',	NULL,	'Stuck Road on Str.133',	6,	2),
(6,	3,	'2015-09-05',	'2015-12-06',	'Charity trail running',	3,	5),
(14,	2,	'2015-09-07',	NULL,	'Falling bricks on Str.58',	5,	2),
(4,	3,	'2017-07-03',	'2017-07-06',	'Cut off streetlight on Str.11',	1,	1)

--3. Update

UPDATE [Reports] SET [CloseDate] = GETDATE()
WHERE [CloseDate] IS NULL

--4. Delete

DELETE FROM [Reports]
WHERE [StatusId] = 4

--5. Unassigned Reports

SELECT 
[Description], 
FORMAT([OpenDate], 'dd-MM-yyyy') AS [OpenDate]
FROM [Reports] AS r
WHERE [EmployeeId] IS NULL
ORDER BY r.[OpenDate], [Description]
--ORDER BY CONVERT(DATETIME, [OpenDate]), [Description]
--ORDER BY YEAR(OpenDate), MONTH(OpenDate), DAY(OpenDate), [Description]

--6. Reports & Categories

SELECT r.[Description], c.[Name] AS [CategoryName]
FROM [Reports] AS r
JOIN [Categories] AS c
ON r.[CategoryId] = c.[Id]
ORDER BY [Description], [CategoryName]
--WHERE [CategoryId] IS NOT NULL

--7.1. Most Reported Category

--SELECT [CategoryId], c.[Name], COUNT(*) AS [ReportsNumber]
SELECT TOP(5) c.[Name], 
COUNT(*) AS [ReportsNumber]
FROM [Reports] AS r
JOIN [Categories] AS c
ON r.[CategoryId] = c.[Id]
GROUP BY [CategoryId], c.[Name]
ORDER BY [ReportsNumber] DESC, [Name]

--7.2. Most Reported Category

SELECT TOP(5)
[Name],
(SELECT COUNT(*) 
FROM [Reports] 
WHERE [CategoryId] = c.[Id]) AS [ReportsNumber]
FROM [Categories] AS c
ORDER BY [ReportsNumber] DESC, [Name]

--8.	Birthday Report

SELECT [Username], 
c.[Name] AS [CategoryName] 
FROM [Reports] AS r
JOIN [Users] AS u
ON u.[Id] = r.[UserId]
JOIN [Categories] AS c
ON c.[Id] = r.[CategoryId]
WHERE --FORMAT(r.[OpenDate], 'MM-dd') = FORMAT(u.[Birthdate], ''MM-dd)
DATEPART(MONTH, r.[OpenDate]) = 
DATEPART(MONTH, u.[Birthdate])
AND
DATEPART(DAY, r.[OpenDate]) = 
DATEPART(DAY, u.[Birthdate])
ORDER BY [Username], c.[Name]

--9.1. Users per Employee 

SELECT 
[FirstName] + ' ' + [LastName] AS [FullName], 
(SELECT COUNT(DISTINCT UserId) FROM [Reports] WHERE [EmployeeId] = e.[Id])
AS [UsersCount] 
FROM [Employees] AS e
ORDER BY [UsersCount] DESC, [FullName]

--9.2.Users per Employee 

SELECT 
[FirstName] + ' ' + [LastName] AS [FullName],  
COUNT(DISTINCT UserId) AS [UsersCount] 
FROM [Reports] r
RIGHT JOIN [Employees] e ON e.[Id] = r.[EmployeeId]
GROUP BY [EmployeeId], [FirstName], [LastName]
ORDER BY [UsersCount] DESC, [FullName]

--9.2.Users per Employee 
SELECT CONCAT(e.FirstName,' ', e.LastName) AS [Full Name], COUNT(r.UserId) AS [UserCount] FROM Employees AS e
LEFT JOIN Reports AS r
ON e.Id = r.EmployeeId
GROUP BY FirstName, LastName
ORDER BY [UserCount] DESC, [Full Name] ASC

--10. Full Info

SELECT 
ISNULL(e.[FirstName] + ' ' + e.[LastName], 'None') AS [Employee],
ISNULL(d.[Name], 'None') AS [Department],
ISNULL(c.[Name], 'None') AS [Category],
r.[Description],
FORMAT(r.[OpenDate], 'dd.MM.yyyy') AS [OpenDate],
s.[Label] AS [Status],
ISNULL(u.[Name], 'None') AS [User]
FROM [Reports] AS r
lEFT JOIN [Employees] AS e
ON e.[Id] = r.[EmployeeId]
LEFT JOIN [Categories] AS c
ON c.[Id] = r.[CategoryId]
LEFT JOIN [Departments] AS d
ON d.[Id] = e.[DepartmentId]
LEFT JOIN [Status] AS s
ON s.[Id] = r.[StatusId]
LEFT JOIN [Users] AS u
ON u.[Id] = r.[UserId]
ORDER BY 
[FirstName] DESC, [LastName] DESC, d.[Name], c.[Name], 
r.[Description], r.[OpenDate], s.[Label], u.[Name] 

--11.	Hours to Complete
GO

CREATE FUNCTION udf_HoursToComplete
(@StartDate DATETIME, @EndDate DATETIME)
RETURNS INT
AS 
BEGIN
IF (@StartDate IS NULL)
RETURN 0;
IF (@EndDate IS NULL)
RETURN 0;
RETURN DATEDIFF(HOUR, @StartDate, @EndDate)
END

--SELECT dbo.udf_HoursToComplete(OpenDate, CloseDate) AS TotalHours
--   FROM Reports

--12. Assign Employee
GO

CREATE PROCEDURE usp_AssignEmployeeToReport
(@EmployeeId INT, @ReportId INT)
AS
BEGIN

DECLARE @EmployeeDepId INT =
(SELECT [DepartmentId] 
FROM [Employees]
WHERE [Id] = @EmployeeId);

DECLARE @ReportDepId INT = 
(SELECT c.[DepartmentId]  
FROM [Reports] AS r
JOIN [Categories] AS c
ON c.[Id] = r.[CategoryId]
WHERE r.[Id] = @ReportId
);

IF (@EmployeeDepId <> @ReportDepId)
THROW 50000, 'Employee doesn''t belong to the appropriate department!',1

UPDATE [Reports] 
SET [EmployeeId] = @EmployeeId
WHERE [Id] = @ReportId
END