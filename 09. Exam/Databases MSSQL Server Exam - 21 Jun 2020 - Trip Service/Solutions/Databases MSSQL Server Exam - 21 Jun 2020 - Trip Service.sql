--CREATE DATABASE [TripService]

--USE [TripService]

--01. DDL 

CREATE TABLE [Cities]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(20) NOT NULL,
[CountryCode] VARCHAR(2) NOT NULL
)

CREATE TABLE [Hotels]
(
[Id] INT PRIMARY KEY IDENTITY,	
[Name] NVARCHAR(30) NOT NULL,
[CityId]	INT REFERENCES [Cities]([Id]) NOT NULL,
[EmployeeCount] INT NOT NULL,
[BaseRate]	DECIMAL(15, 2)
)

CREATE TABLE [Rooms]
(
[Id]	INT PRIMARY KEY IDENTITY,	
[Price]	DECIMAL(15,2) NOT NULL,
[Type]	NVARCHAR(20) NOT NULL,
[Beds]	INT NOT NULL,
[HotelId] INT REFERENCES [Hotels]([Id]) NOT NULL
)

CREATE TABLE [Trips]
(
[Id]	INT PRIMARY KEY IDENTITY,	
[RoomId] INT REFERENCES [Rooms]([Id]) NOT NULL,
[BookDate]	DATE NOT NULL,
[ArrivalDate]	DATE NOT NULL,
CHECK([BookDate] < [ArrivalDate]),
[ReturnDate] DATE NOT NULL,
CHECK([ArrivalDate] < [ReturnDate]),
[CancelDate] DATE
)

CREATE TABLE [Accounts]
(
[Id] INT PRIMARY KEY IDENTITY,		
[FirstName]	 NVARCHAR(50) NOT NULL,
[MiddleName] NVARCHAR(20),	
[LastName]	NVARCHAR(50) NOT NULL,
[CityId] INT REFERENCES [Cities] NOT NULL,	
[BirthDate]	DATE NOT NULL,	
[Email] VARCHAR(100) NOT NULL UNIQUE	 
)

CREATE TABLE [AccountsTrips]
(
[AccountId]	INT REFERENCES [Accounts]([Id]) NOT NULL,
[TripId] INT REFERENCES [Trips]([Id]) NOT NULL,
[Luggage] INT NOT NULL
CHECK([Luggage]>=0)

PRIMARY KEY([AccountId], [TripId])
)

--2. Insert

INSERT INTO [Accounts]([FirstName],	[MiddleName],[LastName], [CityId], [BirthDate],	[Email])
VALUES
('John',	'Smith',	'Smith',	34,	'1975-07-21',	'j_smith@gmail.com'),
('Gosho',	NULL,	'Petrov',	11,	'1978-05-16',	'g_petrov@gmail.com'),
('Ivan',	'Petrovich',	'Pavlov',	59,	'1849-09-26',	'i_pavlov@softuni.bg'),
('Friedrich',	'Wilhelm',	'Nietzsche',	2,	'1844-10-15',	'f_nietzsche@softuni.bg')

INSERT INTO [Trips]([RoomId], [BookDate], [ArrivalDate], [ReturnDate],[CancelDate])
VALUES
(101,	'2015-04-12',	'2015-04-14',	'2015-04-20',	'2015-02-02'),
(102,	'2015-07-07',	'2015-07-15',	'2015-07-22',	'2015-04-29'),
(103,	'2013-07-17',	'2013-07-23',	'2013-07-24',	NULL),
(104,	'2012-03-17',	'2012-03-31',	'2012-04-01',	'2012-01-10'),
(109,	'2017-08-07',	'2017-08-28',	'2017-08-29',	NULL)

--3. Update

UPDATE [Rooms]
SET [Price] += 0.14 * [Price]
WHERE [HotelId] IN (5, 7, 9)

--4. Delete

DELETE FROM [AccountsTrips]
WHERE [AccountId] = 47

