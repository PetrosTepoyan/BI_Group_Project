CREATE PROCEDURE Region_SCD1_with_delete_ETL
AS
BEGIN TRY
MERGE {db_dim}.{schema_dim}.dim_Region_SCD1_with_delete AS TARGET
USING {db_rel}.{schema_rel}.Region AS SOURCE 
ON (TARGET.RegionID_NK = SOURCE.RegionID) 
--When records are matched, update the records if there is any change
WHEN MATCHED AND TARGET.RegionDescription <> SOURCE.RegionDescription 
THEN UPDATE SET TARGET.RegionDescription = SOURCE.RegionDescription 
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT (RegionID_NK, RegionDescription) VALUES (SOURCE.RegionID, SOURCE.RegionDescription)
--When there is a row that exists in target and same record does not exist in source then delete this record target
WHEN NOT MATCHED BY SOURCE 
THEN DELETE 
--$action specifies a column of type nvVARCHARarchar(10) in the OUTPUT clause that returns 
--one of three values for each row: 'INSERT', 'UPDATE', or 'DELETE' according to the action that was performed on that row
OUTPUT $action, 
DELETED.RegionID_NK AS TargetRegionSK, 
DELETED.RegionDescription AS TargetRegionDescription, 
INSERTED.RegionID_NK AS SourceRegionSK, 
INSERTED.RegionDescription AS SourceRegionDescription;

SELECT @@ROWCOUNT;

END TRY
BEGIN CATCH
    THROW
END CATCH
