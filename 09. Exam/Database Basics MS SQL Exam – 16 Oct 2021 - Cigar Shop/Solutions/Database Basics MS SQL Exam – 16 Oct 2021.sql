--1. DDL (30 pts)
--CREATE DATABASE [CigarShop]

--USE [CigarShop]

CREATE TABLE [Sizes]
(
[Id] INT PRIMARY KEY IDENTITY,
[Length] INT NOT NULL,
CHECK([Length] BETWEEN 10 AND 25),
[RingRange] DECIMAL(8, 2) NOT NULL,
CHECK([RingRange] BETWEEN 1.5 AND 7.5)
)

CREATE TABLE [Tastes]
(
[Id] INT PRIMARY KEY IDENTITY, 	
[TasteType] VARCHAR(20) NOT NULL,	
[TasteStrength] VARCHAR(15) NOT NULL,	
[ImageURL] NVARCHAR(100) NOT NULL	
)

CREATE TABLE [Brands]
(
[Id] INT PRIMARY KEY IDENTITY,	
[BrandName] VARCHAR(30) UNIQUE NOT NULL,	
[BrandDescription] VARCHAR(MAX)	
)

CREATE TABLE [Cigars]
(
[Id] INT PRIMARY KEY IDENTITY,	
[CigarName] VARCHAR(80) NOT NULL,
[BrandId] INT REFERENCES [Brands]([Id]) NOT NULL,	
[TastId] INT REFERENCES [Tastes]([Id]) NOT NULL,
[SizeId] INT REFERENCES [Sizes]([Id]) NOT NULL,		
[PriceForSingleCigar] MONEY NOT NULL,	
[ImageURL] NVARCHAR(100) NOT NULL	
)

CREATE TABLE [Addresses]
(
[Id] INT PRIMARY KEY IDENTITY,	
[Town] VARCHAR(30) NOT NULL,	
[Country] NVARCHAR(30) NOT NULL,	
[Streat] NVARCHAR(100) NOT NULL,	
[ZIP] VARCHAR(20) NOT NULL	
)

CREATE TABLE [Clients]
(
[Id] INT PRIMARY KEY IDENTITY,	
[FirstName] NVARCHAR(30) NOT NULL,	
[LastName] NVARCHAR(30) NOT NULL,	
[Email]	NVARCHAR(50) NOT NULL, 
[AddressId] INT REFERENCES [Addresses]([Id]) NOT NULL	
)

CREATE TABLE [ClientsCigars]
(
[ClientId] INT REFERENCES [Clients]([Id]),
[CigarId] INT REFERENCES [Cigars]([Id])	,

PRIMARY KEY([ClientId], [CigarId])
)

--2. Insert
INSERT INTO [Cigars]([CigarName],	[BrandId],	[TastId],	[SizeId],	[PriceForSingleCigar],	[ImageURL]) VALUES
('COHIBA ROBUSTO',	9,	1,	5,	15.50,	'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I',	9,	1,	10,	410.00,	'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE',	14,	5,	11,	7.50,	'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN',	14,	4,	15,	32.00,	'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES',	2,	3,	8,	85.21,	'trinidad-coloniales-stick_30.jpg')

INSERT INTO [Addresses]([Town],	[Country],	[Streat],	[ZIP]) VALUES
('Sofia',	'Bulgaria',	'18 Bul. Vasil levski',	'1000'),
('Athens',	'Greece',	'4342 McDonald Avenue',	'10435'),
('Zagreb',	'Croatia',	'4333 Lauren Drive',	'10000')

--3. Update

UPDATE [Cigars]
SET [PriceForSingleCigar] += 0.20 * [PriceForSingleCigar]
WHERE [TastId] = 1

UPDATE [Brands]
SET [BrandDescription] = 'New description'
WHERE [BrandDescription] IS NULL

--4. Delete

DELETE FROM [Clients]
WHERE [AddressId] IN (7, 8, 10)

DELETE FROM [Addresses]
WHERE [Country] LIKE 'C%'

