/*
	CREATING DESTINATION TABLES
*/
DROP TABLE IF EXISTS [dbo].[Products_SCD4_History];
GO

CREATE TABLE [dbo].[Products_SCD4_History]
(
 [HistoryID] [int] IDENTITY(1,1) NOT NULL,
 [BusinessKey] [int] NULL,
 [ProductName] [nvarchar](50) NULL,
 [QuantityPerUnit] [nvarchar](50) NULL,
 [UnitPrice] decimal(10,2),
 [UnitsInStock] int,
 [UnitsOnOrder] int,
 [ReorderLevel] int,
 [Discontinued] bit,
 [ValidFrom] [datetime] NULL,
 [ValidTo] [datetime] NULL
) 

DROP TABLE IF EXISTS [dbo].[Products_SCD1];
GO

CREATE TABLE [dbo].[Products_SCD1](
 [ProductSK] [int] IDENTITY(1,1) NOT NULL,
 [BusinessKey] [int] NOT NULL,
 [ProductName] [nvarchar](50) NULL,
 [QuantityPerUnit] [nvarchar](50) NULL,
 [UnitPrice] decimal(10,2),
 [UnitsInStock] int,
 [UnitsOnOrder] int,
 [ReorderLevel] int,
 [Discontinued] bit,
 [ValidFrom] [datetime] NULL
) ;

DROP PROCEDURE IF EXISTS dbo.Products_SCD4_ETL
GO

CREATE PROCEDURE dbo.Products_SCD4_ETL
AS  
--DECLARE @Yesterday INT =  (YEAR(DATEADD(dd,-1,GETDATE())) * 10000) + (MONTH(DATEADD(dd,-1,GETDATE())) * 100) + DAY(DATEADD(dd,-1,GETDATE()))
--DECLARE @Today INT =  (YEAR(GETDATE()) * 10000) + (MONTH(GETDATE()) * 100) + DAY(GETDATE())

DECLARE  @Products_SCD4 TABLE
(
 [BusinessKey] [int] NULL,
 [ProductName] [nvarchar](50) NULL,
 [QuantityPerUnit] [nvarchar](50) NULL,
 [UnitPrice] decimal(10,2),
 [UnitsInStock] int,
 [UnitsOnOrder] int,
 [ReorderLevel] int,
 [Discontinued] bit,
 [ValidFrom] [datetime] NULL,
 [MergeAction] [varchar](10) NULL
) 



-- Merge statement
MERGE		dbo.Products_SCD1				AS DST
USING		dbo.dim_Products				AS SRC
ON			(SRC.ProductSK = DST.BusinessKey)

WHEN NOT MATCHED THEN

INSERT (BusinessKey, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, ValidFrom)
VALUES (SRC.ProductSK, SRC.ProductName, SRC.QuantityPerUnit, SRC.UnitPrice, SRC.UnitsInStock, SRC.UnitsOnOrder, SRC.ReorderLevel, SRC.Discontinued, SRC.ValidFrom)

WHEN MATCHED 
AND		
	 ISNULL(DST.ProductName,'') <> ISNULL(SRC.ProductName,'')  
	 OR ISNULL(DST.QuantityPerUnit,'') <> ISNULL(SRC.QuantityPerUnit,'') 
	 OR ISNULL(DST.UnitPrice,'') <> ISNULL(SRC.UnitPrice,'')
	 OR ISNULL(DST.UnitsInStock,'') <> ISNULL(SRC.UnitsInStock,'')
	 OR ISNULL(DST.UnitsOnOrder,'') <> ISNULL(SRC.UnitsOnOrder,'')
	 OR ISNULL(DST.ReorderLevel,'') <> ISNULL(SRC.ReorderLevel,'')
	 OR ISNULL(DST.Discontinued,'') <> ISNULL(SRC.Discontinued,'')
	 OR ISNULL(DST.ValidFrom,'') <> ISNULL(SRC.ValidFrom,'')
THEN UPDATE 

SET			 
	 DST.ProductName = SRC.ProductName
	 ,DST.QuantityPerUnit = SRC.QuantityPerUnit
	 ,DST.UnitPrice = SRC.UnitPrice
	 ,DST.UnitsInStock = SRC.UnitsInStock
	 ,DST.UnitsOnOrder = SRC.UnitsOnOrder
	 ,DST.ReorderLevel = SRC.ReorderLevel
	 ,DST.Discontinued = SRC.Discontinued
	 ,DST.ValidFrom = SRC.ValidFrom

OUTPUT DELETED.BusinessKey, DELETED.ProductName, DELETED.QuantityPerUnit, DELETED.UnitPrice, DELETED.UnitsInStock, DELETED.UnitsOnOrder, DELETED.ReorderLevel, DELETED.Discontinued, DELETED.ValidFrom, $Action AS MergeAction
INTO	@Products_SCD4 (BusinessKey, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, ValidFrom, MergeAction)
;

-- Update history table to set final date and current flag

UPDATE		TP4

SET			TP4.ValidTo = CONVERT (DATE, GETDATE())

FROM		dbo.Products_SCD4_History TP4
			INNER JOIN @Products_SCD4 TMP
			ON TP4.BusinessKey = TMP.BusinessKey

WHERE		TP4.ValidTo IS NULL


-- Add latest history records to history table

INSERT INTO dbo.Products_SCD4_History (BusinessKey, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, ValidFrom, ValidTo)

SELECT BusinessKey, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, ValidFrom, GETDATE()
FROM @Products_SCD4
WHERE BusinessKey IS NOT NULL





SELECT * FROM [dbo].[dim_Products];
GO
EXEC Products_SCD4_ETL;
GO
SELECT * FROM [dbo].[Products_SCD1];
GO
SELECT * FROM [dbo].[Products_SCD4_History];
GO


--Scenario 2: New rows in the source table

INSERT [dbo].[dim_Products] ([ProductSK], [ProductID], [ProductName], [SupplierSK], [CategorySK], [QuantityPerUnit], [UnitPrice], [UnitsInStock], [UnitsOnOrder], [ReorderLevel], [Discontinued]) 
VALUES (10, 10, 'toy', 5, 6, '5', 12, 23, 25, 14, 1)

GO
EXEC Products_SCD4_ETL;
GO
SELECT * FROM [dbo].[Products_SCD1];
GO
SELECT * FROM [dbo].[Products_SCD4_History];
GO

UPDATE [dbo].[dim_Products]
	SET UnitPrice = 14
	WHERE ProductName = 'toy';
GO
EXEC Products_SCD4_ETL;
GO
SELECT * FROM [dbo].[Products_SCD1];
GO
SELECT * FROM [dbo].[Products_SCD4_History];
GO

UPDATE [dbo].[dim_Products]
	SET UnitPrice = 16
	WHERE ProductName = 'toy';
GO
EXEC Products_SCD4_ETL;
GO
SELECT * FROM [dbo].[Products_SCD1];
GO
SELECT * FROM [dbo].[Products_SCD4_History];
GO
