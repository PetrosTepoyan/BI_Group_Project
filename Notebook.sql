-- select * from Categories;
-- use master;
-- drop DATABASE Orders_RELATIONAL_DB;
-- select * from Employees;
-- select * from Orders;

-- ALTER TABLE OrderDetails DROP CONSTRAINT FK_OrderDetails_OrderID;

-- select * from Employees;
select * from dbo.dim_Categories_SCD3;
SELECT 
  ROUTINE_SCHEMA,
  ROUTINE_NAME
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE';

drop procedure Categories_SCD3_ETL;
drop table dbo.dim_Categories_SCD3

select * from dbo.dim_Employees_SCD2;