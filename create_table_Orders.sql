DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID INT NOT NULL,
  CustomerID VARCHAR(10),
  EmployeeID INT,
  OrderDate DATE,
  RequiredDate DATE,
  ShippedDate DATE,
  ShipVia INT,
  Freight DECIMAL(10, 2),
  ShipName VARCHAR(300),
  ShipAddress VARCHAR(300),
  ShipCity VARCHAR(300),
  ShipRegion VARCHAR(300),
  ShipPostalCode VARCHAR(40),
  ShipCountry VARCHAR(300),
  TerritoryID INT
);
