DROP TABLE IF EXISTS fact_Orders;
GO

create table {db}.{schema}.fact_Orders (
ID_SK int IDENTITY(1, 1) primary key,
OrderDate datetime,
RequiredDate datetime,
ShippedDate datetime,
Freight decimal(10,2),
ShipName VARCHAR(50),
ShipAddress VARCHAR(50),
ShipCity VARCHAR(50),
ShipRegion VARCHAR(50),
ShipPostalCode VARCHAR(50),
ShipCountry VARCHAR(50),

CategoryID_SK_FK int foreign key references dim_Category_SCD3(CategoryID_SK),
CustomerID_SK_FK int foreign key references dim_Customers_SCD3(CustomerID_SK),
EmployeeID_SK_FK int foreign key references dim_Employees_SCD2(EmployeeID_SK),
ProductID_SK_FK int foreign key references dim_Products_SCD4(ProductID_SK),
RegionID_SK_FK int foreign key references dim_Region_SCD1_with_delete(RegionID_SK),
ShipViaID_SK_FK int foreign key references dim_Shippers_SCD3(ShipperID_SK),
SupplierID_SK int foreign key references dim_Suppliers_SCD1_with_delete(SupplierID_SK)
TerritoryID_SK_FK int foreign key references dim_Territories_SCD3(TerritoryID_SK),
);

-- CREATE TABLE {db}.{schema}.Orders (
--   OrderID INT NOT NULL,
--   CustomerID_FK VARCHAR(10),
--   EmployeeID_FK INT,
--   OrderDate DATE,
--   RequiredDate DATE,
--   ShippedDate DATE,
--   ShipViaID_FK INT,
--   Freight DECIMAL(10, 2),
--   ShipName VARCHAR(300),
--   ShipAddress VARCHAR(300),
--   ShipCity VARCHAR(300),
--   ShipRegion VARCHAR(300),
--   ShipPostalCode VARCHAR(40),
--   ShipCountry VARCHAR(300),
--   TerritoryID_FK INT
-- );

-- CREATE TABLE {db}.{schema}.OrderDetails (
--   OrderID_FK INT NOT NULL,
--   ProductID_FK INT NOT NULL,
--   UnitPrice INT,
--   Quantity INT,
--   Discount INT
-- );
