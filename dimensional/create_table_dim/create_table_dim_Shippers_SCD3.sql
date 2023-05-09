/*
	CREATING A DESTINATION TABLE
*/

DROP TABLE IF EXISTS [dbo].[dim_shippers_SCD3];
GO

CREATE TABLE dbo.dim_shippers_SCD3 (
	ShipperSK int IDENTITY(1,1) PRIMARY KEY,
	ShipperNK INT NOT NULL,
	CompanyName varchar(50),
	Phone varchar(255),
	[Phone_Prev1] [varchar](50) NULL,
	[Phone_Prev1_ValidTo] [char] (8) NULL
);
GO


/*
	CREATING AN ETL PROCEDURE
*/
DROP PROCEDURE IF EXISTS dbo.Shippers_SCD3_ETL
GO

CREATE PROCEDURE dbo.Shippers_SCD3_ETL
AS  
 DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
 --20210413: string/text/char
MERGE dbo.dim_shippers_SCD3 AS DST
USING [dbo].[dim_Shippers] AS SRC
ON (SRC.ShipperSK = DST.ShipperNK)
WHEN NOT MATCHED THEN
INSERT (ShipperNK, CompanyName, Phone)
VALUES (SRC.ShipperSK, SRC.CompanyName, SRC.Phone)
WHEN MATCHED  -- there can be only one matched case
AND (DST.Phone <> SRC.Phone
 OR DST.Phone <> SRC.Phone)
THEN 
	UPDATE 
	SET  DST.CompanyName = SRC.CompanyName -- simple overwrite
		,DST.Phone_Prev1 = (CASE WHEN DST.Phone <> SRC.Phone THEN DST.Phone ELSE DST.Phone_Prev1 END)
		,DST.Phone_Prev1_ValidTo = (CASE WHEN DST.Phone <> SRC.Phone THEN @Yesterday ELSE DST.Phone_Prev1_ValidTo END)
		,DST.Phone = SRC.Phone;
GO

--Scenario 1: Empty destination table
SELECT * FROM [dbo].[dim_Shippers];
GO
EXEC Shippers_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_Shippers_SCD3];
GO

--Scenario 2: New rows in the source table

INSERT [dbo].[dim_Shippers] ([ShipperSK], [ShipperID], [CompanyName], [Phone]) 
VALUES (13, 13, 'Picsart', '446688')

GO
EXEC Shippers_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_Shippers_SCD3];
GO

--Scenario 3: Updated rows in the source table

UPDATE [dbo].[dim_Shippers]
	SET Phone = '787878'
	WHERE CompanyName = 'Picsart';
GO
EXEC Shippers_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_Shippers_SCD3];
GO

