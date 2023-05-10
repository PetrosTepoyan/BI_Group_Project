CREATE TABLE {db}.{schema}.dim_Customers_SCD3 (
	CustomerID_SK int IDENTITY(1,1) PRIMARY KEY,
	CustomerID_NK VARCHAR(10) NOT NULL,
	ContactName varchar(255),
	ContactTitle varchar(255),
	Address VARCHAR(255),
	City VARCHAR(255),
	Region VARCHAR(255),
	PostalCode VARCHAR(20),
	Country VARCHAR(255),
	Phone VARCHAR(50),
	Fax VARCHAR(50),

	[ContactTitle_Prev1] [varchar](50) NULL,
	[ContactTitle_Prev1_ValidTo] [char] (8) NULL
);
# FIXME