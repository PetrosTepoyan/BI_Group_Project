insert into {db_dim}.{schema_dim}.fact_Orders
(OrderDate, RequiredDate, ShippedDate, Freight, ShipName, ShipAddress, ShipCity, ShipPostalCode, ShipCountry, UnitPrice, Quantity, Discount, CustomerID_SK_FK, EmployeeID_SK_FK, ProductID_SK_FK, ShipViaID_SK_FK, TerritoryID_SK_FK)
(
    select 
        orders.OrderDate,
        orders.RequiredDate,
        orders.ShippedDate, 
        orders.Freight, orders.ShipName, 
        orders.ShipAddress, 
        orders.ShipCity, 
        orders.ShipPostalCode, 
        orders.ShipCountry, 

        order_details.UnitPrice, 
        order_details.Quantity, 
        order_details.Discount, 

        dim_cst.CustomerID_SK, 
        dim_emp.EmployeeID_SK, 
        dim_prod.ProductID_SK, 
        dim_shp.ShipperID_SK, 
        dim_ter.TerritoryID_SK
    
    
    from {db_rel}.{schema_rel}.OrderDetails as order_details

    left join {db_rel}.{schema_rel}.Orders as orders 
        on order_details.OrderID_FK = orders.OrderID

    left join {db_dim}.{schema_dim}.dim_Customers_SCD3 as dim_cst
        on dim_cst.CustomerID_NK = orders.CustomerID_FK

    left join {db_dim}.{schema_dim}.dim_Products_SCD4 as dim_prod
        on order_details.ProductID_FK = dim_prod.BusinessKey -- CORRECT

    left join {db_dim}.{schema_dim}.dim_Employees_SCD2 as dim_emp
        on orders.EmployeeID_FK = dim_emp.BusinessKey -- CORRECT

    left join {db_dim}.{schema_dim}.dim_Shippers_SCD3 as dim_shp 
        on orders.ShipViaID_FK = dim_shp.ShipperID_NK

    left join {db_dim}.{schema_dim}.dim_Territories_SCD3 as dim_ter
        on orders.TerritoryID_FK = dim_ter.TerritoryID_NK
)
