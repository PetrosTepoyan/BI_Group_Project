DROP TABLE IF EXISTS dim_Region;
GO

create table dim_Region (
RegionSK int primary key,
RegionID nvarchar(50),
RegionDescription nvarchar(50)
);

