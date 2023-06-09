ALTER TABLE {db}.{schema}.Employees ADD CONSTRAINT FK_Employees_ReportsTo FOREIGN KEY (ReportsTo) REFERENCES Employees(EmployeeID);
ALTER TABLE {db}.{schema}.OrderDetails ADD CONSTRAINT FK_OrderDetails_OrderID FOREIGN KEY (OrderID_FK) REFERENCES Orders(OrderID);
ALTER TABLE {db}.{schema}.OrderDetails ADD CONSTRAINT FK_OrderDetails_ProductID FOREIGN KEY (ProductID_FK) REFERENCES Products(ProductID);
ALTER TABLE {db}.{schema}.Orders ADD CONSTRAINT FK_Orders_CustomerID FOREIGN KEY (CustomerID_FK) REFERENCES Customers(CustomerID);
ALTER TABLE {db}.{schema}.Orders ADD CONSTRAINT FK_Orders_EmployeeID FOREIGN KEY (EmployeeID_FK) REFERENCES Employees(EmployeeID);
ALTER TABLE {db}.{schema}.Orders ADD CONSTRAINT FK_Orders_ShipVia FOREIGN KEY (ShipViaID_FK) REFERENCES Shippers(ShipperID);
ALTER TABLE {db}.{schema}.Orders ADD CONSTRAINT FK_Orders_TerritoryID FOREIGN KEY (TerritoryID_FK) REFERENCES Territories(TerritoryID);
ALTER TABLE {db}.{schema}.Products ADD CONSTRAINT FK_Products_CategoryID FOREIGN KEY (CategoryID_FK) REFERENCES Categories(CategoryID);
ALTER TABLE {db}.{schema}.Products ADD CONSTRAINT FK_Products_SupplierID FOREIGN KEY (SupplierID_FK) REFERENCES Suppliers(SupplierID);
ALTER TABLE {db}.{schema}.Territories ADD CONSTRAINT FK_Territories_RegionID FOREIGN KEY (RegionID_FK) REFERENCES Region(RegionID);
