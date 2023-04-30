DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
  ProductID INT NOT NULL,
  ProductName VARCHAR(255) NOT NULL,
  SupplierID INT,
  CategoryID INT,
  QuantityPerUnit VARCHAR(255),
  UnitPrice DECIMAL(10, 2),
  UnitsInStock INT,
  UnitsOnOrder INT,
  ReorderLevel INT,
  Discontinued BIT
);
