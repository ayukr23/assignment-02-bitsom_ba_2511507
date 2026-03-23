--DIMENSION TABLE 1: dim_date
-- Derived from the 'date' column in raw data
-- ETL Decision: All 3 date formats (YYYY-MM-DD, DD/MM/YYYY, DD-MM-YYYY)
-- were standardized to YYYY-MM-DD before loading
-- ============================================================
CREATE TABLE dim_date (
    date_key        INT         PRIMARY KEY,   -- Surrogate key: YYYYMMDD e.g. 20230829
    full_date       DATE        NOT NULL,
    day             INT         NOT NULL,
    month           INT         NOT NULL,
    month_name      VARCHAR(15) NOT NULL,
    quarter         INT         NOT NULL,
    year            INT         NOT NULL,
    day_of_week     VARCHAR(10) NOT NULL,
    is_weekend      BOOLEAN     NOT NULL
);
 
-- ============================================================
-- DIMENSION TABLE 2: dim_store
-- Derived from store_name + store_city columns
-- ETL Decision: 19 NULL city values were imputed using the
-- known store_name → city mapping
-- ============================================================
CREATE TABLE dim_store (
    store_key       INT          PRIMARY KEY,  -- Surrogate key
    store_name      VARCHAR(100) NOT NULL,
    store_city      VARCHAR(100) NOT NULL,
    store_region    VARCHAR(100) NOT NULL       -- Derived: South/North/West etc.
);
 
-- ============================================================
-- DIMENSION TABLE 3: dim_product
-- Derived from product_name + category columns
-- ETL Decision: Category casing was standardized
-- 'electronics' → 'Electronics', 'Groceries' → 'Grocery'
-- ============================================================
CREATE TABLE dim_product (
    product_key     INT          PRIMARY KEY,  -- Surrogate key
    product_name    VARCHAR(150) NOT NULL,
    category        VARCHAR(100) NOT NULL,     -- Cleaned & standardized
    unit_price      DECIMAL(12,2) NOT NULL
);
 
-- ============================================================
-- FACT TABLE: fact_sales
-- Central table with numeric measures + foreign keys to dimensions
-- ============================================================
CREATE TABLE fact_sales (
    fact_id         INT            PRIMARY KEY AUTO_INCREMENT,
    transaction_id  VARCHAR(15)    NOT NULL UNIQUE,
    date_key        INT            NOT NULL,
    store_key       INT            NOT NULL,
    product_key     INT            NOT NULL,
    customer_id     VARCHAR(15)    NOT NULL,
    units_sold      INT            NOT NULL CHECK (units_sold > 0),
    unit_price      DECIMAL(12,2)  NOT NULL,
    total_revenue   DECIMAL(15,2)  NOT NULL,   -- Computed: units_sold * unit_price
    FOREIGN KEY (date_key)    REFERENCES dim_date(date_key),
    FOREIGN KEY (store_key)   REFERENCES dim_store(store_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key)
);
 
-- ============================================================
-- INSERT: dim_date
-- All dates normalized from 3 raw formats to YYYY-MM-DD
-- date_key = YYYYMMDD integer for fast partition/range queries
-- ============================================================
INSERT INTO dim_date VALUES (20230829, '2023-08-29', 29, 8,  'August',    3, 2023, 'Tuesday',   FALSE);
INSERT INTO dim_date VALUES (20231212, '2023-12-12', 12, 12, 'December',  4, 2023, 'Tuesday',   FALSE);
INSERT INTO dim_date VALUES (20230205, '2023-02-05',  5, 2,  'February',  1, 2023, 'Sunday',    TRUE);
INSERT INTO dim_date VALUES (20230220, '2023-02-20', 20, 2,  'February',  1, 2023, 'Monday',    FALSE);
INSERT INTO dim_date VALUES (20230115, '2023-01-15', 15, 1,  'January',   1, 2023, 'Sunday',    TRUE);
INSERT INTO dim_date VALUES (20230809, '2023-08-09',  9, 8,  'August',    3, 2023, 'Wednesday', FALSE);
INSERT INTO dim_date VALUES (20230331, '2023-03-31', 31, 3,  'March',     1, 2023, 'Friday',    FALSE);
INSERT INTO dim_date VALUES (20231026, '2023-10-26', 26, 10, 'October',   4, 2023, 'Thursday',  FALSE);
INSERT INTO dim_date VALUES (20231208, '2023-12-08',  8, 12, 'December',  4, 2023, 'Friday',    FALSE);
INSERT INTO dim_date VALUES (20230815, '2023-08-15', 15, 8,  'August',    3, 2023, 'Tuesday',   FALSE);
INSERT INTO dim_date VALUES (20230604, '2023-06-04',  4, 6,  'June',      2, 2023, 'Sunday',    TRUE);
INSERT INTO dim_date VALUES (20231020, '2023-10-20', 20, 10, 'October',   4, 2023, 'Friday',    FALSE);
INSERT INTO dim_date VALUES (20230521, '2023-05-21', 21, 5,  'May',       2, 2023, 'Sunday',    TRUE);
INSERT INTO dim_date VALUES (20230428, '2023-04-28', 28, 4,  'April',     2, 2023, 'Friday',    FALSE);
INSERT INTO dim_date VALUES (20231118, '2023-11-18', 18, 11, 'November',  4, 2023, 'Saturday',  TRUE);
 
