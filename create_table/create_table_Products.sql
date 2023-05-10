CREATE TABLE {db}.{schema}.Products (
  ProductID INT NOT NULL,
  ProductName VARCHAR(255) NOT NULL,
  SupplierID_FK INT,
  CategoryID_FK INT,
  QuantityPerUnit VARCHAR(255),
  UnitPrice DECIMAL(10, 2),
  UnitsInStock INT,
  UnitsOnOrder INT,
  ReorderLevel INT,
  Discontinued BIT
);
