BEGIN TRY
MERGE {db_dim}.{schema_dim}.dim_Suppliers_SCD1_with_delete AS TARGET
USING {db_rel}.{schema_rel}.Suppliers AS SOURCE 
ON (TARGET.SupplierID_NK = SOURCE.SupplierID) 
--When records are matched, update the records if there is any change
WHEN MATCHED AND TARGET.CompanyName <> SOURCE.CompanyName OR TARGET.ContactName <> SOURCE.ContactName OR TARGET.ContactTitle <> SOURCE.ContactTitle
THEN UPDATE SET TARGET.CompanyName = SOURCE.CompanyName, TARGET.ContactName = SOURCE.ContactName, TARGET.ContactTitle = SOURCE.ContactTitle  
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT (SupplierID_NK, CompanyName, ContactName, ContactTitle) VALUES (SOURCE.SupplierID, SOURCE.CompanyName, SOURCE.ContactName, SOURCE.ContactTitle)
--When there is a row that exists in target and same record does not exist in source then delete this record target
WHEN NOT MATCHED BY SOURCE 
THEN DELETE 
--$action specifies a column of type nvarchar(10) in the OUTPUT clause that returns 
--one of three values for each row: 'INSERT', 'UPDATE', or 'DELETE' according to the action that was performed on that row
OUTPUT $action, 
DELETED.SupplierID_NK AS TargetSupplierID, 
DELETED.CompanyName AS TargetCompanyName, 
DELETED.ContactName AS TargetContactName, 
DELETED.ContactTitle AS TargetContactTitle, 

INSERTED.SupplierID_NK AS SourceSupplierSK, 
INSERTED.CompanyName AS SourceCompanyName,
INSERTED.ContactName AS SourceContactName,
INSERTED.ContactTitle AS SourceContactTitle;

SELECT @@ROWCOUNT;

END TRY
BEGIN CATCH
    THROW
END CATCH
