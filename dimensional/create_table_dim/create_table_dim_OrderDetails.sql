DROP TABLE IF EXISTS dim_OrderDetails;
GO

create table dim_OrderDetails (
OrderDetailSK int primary key,
OrderID int foreign key references fact_Orders(OrderSK),
ProductID int foreign key references dim_Products(ProductSK),
UnitPrice decimal(10,2),
Quantity int,
Discount decimal(10,2)
);

