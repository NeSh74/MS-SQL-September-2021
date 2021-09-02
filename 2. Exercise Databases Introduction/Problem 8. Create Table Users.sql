CREATE TABLE Users
(
	Id BIGINT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARCHAR(MAX),
	LastLoginTime DATETIME,
	IsDeleted BIT
)
INSERT INTO Users 
(Username, [Password], ProfilePicture,LastLoginTime, IsDeleted)
VALUES
('NeSh', 'strongpas123','https://avatars.githubusercontent.com/u/72164309?v=4','01/08/2021', 0),
('MeSh', 'strongpas1234','https://avatars.githubusercontent.com/u/72164309?v=4','02/08/2021', 0),
('Mika', 'strongpas12345','https://avatars.githubusercontent.com/u/72164309?v=4','03/08/2021', 0),
('Gigo', 'strongpas123456','https://avatars.githubusercontent.com/u/72164309?v=4','04/08/2021', 0),
('Pesho', 'strongpas1234567','https://avatars.githubusercontent.com/u/72164309?v=4','05/08/2021', 0)