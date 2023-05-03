-- select * from Categories;
use master;
drop DATABASE Orders_RELATIONAL_DB;
select * from Employees;
select * from Orders;

ALTER TABLE OrderDetails DROP CONSTRAINT FK_OrderDetails_OrderID;