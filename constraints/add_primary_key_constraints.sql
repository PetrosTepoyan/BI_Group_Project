ALTER TABLE {db}.{schema}.Categories ADD CONSTRAINT PK_Categories PRIMARY KEY (CategoryID);
ALTER TABLE {db}.{schema}.Customers ADD CONSTRAINT PK_Customers PRIMARY KEY (CustomerID);
ALTER TABLE {db}.{schema}.Employees ADD CONSTRAINT PK_Employees PRIMARY KEY (EmployeeID);
ALTER TABLE {db}.{schema}.OrderDetails ADD CONSTRAINT PK_OrderDetails PRIMARY KEY (OrderID_FK, ProductID_FK);
ALTER TABLE {db}.{schema}.Orders ADD CONSTRAINT PK_Orders PRIMARY KEY (OrderID);
ALTER TABLE {db}.{schema}.Products ADD CONSTRAINT PK_Products PRIMARY KEY (ProductID);
ALTER TABLE {db}.{schema}.Region ADD CONSTRAINT PK_Region PRIMARY KEY (RegionID);
ALTER TABLE {db}.{schema}.Shippers ADD CONSTRAINT PK_Shippers PRIMARY KEY (ShipperID);
ALTER TABLE {db}.{schema}.Suppliers ADD CONSTRAINT PK_Suppliers PRIMARY KEY (SupplierID);
ALTER TABLE {db}.{schema}.Territories ADD CONSTRAINT PK_Territories PRIMARY KEY (TerritoryID);
