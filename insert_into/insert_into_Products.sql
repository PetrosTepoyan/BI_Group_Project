INSERT INTO {db}.{schema}.Products
    ([ProductID], [ProductName], [SupplierID_FK], [CategoryID_FK], [QuantityPerUnit], [UnitPrice], [UnitsInStock], [UnitsOnOrder], [ReorderLevel], [Discontinued])
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
