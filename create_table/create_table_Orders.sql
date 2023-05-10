CREATE TABLE {db}.{schema}.Orders (
  OrderID INT NOT NULL,
  CustomerID_FK VARCHAR(10),
  EmployeeID_FK INT,
  OrderDate DATE,
  RequiredDate DATE,
  ShippedDate DATE,
  ShipViaID_FK INT,
  Freight DECIMAL(10, 2),
  ShipName VARCHAR(300),
  ShipAddress VARCHAR(300),
  ShipCity VARCHAR(300),
  ShipRegion VARCHAR(300),
  ShipPostalCode VARCHAR(40),
  ShipCountry VARCHAR(300),
  TerritoryID_FK INT
);
