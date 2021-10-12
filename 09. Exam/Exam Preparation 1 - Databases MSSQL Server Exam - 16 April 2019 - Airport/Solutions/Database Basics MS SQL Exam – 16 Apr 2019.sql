--CREATE DATABASE [Airport]

--USE [Airport]

--1. DDL (30 pts)

CREATE TABLE [Planes](
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL,
[Seats] INT NOT NULL,
[Range] INT NOT NULL
)

CREATE TABLE [Flights](
[Id] INT PRIMARY KEY IDENTITY,
[DepartureTime] DATETIME2,
[ArrivalTime] DATETIME2,
[Origin] VARCHAR(50) NOT NULL,
[Destination] VARCHAR(50) NOT NULL,
[PlaneId] INT FOREIGN KEY REFERENCES [Planes]([Id]) NOT NULL
)

CREATE TABLE [Passengers](
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] VARCHAR(30) NOT NULL,
[LastName]  VARCHAR(30) NOT NULL,
[Age] INT NOT NULL,
[Address]  VARCHAR(30) NOT NULL,
[PassportId] CHAR(11) NOT NULL,
)

CREATE TABLE [LuggageTypes](
[Id] INT PRIMARY KEY IDENTITY,
[Type] VARCHAR(30) NOT NULL
)

CREATE TABLE [Luggages](
[Id] INT PRIMARY KEY IDENTITY,
[LuggageTypeId] INT FOREIGN KEY REFERENCES [LuggageTypes]([Id]) NOT NULL,
[PassengerId] INT FOREIGN KEY REFERENCES [Passengers]([Id]) NOT NULL
)

CREATE TABLE [Tickets](
[Id] INT PRIMARY KEY IDENTITY,
[PassеngerId] INT FOREIGN KEY REFERENCES [Passengers]([Id]) NOT NULL,
[FlightId] INT FOREIGN KEY REFERENCES [Flights]([Id]) NOT NULL,
[LuggageId] INT FOREIGN KEY REFERENCES [Luggages]([Id]) NOT NULL,
[Price] DECIMAL (15, 2) NOT NULL
)

--2. Insert

INSERT INTO [Planes]([Name], [Seats], [Range])
VALUES
('Airbus 336',	112,	5132),
('Airbus 330',	432,	5325),
('Boeing 369',	231,	2355),
('Stelt 297',	254,	2143),
('Boeing 338',	165,	5111),
('Airbus 558',	387,	1342),
('Boeing 128',	345,	5541)

INSERT INTO [LuggageTypes]([Type])
VALUES
('Crossbody Bag'),
('School Backpack'),
('Shoulder Bag')

--3. Update

UPDATE
	[Tickets]
	SET [Price] += [Price] * 0.13
	WHERE [FlightId] = 41
	--WHERE [FlightId] IN(
	--SELECT [Id] FROM [Flights]
	--WHERE [Destination] = 'Carlsbad'
	--)

--4.1. Delete

SELECT [Id] FROM [Flights]
WHERE [Destination] = 'Ayn Halagim'

DELETE FROM [Tickets]
WHERE [FlightId] IN (
SELECT [Id] FROM [Flights]
WHERE [Destination] = 'Ayn Halagim'
)

DELETE FROM [Flights]
WHERE [Destination] = 'Ayn Halagim'

--4.2. Delete

DELETE 
	Tickets 
	WHERE FlightId = 30

DELETE 
	Flights 
	WHERE Destination = 'Ayn Halagim'

--5.The "Tr" Planes

SELECT * FROM [Planes]
WHERE [Name] LIKE '%tr%' --WHERE CHARINDEX('tr', [Name], 1) > 0 
ORDER BY [Id], [Name], [Seats], [Range]

--6.1. Flight Profits

SELECT t.[FlightId],
SUM(t.[Price]) AS [Price]
FROM [Flights] AS f
INNER JOIN [Tickets] AS t
ON f.[Id] = t.[FlightId]
GROUP BY t.[FlightId]
ORDER BY [Price] DESC, [FlightId]  


--6.2. Flight Profits
SELECT 
	[FlightId], 
	SUM([Price]) AS [Price]
	FROM [Tickets]
	GROUP BY [FlightId]
	ORDER BY SUM([Price]) DESC, [FlightId]

--7.1. Passenger Trips

SELECT CONCAT(p.[FirstName], ' ', p.[LastName]) AS [Full Name],
f.[Origin],
f.[Destination]
FROM [Passengers] AS p
INNER JOIN [Tickets] AS t
ON t.[PassеngerId] = p.[Id]
INNER JOIN [Flights] AS f
ON t.[FlightId] = f.[Id]
ORDER BY [Full Name], f.[Origin], f.[Destination]

--7.2. Passenger Trips

