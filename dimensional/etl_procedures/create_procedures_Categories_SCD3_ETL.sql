/*
	CREATING AN ETL PROCEDURE
*/
DROP PROCEDURE IF EXISTS {db_dim}.{schema_dim}.Categories_SCD3_ETL
GO

CREATE PROCEDURE {db_dim}.{schema_dim}.Categories_SCD3_ETL
AS  
 DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
 --20210413: string/text/char
MERGE {db_dim}.{schema_dim}.dim_Categories_SCD3 AS DST
USING {db_rel}.{schema_rel}.Categories AS SRC
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