--5. Cigars by Price

SELECT
[CigarName],
[PriceForSingleCigar],
[ImageURL]
FROM [Cigars]
ORDER BY [PriceForSingleCigar], [CigarName] DESC

--6. Cigars by Taste

SELECT c.[Id],
c.[CigarName],
c. [PriceForSingleCigar],
t.[TasteType],
t.[TasteStrength]
FROM [Cigars] AS c
JOIN [Tastes] AS T
ON c.TastId = t.[Id]
WHERE [TasteType] IN ('Earthy', 'Woody')
ORDER BY [PriceForSingleCigar] DESC

--7. Clients without Cigars

SELECT c.[Id], 
CONCAT(c.[FirstName], ' ', c.[LastName]) AS [ClientName], 
c.[Email]
FROM [Clients] c
LEFT JOIN [ClientsCigars] cc ON c.[Id] = cc.[ClientId]
WHERE cc.[CigarId] IS NULL
ORDER BY [ClientName]

--8. First 5 Cigars

SELECT TOP(5)
[CigarName], 
[PriceForSingleCigar], 
[ImageURL]
FROM [Cigars] c
JOIN [Sizes] s ON c.[SizeId] = s.[Id]
WHERE s.[Length] >= 12 AND (c.[CigarName] LIKE N'%ci%' 
OR c.[PriceForSingleCigar] > 50 AND s.[RingRange] > 2.55)
ORDER BY [CigarName], [PriceForSingleCigar] DESC

--9. Clients with ZIP Codes

SELECT 
CONCAT([FirstName], ' ', [LastName]) AS [FullName],
[Country],
[ZIP],
CONCAT('$', MAX(cg.[PriceForSingleCigar])) AS [CigarPrice]
FROM [Clients] c
JOIN [Addresses] a ON c.[AddressId] = a.[Id]
JOIN [ClientsCigars] cc ON c.[Id] = cc.[ClientId]
JOIN [Cigars] cg ON cc.[CigarId] = cg.[Id]
WHERE a.[ZIP] NOT LIKE '%[^0123456789]%'
GROUP BY [FirstName], [LastName], a.[Country], a.[ZIP]
ORDER BY [FullName]

--10. Cigars by Size

SELECT 
c.[LastName], 
AVG(s.[Length]) AS [CiagrLength], CEILING(AVG(s.[RingRange])) AS [CiagrRingRange]
FROM [Clients] c
JOIN [ClientsCigars] cc ON c.[Id] = cc.[ClientId]
JOIN [Cigars] cg ON cc.[CigarId] = cg.[id]
JOIN [Sizes] s ON cg.[SizeId] = s.[Id]
GROUP BY c.[LastName]
ORDER BY [CiagrLength] DESC

--11. Client with Cigars
GO

CREATE FUNCTION udf_ClientWithCigars(@name NVARCHAR(30)) 
RETURNS INT
AS
BEGIN
DECLARE @id INT = (SELECT [Id] FROM [Clients] WHERE [FirstName] = @name)

	DECLARE @result INT = (SELECT COUNT([CigarId]) FROM [ClientsCigars] WHERE [ClientId] = @id)

	RETURN @result
END

--12. Search for Cigar with Specific Taste

CREATE PROC usp_SearchByTaste(@taste VARCHAR(20))
AS
BEGIN
SELECT c.[CigarName], 
CONCAT('$', c.[PriceForSingleCigar]), 
t.[TasteType], 
b.[BrandName],
CONCAT(s.[Length], ' cm') AS [CigarLength],
CONCAT(s.[RingRange], ' cm') AS [CigarRingRange]
FROM [Cigars] c
JOIN [Sizes] s ON c.[SizeId] = s.[Id]
JOIN [Tastes] t ON c.[TastId] = t.[Id]
JOIN [Brands] b ON c.[BrandId] = b.[Id]
WHERE t.[TasteType] = @taste
ORDER BY [CigarLength], [CigarRingRange] DESC
END