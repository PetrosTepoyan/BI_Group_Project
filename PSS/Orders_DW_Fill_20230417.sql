USE Orders_DW;
GO 

DROP PROCEDURE IF EXISTS Orders_DW_brand_SCD1_ETL
GO
CREATE PROCEDURE Orders_DW_brand_SCD1_ETL
AS
BEGIN TRY
MERGE Orders_DW.dbo.dim_production_brands_SCD1 AS DST -- destination
USING Orders_ER.production.brands AS SRC -- source
ON ( SRC.brand_id = DST.brand_id_nk )
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (brand_id_nk, brand_name)
  VALUES (SRC.brand_id, SRC.brand_name)
WHEN MATCHED AND (
	Isnull(DST.brand_name, '') <> Isnull(SRC.brand_name, '') ) 
	THEN
		UPDATE SET DST.brand_name = SRC.brand_name; 
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM Orders_ER.production.brands;
SELECT * FROM Orders_DW.dbo.dim_production_brands_SCD1;
EXEC Orders_DW_brand_SCD1_ETL;


DROP PROCEDURE IF EXISTS Orders_DW_categories_SCD1_ETL
GO
CREATE PROCEDURE Orders_DW_categories_SCD1_ETL
AS
BEGIN TRY
MERGE Orders_DW.dbo.dim_production_categories_SCD1 AS DST -- destination
USING Orders_ER.production.categories AS SRC -- source
ON ( SRC.category_id = DST.category_id_nk )
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (category_id_nk, category_name)
  VALUES (SRC.category_id, SRC.category_name)
WHEN MATCHED AND (
  Isnull(DST.category_name, '') <> Isnull(SRC.category_name, '') ) 
  THEN
    UPDATE SET DST.category_name = SRC.category_name; 
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM Orders_ER.production.categories;
SELECT * FROM Orders_DW.dbo.dim_production_categories_SCD1;
EXEC Orders_DW_categories_SCD1_ETL;


DROP PROCEDURE IF EXISTS Orders_DW_products_SCD1_ETL
GO
CREATE PROCEDURE Orders_DW_products_SCD1_ETL
AS
BEGIN TRY
MERGE Orders_DW.dbo.dim_products_SCD1 AS DST -- destination
USING 
(select prod.*, dimcat.category_id_sk, dimbrand.brand_id_sk
from Orders_ER.production.products prod
left join ORDERS_DW.dbo.dim_production_categories_SCD1 dimcat
on prod.category_id = dimcat.category_id_nk
left join Orders_DW.dbo.dim_production_brands_SCD1 dimbrand
ON prod.brand_id = dimbrand.brand_id_nk)AS SRC -- source
ON ( SRC.product_id = DST.product_id_nk )
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (
		  product_id_nk,
		  product_name,
          brand_id_sk_fk,
          category_id_sk_fk,
          model_year,
          list_price)
  VALUES (
	      SRC.product_id,
		  SRC.product_name,
          SRC.brand_id_sk,
          SRC.category_id_sk,
          SRC.model_year,
          SRC.list_price)
WHEN MATCHED AND (
  Isnull(DST.product_name, '') <> Isnull(SRC.product_name, '') OR
  Isnull(DST.brand_id_sk_fk, '') <> Isnull(SRC.brand_id_sk, '') OR
  Isnull(DST.category_id_sk_fk, '') <> Isnull(SRC.category_id_sk, '') OR
  Isnull(DST.model_year, '') <> Isnull(SRC.model_year, '') OR
  Isnull(DST.list_price, '') <> Isnull(SRC.list_price, '') 
  ) 
  THEN
    UPDATE SET 
      DST.product_name = SRC.product_name,
      DST.brand_id_sk_fk = SRC.brand_id_sk,
      DST.category_id_sk_fk = SRC.category_id_sk,
      DST.model_year = SRC.model_year,
      DST.list_price = SRC.list_price; 
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM Orders_ER.production.products;
SELECT * FROM Orders_DW.dbo.dim_products_SCD1;
EXEC Orders_DW_products_SCD1_ETL;

