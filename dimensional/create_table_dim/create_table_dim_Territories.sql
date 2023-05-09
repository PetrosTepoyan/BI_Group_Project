DROP TABLE IF EXISTS dim_Territories;
GO

create table dim_Territories (
TerritorySK int primary key,
TerritoryID nvarchar(50),
TerritoryDescription nvarchar(50),
RegionSK int foreign key references dim_Region(RegionSK)
);


