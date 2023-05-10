CREATE TABLE {db}.{schema}.dim_Suppliers_SCD1_with_delete(
   SupplierID_SK INT PRIMARY KEY IDENTITY(1,1),
   SupplierID_NK INT,
   CompanyName VARCHAR(255),
   ContactName VARCHAR(255),
   ContactTitle VARCHAR(255),
   Address VARCHAR(255),
   City VARCHAR(255),
   Region VARCHAR(255),
   PostalCode VARCHAR(50),
   Country VARCHAR(255),
   Phone VARCHAR(50),
   Fax VARCHAR(50),
   HomePage VARCHAR(300)
);
