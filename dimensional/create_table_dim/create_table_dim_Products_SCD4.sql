DROP TABLE IF EXISTS {db}.{schema}.[dim_Products_SCD4_History];

CREATE TABLE {db}.{schema}.[dim_Products_SCD4_History]
(
 [HistoryID] [int] IDENTITY(1,1) NOT NULL,
 [BusinessKey] [int] NULL,
 [ProductName] [VARCHAR](50) NULL,
 [QuantityPerUnit] [VARCHAR](50) NULL,
 [UnitPrice] decimal(10,2),
 [UnitsInStock] int,
 [UnitsOnOrder] int,
 [ReorderLevel] int,
 [Discontinued] bit,
 [ValidFrom] [datetime] NULL,
 [ValidTo] [datetime] NULL
)

DROP TABLE IF EXISTS {db}.{schema}.[dim_Products_SCD4];

CREATE TABLE {db}.{schema}.[dim_Products_SCD4](
 [ProductID_SK] [int] IDENTITY(1,1) PRIMARY KEY,
 [BusinessKey] [int] NOT NULL,
 [ProductName] [VARCHAR](50) NULL,
 [QuantityPerUnit] [VARCHAR](50) NULL,
 [UnitPrice] decimal(10,2),
 [UnitsInStock] int,
 [UnitsOnOrder] int,
 [ReorderLevel] int,
 [Discontinued] bit,
 [ValidFrom] [datetime] NULL
);