-- ============================================================
-- INSERT: dim_store
-- 5 unique stores; NULL cities resolved via store-to-city lookup
-- ============================================================
INSERT INTO dim_store VALUES (1, 'Chennai Anna',   'Chennai',   'South');
INSERT INTO dim_store VALUES (2, 'Delhi South',    'Delhi',     'North');
INSERT INTO dim_store VALUES (3, 'Bangalore MG',   'Bangalore', 'South');
INSERT INTO dim_store VALUES (4, 'Pune FC Road',   'Pune',      'West');
INSERT INTO dim_store VALUES (5, 'Mumbai Central', 'Mumbai',    'West');
 
-- ============================================================
-- INSERT: dim_product
-- 16 unique products; category cleaned:
--   'electronics' → 'Electronics'
--   'Groceries'   → 'Grocery'
-- ============================================================
INSERT INTO dim_product VALUES (1,  'Speaker',    'Electronics', 49262.78);
INSERT INTO dim_product VALUES (2,  'Tablet',     'Electronics', 23226.12);
INSERT INTO dim_product VALUES (3,  'Phone',      'Electronics', 48703.39);
INSERT INTO dim_product VALUES (4,  'Smartwatch', 'Electronics', 58851.01);
INSERT INTO dim_product VALUES (5,  'Laptop',     'Electronics', 42343.15);
INSERT INTO dim_product VALUES (6,  'Headphones', 'Electronics', 39854.96);
INSERT INTO dim_product VALUES (7,  'Atta 10kg',  'Grocery',     52464.00);
INSERT INTO dim_product VALUES (8,  'Biscuits',   'Grocery',     27469.99);
INSERT INTO dim_product VALUES (9,  'Milk 1L',    'Grocery',     43374.39);
INSERT INTO dim_product VALUES (10, 'Oil 1L',     'Grocery',     26474.34);
INSERT INTO dim_product VALUES (11, 'Pulses 1kg', 'Grocery',     31604.47);
INSERT INTO dim_product VALUES (12, 'Rice 5kg',   'Grocery',     52195.05);
INSERT INTO dim_product VALUES (13, 'Jacket',     'Clothing',    30187.24);
INSERT INTO dim_product VALUES (14, 'Jeans',      'Clothing',     2317.47);
INSERT INTO dim_product VALUES (15, 'Saree',      'Clothing',    35451.81);
INSERT INTO dim_product VALUES (16, 'T-Shirt',    'Clothing',    29770.19);
 
-- ============================================================
-- INSERT: fact_sales — 15 cleaned rows from retail_transactions.csv
-- total_revenue = units_sold * unit_price (computed during ETL)
-- Dates normalized, cities imputed, categories standardized
-- ============================================================
INSERT INTO fact_sales (transaction_id, date_key, store_key, product_key, customer_id, units_sold, unit_price, total_revenue)
VALUES
('TXN5000', 20230829, 1, 1,  'CUST045',  3, 49262.78,  147788.34),
('TXN5001', 20231212, 1, 2,  'CUST021', 11, 23226.12,  255487.32),
('TXN5002', 20230205, 1, 3,  'CUST019', 20, 48703.39,  974067.80),
('TXN5003', 20230220, 2, 2,  'CUST007', 14, 23226.12,  325165.68),
('TXN5004', 20230115, 1, 4,  'CUST004', 10, 58851.01,  588510.10),
('TXN5005', 20230809, 3, 7,  'CUST027', 12, 52464.00,  629568.00),
('TXN5006', 20230331, 4, 4,  'CUST025',  6, 58851.01,  353106.06),
('TXN5007', 20231026, 4, 14, 'CUST041', 16,  2317.47,   37079.52),
('TXN5008', 20231208, 3, 8,  'CUST030',  9, 27469.99,  247229.91),
('TXN5009', 20230815, 3, 4,  'CUST020',  3, 58851.01,  176553.03),
('TXN5010', 20230604, 1, 13, 'CUST031', 15, 30187.24,  452808.60),
('TXN5011', 20231020, 5, 14, 'CUST045', 13,  2317.47,   30127.11),
('TXN5012', 20230521, 3, 5,  'CUST044', 13, 42343.15,  550460.95),
('TXN5013', 20230428, 5, 9,  'CUST015', 10, 43374.39,  433743.90),
('TXN5014', 20231118, 2, 13, 'CUST042',  5, 30187.24,  150936.20);
