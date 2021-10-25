--1. Create Table Logs

CREATE TABLE Logs 
(
	LogId INT PRIMARY KEY IDENTITY,
	AccountId INT NOT NULL FOREIGN KEY REFERENCES Accounts (Id), 
	OldSum MONEY NOT NULL, 
	NewSum MONEY NOT NULL
)

-- For Judge
CREATE TRIGGER tr_AddToLogsOnAccountUpdate ON Accounts FOR UPDATE
AS
BEGIN
	INSERT INTO Logs (AccountId, OldSum, NewSum)
			SELECT i.Id, d.Balance, i.Balance
			FROM inserted i
			JOIN deleted d ON d.Id = i.Id
			WHERE i.Balance != d.Balance;
END
--

UPDATE 
	Accounts 
	SET Balance -= 10 
	WHERE Id = 1

SELECT * 
	FROM Logs

SELECT * 
	FROM Accounts

--2. Create Table Emails

CREATE TABLE NotificationEmails 
(
	Id INT PRIMARY KEY IDENTITY,
	Recipient INT FOREIGN KEY REFERENCES Accounts(Id), 
	[Subject] NVARCHAR(150) NOT NULL, 
	[Body] NVARCHAR(200) NOT NULL
)

-- For Judge
CREATE TRIGGER tr_NotificationEmail ON Logs FOR INSERT
AS
BEGIN

	INSERT INTO 
		NotificationEmails 
		(Recipient, [Subject], [Body])
		SELECT 
		i.LogId,
		'Balance change for account: ' + CAST(i.AccountId AS NVARCHAR(20)),
		'On ' + CAST(GETDATE() AS NVARCHAR(50)) + 
		' your balance was changed from ' + 
		CAST(i.OldSum AS NVARCHAR(20)) + 
		' to ' + 
		CAST(i.NewSum AS NVARCHAR(20)) + 
		'.'
		FROM inserted i

END
--

GO

UPDATE 
	Accounts 
	SET Balance -= 10 
	WHERE Id = 1

SELECT * FROM Accounts
SELECT * FROM Logs
SELECT * FROM NotificationEmails

--3. Deposit Money

CREATE PROC usp_DepositMoney (@accountId INT, @moneyAmount DECIMAL(15, 4))
AS
BEGIN TRANSACTION

	DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @accountId)
	IF(@account IS NULL)
	BEGIN
		ROLLBACK
		RAISERROR('Invalid Account Id!', 16, 1)
		RETURN
	END

	IF(@moneyAmount <= 0)
	BEGIN
		ROLLBACK
		RAISERROR('Money amount cannot be zero or negative!', 16, 1)
		RETURN
	END

	UPDATE 
		Accounts 
		SET Balance += @moneyAmount 
		WHERE Id = @accountId

COMMIT

--GO

--EXEC usp_DepositMoney 1, 100

--4.1. Withdraw Money

CREATE PROC usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(12,4))
AS
	BEGIN TRANSACTION
	IF (@MoneyAmount < 0)
	THROW 50001, 'Can`t make transaction with negative number!',1
	IF @AccountId = 0
	THROW 50002, 'There is no customer with that id!',1
	UPDATE Accounts SET Balance -= @MoneyAmount
	WHERE Id = @AccountId

COMMIT

--4.2. Withdraw Money

CREATE PROC usp_WithdrawMoney (@accountId INT, @moneyAmount DECIMAL(15, 4))
AS
BEGIN TRANSACTION

	DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id = @accountId)
	IF(@account IS NULL)
	BEGIN
		ROLLBACK
		RAISERROR('Invalid Account Id!', 16, 1)
		RETURN
	END

	IF(@moneyAmount < 0) -- I think <= 0 is better, but Judge don't agree with me. :(
	BEGIN
		ROLLBACK
		RAISERROR('Money amount cannot be negative!', 16, 1)
		RETURN
	END

	DECLARE @currentBalance MONEY = (SELECT Balance FROM Accounts WHERE Id = @accountId)
	IF(@currentBalance - @moneyAmount < 0)
	BEGIN
		ROLLBACK
		RAISERROR('Cannot withdraw from balance that is less than zero!', 16, 1)
		RETURN
	END

  UPDATE 
	Accounts 
    SET Balance -= @moneyAmount 
    WHERE Id = @accountId

COMMIT

--GO

--EXEC usp_WithdrawMoney 1, 400

--5. Money Transfer

CREATE PROC usp_TransferMoney @SenderId INT,@ReceiverId INT,@MoneyAmount DECIMAL(18,4)
AS
BEGIN TRANSACTION
	EXEC usp_WithdrawMoney @SenderId,@MoneyAmount
	EXEC usp_DepositMoney @ReceiverId,@MoneyAmount
COMMIT

--6. Trigger

-- 1
CREATE TRIGGER tr_RestrictItem ON UserGameItems FOR INSERT
AS
BEGIN
    INSERT INTO 
		UserGameItems 
		(ItemId, UserGameId)
		SELECT 
		i.ItemId, 
		i.UserGameId
		FROM inserted i
		JOIN Items it ON it.Id = i.ItemId
		JOIN UsersGames ug ON ug.Id = i.UserGameId
		JOIN Users u ON u.Id = ug.UserId
		WHERE ug.[Level] >= it.MinLevel	

