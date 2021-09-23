--CREATE DATABASE [EntityRelationsDemo2021]

--USE [EntityRelationsDemo2021]

CREATE TABLE [Teachers](
						[TeacherID] INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
						[Name] VARCHAR(50) NOT NULL,
						[ManagerID] INT FOREIGN KEY REFERENCES [Teachers]([TeacherID]) --CAN BE NULL, SEE THE CELL 1
)

INSERT INTO [Teachers]([Name], [ManagerID])
	VALUES
			('John', NULL),
			('Maya', 106),
			('Silvia', 106),
			('Ted', 105),
			('Mark', 101),
			('Greta', 101)

--SELECT * FROM [Teachers]