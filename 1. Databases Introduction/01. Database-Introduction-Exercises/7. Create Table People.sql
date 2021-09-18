CREATE TABLE [People]
					(
					[Id] INT PRIMARY KEY IDENTITY(1,1),
					[Name] NVARCHAR(200) NOT NULL,
					[Picture] VARBINARY(2),
					[Height] DECIMAL(5,2),
					[Weight] DECIMAL(5,2),
					[Gender] CHAR(1) NOT NULL,
					[Birthdate] DATE NOT NULL,
					[Biography] NVARCHAR(MAX)
					)

INSERT INTO 
		[People]	
				([Name], [Picture], [Height], [Weight], [Gender], [Birthdate], [Biography]) 
				VALUES
('Anna Ivanova',	2, 160, 65, 'f', '1992-04-02', 'Born in Sofia.'),
('Anton Petrov',	2, 170, 65, 'm', '2000-06-30', 'Born in Plovdiv.'),
('Georgi Peshev',	2, 160, 85, 'm', '1997-12-06', 'Born in Sliven.'),
('Milena Ivanova',	2, 162, 75, 'f', '1992-04-02', 'Born in Sofia.'),
('Stoyan Stoyanov', 2, 160, 65, 'm', '1980-10-05', 'Born in Pleven.')


--CREATE TABLE [People]
--						(
--						[Id] BIGINT PRIMARY KEY IDENTITY,
--						[Name] NVARCHAR(200) UNIQUE NOT NULL,
--						[Picture] VARBINARY(MAX),
--						CHECK (DATALENGTH([Picture]) <= 2000*1024),
--						[Height] FLOAT(2),
--						[Weight] FLOAT(2),
--						[Gender] CHAR(1) CONSTRAINT One_letter CHECK([Gender] in ('f','m')) NOT NULL,
--						[Birthdate] DATE NOT NULL,
--						[Biography] NVARCHAR(MAX)
--						)

--INSERT INTO 
--		[People]	
--				([Name], [Picture], [Height], [Weight], [Gender], [Birthdate], [Biography]) 
--				VALUES
--('Anna Ivanova',	2, 160, 65, 'f', '1992-04-02', 'Born in Sofia.'),
--('Anton Petrov',	2, 170, 65, 'm', '2000-06-30', 'Born in Plovdiv.'),
--('Georgi Peshev',	2, 160, 85, 'm', '1997-12-06', 'Born in Sliven.'),
--('Milena Ivanova',	2, 162, 75, 'f', '1992-04-02', 'Born in Sofia.'),
--('Stoyan Stoyanov', 2, 160, 65, 'm', '1980-10-05', 'Born in Pleven.')