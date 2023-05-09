DROP TABLE IF EXISTS dim_Suppliers;
GO

create table dim_Suppliers (
SupplierSK int primary key,
SupplierID nvarchar(50),
CompanyName nvarchar(50),
ContactName nvarchar(50),
ContactTitle nvarchar(50),
Address nvarchar(50),
City nvarchar(50),
Region nvarchar(50),
PostalCode nvarchar(50),
Country nvarchar(50),
Phone nvarchar(50),
Fax nvarchar(50),
HomePage nvarchar(50)
);

