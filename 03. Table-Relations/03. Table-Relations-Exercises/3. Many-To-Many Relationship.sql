--CREATE DATABASE [EntityRelationsDemo2021]

--USE [EntityRelationsDemo2021]

CREATE TABLE [Students](
						[StudentID] INT PRIMARY KEY IDENTITY NOT NULL,
						[Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE [Exams](
					[ExamID] INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
					[Name] NVARCHAR(75) NOT NULL
)

CREATE TABLE [StudentsExams](
					[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]) NOT NULL,
					[ExamID] INT FOREIGN KEY REFERENCES [Exams]([ExamID]) NOT NULL,
					PRIMARY KEY ([StudentID], [ExamID]) --Composit Primary Key
)

INSERT INTO [Students]([Name]) 
	VALUES
			('Mila'),                                      
			('Toni'),
			('Ron')

INSERT INTO [Exams]([Name]) 
	VALUES
			('SpringMVC'),
			('Neo4j'),
			('Oracle 11g')

INSERT INTO [StudentsExams]([StudentID], [ExamID]) 
	VALUES
			(1, 101),
			(1,	102),
			(2,	101),
			(3,	103),
			(2,	102),
			(2,	103)



--SELECT * FROM [Students]
--SELECT * FROM [Exams]
--SELECT * FROM [StudentsExams]

--SELECT s.[Name], e.[Name] FROM StudentsExams AS se
--JOIN Students AS s ON se.StudentID = s.StudentID 
--JOIN Exams AS E ON se.ExamID = e.ExamID