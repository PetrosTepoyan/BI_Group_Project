DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
 --20210413: string/text/char
MERGE {db_dim}.{schema_dim}.dim_Customers_SCD3 AS DST
USING {db_rel}.{schema_rel}.Customers AS SRC
ON (SRC.CustomerID = DST.CustomerID_NK)
WHEN NOT MATCHED THEN
INSERT (CustomerID_NK, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
VALUES (SRC.CustomerID, SRC.ContactName, SRC.ContactTitle, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.Phone, SRC.Fax)
WHEN MATCHED  -- there can be only one matched case
AND (DST.ContactTitle <> SRC.ContactTitle
 OR DST.ContactName <> SRC.ContactName)
THEN 
	UPDATE 
	SET  DST.ContactName = SRC.ContactName -- simple overwrite
		,DST.ContactTitle_Prev1 = (CASE WHEN DST.ContactTitle <> SRC.ContactTitle THEN DST.ContactTitle ELSE DST.ContactTitle_Prev1 END)
		,DST.ContactTitle_Prev1_ValidTo = (CASE WHEN DST.ContactTitle <> SRC.ContactTitle THEN @Yesterday ELSE DST.ContactTitle_Prev1_ValidTo END)
		,DST.ContactTitle = SRC.ContactTitle;