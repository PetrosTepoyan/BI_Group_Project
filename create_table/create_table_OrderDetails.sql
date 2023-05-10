CREATE TABLE {db}.{schema}.OrderDetails (
  OrderID_FK INT NOT NULL,
  ProductID_FK INT NOT NULL,
  UnitPrice INT,
  Quantity INT,
  Discount INT
);