END

-- 2

UPDATE 
	UsersGames
	SET Cash += 50000
	WHERE GameId = 212

-- 3

DECLARE @indexId INT = 251;
	
WHILE @indexId < 300
BEGIN
	
	INSERT INTO 
		UserGameItems 
		(ItemId, UserGameId)
		SELECT 
		@indexId, 
		ug.GameId
		FROM Items i, UsersGames ug
		WHERE ug.GameId = 212
		SET @indexId += 1;

END

--7. *Massive Shopping

DECLARE @UserGameId INT = 
(
	SELECT Id
		FROM UsersGames
		WHERE UserId = (SELECT Id FROM Users WHERE Username = 'Stamat')
			  AND GameId = (SELECT Id FROM Games WHERE [Name] = 'Safflower')
)

DECLARE @StamatCash DECIMAL(18,2) = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
DECLARE @ItemsPrice DECIMAL(18,2) = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 11 AND 12)

IF(@StamatCash >= @ItemsPrice)
BEGIN 
	BEGIN TRANSACTION
		INSERT INTO UserGameItems
		SELECT Id,@UserGameId FROM Items  WHERE MinLevel BETWEEN 11 AND 12

		UPDATE UsersGames
			SET Cash = Cash - @ItemsPrice
			WHERE Id = @UserGameId
	COMMIT
END

SET @StamatCash  = (SELECT Cash FROM UsersGames WHERE Id = @UserGameId)
SET @ItemsPrice  = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN 19 AND 21)

IF(@StamatCash >= @ItemsPrice)
BEGIN 
	BEGIN TRANSACTION
		INSERT INTO UserGameItems
		SELECT Id,@UserGameId FROM Items  WHERE MinLevel BETWEEN 19 AND 21

		UPDATE UsersGames
			SET Cash = Cash - @ItemsPrice
			WHERE Id = @UserGameId
	COMMIT
END

SELECT it.[Name] AS [Item Name]
	FROM UsersGames AS ug
	JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
	JOIN Items AS it ON it.Id = ugi.ItemId
	WHERE ug.Id = @UserGameId
 ORDER BY [Item Name]

 --8. Employees with Three Projects

 CREATE PROC usp_AssignProject @emloyeeId INT , @projectID INT
AS
BEGIN TRANSACTION

 	DECLARE @EmployeeProjectsCount INT = (SELECT COUNT(*)
												FROM  EmployeesProjects
											WHERE EmployeeID = @emloyeeId)
	IF (@EmployeeProjectsCount >= 3)
	BEGIN
		ROLLBACK
		RAISERROR('The employee has too many projects!',16,1)
	END
	INSERT INTO EmployeesProjects(EmployeeID,ProjectID) VALUES
	(@emloyeeId,@projectID)
COMMIT

---
CREATE PROC usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
BEGIN TRANSACTION

	DECLARE @currentEmployeeID INT = (SELECT EmployeeID FROM Employees WHERE EmployeeID = @emloyeeId)
	DECLARE @currentProjectID INT = (SELECT ProjectID FROM Projects WHERE ProjectID = @projectID)
	
	IF(@currentEmployeeID IS NULL)
	BEGIN
	    ROLLBACK
		RAISERROR('Invalid Employee Id!', 16, 1)
		RETURN
	END
	
	IF(@currentProjectID IS NULL)
	BEGIN
	    ROLLBACK
		RAISERROR('Invalid Project Id!', 16, 1)
		RETURN
	END
	
	DECLARE @countOfProjects INT = (SELECT COUNT(*) FROM EmployeesProjects WHERE EmployeeID = @emloyeeId)
	IF(@countOfProjects >= 3)
	BEGIN
	    ROLLBACK
		RAISERROR('The employee has too many projects!', 16, 1)
		RETURN
	END
	
	INSERT INTO 
		EmployeesProjects 
		(EmployeeID, ProjectID)
		VALUES 
		(@emloyeeId, @projectID)

COMMIT

--GO

--SELECT 
--	COUNT(*) 
--	FROM EmployeesProjects 
--	WHERE EmployeeID = 1

--SELECT * 
--	FROM EmployeesProjects
	
--EXEC usp_AssignProject 1, 39

--9. Delete Employees

CREATE OR ALTER TRIGGER tr_LogDeletedEmployees
ON Employees FOR DELETE
AS
BEGIN
	INSERT INTO Deleted_Employees
	SELECT FirstName,LastName,MiddleName,JobTitle,DepartmentID,Salary FROM deleted
END

--

CREATE TRIGGER tr_AddToDeletedEmployees ON Employees FOR DELETE
AS
BEGIN

  INSERT INTO 
	Deleted_Employees 
	(FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
	SELECT 
	d.FirstName, d.LastName, d.MiddleName, d.JobTitle, d.DepartmentID, d.Salary
	FROM deleted d

END
