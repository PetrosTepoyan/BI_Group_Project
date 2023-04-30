DROP TABLE IF EXISTS OrderDetails;
CREATE TABLE OrderDetails (
  OrderID INT NOT NULL,
  ProductID INT NOT NULL,
  UnitPrice INT,
  Quantity INT,
  Discount INT
);
