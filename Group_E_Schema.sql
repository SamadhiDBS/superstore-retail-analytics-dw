-- Drop tables if they exist (for clean re-run)DROP TABLE IF EXISTS "FACT_SALES";
DROP TABLE IF EXISTS "DIM_CUSTOMER";
DROP TABLE IF EXISTS "DIM_PRODUCT";
DROP TABLE IF EXISTS "DIM_ORDER";
DROP TABLE IF EXISTS "DIM_TIME";

DROP TABLE IF EXISTS fact_sales CASCADE;
DROP TABLE IF EXISTS dim_customer CASCADE;
DROP TABLE IF EXISTS dim_product CASCADE;
DROP TABLE IF EXISTS dim_order CASCADE;
DROP TABLE IF EXISTS dim_time CASCADE;

-- DIM_CUSTOMER
CREATE TABLE DIM_CUSTOMER (
    customerkey SERIAL PRIMARY KEY,
    customerid VARCHAR(50) NOT NULL UNIQUE,
    customername VARCHAR(100),
    segment VARCHAR(50)
);

-- DIM_PRODUCT
CREATE TABLE DIM_PRODUCT (
    productkey SERIAL PRIMARY KEY,
    productid VARCHAR(50) NOT NULL UNIQUE,
    category VARCHAR(50),
    subcategory VARCHAR(50),
    productname VARCHAR(200)
);

-- DIM_ORDER
CREATE TABLE DIM_ORDER (
    orderkey SERIAL PRIMARY KEY,
    orderid VARCHAR(50) NOT NULL UNIQUE,
    orderdate DATE,
    shipdate DATE,
    shipmode VARCHAR(50),
    region VARCHAR(50),
    state VARCHAR(50),
    city VARCHAR(100),
    postalcode VARCHAR(20),
    country VARCHAR(50)
);

-- DIM_TIME
CREATE TABLE DIM_TIME (
    timekey INT PRIMARY KEY,
    fulldate DATE NOT NULL,
    year INT,
    quarter INT,
    month INT,
    monthname VARCHAR(20),
    dayofweek INT,
    dayname VARCHAR(10),
    weekofyear INT,
    isweekend BOOLEAN
);

-- FACT_SALES
CREATE TABLE FACT_SALES (
    saleskey SERIAL PRIMARY KEY,
    customerkey INT REFERENCES DIM_CUSTOMER(customerkey),
    productkey INT REFERENCES DIM_PRODUCT(productkey),
    orderkey INT REFERENCES DIM_ORDER(orderkey),
    timekey INT REFERENCES DIM_TIME(timekey),
    orderid VARCHAR(50),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2)
);

-- Indexes
CREATE INDEX idx_fact_customer ON FACT_SALES(customerkey);
CREATE INDEX idx_fact_product ON FACT_SALES(productkey);
CREATE INDEX idx_fact_order ON FACT_SALES(orderkey);
CREATE INDEX idx_fact_time ON FACT_SALES(timekey);