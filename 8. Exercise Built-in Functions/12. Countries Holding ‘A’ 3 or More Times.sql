--USE [Geography]

SELECT CountryName AS [Country Name], IsoCode AS [Iso Code] 
FROM Countries
WHERE CountryName LIKE '%a%a%a%'
ORDER BY IsoCode