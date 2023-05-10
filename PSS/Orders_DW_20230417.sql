DROP DATABASE IF EXISTS Orders_DW
GO

CREATE DATABASE Orders_DW
GO

-- drop tables
USE Orders_DW;
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_products_SCD1;
DROP TABLE IF EXISTS dim_production_categories_SCD1;
DROP TABLE IF EXISTS dim_production_brands_SCD1;
DROP TABLE IF EXISTS dim_customers_SCD1;
DROP TABLE IF EXISTS dim_sales_staff_SCD1;
DROP TABLE IF EXISTS dim_stores_SCD1;
GO

USE Orders_DW;
CREATE TABLE dim_production_categories_SCD1(
	category_id_sk INT IDENTITY (1, 1) PRIMARY KEY,
	category_id_nk INT NOT NULL,
	category_name VARCHAR (255) NOT NULL
);
GO

USE Orders_DW;
CREATE TABLE dim_production_brands_SCD1 (
	brand_id_sk INT IDENTITY (1, 1) PRIMARY KEY,
	brand_id_nk INT NOT NULL,
	brand_name VARCHAR (255) NOT NULL
);
GO

USE Orders_DW;
CREATE TABLE dim_products_SCD1 (
	product_id_sk INT IDENTITY (1, 1) PRIMARY KEY,
	product_id_nk INT NOT NULL,
	product_name VARCHAR (255) NOT NULL,
	brand_id_sk_fk INT NOT NULL,
	category_id_sk_fk INT NOT NULL,
	model_year SMALLINT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	FOREIGN KEY (category_id_sk_fk) REFERENCES dim_production_categories_SCD1 (category_id_sk) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (brand_id_sk_fk) REFERENCES dim_production_brands_SCD1 (brand_id_sk) ON DELETE CASCADE ON UPDATE CASCADE
);
GO

USE Orders_DW;
CREATE TABLE dim_customers_SCD1 (
	customer_id_sk INT IDENTITY (1, 1) PRIMARY KEY,
	customer_id_nk INT NOT NULL,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255) NOT NULL,
	street VARCHAR (255),
	city VARCHAR (50),
	state VARCHAR (25),
	zip_code VARCHAR (5)
);
GO

USE Orders_DW;
CREATE TABLE dim_stores_SCD1 (
	store_id_sk INT IDENTITY (1, 1) PRIMARY KEY,
	store_id_nk INT NOT NULL,
	store_name VARCHAR (255) NOT NULL,
	phone VARCHAR (25),
	email VARCHAR (255),
	street VARCHAR (255),
	city VARCHAR (255),
	state VARCHAR (10),
	zip_code VARCHAR (5)
);
GO

USE Orders_DW;
CREATE TABLE dim_sales_staff_SCD1 (
	staff_id_sk INT IDENTITY (1, 1) PRIMARY KEY,
	staff_id_nk INT NOT NULL UNIQUE,
	first_name VARCHAR (50) NOT NULL,
	last_name VARCHAR (50) NOT NULL,
	email VARCHAR (255) NOT NULL UNIQUE,
	phone VARCHAR (25),
	active tinyint NOT NULL,
	store_id_sk_fk INT NOT NULL,
	manager_id INT,
	FOREIGN KEY (store_id_sk_fk) REFERENCES dim_stores_SCD1 (store_id_sk) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (manager_id) REFERENCES dim_sales_staff_SCD1 (staff_id_nk) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO

DROP TABLE IF EXISTS Orders_DW.dbo.fact_sales;
USE Orders_DW;
CREATE TABLE fact_sales (
	id_sk INT IDENTITY(1, 1) PRIMARY KEY,
	order_id_nk INT NOT NULL,
	order_status tinyint NOT NULL,
	-- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed
	order_date DATE NOT NULL,
	required_date DATE,
	shipped_date DATE,
	customer_id_sk_fk INT NOT NULL,
	store_id_sk_fk INT NOT NULL,
	staff_id_sk_fk INT NOT NULL,
	item_id INT,
	product_id_sk_fk INT NOT NULL,
	quantity INT NOT NULL,
	list_price DECIMAL (10, 2) NOT NULL,
	discount DECIMAL (4, 2) NOT NULL DEFAULT 0,
	FOREIGN KEY (product_id_sk_fk) REFERENCES dim_products_SCD1 (product_id_sk) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (customer_id_sk_fk) REFERENCES dim_customers_SCD1 (customer_id_sk) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (store_id_sk_fk) REFERENCES dim_stores_SCD1 (store_id_sk) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id_sk_fk) REFERENCES dim_sales_staff_SCD1 (staff_id_sk) ON DELETE NO ACTION ON UPDATE NO ACTION
);
GO






