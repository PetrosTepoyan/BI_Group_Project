
/*
	CREATING A SOURCE TABLE
*/
USE Orders_ER;
GO
DROP TABLE IF EXISTS [dbo].[Client];
GO 

CREATE TABLE [dbo].[Client](
 [ID] [int] IDENTITY(1,1) NOT NULL,
 [ClientName] [varchar](150) NULL,
 [Country] [varchar](50) NULL,
 [Town] [varchar](50) NULL,
 [County] [varchar](50) NULL,
 [Address1] [varchar](50) NULL,
 [Address2] [varchar](50) NULL,
 [ClientType] [varchar](20) NULL,
 [ClientSize] [varchar](10) NULL,
 [ValidFrom] [datetime] DEFAULT  current_timestamp,
 CONSTRAINT [PK_Client] PRIMARY KEY CLUSTERED 
	([ID] ASC) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY];
GO

/*
	POPULATING THE SOURCE TABLE
*/
SET IDENTITY_INSERT [dbo].[Client] ON
INSERT [dbo].[Client] ([ID], [ClientName], [Country], [Town], [County], [Address1], [Address2], [ClientType], [ClientSize]) VALUES (1, N'John Smith', N'UK', N'Uttoxeter', N'Staffs', N'4, Grove Drive', NULL, N'Private', N'M')
INSERT [dbo].[Client] ([ID], [ClientName], [Country], [Town], [County], [Address1], [Address2], [ClientType], [ClientSize]) VALUES (2, N'Bauhaus Motors', N'UK', N'Oxford', N'Oxon', N'Suite 27', N'12-14 Turl Street', N'Business', N'S')
INSERT [dbo].[Client] ([ID], [ClientName], [Country], [Town], [County], [Address1], [Address2], [ClientType], [ClientSize]) VALUES (7, N'Honest Fred', N'UK', N'Stoke', N'Staffs', NULL, NULL, N'Business', N'S')
INSERT [dbo].[Client] ([ID], [ClientName], [Country], [Town], [County], [Address1], [Address2], [ClientType], [ClientSize]) VALUES (8, N'Fast Eddie', N'Wales', N'Cardiff', NULL, NULL, NULL, N'Business', N'L')
INSERT [dbo].[Client] ([ID], [ClientName], [Country], [Town], [County], [Address1], [Address2], [ClientType], [ClientSize]) VALUES (9, N'Slow Sid', N'France', N'Avignon', N'Vaucluse', N'2, Rue des Courtisans', NULL, N'Private', N'M')
SET IDENTITY_INSERT [dbo].[Client] OFF;
GO

/*
	CHECKING THE VALUES OF THE SOURCE TABLE
*/
SELECT * FROM [dbo].[Client];
GO

/* -----------------------------------------------------------------------
	Type 4 SCD - Keep the currently valid record in the dimension table, 
			     and a history of previous attributes in a separate table 
				 along with he dates they were valid

This is, basically, a type 1 table with a separate history table for the 
previous versions of the data. So when any attributes change, the current 
version is removed from the "main" table and added to the "History" table, 
and a new record containing the latest attributes is added to the "main" table.

*/ -----------------------------------------------------------------------

/*
	CREATING DESTINATION TABLES
*/
DROP TABLE IF EXISTS [dbo].[Client_SCD4_History];
GO

CREATE TABLE [dbo].[Client_SCD4_History]
(
 [HistoryID] [int] IDENTITY(1,1) NOT NULL,
 [BusinessKey] [int] NULL,
 [ClientName] [varchar](150) NULL,
 [Country] [varchar](50) NULL,
 [Town] [varchar](50) NULL,
 [County] [varchar](50) NULL,
 [Address1] [varchar](50) NULL,
 [Address2] [varchar](50) NULL,
 [ClientType] [varchar](20) NULL,
 [ClientSize] [varchar](10) NULL,
 [ValidFrom] [datetime] NULL,
 [ValidTo] [datetime] NULL
) 

DROP TABLE IF EXISTS [dbo].[Client_SCD1];
GO

CREATE TABLE [dbo].[Client_SCD1](
 [ClientID] [int] IDENTITY(1,1) NOT NULL,
 [BusinessKey] [int] NOT NULL,
 [ClientName] [varchar](150) NULL,
 [Country] [varchar](50) NULL,
 [Town] [varchar](50) NULL,
 [County] [varchar](50) NULL,
 [Address1] [varchar](50) NULL,
 [Address2] [varchar](50) NULL,
 [ClientType] [varchar](20) NULL,
 [ClientSize] [varchar](10) NULL,
 [ValidFrom] [datetime] NULL
) ;

DROP PROCEDURE IF EXISTS dbo.Client_SCD4_ETL
GO

CREATE PROCEDURE dbo.Client_SCD4_ETL
AS  
--DECLARE @Yesterday INT =  (YEAR(DATEADD(dd,-1,GETDATE())) * 10000) + (MONTH(DATEADD(dd,-1,GETDATE())) * 100) + DAY(DATEADD(dd,-1,GETDATE()))
--DECLARE @Today INT =  (YEAR(GETDATE()) * 10000) + (MONTH(GETDATE()) * 100) + DAY(GETDATE())

