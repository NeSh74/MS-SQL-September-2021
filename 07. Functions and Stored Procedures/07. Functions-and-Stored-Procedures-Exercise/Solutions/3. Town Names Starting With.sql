--USE [SoftUni]

--GO

CREATE PROCEDURE usp_GetTownsStartingWith @startLetters NVARCHAR(25)
AS 
BEGIN
	SELECT [Name] AS [Town]
	  FROM [Towns]
	 WHERE [NAME] LIKE @startLetters + '%'
END

--GO

--EXEC usp_GetTownsStartingWith "b"