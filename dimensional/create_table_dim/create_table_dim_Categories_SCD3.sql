/*
	CREATING A DESTINATION TABLE
*/

DROP TABLE IF EXISTS {db}.{schema}.[dim_Categories_SCD3];
GO

CREATE TABLE {db}.{schema}.dim_Categories_SCD3 (
	CategoryID_SK int IDENTITY(1,1) PRIMARY KEY,
	CategoryID_NK INT NOT NULL,
	CategoryName varchar(50),
	Description varchar(255),
	[Description_Prev1] [varchar](50) NULL,
	[Description_Prev1_ValidTo] [char] (8) NULL
);
GO


