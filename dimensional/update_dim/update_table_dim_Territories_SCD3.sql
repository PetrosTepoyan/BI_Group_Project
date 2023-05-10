DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
 --20210413: string/text/char
MERGE {db_dim}.{schema_dim}.dim_Territories_SCD3 AS DST
USING (
	select territories.*, dim_region.RegionID_SK
	from {db_rel}.{schema_rel}.Territories as territories
	left join {db_dim}.{schema_dim}.dim_Region_SCD1_with_delete as dim_region
	on (territories.RegionID_FK = dim_region.RegionID_NK)
) as SRC 
ON (SRC.TerritoryID = DST.TerritoryID_NK)
WHEN NOT MATCHED THEN
INSERT (TerritoryID_NK, Description, RegionID_SK_FK)
VALUES (SRC.TerritoryID, SRC.TerritoryDescription, SRC.RegionID_SK)
WHEN MATCHED  -- there can be only one matched case
AND (DST.Description <> SRC.TerritoryDescription)
THEN 
	UPDATE 
	SET  DST.Description_Prev1 = (CASE WHEN DST.Description <> SRC.TerritoryDescription THEN DST.Description ELSE DST.Description_Prev1 END)
		,DST.Description_Prev1_ValidTo = (CASE WHEN DST.Description <> SRC.TerritoryDescription THEN @Yesterday ELSE DST.Description_Prev1_ValidTo END)
		,DST.Description = SRC.TerritoryDescription;
