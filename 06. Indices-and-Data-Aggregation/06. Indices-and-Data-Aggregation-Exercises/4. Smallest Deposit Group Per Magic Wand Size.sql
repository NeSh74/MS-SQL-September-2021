--USE [Gringotts]
--SELECT * FROM [WizzardDeposits]

  SELECT 
	 TOP(2)
		 [DepositGroup] 
      AS [DepositGroup]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]
ORDER BY AVG([MagicWandSize])
