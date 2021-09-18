CREATE DATABASE [SoftUni1]

USE [SoftUni1] 

CREATE TABLE [Towns]
					(
						[Id] INT PRIMARY KEY IDENTITY,
						[Name] NVARCHAR(50)				NOT NULL
					)

CREATE TABLE [Addresses]
						(
							[Id] INT PRIMARY KEY IDENTITY, 
							[AddressText] NVARCHAR(100) NOT NULL, 
							[TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]) NOT NULL
						)

CREATE TABLE [Departments]
					(
						[Id]	INT PRIMARY KEY IDENTITY,
						[Name]	NVARCHAR(50)				NOT NULL
					)

CREATE TABLE [Employees]
					(
						[Id]			INT PRIMARY KEY IDENTITY,
						[FirstName]		NVARCHAR(50)				NOT NULL, 
						[MiddleName]	NVARCHAR(50), 
						[LastName]		NVARCHAR(50)				NOT NULL, 
						[JobTitle]		NVARCHAR(30)				NOT NULL, 
						[DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]) NOT NULL,
						[HireDate] DATE NOT NULL, 
						[Salary] DECIMAL(7, 2) NOT NULL, 
						[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id]) NOT NULL
						)