DROP PROCEDURE IF EXISTS Orders_DW_customers_SCD1_ETL
GO
CREATE PROCEDURE Orders_DW_customers_SCD1_ETL
AS
BEGIN TRY
MERGE Orders_DW.dbo.dim_customers_SCD1 AS DST -- destination
USING Orders_ER.sales.customers AS SRC -- source
ON ( SRC.customer_id = DST.customer_id_nk )
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (customer_id_nk,
		  first_name,
          last_name,
          phone,
          email,
          street,
          city,
          state,
          zip_code)
  VALUES (SRC.customer_id,
		  SRC.first_name,
          SRC.last_name,
          SRC.phone,
          SRC.email,
          SRC.street,
          SRC.city,
          SRC.state,
          SRC.zip_code)
WHEN MATCHED AND (
  Isnull(DST.first_name, '') <> Isnull(SRC.first_name, '') OR
  Isnull(DST.last_name, '') <> Isnull(SRC.last_name, '') OR
  Isnull(DST.phone, '') <> Isnull(SRC.phone, '') OR
  Isnull(DST.email, '') <> Isnull(SRC.email, '') OR
  Isnull(DST.street, '') <> Isnull(SRC.street, '') OR
  Isnull(DST.city, '') <> Isnull(SRC.city, '') OR
  Isnull(DST.state, '') <> Isnull(SRC.state, '') OR
  Isnull(DST.zip_code, '') <> Isnull(SRC.zip_code, '') 
  ) 
  THEN
    UPDATE SET 
      DST.first_name = SRC.first_name,
      DST.last_name = SRC.last_name,
      DST.phone = SRC.phone,
      DST.email = SRC.email,
      DST.street = SRC.street,
      DST.city = SRC.city,
      DST.state = SRC.state,
      DST.zip_code = SRC.zip_code; 
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM Orders_ER.sales.customers;
SELECT * FROM Orders_DW.dbo.dim_customers_SCD1;
EXEC Orders_DW_customers_SCD1_ETL;

DROP PROCEDURE IF EXISTS Orders_DW_stores_SCD1_ETL
GO
CREATE PROCEDURE Orders_DW_stores_SCD1_ETL
AS
BEGIN TRY
MERGE Orders_DW.dbo.dim_stores_SCD1 AS DST -- destination
USING Orders_ER.sales.stores AS SRC -- source
ON ( SRC.store_id = DST.store_id_nk )
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (store_id_nk,
		  store_name,
          phone,
          email,
          street,
          city,
          state,
          zip_code)
  VALUES (SRC.store_id,
          SRC.store_name,
          SRC.phone,
          SRC.email,
          SRC.street,
          SRC.city,
          SRC.state,
          SRC.zip_code)
WHEN MATCHED AND (
  Isnull(DST.store_name, '') <> Isnull(SRC.store_name, '') OR
  Isnull(DST.phone, '') <> Isnull(SRC.phone, '') OR
  Isnull(DST.email, '') <> Isnull(SRC.email, '') OR
  Isnull(DST.street, '') <> Isnull(SRC.street, '') OR
  Isnull(DST.city, '') <> Isnull(SRC.city, '') OR
  Isnull(DST.state, '') <> Isnull(SRC.state, '') OR
  Isnull(DST.zip_code, '') <> Isnull(SRC.zip_code, '') 
  ) 
  THEN
    UPDATE SET 
      DST.store_name = SRC.store_name,
      DST.phone = SRC.phone,
      DST.email = SRC.email,
      DST.street = SRC.street,
      DST.city = SRC.city,
      DST.state = SRC.state,
      DST.zip_code = SRC.zip_code; 
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM Orders_ER.sales.stores;
SELECT * FROM Orders_DW.dbo.dim_stores_SCD1;
EXEC Orders_DW_stores_SCD1_ETL;

DROP PROCEDURE IF EXISTS Orders_DW_staff_SCD1_ETL
GO
CREATE PROCEDURE Orders_DW_staff_SCD1_ETL
AS
BEGIN TRY
MERGE Orders_DW.dbo.dim_sales_staff_SCD1 AS DST -- destination
USING 
(SELECT staff.*,stores.store_id_sk 
FROM Orders_ER.sales.staffs staff
LEFT JOIN ORDERS_DW.dbo.dim_stores_SCD1 stores
ON staff.store_id = stores.store_id_nk) AS SRC -- source
ON ( SRC.staff_id = DST.staff_id_nk )
WHEN NOT MATCHED THEN -- there are IDs in the source table that are not in the destination table
  INSERT (staff_id_nk,
		  first_name,
          last_name,
          email,
          phone,
          active,
          store_id_sk_fk,
          manager_id)
  VALUES (SRC.staff_id,
		  SRC.first_name,
          SRC.last_name,
          SRC.email,
          SRC.phone,
          SRC.active,
          SRC.store_id_sk,
          SRC.manager_id)
