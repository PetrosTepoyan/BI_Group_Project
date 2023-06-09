create table {db}.{schema}.fact_Orders (
ID_SK int IDENTITY(1, 1) primary key,
OrderDate DATE,
RequiredDate DATE,
ShippedDate DATE,
Freight DECIMAL(10,2),
ShipName VARCHAR(50),
ShipAddress VARCHAR(50),
ShipCity VARCHAR(50),
ShipRegion VARCHAR(50),
ShipPostalCode VARCHAR(50),
ShipCountry VARCHAR(50),

UnitPrice Int,
Quantity Int,
Discount Int,

CustomerID_SK_FK int foreign key references {db}.{schema}.dim_Customers_SCD3(CustomerID_SK),
EmployeeID_SK_FK int foreign key references {db}.{schema}.dim_Employees_SCD2(EmployeeID_SK),
ProductID_SK_FK int foreign key references {db}.{schema}.dim_Products_SCD4(ProductID_SK),
ShipViaID_SK_FK int foreign key references {db}.{schema}.dim_Shippers_SCD3(ShipperID_SK),
TerritoryID_SK_FK int foreign key references {db}.{schema}.dim_Territories_SCD3(TerritoryID_SK),
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
