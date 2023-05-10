INSERT INTO {db}.{schema}.OrderDetails
    ([OrderID_FK], [ProductID_FK], [UnitPrice], [Quantity], [Discount])
    VALUES (?, ?, ?, ?, ?);
