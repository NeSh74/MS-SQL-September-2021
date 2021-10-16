USE [WMS]

GO

CREATE PROCEDURE usp_PlaceOrder @jobId INT, @partSerialNumber VARCHAR(50), @quantity INT
AS
BEGIN
		IF(@quantity <= 0)
		BEGIN
		THROW 50012, 'Part quantity must be more than zero!', 1
		END

		IF((SELECT [Status] FROM [Jobs]
		WHERE [JobId] = @jobId) = 'Finished')
		BEGIN
		THROW 50011, 'This job is not active!', 1
		END

		DECLARE @jobIdDb INT = (
								SELECT [JobId] FROM [Jobs]
								WHERE [JobId] = @jobId
								)

		IF (@jobIdDb IS NULL)
		BEGIN
		THROW 50013, 'Job not found!', 1
		END

		DECLARE @partId INT = (
								SELECT [PartId] FROM [Parts]
								WHERE [SerialNumber] = @partSerialNumber
								)

		IF (@partId IS NULL)
		BEGIN
		THROW 50014, 'Part not found!', 1
		END

		IF((SELECT [OrderId] FROM [Orders]
		WHERE [jobId] = @jobId AND [IssueDate] IS NULL) IS NULL)
		BEGIN
		INSERT INTO [Orders]([JobId], [IssueDate], [Delivered])
		VALUES
		(@jobId, NULL, 0)
END
		DECLARE @orderId INT = (
									(SELECT [OrderId] FROM [Orders]
									WHERE [jobId] = @jobId AND [IssueDate] IS NULL)
									)

		DECLARE @orderedPartQuantity INT = (
		SELECT [Quantity] FROM [OrderParts]
		WHERE [OrderId] = @orderId AND [PartId] = @partId
		)

		IF (@orderedPartQuantity IS NULL)
		BEGIN
			INSERT INTO [OrderParts]([OrderId], [PartId], [Quantity])
			VALUES
			(@orderId, @partId, @quantity)
		END
		ELSE
		BEGIN
			UPDATE [OrderParts]
			SET [Quantity] += @quantity
			WHERE [OrderId] = @orderId AND [PartId] = @partId
		END
END

GO