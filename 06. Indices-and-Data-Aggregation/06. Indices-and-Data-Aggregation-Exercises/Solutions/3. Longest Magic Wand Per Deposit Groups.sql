--USE [Gringotts]
--SELECT * FROM [WizzardDeposits]

   SELECT [DepositGroup] AS [DepositGroup], 
         MAX([MagicWandSize]) AS [LongestMagicWand] 
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]