WHEN MATCHED AND (
  Isnull(DST.first_name, '') <> Isnull(SRC.first_name, '') OR
  Isnull(DST.last_name, '') <> Isnull(SRC.last_name, '') OR
  Isnull(DST.email, '') <> Isnull(SRC.email, '') OR
  Isnull(DST.phone, '') <> Isnull(SRC.phone, '') OR
  Isnull(DST.active, '') <> Isnull(SRC.active, '') OR
  Isnull(DST.store_id_sk_fk, '') <> Isnull(SRC.store_id_sk, '') OR
  Isnull(DST.manager_id, '') <> Isnull(SRC.manager_id, '') 
  ) 
  THEN
    UPDATE SET 
      DST.first_name = SRC.first_name,
      DST.last_name = SRC.last_name,
      DST.email = SRC.email,
      DST.phone = SRC.phone,
      DST.active = SRC.active,
      DST.store_id_sk_fk = SRC.store_id_sk,
      DST.manager_id = SRC.manager_id; 
END TRY
BEGIN CATCH
    THROW
END CATCH
GO

SELECT * FROM Orders_ER.sales.staffs;
SELECT * FROM Orders_DW.dbo.dim_sales_staff_SCD1;
EXEC Orders_DW_staff_SCD1_ETL;


DROP PROCEDURE IF EXISTS Orders_DW_fact_table_ingestion
GO
CREATE PROCEDURE Orders_DW_fact_table_ingestion
AS
BEGIN TRY
INSERT INTO Orders_DW.dbo.fact_sales 
	(
	order_id_nk,
	order_status,
	order_date,
	required_date,
	shipped_date,
	customer_id_sk_fk,
	store_id_sk_fk,
	staff_id_sk_fk,
	item_id,
	product_id_sk_fk,
	quantity,
	list_price,
	discount
	)
SELECT 
	orders.order_id, -- junk dimension (for tracing_
	orders.order_status,
	orders.order_date,
	orders.required_date,
	orders.shipped_date,
	customers.customer_id_sk,
	stores.store_id_sk,
	staff.staff_id_sk,
	order_items.item_id,
	products.product_id_sk,
	ISNULL(order_items.quantity, 0),
	ISNULL(order_items.list_price, 0),
	ISNULL(order_items.discount, 0)
FROM Orders_ER.sales.order_items AS order_items 

LEFT JOIN Orders_ER.sales.orders as orders
ON order_items.order_id = orders.order_id

LEFT JOIN Orders_DW.dbo.dim_products_SCD1 products
ON order_items.product_id = products.product_id_nk

LEFT JOIN Orders_DW.dbo.dim_customers_SCD1 customers
ON orders.customer_id = customers.customer_id_nk

LEFT JOIN Orders_DW.dbo.dim_stores_SCD1 stores
ON orders.store_id = stores.store_id_nk

LEFT JOIN Orders_DW.dbo.dim_sales_staff_SCD1 staff
ON orders.staff_id = staff.staff_id_nk

END TRY
BEGIN CATCH
    THROW
END CATCH
GO

-- CREATE TABLE sales.order_items (
-- 	order_id INT,
-- 	item_id INT,
-- 	product_id INT NOT NULL,
-- 	quantity INT NOT NULL,
-- 	list_price DECIMAL (10, 2) NOT NULL,
-- 	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
-- 	PRIMARY KEY (order_id, item_id),
-- 	FOREIGN KEY (order_id) REFERENCES sales.orders (order_id) ON DELETE CASCADE ON UPDATE CASCADE,
-- 	FOREIGN KEY (product_id) REFERENCES production.products (product_id) ON DELETE CASCADE ON UPDATE CASCADE
-- );



SELECT * FROM Orders_ER.sales.order_items;
SELECT * FROM Orders_DW.dbo.fact_sales;
EXEC Orders_DW_fact_table_ingestion;