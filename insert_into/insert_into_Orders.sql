INSERT INTO {db}.{schema}.Orders
    ([OrderID], [CustomerID_FK], [EmployeeID_FK], [OrderDate], [RequiredDate], [ShippedDate], [ShipViaID_FK], [Freight], [ShipName], [ShipAddress], [ShipCity], [ShipRegion], [ShipPostalCode], [ShipCountry], [TerritoryID_FK])
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
