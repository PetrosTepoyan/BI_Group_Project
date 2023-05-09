DROP TABLE IF EXISTS dim_Categories;
GO

CREATE TABLE dim_Categories (
CategorySK int PRIMARY KEY,
CategoryID int,
CategoryName varchar(50),
Description varchar(255)
);


