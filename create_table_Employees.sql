DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
  EmployeeID INT NOT NULL,
  LastName VARCHAR(255),
  FirstName VARCHAR(255),
  Title VARCHAR(255),
  TitleOfCourtesy VARCHAR(50),
  BirthDate DATE,
  HireDate DATE,
  Address VARCHAR(255),
  City VARCHAR(255),
  Region VARCHAR(255),
  PostalCode VARCHAR(20),
  Country VARCHAR(255),
  HomePhone VARCHAR(50),
  Extension VARCHAR(10),
  Notes TEXT,
  ReportsTo INT,
  PhotoPath VARCHAR(255)
);
