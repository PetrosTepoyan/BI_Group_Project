DROP TABLE IF EXISTS fact_Orders;
GO

create table fact_Orders (
ID_SK int IDENTITY(1, 1) primary key,
CustomerID_SK_FK int foreign key references dim_Customers_SCD3(CustomerID_SK),
EmployeeID_SK_FK int foreign key references dim_Employees_SCD2(EmployeeID_SK),
OrderDate datetime,
RequiredDate datetime,
ShippedDate datetime,
ShipViaID_SK_FK int foreign key references dim_Shippers_SCD3(ShipperID_SK),
Freight decimal(10,2),
ShipName VARCHAR(50),
ShipAddress VARCHAR(50),
ShipCity VARCHAR(50),
ShipRegion VARCHAR(50),
ShipPostalCode VARCHAR(50),
ShipCountry VARCHAR(50),
TerritoryID_SK_FK int foreign key references dim_Territories_SCD3(TerritoryID_SK)
);
