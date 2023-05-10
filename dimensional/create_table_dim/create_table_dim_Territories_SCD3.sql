CREATE TABLE {db}.{schema}.dim_Territories_SCD3 (
	TerritoryID_SK int IDENTITY(1,1) PRIMARY KEY,
	TerritoryID_NK INT NOT NULL,
	Description varchar(255),
	[description_Prev1] [varchar](50) NULL,
	[description_Prev1_ValidTo] [char] (8) NULL
);