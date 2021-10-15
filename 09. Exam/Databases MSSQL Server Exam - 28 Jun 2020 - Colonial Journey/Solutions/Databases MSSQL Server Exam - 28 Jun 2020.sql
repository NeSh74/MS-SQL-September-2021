--CREATE DATABASE [ColonialJourney]

--USE [ColonialJourney]

--1. DDL 

CREATE TABLE [Planets]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE [Spaceports]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,	
[PlanetId] INT REFERENCES [Planets]([Id]) NOT NULL	
)

CREATE TABLE [Spaceships]
(
[Id] INT PRIMARY KEY IDENTITY,	
[Name]	VARCHAR(50) NOT NULL,
[Manufacturer] VARCHAR(30) NOT NULL,
[LightSpeedRate] INT DEFAULT 0
)

CREATE TABLE [Colonists]
(
[Id] INT PRIMARY KEY IDENTITY,	
[FirstName] VARCHAR(20) NOT NULL,	
[LastName] VARCHAR(20) NOT NULL,	
[Ucn] VARCHAR(10) UNIQUE NOT NULL,	
[BirthDate]	DATE NOT NULL
)

CREATE TABLE [Journeys]
(
[Id] INT PRIMARY KEY IDENTITY,
[JourneyStart]	DATETIME NOT NULL,	
[JourneyEnd] DATETIME NOT NULL,	
[Purpose] VARCHAR(11) 
CHECK([Purpose] IN ('Medical', 'Technical', 'Educational', 'Military')),
[DestinationSpaceportId] INT REFERENCES [Spaceports](Id) NOT NULL,	
[SpaceshipId] INT REFERENCES [Spaceships]([Id]) NOT NULL
)

CREATE TABLE [TravelCards]
(
[Id] INT PRIMARY KEY IDENTITY,	
[CardNumber] VARCHAR(10) UNIQUE NOT NULL,
[JobDuringJourney] VARCHAR(8),
CHECK([JobDuringJourney] IN ('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook')),
[ColonistId] INT REFERENCES [Colonists]([Id]) NOT NULL,	
[JourneyId]	INT REFERENCES [Journeys]([Id]) NOT NULL
)

--2. Insert

INSERT INTO [Planets]([Name])
VALUES
('Mars'),
('Earth'),
('Jupiter'),
('Saturn')

INSERT INTO [Spaceships]([Name], [Manufacturer], [LightSpeedRate])
VALUES
('Golf', 'VW', 3),
('WakaWaka', 'Wakanda',	4),
('Falcon9',	'SpaceX',	1),
('Bed',	'Vidolov',	6)

--3. Update

UPDATE [Spaceships]
SET [LightSpeedRate] += 1
WHERE [Id] BETWEEN 8 AND 12

--4. Delete
DELETE 
FROM [TravelCards]
WHERE [JourneyId] IN (1, 2, 3)

DELETE 
FROM [Journeys]
WHERE [Id] IN (1, 2, 3)

--5. Select all military journeys

SELECT 
[Id],
FORMAT([JourneyStart], 'dd/MM/yyyy') AS [JourneyStart],
FORMAT([JourneyEnd], 'dd/MM/yyyy') AS [JourneyEnd]
FROM [Journeys]
WHERE [Purpose] = 'Military'
ORDER BY [JourneyStart]

--6. Select all pilots

SELECT 
c.[Id] AS [Id],
CONCAT([FirstName], ' ', [LasTName]) AS [FullName]
FROM [Colonists] AS c
JOIN [TravelCards] AS tc
ON c.[Id] = tc.[ColonistId]
WHERE [JobDuringJourney] = 'Pilot'
ORDER BY c.[Id]	

--7. Count colonists

SELECT 
COUNT(*) AS [Count] 
FROM [Colonists] AS c
JOIN [TravelCards] AS tc
ON c.[Id] = tc.[ColonistId]
JOIN [Journeys] AS j
ON j.[Id] = tc.[JourneyId]
WHERE j.[Purpose] = 'Technical'

--8.	Select spaceships with pilots younger than 30 years
SELECT 
ss.[Name],
ss.[Manufacturer]
FROM [Spaceships] AS ss
JOIN [Journeys] AS j ON j.[SpaceshipId] = ss.[Id] 
JOIN [TravelCards] AS tc
ON tc.[JourneyId] = j.[Id] AND tc.[JobDuringJourney] = 'Pilot'
JOIN [Colonists] AS c 
ON c.[Id]= tc.[ColonistId] AND DATEDIFF(YEAR,c.[BirthDate], '01/01/2019') < 30
ORDER BY ss.[Name]

--9. Select all planets and their journey count

SELECT 
 	p.[Name],
	COUNT(*) AS [JourneysCount]
	FROM Planets p
	JOIN [Spaceports] sp ON sp.[PlanetId] = p.[Id]
	JOIN [Journeys] j ON j.[DestinationSpaceportId] = sp.[Id]
	GROUP BY p.[Name]
	ORDER BY [JourneysCount] DESC, p.[Name]

--10. Select Second Oldest Important Colonist
SELECT 
	* FROM 
	(
	SELECT
	tc.[JobDuringJourney],
	c.[FirstName] + ' ' + c.[LastName] AS [FullName],
	DENSE_RANK() OVER(PARTITION BY [JobDuringJourney] ORDER BY c.[BirthDate]) AS [JobRank]
	FROM [Colonists] c JOIN [TravelCards] tc ON tc.[ColonistId] = c.[Id]
	) AS k
	WHERE k.[JobRank] = 2

--11.Get Colonists Count
GO

CREATE FUNCTION udf_GetColonistsCount(@PlanetName VARCHAR (30))
RETURNS INT
AS
BEGIN

	DECLARE 
		@Result INT = (SELECT 
						COUNT(*)
						FROM [Planets] p
						JOIN [Spaceports] sp ON sp.[PlanetId] = p.[Id]
						JOIN [Journeys] j ON j.[DestinationSpaceportId] = sp.[Id]
						JOIN [TravelCards] tc ON tc.[JourneyId] = j.[Id]
						JOIN [Colonists] c ON c.[Id] = tc.[ColonistId]
						WHERE p.[Name] = @PlanetName
					  );

	RETURN @Result;

END

GO
--12. Change Journey Purpose
CREATE PROC usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(11))
AS
BEGIN

	IF NOT EXISTS (SELECT * FROM [Journeys] WHERE [Id] = @JourneyId)
		THROW 50001, 'The journey does not exist!', 1
	
	IF ((SELECT [Purpose] FROM [Journeys] WHERE [Id] = @JourneyId) = @NewPurpose)
		THROW 50002, 'You cannot change the purpose!', 1
	
	UPDATE 
		[Journeys]
		SET [Purpose] = @NewPurpose
		WHERE [Id] = @JourneyId

END

