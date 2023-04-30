DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
  CustomerID INT NOT NULL,
  CompanyName VARCHAR(255),
  ContactName VARCHAR(255),
  ContactTitle VARCHAR(255),
  Address VARCHAR(255),
  City VARCHAR(255),
  Region VARCHAR(255),
  PostalCode VARCHAR(20),
  Country VARCHAR(255),
  Phone VARCHAR(50),
  Fax VARCHAR(50)
);
