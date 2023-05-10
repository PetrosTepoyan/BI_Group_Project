insert into {db_dim}.{schema_dim}.fact_Orders
{fact_Orders.columns...}
(
    select {fact_Orders.columns...} dim_prod.ProductID_SK, dim_emp.EmployeeID_SK
    
    from {db_rel}.{schema_rel}.OrderDetails as order_details

    left join {db_rel}.{schema_rel}.Orders as orders 
        on order_details.OrderID = orders.OrderID -- IDSHERE

    left join {db_dim}.{schema_dim}.dim_Products_SCD4 as dim_prod
        on order_details.ProductID = dim_prod.BusinessKey -- CORRECT

    -- left join {db_dim}.{schema_dim}.dim_Categories_SCD3 as dim_cat 
    --     on dim_cat.CategoryID_NK = order_details.CategoryID

    left join {db_dim}.{schema_dim}.dim_Employees_SCD2 as dim_emp
        on orders.EmployeeID_FK = dim_emp.BusinessKey -- CORRECT

    left join {db_dim}.{schema_dim}.dim_Shippers_SCD3 as dim_shp 
        on dim_shp.ShipViaID_SK = ShipViaID_SK_FK

    left join {db_dim}.{schema_dim}.dim_Territories_SCD3 as dim_ter
        on dim_ter.TerritoryID_SK = TerritoryID_SK_FK
)

-- create table fact_Orders (
-- ID_SK int IDENTITY(1, 1) primary key,
-- CustomerID_SK_FK int foreign key references dim_Customers_SCD3(CustomerID_SK),
-- EmployeeID_SK_FK int foreign key references dim_Employees_SCD2(EmployeeID_SK),
-- OrderDate datetime,
-- RequiredDate datetime,
-- ShippedDate datetime,
-- ShipViaID_SK_FK int foreign key references dim_Shippers_SCD3(ShipperID_SK),
-- Freight decimal(10,2),
-- ShipName VARCHAR(50),
-- ShipAddress VARCHAR(50),
-- ShipCity VARCHAR(50),
-- ShipRegion VARCHAR(50),
-- ShipPostalCode VARCHAR(50),
-- ShipCountry VARCHAR(50),
-- TerritoryID_SK_FK int foreign key references dim_Territories_SCD3(TerritoryID_SK)
-- );

-- CREATE TABLE {db}.{schema}.OrderDetails (
--   OrderID INT NOT NULL,
--   ProductID INT NOT NULL,
--   UnitPrice INT,
--   Quantity INT,
--   Discount INT
-- );

