/*
	CREATING A DESTINATION TABLE
*/

DROP TABLE IF EXISTS [dbo].[dim_territories_SCD3];
GO

CREATE TABLE dbo.dim_territories_SCD3 (
	TerritorySK int IDENTITY(1,1) PRIMARY KEY,
	TerritoryNK INT NOT NULL,
	Description varchar(255),
	[description_Prev1] [varchar](50) NULL,
	[description_Prev1_ValidTo] [char] (8) NULL
);
GO


/*
	CREATING AN ETL PROCEDURE
*/
DROP PROCEDURE IF EXISTS dbo.Territories_SCD3_ETL
GO

CREATE PROCEDURE dbo.Territories_SCD3_ETL
AS  
 DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
 --20210413: string/text/char
MERGE dbo.dim_territories_SCD3 AS DST
USING [dbo].[dim_Territories] AS SRC
ON (SRC.TerritorySK = DST.TerritoryNK)
WHEN NOT MATCHED THEN
INSERT (TerritoryNK, Description)
VALUES (SRC.TerritorySK, SRC.TerritoryDescription)
WHEN MATCHED  -- there can be only one matched case
AND (DST.Description <> SRC.TerritoryDescription)
THEN 
	UPDATE 
	SET  DST.Description_Prev1 = (CASE WHEN DST.Description <> SRC.TerritoryDescription THEN DST.Description ELSE DST.Description_Prev1 END)
		,DST.Description_Prev1_ValidTo = (CASE WHEN DST.Description <> SRC.TerritoryDescription THEN @Yesterday ELSE DST.Description_Prev1_ValidTo END)
		,DST.Description = SRC.TerritoryDescription;
GO

--Scenario 1: Empty destination table
SELECT * FROM [dbo].[dim_Territories];
GO
EXEC Territories_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_territories_SCD3];
GO

--Scenario 2: New rows in the source table

INSERT [dbo].[dim_Territories] ([TerritorySK], [TerritoryID], [TerritoryDescription], [RegionSK]) VALUES (12, 12, 'Rural', 4)

GO
EXEC Territories_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_territories_SCD3];
GO

--Scenario 3: Updated rows in the source table

UPDATE [dbo].[dim_Territories]
	SET TerritoryDescription = 'Urban'
	WHERE TerritorySK = 12;
GO
EXEC Territories_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_territories_SCD3];
GO

