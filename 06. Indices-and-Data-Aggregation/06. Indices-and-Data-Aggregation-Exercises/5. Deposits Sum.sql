--USE [Gringotts]
--SELECT * FROM [WizzardDeposits]

  SELECT [DepositGroup], 
         SUM([DepositAmount]) AS [TotalSum] 
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]