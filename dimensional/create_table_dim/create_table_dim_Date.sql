DROP TABLE IF EXISTS {db}.{schema}.dim_Date;
GO

CREATE TABLE {db}.{schema}.dim_Date (
    DateSK INT NOT NULL IDENTITY(1,1),
    Date DATETIME NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    MonthName NVARCHAR(50) NOT NULL,
    Day INT NOT NULL,
    DayOfWeek INT NOT NULL,
    DayName NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_Date PRIMARY KEY (DateSK)
);

DECLARE @StartDate DATETIME, @EndDate DATETIME;
SET @StartDate = '01/01/1990';
SET @EndDate = '12/31/2023';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO dim_Date (Date, Year, Quarter, Month, MonthName, Day, DayOfWeek, DayName)
    VALUES (
        @StartDate,
        YEAR(@StartDate),
        DATEPART(Q, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DAY(@StartDate),
        DATEPART(DW, @StartDate),
        DATENAME(WEEKDAY, @StartDate)
    );
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;

