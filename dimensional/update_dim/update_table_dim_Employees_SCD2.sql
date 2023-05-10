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
   {db_dim}.{schema_dim}.dim_Employees_SCD2 (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, PhotoPath, ValidFrom, IsCurrent) 
   SELECT
      EmployeeID, 
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
         MERGE INTO {db_dim}.{schema_dim}.dim_Employees_SCD2 AS DST 
		 USING {db_rel}.{schema_rel}.Employees AS SRC 
         ON (SRC.EmployeeID = DST.EmployeeID_SK) 			
		 -- New records inserted
         WHEN
            NOT MATCHED 
         THEN
            INSERT (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, PhotoPath, ValidFrom, IsCurrent) --There is no ValidTo
      VALUES
         (
            SRC.EmployeeID, SRC.LastName, SRC.FirstName, SRC.Title, SRC.TitleOfCourtesy, SRC.BirthDate, SRC.HireDate, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.HomePhone, SRC.Extension, SRC.Notes, SRC.PhotoPath, @Today, 1
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
			OUTPUT SRC.EmployeeID, SRC.LastName, SRC.FirstName, SRC.Title, SRC.TitleOfCourtesy, SRC.BirthDate, SRC.HireDate, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.HomePhone, SRC.Extension, SRC.Notes, SRC.PhotoPath, $Action AS MergeAction 
      )
      AS MRG 
   WHERE
      MRG.MergeAction = 'UPDATE' ;