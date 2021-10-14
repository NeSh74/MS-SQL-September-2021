--CREATE DATABASE [Bakery]

--USE [Bakery]

CREATE TABLE [Countries]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE [Customers]
(
[Id]	INT PRIMARY KEY IDENTITY,
[FirstName]	NVARCHAR(25) NOT NULL,
[LastName]	NVARCHAR(25) NOT NULL,
[Gender] CHAR(1) CHECK([Gender] IN ('M', 'F')) NOT NULL,
[Age]	INT,
[PhoneNumber] CHAR(10),
[CountryId]	INT FOREIGN KEY REFERENCES[Countries]([Id])
)

CREATE TABLE [Products]
(
[Id]	INT PRIMARY KEY IDENTITY,
[Name]	NVARCHAR(25) UNIQUE NOT NULL,
[Description]	NVARCHAR(255) NOT NULL,
[Recipe]	NVARCHAR(MAX),
[Price] MONEY CHECK([Price] > 0)
)

CREATE TABLE [Feedbacks]
(
[Id]INT PRIMARY KEY IDENTITY,	
[Description]	NVARCHAR(255),
[Rate]	DECIMAL (15,2) CHECK([Rate] BETWEEN 0 AND 10),
[ProductId]	INT FOREIGN KEY REFERENCES [Products]([Id]),
[CustomerId] INT FOREIGN KEY REFERENCES [Customers]([Id])
)

CREATE TABLE [Distributors]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name]	NVARCHAR(25) UNIQUE,
[AddressText]	NVARCHAR(30),
[Summary]	NVARCHAR(200),	
[CountryId]	INT FOREIGN KEY REFERENCES [Countries]([Id])
)

CREATE TABLE [Ingredients]
(
[Id] INT PRIMARY KEY IDENTITY,	
[Name]	NVARCHAR(30),
[Description]	NVARCHAR(200),
[OriginCountryId] INT FOREIGN KEY REFERENCES [Countries]([Id]),
[DistributorId]	INT FOREIGN KEY REFERENCES [Distributors]([Id])
)

CREATE TABLE [ProductsIngredients]
(
[ProductId]	INT FOREIGN KEY REFERENCES [Products]([Id]), 
[IngredientId]	INT FOREIGN KEY REFERENCES [Ingredients]([Id])

PRIMARY KEY ([ProductId], [IngredientId])
)

--2. Insert

INSERT INTO [Distributors]([Name], [CountryId],	[AddressText], [Summary])
VALUES
('Deloitte & Touche',	2,	'6 Arch St #9757',	'Customizable neutral traveling'),
('Congress Title',	13,	'58 Hancock St',	'Customer loyalty'),
('Kitchen People',	1,	'3 E 31st St #77',	'Triple-buffered stable delivery'),
('General Color Co Inc',	21,	'6185 Bohn St #72',	'Focus group'),
('Beck Corporation',	23,	'21 E 64th Ave',	'Quality-focused 4th generation hardware')

INSERT INTO [Customers]([FirstName],	[LastName],	[Age],	[Gender],	[PhoneNumber], [CountryId])
VALUES
('Francoise',	'Rautenstrauch'	,15,	'M',	'0195698399',	5),
('Kendra',	'Loud',	22,	'F',	'0063631526',	11),
('Lourdes',	'Bauswell',	50,	'M',	'0139037043',	8),
('Hannah',	'Edmison',	18,	'F',	'0043343686',	1),
('Tom',	'Loeza',	31,	'M',	'0144876096',	23),
('Queenie',	'Kramarczyk',	30,	'F',	'0064215793',	29),
('Hiu',	'Portaro',	25,	'M',	'0068277755',	16),
('Josefa',	'Opitz',	43,	'F',	'0197887645',	17)

--3. Update

UPDATE [Ingredients]
SET [DistributorId] = 35
WHERE [Name] IN ('Bay Leaf', 'Paprika', 'Poppy')