DELETE FROM [Accounts]
WHERE [Id] = 47

--5. EEE-Mails

SELECT
a.[FirstName],
a.[LastName],
FORMAT(a.[BirthDate], 'MM-dd-yyyy') AS [BirthDate],
c.[Name] AS [Hometown],
a.[Email]
FROM [Accounts] AS a
LEFT JOIN [Cities] AS c
ON  c.[Id] = a.[CityId]
WHERE [Email] LIKE 'e%'
ORDER BY [Name]

--6. City Statistics

SELECT 
c.[Name] AS [City], 
COUNT(*) AS [Hotels]
FROM [Hotels] AS h
JOIN [Cities] AS c
ON h.[CityId] = c.[Id]
GROUP BY c.[Name]
ORDER BY [Hotels] DESC, c.[Name]

--7. Longest and Shortest Trips

SELECT 
	at.[AccountId], 
	a.[FirstName] + ' ' + a.[LastName] AS [FullName], 
	MAX(DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate])) AS [LongestTrip], 
	MIN(DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate])) AS [ShortestTrip]
	FROM [AccountsTrips] at
	LEFT JOIN [Accounts] a ON a.[Id] = at.[AccountId]
	LEFT JOIN [Trips] t ON t.Id = at.[TripId]
	WHERE a.[MiddleName] IS NULL AND t.[CancelDate] IS NULL
	GROUP BY at.[AccountId], a.[FirstName], a.[LastName]
	ORDER BY [LongestTrip] DESC, [ShortestTrip]

--8. Metropolis

SELECT TOP 10
	a.[CityId], 
	c.[Name], 
	c.[CountryCode], 
	COUNT([CityId]) AS [Accounts]
	FROM [Accounts] a
	JOIN Cities c ON c.[Id] = a.[CityId]
	GROUP BY a.[CityId], c.[Name], c.[CountryCode]
	ORDER BY [Accounts] DESC

--9. Romantic Getaways

SELECT 
	at.[AccountId], 
	a.[Email], 
	c.[Name], 
	COUNT(at.[AccountId]) AS [Trips]
	FROM [AccountsTrips] at
	JOIN Accounts a ON a.[Id] = at.[AccountId]
	JOIN Trips t ON t.[Id] = at.[TripId]
	JOIN Rooms r ON r.[Id] = t.[RoomId]
	JOIN [Hotels] h ON h.[Id] = r.[HotelId]
	JOIN [Cities] c ON c.[Id] = h.[CityId] AND c.[Id] = a.[CityId]
	GROUP BY at.[AccountId], a.[Email], c.[Name]
	ORDER BY COUNT(at.[AccountId]) DESC, at.[AccountId]

--10. GDPR Violation

SELECT 
	t.[Id],
	a.[FirstName] + ' ' + ISNULL(a.[MiddleName] + ' ', '') + a.[LastName] AS [Full Name], 
	c.[Name] AS [From],
	c2.[Name] AS [To],
	IIF(t.[CancelDate] IS NULL, CAST(DATEDIFF(DAY, t.[ArrivalDate], t.[ReturnDate]) AS VARCHAR(MAX)) + ' days', 'Canceled') AS [Duration]
	FROM [AccountsTrips] at
	JOIN Accounts a ON a.Id = at.AccountId
	JOIN Cities c ON c.Id = a.CityId
	JOIN Trips t ON t.Id = at.TripId
	JOIN Rooms r ON r.Id = t.RoomId
	JOIN Hotels h ON h.Id = r.HotelId
	JOIN Cities c2 ON c2.[Id] = h.[CityId]
	ORDER BY [Full Name], t.[Id]

--11. Available Room
GO

