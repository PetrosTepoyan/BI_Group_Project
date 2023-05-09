DROP TABLE IF EXISTS dim_Products;
GO

create table dim_Products (
ProductSK int primary key,
ProductID int,
ProductName nvarchar(50),
SupplierSK int foreign key references dim_Suppliers(SupplierSK),
CategorySK int foreign key references dim_Categories(CategorySK),
QuantityPerUnit nvarchar(50),
UnitPrice decimal(10,2),
UnitsInStock int,
UnitsOnOrder int,
ReorderLevel int,
Discontinued bit,
[ValidFrom] [datetime] DEFAULT  current_timestamp,  -- adding this for SCD4
);