DECLARE  @Client_SCD4 TABLE
(
	[BusinessKey] [int] NULL,
	[ClientName] [varchar](150) NULL,
	[Country] [varchar](50) NULL,
	[Town] [varchar](50) NULL,
	[County] [varchar](50) NULL,
	[Address1] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[ClientType] [varchar](20) NULL,
	[ClientSize] [varchar](10) NULL,
	[ValidFrom] [datetime] NULL,
	[MergeAction] [varchar](10) NULL
) 



-- Merge statement
MERGE		dbo.Client_SCD1					AS DST
USING		dbo.Client				AS SRC
ON			(SRC.ID = DST.BusinessKey)

WHEN NOT MATCHED THEN

INSERT (BusinessKey, ClientName, Country, Town, Address1, Address2, ClientType, ClientSize, ValidFrom)
VALUES (SRC.ID, SRC.ClientName, SRC.Country, SRC.Town, SRC.Address1, SRC.Address2, SRC.ClientType, SRC.ClientSize, SRC.ValidFrom)

WHEN MATCHED 
AND		
	 ISNULL(DST.ClientName,'') <> ISNULL(SRC.ClientName,'')  
	 OR ISNULL(DST.Country,'') <> ISNULL(SRC.Country,'') 
	 OR ISNULL(DST.Town,'') <> ISNULL(SRC.Town,'')
	 OR ISNULL(DST.Address1,'') <> ISNULL(SRC.Address1,'')
	 OR ISNULL(DST.Address2,'') <> ISNULL(SRC.Address2,'')
	 OR ISNULL(DST.ClientType,'') <> ISNULL(SRC.ClientType,'')
	 OR ISNULL(DST.ClientSize,'') <> ISNULL(SRC.ClientSize,'')
	 OR ISNULL(DST.ValidFrom,'') <> ISNULL(SRC.ValidFrom,'')
THEN UPDATE 

SET			 
	 DST.ClientName = SRC.ClientName  
	 ,DST.Country = SRC.Country 
	 ,DST.Town = SRC.Town
	 ,DST.Address1 = SRC.Address1
	 ,DST.Address2 = SRC.Address2
	 ,DST.ClientType = SRC.ClientType
	 ,DST.ClientSize = SRC.ClientSize
	 ,DST.ValidFrom = SRC.ValidFrom

OUTPUT DELETED.BusinessKey, DELETED.ClientName, DELETED.Country, DELETED.Town, DELETED.Address1, DELETED.Address2, DELETED.ClientType, DELETED.ClientSize, DELETED.ValidFrom, $Action AS MergeAction
INTO	@Client_SCD4 (BusinessKey, ClientName, Country, Town, Address1, Address2, ClientType, ClientSize, ValidFrom, MergeAction)
;

-- Update history table to set final date and current flag

UPDATE		TP4

SET			TP4.ValidTo = CONVERT (DATE, GETDATE())

FROM		dbo.Client_SCD4_History TP4
			INNER JOIN @Client_SCD4 TMP
			ON TP4.BusinessKey = TMP.BusinessKey

WHERE		TP4.ValidTo IS NULL


-- Add latest history records to history table

INSERT INTO dbo.Client_SCD4_History (BusinessKey, ClientName, Country, Town, Address1, Address2, ClientType, ClientSize, ValidFrom, ValidTo)

SELECT BusinessKey, ClientName, Country, Town, Address1, Address2, ClientType, ClientSize, ValidFrom, GETDATE()
FROM @Client_SCD4
WHERE BusinessKey IS NOT NULL





SELECT * FROM [dbo].[Client];
GO
EXEC Client_SCD4_ETL;
GO
SELECT * FROM [dbo].[Client_SCD1];
GO
SELECT * FROM [dbo].[Client_SCD4_History];
GO


--Scenario 2: New rows in the source table
SET IDENTITY_INSERT [dbo].[Client] ON
INSERT [dbo].[Client] ([ID], [ClientName], [Country], [Town], [County], [Address1], [Address2], [ClientType], [ClientSize]) VALUES (10, N'Petros', N'UK', N'Uttoxeter', N'Staffs', N'4, Grove Drive', NULL, N'Private', N'M')
SET IDENTITY_INSERT [dbo].[Client] OFF;
GO
EXEC Client_SCD4_ETL;
GO
SELECT * FROM [dbo].[Client_SCD1];
GO
SELECT * FROM [dbo].[Client_SCD4_History];
GO

UPDATE [dbo].[Client]
	SET Country = 'Armenia'
	WHERE ClientName = 'Petros';
GO
EXEC Client_SCD4_ETL;
GO
SELECT * FROM [dbo].[Client_SCD1];
GO
SELECT * FROM [dbo].[Client_SCD4_History];
GO

UPDATE [dbo].[Client]
	SET Country = 'Georgia'
	WHERE ClientName = 'Petros';
GO
EXEC Client_SCD4_ETL;
GO
SELECT * FROM [dbo].[Client_SCD1];
GO
SELECT * FROM [dbo].[Client_SCD4_History];
GO