UPDATE [Ingredients]
SET [OriginCountryId] = 14
WHERE [OriginCountryId] = 8

--4. Delete

DELETE FROM [Feedbacks]
WHERE [CustomerId] = 14 OR [ProductId] = 5

--5. Products by Price

SELECT [Name], [Price],	[Description] 
FROM [Products]
ORDER BY [Price] DESC, [Name]

--6. Negative Feedback

SELECT 
f.[ProductId],
f.[Rate],
f.[Description],
f.[CustomerId],
c.[Age],
c.[Gender]
FROM [Feedbacks] AS f
JOIN [Customers] AS c
ON f.[CustomerId] = c.[Id]
WHERE [Rate] < 5.0
ORDER BY [ProductId] DESC, [Rate]

--7. Customers without Feedback

SELECT 
CONCAT(c.[FirstName], ' ', c.[LastName]) AS [CustomerName],
c.[PhoneNumber],
c.[Gender]
FROM [Feedbacks] AS f
RIGHT JOIN [Customers] AS c
ON c.[Id] = f.[CustomerId]
WHERE f.[Id] IS NULL
ORDER BY c.[Id]

--8. Customers by Criteria 


SELECT 
[FirstName],
[Age],
[PhoneNumber]
FROM [Customers]
WHERE [Age] >= 21 AND 
([FirstName] LIKE '%an%' OR [PhoneNumber] LIKE '%38') AND 
[CountryId] <> 31
ORDER BY [FirstName], [Age] DESC

--9. Middle Range Distributors

SELECT 
d.[Name] AS [DistributorName],
i.[Name] AS [IngredientName],
p.[Name] AS [ProductName],
AVG(f.[Rate]) AS [AverageRate]
FROM [Distributors] AS d
LEFT JOIN [Ingredients] AS i ON i.[DistributorId] = d.[Id]
LEFT JOIN [ProductsIngredients] AS pi ON pi.[IngredientId] = i.[Id]
LEFT JOIN [Products] AS p ON p.[Id] = pi.[ProductId]
LEFT JOIN [Feedbacks] AS f ON f.ProductId = p.Id
GROUP BY d.[Name], i.[Name], p.[Name]
HAVING AVG(f.[Rate]) BETWEEN 5 AND 8
ORDER BY d.[Name], i.[Name], p.[Name]

--10.	Country Representative

SELECT 
	k.CountryName, 
	k.DistributorName
	FROM(
		SELECT
		c.[Name] AS CountryName,
		d.[Name] AS DistributorName,
		COUNT(i.Id) AS [Counter],
		DENSE_RANK() OVER (PARTITION BY c.[Name] ORDER BY COUNT(i.Id) DESC) AS [Rank]
		FROM Distributors d 
		LEFT JOIN Ingredients i ON i.DistributorId = d.Id 
		JOIN Countries c ON c.Id = d.CountryId
		GROUP BY c.[Name], d.[Name]
		) AS k
	WHERE k.[Rank] = 1
	ORDER BY k.CountryName, k.DistributorName

--11. Customers with Countries
GO

CREATE VIEW v_UserWithCountries AS
SELECT 
	CONCAT([FirstName], ' ', [LastName]) AS [CustomerName], 
	[Age],
	[Gender],
	CN.[Name]
	FROM [Customers] ct
	LEFT JOIN Countries cn ON cn.Id = ct.CountryId 

GO
--12. Delete Products

CREATE TRIGGER tr_DeleteAllProducts ON Products INSTEAD OF DELETE
AS
BEGIN

	DECLARE @productId INT = (SELECT Id FROM deleted)

	DELETE
		FROM [Feedbacks]
		WHERE [ProductId] = @productId

	DELETE
		FROM [ProductsIngredients] 
		WHERE [ProductId] = @productId

	DELETE
		FROM [Products]
		WHERE [Id] = @productId

END
