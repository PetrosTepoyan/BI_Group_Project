DROP TABLE IF EXISTS fact_Orders;
GO

create table fact_Orders (
OrderSK int primary key,
CustomerSK int foreign key references dim_Customers(CustomerSK),
EmployeeSK int foreign key references dim_Employees(EmployeeSK),
OrderDate datetime,
RequiredDate datetime,
ShippedDate datetime,
ShipViaSK int foreign key references dim_Shippers(ShipperSK),
Freight decimal(10,2),
ShipName nvarchar(50),
ShipAddress nvarchar(50),
ShipCity nvarchar(50),
ShipRegion nvarchar(50),
ShipPostalCode nvarchar(50),
ShipCountry nvarchar(50),
TerritorySK int foreign key references dim_Territories(TerritorySK)
);
