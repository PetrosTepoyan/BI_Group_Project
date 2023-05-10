CREATE TABLE {db}.{schema}.dim_Suppliers_SCD1_with_delete(
   SupplierID_SK INT PRIMARY KEY IDENTITY(1,1),
   SupplierID_NK INT,
   CompanyName VARCHAR(50),
   ContactName VARCHAR(50),
   ContactTitle VARCHAR(50)
);
