DECLARE @Yesterday INT =  (YEAR(DATEADD(dd,-1,GETDATE())) * 10000) + (MONTH(DATEADD(dd,-1,GETDATE())) * 100) + DAY(DATEADD(dd,-1,GETDATE()))
DECLARE @Today INT =  (YEAR(GETDATE()) * 10000) + (MONTH(GETDATE()) * 100) + DAY(GETDATE())

DECLARE  @Products_SCD4 TABLE
(
 [BusinessKey] [int] NULL,
 [ProductName] [VARCHAR](50) NULL,
 [QuantityPerUnit] [VARCHAR](50) NULL,
 [UnitPrice] decimal(10,2),
 [UnitsInStock] int,
 [UnitsOnOrder] int,
 [ReorderLevel] int,
 [Discontinued] bit,
 [ValidFrom] [datetime] NULL,
 [MergeAction] [varchar](10) NULL
) 



-- Merge statement
MERGE		{db_dim}.{schema_dim}.dim_Products_SCD4				AS DST
USING		{db_rel}.{schema_rel}.Products				AS SRC
ON			(SRC.ProductID = DST.BusinessKey)

WHEN NOT MATCHED THEN

INSERT (BusinessKey, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, ValidFrom)
VALUES (SRC.ProductID, SRC.ProductName, SRC.QuantityPerUnit, SRC.UnitPrice, SRC.UnitsInStock, SRC.UnitsOnOrder, SRC.ReorderLevel, SRC.Discontinued, GETDATE())

WHEN MATCHED 
AND		
	 ISNULL(DST.ProductName,'') <> ISNULL(SRC.ProductName,'')  
	 OR ISNULL(DST.QuantityPerUnit,'') <> ISNULL(SRC.QuantityPerUnit,'') 
	 OR ISNULL(DST.UnitPrice,'') <> ISNULL(SRC.UnitPrice,'')
	 OR ISNULL(DST.UnitsInStock,'') <> ISNULL(SRC.UnitsInStock,'')
	 OR ISNULL(DST.UnitsOnOrder,'') <> ISNULL(SRC.UnitsOnOrder,'')
	 OR ISNULL(DST.ReorderLevel,'') <> ISNULL(SRC.ReorderLevel,'')
	 OR ISNULL(DST.Discontinued,'') <> ISNULL(SRC.Discontinued,'')
	 OR ISNULL(DST.ValidFrom,'') <> ISNULL(GETDATE(),'')
THEN UPDATE 

SET			 
	 DST.ProductName = SRC.ProductName
	 ,DST.QuantityPerUnit = SRC.QuantityPerUnit
	 ,DST.UnitPrice = SRC.UnitPrice
	 ,DST.UnitsInStock = SRC.UnitsInStock
	 ,DST.UnitsOnOrder = SRC.UnitsOnOrder
	 ,DST.ReorderLevel = SRC.ReorderLevel
	 ,DST.Discontinued = SRC.Discontinued
	 ,DST.ValidFrom = GETDATE()

OUTPUT DELETED.BusinessKey, DELETED.ProductName, DELETED.QuantityPerUnit, DELETED.UnitPrice, DELETED.UnitsInStock, DELETED.UnitsOnOrder, DELETED.ReorderLevel, DELETED.Discontinued, DELETED.ValidFrom, $Action AS MergeAction
INTO	@Products_SCD4 (BusinessKey, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, ValidFrom, MergeAction)
;

-- Update history table to set final date and current flag

UPDATE		TP4

SET			TP4.ValidTo = CONVERT (DATE, GETDATE())

FROM		{db_dim}.{schema_dim}.dim_Products_SCD4_History TP4
			INNER JOIN @Products_SCD4 TMP
			ON TP4.BusinessKey = TMP.BusinessKey

WHERE		TP4.ValidTo IS NULL


-- Add latest history records to history table

INSERT INTO {db_dim}.{schema_dim}.dim_Products_SCD4_History (BusinessKey, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, ValidFrom, ValidTo)

SELECT BusinessKey, ProductName, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, ValidFrom, GETDATE()
FROM @Products_SCD4
WHERE BusinessKey IS NOT NULL