SELECT 
	CONCAT([FirstName], ' ', [LastName]) AS [Full Name],
	[Origin],
	[Destination]
	FROM [Passengers] p
	JOIN [Tickets] t ON t.[PassengerId] = p.[Id]
	JOIN [Flights] f ON f.[Id] = t.[FlightId]
	ORDER BY CONCAT([FirstName], ' ', [LastName]), [Origin], [Destination]

--8. Non Adventures People

SELECT p.[FirstName] AS [First Name] ,
	   p.[LastName] AS [Last Name],
	   p.[Age]  
FROM [Passengers] AS p
LEFT JOIN [Tickets] AS t
ON p.[Id] = t.[PassеngerId]
WHERE t.[Id] IS NULL
ORDER BY p.[Age] DESC, [First Name], [Last Name]

--9.1. Full Info

SELECT CONCAT(p.[FirstName], ' ', p.[LastName]) AS [Full Name],
			  pl.[Name] AS [Plane Name],
	   CONCAT(f.[Origin], ' - ', f.[Destination]) AS [Trip],
	         lt.[Type] AS [Luggage Type]
FROM [Passengers] AS p
INNER JOIN [Tickets] AS t
ON t.[PassеngerId] = p.[Id]
INNER JOIN [Flights] AS f
ON t.[FlightId] = f.[Id]
INNER JOIN [Planes] AS pl
ON f.[PlaneId] = pl.[Id]
INNER JOIN [Luggages] AS l
ON t.[LuggageId] = l.[Id]
INNER JOIN [LuggageTypes] AS lt
ON l.[LuggageTypeId] = lt.[Id]
ORDER BY [Full Name], [Plane Name], f.[Origin], f.[Destination], [Luggage Type]

--9.2. Full Info

SELECT 
	CONCAT(P.FirstName, ' ', P.LastName) AS [Full Name],
	PL.[Name],
	CAST(F.Origin + ' - ' + F.[Destination] AS NVARCHAR(MAX)) AS Trip,
	LT.[Type]
	FROM Passengers P
	JOIN Tickets T ON T.PassengerId = P.Id
	JOIN Flights F ON F.Id = T.FlightId
	JOIN Planes PL ON PL.Id = F.PlaneId
	JOIN Luggages L ON L.Id = T.LuggageId
	JOIN LuggageTypes LT ON LT.Id = L.LuggageTypeId
	ORDER BY [Full Name], PL.[Name], F.Origin, F.Destination, LT.[Type]

--10. PSP

SELECT pl.[Name],
	   pl.[Seats],
	   COUNT(t.[PassеngerId]) AS [Passengers Count]
FROM [Planes] AS pl
LEFT JOIN [Flights] AS f
ON pl.[Id] = f.[Id]
LEFT JOIN [Tickets] AS t
ON f.[Id] = t.[FlightId]
GROUP BY pl.[Name], pl.[Seats]
ORDER BY [Passengers Count] DESC, [Name], [Seats]

--11.	Vacation

CREATE FUNCTION udf_CalculateTickets(@origin VARCHAR(50), @destination VARCHAR(50), @peopleCount INT) 
RETURNS VARCHAR(70)
AS
BEGIN
IF (@peopleCount <=0)
BEGIN
RETURN 'Invalid people count!';
END

DECLARE @flightId INT = (
SELECT TOP (1) Id FROM Flights
WHERE [Origin] = @origin AND Destination = @destination
);

IF (@flightId IS NULL)
BEGIN
RETURN 'Invalid flight!';
END

DECLARE @pricePerTicket DECIMAL(15, 2) = (
SELECT TOP (1) [Price] FROM [Tickets]
WHERE [FlightId] = @flightId
);

DECLARE @totalPrice DECIMAL(24, 2) = @pricePerTicket * @peopleCount;

RETURN CONCAT('Total price ', @totalPrice);

END

--SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', 33)
--SELECT dbo.udf_CalculateTickets('Kolyshley','Rancabolang', -1)
--SELECT dbo.udf_CalculateTickets('Invalid','Rancabolang', 33)

--12.1.	Wrong Data

CREATE PROCEDURE usp_CancelFlights
AS
BEGIN
UPDATE [Flights] 
SET [DepartureTime] = NULL, [ArrivalTime] = NULL
WHERE DATEDIFF(SECOND, [ArrivalTime], [DepartureTime]) < 0

--SELECT [DepartureTime], [ArrivalTime], DATEDIFF(SECOND, [DepartureTime], [ArrivalTime])
-- FROM [Flights]
END

--12.2.	Wrong Data

CREATE PROC usp_CancelFlights
AS
BEGIN
	
	UPDATE
		Flights
		SET ArrivalTime = NULL, 
		DepartureTime = NULL
		WHERE ArrivalTime > DepartureTime

END

--EXEC usp_CancelFlights