DROP TABLE IF EXISTS dim_Shippers;
GO

create table dim_Shippers (
ShipperSK int primary key,
ShipperID nvarchar(50),
CompanyName nvarchar(50),
Phone nvarchar(50)
);


