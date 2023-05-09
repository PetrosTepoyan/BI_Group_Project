DROP TABLE IF EXISTS Dim_Suppliers_SCD1;
GO
CREATE TABLE dim_Suppliers_SCD1
(
   SupplierSK INT PRIMARY KEY IDENTITY(1,1),
   SupplierNK INT,
   CompanyName nvarchar(50),
   ContactName nvarchar(50),
   ContactTitle nvarchar(50)
);
GO

DROP PROCEDURE IF EXISTS dbo.Suppliers_SCD1_ETL;
GO

CREATE PROCEDURE dbo.Suppliers_SCD1_ETL
AS
BEGIN TRY
MERGE dim_Suppliers_SCD1 AS TARGET
USING dim_Suppliers AS SOURCE 
ON (TARGET.SupplierNK = SOURCE.SupplierSK) 
--When records are matched, update the records if there is any change
WHEN MATCHED AND TARGET.CompanyName <> SOURCE.CompanyName OR TARGET.ContactName <> SOURCE.ContactName OR TARGET.ContactTitle <> SOURCE.ContactTitle
THEN UPDATE SET TARGET.CompanyName = SOURCE.CompanyName, TARGET.ContactName = SOURCE.ContactName, TARGET.ContactTitle = SOURCE.ContactTitle  
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT (SupplierNK, CompanyName, ContactName, ContactTitle) VALUES (SOURCE.SupplierSK, SOURCE.CompanyName, SOURCE.ContactName, SOURCE.ContactTitle)
--When there is a row that exists in target and same record does not exist in source then delete this record target
WHEN NOT MATCHED BY SOURCE 
THEN DELETE 
--$action specifies a column of type nvarchar(10) in the OUTPUT clause that returns 
--one of three values for each row: 'INSERT', 'UPDATE', or 'DELETE' according to the action that was performed on that row
OUTPUT $action, 
DELETED.SupplierNK AS TargetSupplierSK, 
DELETED.CompanyName AS TargetCompanyName, 
DELETED.ContactName AS TargetContactName, 
DELETED.ContactTitle AS TargetContactTitle, 
INSERTED.SupplierNK AS SourceSupplierSK, 
INSERTED.CompanyName AS SourceCompanyName,
INSERTED.ContactName AS SourceContactName,
INSERTED.ContactTitle AS SourceContactTitle;

SELECT @@ROWCOUNT;

END TRY
BEGIN CATCH
    THROW
END CATCH
GO

-- Testing
--Insert records into target table
INSERT INTO dim_Suppliers
VALUES
   (1, '1', 'SAS', 'John', 'Manager', 'Abovyan street', 'Yerevan', 'Kentron', '012', 'Armenia', '123456789', '5', '6')
GO
SELECT * FROM dim_Suppliers;

EXEC dbo.Suppliers_SCD1_ETL;

SELECT * FROM dim_Suppliers_SCD1;

INSERT INTO dim_Suppliers
VALUES
   (2, '2', 'Zovq', 'Andrey', 'Administrator', 'Nalbandyan street', 'Yerevan', 'Kentron', '013', 'Armenia', '987654321', '7', '8')
GO

Update dim_Suppliers
SET ContactTitle = 'Top Manager' 
WHERE SupplierID = '1';

EXEC dbo.Suppliers_SCD1_ETL;

SELECT * FROM dim_Suppliers_SCD1;

DELETE FROM dim_Suppliers
WHERE SupplierID = '1';

EXEC dbo.Suppliers_SCD1_ETL;

SELECT * FROM dim_Suppliers_SCD1;

