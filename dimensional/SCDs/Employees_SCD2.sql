/*
	CREATING A DESTINATION TABLE
*/
DROP TABLE IF EXISTS [dbo].[dim_employees_SCD2]; 
GO

CREATE TABLE [dbo].[dim_employees_SCD2](
EmployeeSK int IDENTITY(1,1) NOT NULL,
BusinessKey int NOT NULL,
LastName nvarchar(50),
FirstName nvarchar(50),
Title nvarchar(50),
TitleOfCourtesy nvarchar(50),
BirthDate datetime,
HireDate datetime,
Address nvarchar(50),
City nvarchar(50),
Region nvarchar(50),
PostalCode nvarchar(50),
Country nvarchar(50),
HomePhone nvarchar(50),
Extension nvarchar(50),
Notes nvarchar(500),
PhotoPath nvarchar(50),
ValidFrom INT NULL,
ValidTo INT NULL,
IsCurrent BIT NULL
) ON [PRIMARY]
GO

/*
	CREATING AN ETL PROCEDURE
*/
DROP PROCEDURE IF EXISTS dbo.Employees_SCD2_ETL
GO
 
CREATE PROCEDURE dbo.Employees_SCD2_ETL
AS
-- Define the dates used in validity - assume whole 24 hour cycles
DECLARE @Yesterday INT =  --20210412 = 2021 * 10000 + 4 * 100 + 12
(
   YEAR(DATEADD(dd, - 1, GETDATE())) * 10000
)
+ (MONTH(DATEADD(dd, - 1, GETDATE())) * 100) + DAY(DATEADD(dd, - 1, GETDATE())) 
DECLARE @Today INT = --20210413 = 2021 * 10000 + 4 * 100 + 13
(
   YEAR(GETDATE()) * 10000
)
+ (MONTH(GETDATE()) * 100) + DAY(GETDATE()) -- Outer insert - the updated records are added to the SCD2 table
INSERT INTO
   dbo.dim_employees_SCD2 (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, PhotoPath, ValidFrom, IsCurrent) 
   SELECT
      EmployeeSK,
      LastName,
      FirstName,
      Title,
      TitleOfCourtesy,
      BirthDate,
      HireDate,
      Address,
      City,
      Region,
      PostalCode,
      Country,
      HomePhone,
      Extension,
      Notes,
      PhotoPath,
      @Today,
      1 
   FROM
      (
         -- Merge statement
         MERGE INTO dbo.dim_employees_SCD2 AS DST 
		 USING [dbo].[dim_Employees] AS SRC 
         ON (SRC.EmployeeSK = DST.BusinessKey) 			
		 -- New records inserted
         WHEN
            NOT MATCHED 
         THEN
            INSERT (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, PhotoPath, ValidFrom, IsCurrent) --There is no ValidTo
      VALUES
         (
            SRC.EmployeeSK, SRC.LastName, SRC.FirstName, SRC.Title, SRC.TitleOfCourtesy, SRC.BirthDate, SRC.HireDate, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.HomePhone, SRC.Extension, SRC.Notes, SRC.PhotoPath, @Today, 1
         )
         -- Existing records updated if data changes
      WHEN
         MATCHED 
         AND IsCurrent = 1 
         AND 
         (
            
            ISNULL(DST.LastName, '') <> ISNULL(SRC.LastName, '')
            OR ISNULL(DST.FirstName, '') <> ISNULL(SRC.FirstName, '') 
            OR ISNULL(DST.Title, '') <> ISNULL(SRC.Title, '') 
            OR ISNULL(DST.TitleOfCourtesy, '') <> ISNULL(SRC.TitleOfCourtesy, '') 
            OR ISNULL(DST.BirthDate, '') <> ISNULL(SRC.BirthDate, '') 
            OR ISNULL(DST.HireDate, '') <> ISNULL(SRC.HireDate, '')
			OR ISNULL(DST.Address, '') <> ISNULL(SRC.Address, '')
			OR ISNULL(DST.City, '') <> ISNULL(SRC.City, '')
			OR ISNULL(DST.Region, '') <> ISNULL(SRC.Region, '')
			OR ISNULL(DST.PostalCode, '') <> ISNULL(SRC.PostalCode, '')
			OR ISNULL(DST.Country, '') <> ISNULL(SRC.Country, '')
			OR ISNULL(DST.HomePhone, '') <> ISNULL(SRC.HomePhone, '')
			OR ISNULL(DST.Extension, '') <> ISNULL(SRC.Extension, '')
			OR ISNULL(DST.Notes, '') <> ISNULL(SRC.Notes, '')
			OR ISNULL(DST.PhotoPath, '') <> ISNULL(SRC.PhotoPath, '')
			
         )
         -- Update statement for a changed dimension record, to flag as no longer active
      THEN
         UPDATE
         SET
            DST.IsCurrent = 0, 
			DST.ValidTo = @Yesterday 
			OUTPUT SRC.EmployeeSK, SRC.LastName, SRC.FirstName, SRC.Title, SRC.TitleOfCourtesy, SRC.BirthDate, SRC.HireDate, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.HomePhone, SRC.Extension, SRC.Notes, SRC.PhotoPath, $Action AS MergeAction 
      )
      AS MRG 
   WHERE
      MRG.MergeAction = 'UPDATE' ;
GO

/*
	CHECKING THE ETL PROCEDURE
*/

--Scenario 1: Empty destination table
SELECT * FROM [dbo].[dim_employees_SCD2];
GO
EXEC Employees_SCD2_ETL;
GO
SELECT * FROM [dbo].[dim_employees_SCD2];
GO

--Scenario 2: New rows in the source table

INSERT [dbo].[dim_Employees] ([EmployeeSK], [EmployeeID], [LastName], [FirstName], [Title], [TitleOfCourtesy], [BirthDate], [HireDate], [Address], [City], [Region], [PostalCode], [Country], [HomePhone], [Extension], [Notes], [ReportsToSK], [PhotoPath])
VALUES (15, 15, 'Poghosyan', 'Ani', 'title', 'Ms', '2001-04-22', '2019-01-22', 'Baghramyan', 'Yerevan', 'Yerevan', '456', 'Armenia', '055 00 00', 'EX', 'note', 4, 'PH' );
GO
EXEC Employees_SCD2_ETL;
GO
SELECT * FROM [dbo].[dim_employees_SCD2];
GO

select * from dim_Employees


--Scenario 3: Updated rows in the source table
UPDATE [dbo].[dim_Employees]
	SET TitleOfCourtesy = 'changed1'
	WHERE LastName = 'Poghosyan';
GO
EXEC Employees_SCD2_ETL;
GO
SELECT * FROM [dbo].[dim_employees_SCD2];
GO

UPDATE [dbo].[dim_Employees]
	SET TitleOfCourtesy = 'changed2'
	WHERE LastName = 'Poghosyan';
GO
EXEC Employees_SCD2_ETL;
GO
SELECT * FROM [dbo].[dim_employees_SCD2];
GO