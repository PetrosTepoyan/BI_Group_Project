/*
	CREATING A DESTINATION TABLE
*/

DROP TABLE IF EXISTS [dbo].[dim_categories_SCD3];
GO

CREATE TABLE dbo.dim_categories_SCD3 (
	CategorySK int IDENTITY(1,1) PRIMARY KEY,
	CategoryNK INT NOT NULL,
	CategoryName varchar(50),
	Description varchar(255),
	[description_Prev1] [varchar](50) NULL,
	[description_Prev1_ValidTo] [char] (8) NULL
);
GO


/*
	CREATING AN ETL PROCEDURE
*/
DROP PROCEDURE IF EXISTS dbo.Categories_SCD3_ETL
GO

CREATE PROCEDURE dbo.Categories_SCD3_ETL
AS  
 DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
 --20210413: string/text/char
MERGE dbo.dim_categories_SCD3 AS DST
USING [dbo].[dim_Categories] AS SRC
ON (SRC.CategorySK = DST.CategoryNK)
WHEN NOT MATCHED THEN
INSERT (CategoryNK, CategoryName, Description)
VALUES (SRC.CategorySK, SRC.CategoryName, SRC.Description)
WHEN MATCHED  -- there can be only one matched case
AND (DST.Description <> SRC.Description
 OR DST.CategoryName <> SRC.CategoryName)
THEN 
	UPDATE 
	SET  DST.CategoryName = SRC.CategoryName -- simple overwrite
		,DST.Description_Prev1 = (CASE WHEN DST.Description <> SRC.Description THEN DST.Description ELSE DST.Description_Prev1 END)
		,DST.Description_Prev1_ValidTo = (CASE WHEN DST.Description <> SRC.Description THEN @Yesterday ELSE DST.Description_Prev1_ValidTo END)
		,DST.Description = SRC.Description;
GO

--Scenario 1: Empty destination table
SELECT * FROM [dbo].[dim_Categories];
GO
EXEC Categories_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_categories_SCD3];
GO

--Scenario 2: New rows in the source table
--SET IDENTITY_INSERT [dbo].[dim_Categories] ON
INSERT [dbo].[dim_Categories] ([CategorySK], [CategoryID], [CategoryName], [Description]) VALUES (12, 12, 'new', 'new!')
--SET IDENTITY_INSERT [dbo].[dim_Categories] OFF;
GO
EXEC Categories_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_categories_SCD3];
GO

--Scenario 3: Updated rows in the source table

UPDATE [dbo].[dim_Categories]
	SET Description = 'Bye bye'
	WHERE CategoryName = 'apple';
GO
EXEC Categories_SCD3_ETL;
GO
SELECT * FROM [dbo].[dim_categories_SCD3];
GO

