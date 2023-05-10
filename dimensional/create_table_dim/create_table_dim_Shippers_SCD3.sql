CREATE TABLE {db}.{schema}.dim_Shippers_SCD3 (
	ShipperID_SK int IDENTITY(1,1) PRIMARY KEY,
	ShipperID_NK INT NOT NULL,
	CompanyName VARCHAR(50),
	Phone varchar(50),
	[Phone_Prev1] [varchar](50) NULL,
	[Phone_Prev1_ValidTo] [char] (8) NULL
);