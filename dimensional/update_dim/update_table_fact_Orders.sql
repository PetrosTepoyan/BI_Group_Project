merge into {db_dim}.{schema_dim}.fact_Orders AS DST
using (
    select order_details.*, orders.*, dimcat.sk, dimprod. 
    
    from {db_rel}.{schema_rel}.OrderDetails as order_details

    left join {db_rel}.{schema_rel}.Orders as orders 
        on order_details.OrderID = orders.OrderID -- IDSHERE

    left join {db_dim}.{schema_dim}.dim_Products_SCD4 as dim_prod
        on order_details.ProductID = dim_prod.BusinessKey -- IDSHERE

    left join {db_dim}.{schema_dim}.dim_Categories_SCD3 as dim_cat 
        on dim_cat.CategoryID_NK = order_details.CategoryID

    left join {db_dim}.{schema_dim}.dim_Employees_SCD2 as dim_emp
        on dim_emp.EmployeeID_SK = DST.EmployeeID_SK_FK

    left join {db_dim}.{schema_dim}.dim_Shippers_SCD3 as dim_shp 
        on dim_shp.ShipViaID_SK = DST.ShipViaID_SK_FK

    left join {db_dim}.{schema_dim}.dim_Territories_SCD3 as dim_ter
        on dim_ter.TerritoryID_SK = DST.TerritoryID_SK_FK
    
) AS SRC
on multiple columns
when not matched
insert

-- CREATE TABLE {db}.{schema}.OrderDetails (
--   OrderID INT NOT NULL,
--   ProductID INT NOT NULL,
--   UnitPrice INT,
--   Quantity INT,
--   Discount INT
-- );



-- create table fact_Orders (
-- OrderID_SK int primary key,
-- CustomerID_SK_FK int foreign key references dim_Customers(CustomerID_SK),
-- EmployeeID_SK_FK int foreign key references dim_Employees(EmployeeID_SK),
-- OrderDate datetime,
-- RequiredDate datetime,
-- ShippedDate datetime,
-- ShipViaID_SK_FK int foreign key references dim_Shippers(ShipperID_SK),
-- Freight decimal(10,2),
-- ShipName VARCHAR(50),
-- ShipAddress VARCHAR(50),
-- ShipCity VARCHAR(50),
-- ShipRegion VARCHAR(50),
-- ShipPostalCode VARCHAR(50),
-- ShipCountry VARCHAR(50),
-- TerritoryID_SK_FK int foreign key references dim_Territories(TerritoryID_SK)
-- );