CREATE TABLE {db}.{schema}.dim_Customers_SCD3 (
	CustomerID_SK int IDENTITY(1,1) PRIMARY KEY,
	CustomerID_NK VARCHAR(10) NOT NULL,
	ContactName varchar(50),
	ContactTitle varchar(255),
	[ContactTitle_Prev1] [varchar](50) NULL,
	[ContactTitle_Prev1_ValidTo] [char] (8) NULL
);