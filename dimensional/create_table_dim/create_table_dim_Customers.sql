DROP TABLE IF EXISTS dim_Customers;
GO

CREATE TABLE dim_Customers (
CustomerSK int PRIMARY KEY,
CustomerID varchar(5),
CompanyName varchar(50),
ContactName varchar(50),
ContactTitle varchar(50),
Address varchar(255),
City varchar(50),
Region varchar(50),
PostalCode varchar(10),
Country varchar(50),
Phone varchar(20),
Fax varchar(20)
);

