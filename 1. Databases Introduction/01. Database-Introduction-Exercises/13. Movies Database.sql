--CREATE DATABASE [Movies]

--USE [Movies]

CREATE TABLE [Directors]
						(
						[Id]			INT PRIMARY KEY IDENTITY NOT NULL,	
						[DirectorName]	NVARCHAR(50)			 NOT NULL, 
						[Notes]			NVARCHAR(MAX)
						)

INSERT INTO 
	[Directors]
				([DirectorName])
				VALUES
				('Tim Berners-Lee'),
				('Leonard Kleinrock'),
				('Charles Babbage'),
				('Konrad Zuse'),
				('Steve Wozniak')

CREATE TABLE [Genres]
					(
						[Id]		INT PRIMARY KEY IDENTITY NOT NULL,
						[GenreName] NVARCHAR(50)			 NOT NULL,
						[Notes]		NVARCHAR(MAX)
					)

INSERT INTO 
			[Genres]
			([GenreName])
			VALUES
					('Action'),
					('Fantasy'),
					('Romance'),
					('Drama'),
					('Comedy')

CREATE TABLE [Categories]
						(
							[Id]			INT PRIMARY KEY IDENTITY NOT NULL,
							[CategoryName]	NVARCHAR(50)			 NOT NULL,
							[Notes]			NVARCHAR(MAX)
						)

INSERT INTO 
			[Categories]
						([CategoryName], [Notes])
						VALUES
								('Crime Thriller' , '+10'),
								('Disaster Thriller', '+15'),
								('Psychological Thriller', '+18'),
								('Techno Thriller', '+5'),
								('Other Thriller', '')

CREATE TABLE [Movies]
					(
						[Id]			INT PRIMARY KEY IDENTITY NOT NULL,
						[Title]			NVARCHAR(50)			 NOT NULL,
						[DirectorId]	INT						 NOT NULL,
						[CopyrightYear] DATETIME2				 NOT NULL,
						[Length]		INT						 NOT NULL,
						[GenreId]		INT						 NOT NULL,
						[CategoryId]	INT						 NOT NULL,
						[Rating]		DECIMAL(5,2),
						[Notes]			NVARCHAR(MAX)			 NOT NULL
				)

ALTER TABLE [Movies] 
ADD CONSTRAINT [FK_MovieDirectorId_DirectorId]
FOREIGN KEY ([DirectorId]) REFERENCES [Directors] ([Id])

ALTER TABLE [Movies] 
ADD CONSTRAINT [FK_MovieGenreId_GenreId]
FOREIGN KEY ([GenreId]) REFERENCES [Genres] ([Id])

ALTER TABLE [Movies] 
ADD CONSTRAINT [FK_MovieCategoryId_CategoryId]
FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([Id])

INSERT INTO 
			[Movies]
			([Title], [DirectorId], [CopyrightYear], [Length], [GenreId], [CategoryId], [Rating], [Notes])
	VALUES
	('The Father', 1, '2021-02-26', 155, 1, 1, 4.5, 'An aging man struggling with memory loss whose daughter moves into his flat to help care for him.'),
	('Tom & Jerry', 2, '2021-02-26', 130, 5, 1, 3.1, 'A live-action/animated hybrid.'),
	('May', 3, '2001-11-04', 152, 2, 1, 7.6, 'Based on the 2004 French film Cash Truck, Wrath of Man.'),
	('F9 The Fast Saga', 4, '2021-06-25', 130, 4, 1, 2.9, 'Crime/adventure/anti-terrorism/what-even-are-they family yet again.'),
	('Cinderella', 5, '2001-12-10', 150, 3, 1, 3.8, 'Vocal legends bringing a classic story to life.')