/*
	CREATING A DESTINATION TABLE
*/

DROP TABLE IF EXISTS {db}.{schema}.[dim_customers_SCD3];
GO

CREATE TABLE dbo.dim_customers_SCD3 (
	CustomerID_SK int IDENTITY(1,1) PRIMARY KEY,
	CustomerID_NK INT NOT NULL,
	ContactName varchar(50),
	ContactTitle varchar(255),
	[ContactTitle_Prev1] [varchar](50) NULL,
	[ContactTitle_Prev1_ValidTo] [char] (8) NULL
);
GO


/*
	CREATING AN ETL PROCEDURE
*/
DROP PROCEDURE IF EXISTS dbo.Customers_SCD3_ETL
GO

CREATE PROCEDURE dbo.Customers_SCD3_ETL
AS  
 DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
 --20210413: string/text/char
MERGE dbo.dim_customers_SCD3 AS DST
USING [dbo].[dim_Customers] AS SRC
ON (SRC.CustomerSK = DST.CustomerNK)
WHEN NOT MATCHED THEN
INSERT (CustomerNK, ContactName, ContactTitle)
VALUES (SRC.CustomerSK, SRC.ContactName, SRC.ContactTitle)
WHEN MATCHED  -- there can be only one matched case
AND (DST.ContactTitle <> SRC.ContactTitle
 OR DST.ContactName <> SRC.ContactName)
THEN 
	UPDATE 
	SET  DST.ContactName = SRC.ContactName -- simple overwrite
		,DST.ContactTitle_Prev1 = (CASE WHEN DST.ContactTitle <> SRC.ContactTitle THEN DST.ContactTitle ELSE DST.ContactTitle_Prev1 END)
		,DST.ContactTitle_Prev1_ValidTo = (CASE WHEN DST.ContactTitle <> SRC.ContactTitle THEN @Yesterday ELSE DST.ContactTitle_Prev1_ValidTo END)
		,DST.ContactTitle = SRC.ContactTitle;
GO

--Scenario 1: Empty destination table
SELECT * FROM [dbo].[dim_Customers];
GO
EXEC Customers_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_customers_SCD3];
GO

--Scenario 2: New rows in the source table

INSERT [dbo].[dim_Customers] ([CustomerSK], [CustomerID], [CompanyName], [ContactName], [ContactTitle], [Address], [City], [Region], [PostalCode], [Country], [Phone], [Fax]) 
VALUES (13, 13, 'Picsart', 'Ani', 'Manager', 'Abovyan street', 'Yerevan', 'Kentron', '446', 'Armenia', '11557', '8')

GO
EXEC Customers_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_customers_SCD3];
GO

--Scenario 3: Updated rows in the source table

UPDATE [dbo].[dim_Customers]
	SET ContactTitle = 'Top manager'
	WHERE ContactName = 'Ani';
GO
EXEC Customers_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_customers_SCD3];
GO