CREATE FUNCTION udf_GetAvailableRoom (@hotelId INT, @date DATE, @people INT)
RETURNS NVARCHAR(400)
AS
BEGIN
	
	DECLARE @roomId INT = (SELECT TOP 1 r.[Id] FROM Rooms r JOIN [Hotels] h ON h.[Id] = r.[HotelId] WHERE h.[Id] = @hotelId ORDER BY r.[Price] DESC)

	DECLARE @roomPrice DECIMAL(15, 2) = (SELECT [Price] FROM [Rooms] WHERE [Id] = @roomId)
	
	DECLARE @hotelBaseRate DECIMAL(15, 2) = (SELECT [BaseRate] FROM [Hotels] WHERE [Id] = @hotelId)

	DECLARE @totalPrice DECIMAL (15, 2) = (@hotelBaseRate + @roomPrice) * @people

	DECLARE @tripArrivalDate DATE = 
								(SELECT TOP 1 t.[ArrivalDate]	
								FROM [Rooms] r 
								JOIN [Hotels] h ON h.Id = r.[HotelId]
								JOIN [Trips] t ON t.[RoomId] = r.[Id] 
								WHERE h.[Id] = @hotelId AND t.[CancelDate] IS NULL AND t.[RoomId] = @roomId)

	DECLARE @tripReturnDate DATE = 
								(SELECT TOP 1 t.[ReturnDate] 
								FROM [Rooms] r 
								JOIN [Hotels] h ON h.[Id] = r.[HotelId] 
								JOIN [Trips] t ON t.[RoomId] = r.[Id]
								WHERE h.[Id] = @hotelId AND t.[CancelDate] IS NULL AND t.[RoomId] = @roomId)

	DECLARE @result NVARCHAR(400) = 'No rooms available'

	IF (@date BETWEEN @tripArrivalDate AND @tripReturnDate)
		RETURN @result

	IF NOT EXISTS 
	(
		SELECT r.[Id] 
		FROM [Hotels] h 
		JOIN [Rooms] r ON r.[HotelId] = h.[Id] 
		WHERE h.[Id] = @hotelId AND @roomId = ANY 
											  (
											    SELECT r.[Id] 
											    FROM [Hotels] h JOIN [Rooms] r ON r.[HotelId] = h.[Id] 
											    WHERE h.[Id] = @hotelId AND r.[Id] = @roomId
											  )
	)
		RETURN @result

	DECLARE @roomBeds INT = (SELECT [Beds] FROM [Rooms] WHERE [Id] = @roomId)

	IF (@people > @roomBeds)
		RETURN @result

	DECLARE @roomType NVARCHAR(100) = (SELECT [Type] FROM [Rooms] WHERE [Id] = @roomId)

	SET @result = 
		'Room ' + CAST(@roomId AS NVARCHAR(50)) + ': ' + CAST(@roomType AS NVARCHAR(50)) + ' (' + CAST(@roomBeds AS NVARCHAR(50)) + ' beds) - $' + CAST(@totalPrice AS NVARCHAR(50))
			RETURN @result
END

--12. Switch Room
GO

CREATE PROC usp_SwitchRoom (@TripId INT, @TargetRoomId INT)
AS
BEGIN
	DECLARE @tripHotel INT = (SELECT r.[HotelId] FROM [Trips] t JOIN [Rooms] r ON r.[Id] = t.[RoomId] WHERE t.[Id] = @TripId)
	
	DECLARE @roomHotel INT = (SELECT [HotelId] FROM [Rooms] WHERE [Id] = @TargetRoomId)

	IF (@tripHotel <> @roomHotel)
		THROW 50001, 'Target room is in another hotel!', 1

	DECLARE @bedsNeeded INT = (SELECT COUNT(*) FROM [AccountsTrips] WHERE [TripId] = @TripId)
	
	DECLARE @beds INT = (SELECT [Beds] FROM [Rooms] WHERE [Id] = @TargetRoomId)
	
	IF (@bedsNeeded > @beds)
		THROW 50002, 'Not enough beds in target room!', 1

	UPDATE 
		[Trips] 
		SET [RoomId] = @TargetRoomId 
		WHERE [Id] = @TripId
END
