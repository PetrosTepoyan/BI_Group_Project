DROP TABLE IF EXISTS Dim_Region_SCD1;
GO
CREATE TABLE dim_Region_SCD1
(
   RegionSK INT PRIMARY KEY IDENTITY(1,1),
   RegionNK INT,
   RegionDescription nvarchar(50)
);
GO

DROP PROCEDURE IF EXISTS dbo.Region_SCD1_ETL;
GO

CREATE PROCEDURE dbo.Region_SCD1_ETL
AS
BEGIN TRY
MERGE dim_Region_SCD1 AS TARGET
USING dim_Region AS SOURCE 
ON (TARGET.RegionNK = SOURCE.RegionSK) 
--When records are matched, update the records if there is any change
WHEN MATCHED AND TARGET.RegionDescription <> SOURCE.RegionDescription 
THEN UPDATE SET TARGET.RegionDescription = SOURCE.RegionDescription 
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT (RegionNK, RegionDescription) VALUES (SOURCE.RegionSK, SOURCE.RegionDescription)
--When there is a row that exists in target and same record does not exist in source then delete this record target
WHEN NOT MATCHED BY SOURCE 
THEN DELETE 
--$action specifies a column of type nvarchar(10) in the OUTPUT clause that returns 
--one of three values for each row: 'INSERT', 'UPDATE', or 'DELETE' according to the action that was performed on that row
OUTPUT $action, 
DELETED.RegionNK AS TargetRegionSK, 
DELETED.RegionDescription AS TargetRegionDescription, 
INSERTED.RegionNK AS SourceRegionSK, 
INSERTED.RegionDescription AS SourceRegionDescription;

SELECT @@ROWCOUNT;

END TRY
BEGIN CATCH
    THROW
END CATCH
GO

-- Testing
--Insert records into target table
-- INSERT INTO dim_Region
-- VALUES
--    (1, '1', 'Kentron'),
--    (2, '2', 'Ajapnyak'),
--    (3, '3', 'Kentron'),
--    (4, '4', 'Erebuni')
-- GO
-- SELECT * FROM dim_Region;

-- EXEC dbo.Region_SCD1_ETL;

-- SELECT * FROM dim_Region_SCD1;

-- INSERT INTO dim_Region
-- VALUES
--    (5, '5', 'Erebuni')
-- GO

-- Update dim_Region
-- SET RegionDescription = 'Zeytun' 
-- WHERE RegionID = '2';

-- EXEC dbo.Region_SCD1_ETL;

-- SELECT * FROM dim_Region_SCD1;

-- DELETE FROM dim_Region
-- WHERE RegionID = '5';

-- EXEC dbo.Region_SCD1_ETL;

-- SELECT * FROM dim_Region_SCD1;

