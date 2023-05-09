DROP TABLE IF EXISTS dim_Employees;
GO

create table dim_Employees (
EmployeeSK int primary key,
EmployeeID nvarchar(50),
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
ReportsToSK int foreign key references dim_Employees(EmployeeSK),
PhotoPath nvarchar(50)
);


