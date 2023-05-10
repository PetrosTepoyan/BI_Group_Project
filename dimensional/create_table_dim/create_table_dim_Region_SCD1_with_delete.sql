CREATE TABLE {db}.{schema}.dim_Region_SCD1_with_delete(
   RegionID_SK INT PRIMARY KEY IDENTITY(1,1),
   RegionID_NK INT,
   RegionDescription VARCHAR(255) NOT NULL
);