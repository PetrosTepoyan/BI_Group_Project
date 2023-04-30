DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID INT NOT NULL,
  CustomerID INT,
  EmployeeID INT,
  OrderDate DATE,
  RequiredDate DATE,
  ShippedDate DATE,
  ShipVia INT,
  Freight DECIMAL(10, 2),
  ShipName VARCHAR(255),
  ShipAddress VARCHAR(255),
  ShipCity VARCHAR(255),
  ShipRegion VARCHAR(255),
  ShipPostalCode INT,
  ShipCountry VARCHAR(255),
  TerritoryID INT
);
