CREATE PROCEDURE Shippers_SCD3_ETL
AS  
 DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
 --20210413: string/text/char
MERGE {db_dim}.{schema_dim}.dim_Shippers_SCD3 AS DST
USING {db_rel}.{schema_rel}.Shippers AS SRC
ON (SRC.ShipperID = DST.ShipperID_NK)
WHEN NOT MATCHED THEN
INSERT (ShipperID_NK, CompanyName, Phone)
VALUES (SRC.ShipperID, SRC.CompanyName, SRC.Phone)
WHEN MATCHED  -- there can be only one matched case
AND (DST.Phone <> SRC.Phone
 OR DST.Phone <> SRC.Phone)
THEN 
	UPDATE 
	SET  DST.CompanyName = SRC.CompanyName -- simple overwrite
		,DST.Phone_Prev1 = (CASE WHEN DST.Phone <> SRC.Phone THEN DST.Phone ELSE DST.Phone_Prev1 END)
		,DST.Phone_Prev1_ValidTo = (CASE WHEN DST.Phone <> SRC.Phone THEN @Yesterday ELSE DST.Phone_Prev1_ValidTo END)
		,DST.Phone = SRC.Phone;
