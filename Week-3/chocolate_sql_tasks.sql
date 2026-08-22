/* ============================================================
   SQL ASSIGNMENT - CHOCOLATE SALES DATASET
   Tables used:
     1. chocolate_sales   -> from chocolate.csv (main sales data)
     2. product_category  -> from chocolate.xlsx screenshot (Product -> Category lookup)
   ============================================================ */


/* ============================================================
   SETUP: CREATE TABLES
   ============================================================ */

CREATE TABLE chocolate_sales (
    sales_person   VARCHAR(50),
    country        VARCHAR(50),
    product        VARCHAR(100),
    sale_date      DATE,
    amount         INT,
    boxes_shipped  INT
);

CREATE TABLE product_category (
    product   VARCHAR(100) PRIMARY KEY,
    category  VARCHAR(50)
);

-- Sample inserts for product_category (from provided screenshot)
INSERT INTO product_category (product, category) VALUES
('50% Dark Bites', 'Dark Chocolate'),
('70% Dark Bites', 'Dark Chocolate'),
('85% Dark Bars', 'Dark Chocolate'),
('99% Dark & Pure', 'Dark Chocolate'),
('After Nines', 'Chocolate'),
('Almond Choco', 'Chocolate'),
('Baker''s Choco Chips', 'Chocolate'),
('Caramel Stuffed Bars', 'Chocolate'),
('Choco Coated Almonds', 'Chocolate'),
('Drinking Coco', 'Cocoa'),
('Eclairs', 'Candy'),
('Fruit & Nut Bars', 'Snack'),
('Manuka Honey Choco', 'Chocolate'),
('Milk Bars', 'Chocolate'),
('Mint Chip Choco', 'Chocolate'),
('Orange Choco', 'Chocolate'),
('Organic Choco Syrup', 'Syrup'),
('Peanut Butter Cubes', 'Snack'),
('Raspberry Choco', 'Chocolate'),
('Smooth Sliky Salty', 'Chocolate'),
('Spicy Special Slims', 'Chocolate'),
('White Choc', 'Chocolate');

-- chocolate_sales rows loaded via bulk import from cleaned chocolate.csv
-- (dates already normalized to YYYY-MM-DD, amount already numeric)
-- Example (MySQL):
-- LOAD DATA INFILE 'chocolate_cleaned.csv'
-- INTO TABLE chocolate_sales
-- FIELDS TERMINATED BY ',' ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (sales_person, country, product, sale_date, amount, boxes_shipped);


/* ============================================================
   TASK 1: Introduction to Databases & SELECT Statement (10 Marks)
   ============================================================ */

-- 1a. Display all records
SELECT *
FROM chocolate_sales;

-- 1b. Select specific columns
SELECT sales_person, country, product, amount
FROM chocolate_sales;

-- 1c. Select specific columns using column aliases
SELECT
    sales_person  AS "Sales Rep",
    country       AS "Country",
    product       AS "Product Name",
    amount        AS "Sale Amount ($)"
FROM chocolate_sales;


/* ============================================================
   TASK 2: WHERE, ORDER BY & Aggregate Functions (15 Marks)
   ============================================================ */

-- 2a. Filter records using WHERE clause
SELECT *
FROM chocolate_sales
WHERE country = 'UK';

-- 2b. Filter using comparison operators
SELECT sales_person, product, amount
FROM chocolate_sales
WHERE amount > 10000;

-- 2c. Sort records using ORDER BY (descending by amount)
SELECT sales_person, product, amount
FROM chocolate_sales
ORDER BY amount DESC;

-- 2d. Aggregate functions

-- COUNT: total number of sales transactions
SELECT COUNT(*) AS total_transactions
FROM chocolate_sales;

-- SUM: total sales amount
SELECT SUM(amount) AS total_sales_amount
FROM chocolate_sales;

-- AVG: average sale amount
SELECT AVG(amount) AS average_sale_amount
FROM chocolate_sales;

-- MIN: smallest sale amount
SELECT MIN(amount) AS minimum_sale_amount
FROM chocolate_sales;

-- MAX: largest sale amount
SELECT MAX(amount) AS maximum_sale_amount
FROM chocolate_sales;


/* ============================================================
   TASK 3: GROUP BY & HAVING (10 Marks)
   ============================================================ */

-- 3a. Group records by country and calculate total sales per group
SELECT
    country,
    COUNT(*)      AS total_orders,
    SUM(amount)   AS total_sales
FROM chocolate_sales
GROUP BY country
ORDER BY total_sales DESC;

-- 3b. Use HAVING to filter grouped results
-- Only show countries whose total sales exceed 1,000,000
SELECT
    country,
    SUM(amount) AS total_sales
FROM chocolate_sales
GROUP BY country
HAVING SUM(amount) > 1000000
ORDER BY total_sales DESC;

/* Explanation:
   GROUP BY collapses rows into one row per country and lets us
   compute an aggregate (SUM) per group. HAVING then filters those
   grouped rows (unlike WHERE, which can only filter raw rows before
   grouping) — here it keeps only countries with combined sales
   above 1,000,000. */


/* ============================================================
   TASK 4: SQL Joins (15 Marks)
   Tables: chocolate_sales (main) + product_category (lookup)
   Common column: product
   ============================================================ */

-- 4a. INNER JOIN
-- Returns only sales rows whose product has a matching category entry
SELECT
    cs.sales_person,
    cs.product,
    pc.category,
    cs.amount
FROM chocolate_sales cs
INNER JOIN product_category pc
    ON cs.product = pc.product;

-- 4b. LEFT JOIN
-- Returns ALL sales rows, with category filled in where a match exists
-- (NULL category if a product has no entry in product_category)
SELECT
    cs.sales_person,
    cs.product,
    pc.category,
    cs.amount
FROM chocolate_sales cs
LEFT JOIN product_category pc
    ON cs.product = pc.product;

-- 4c. RIGHT JOIN
-- Returns ALL products from product_category, with sales data
-- attached where matching sales exist (NULL sales fields otherwise)
SELECT
    pc.product,
    pc.category,
    cs.sales_person,
    cs.amount
FROM chocolate_sales cs
RIGHT JOIN product_category pc
    ON cs.product = pc.product;

/* Explanation of each JOIN:
   - INNER JOIN: keeps only rows that match on "product" in BOTH
     tables — used when you only want fully matched sales+category data.
   - LEFT JOIN: keeps every row from chocolate_sales (the left table)
     even if there's no matching category — useful for auditing which
     products in sales are missing a category classification.
   - RIGHT JOIN: keeps every row from product_category (the right
     table) even if that product never appeared in sales — useful for
     seeing which catalog products have never sold. */


/* ============================================================
   TASK 5: SQL Subqueries (10 Marks)
   ============================================================ */

-- 5a. Find sales persons whose total sales amount is higher than
--     the average total sales amount (across all sales persons)
SELECT sales_person, total_amount
FROM (
    SELECT sales_person, SUM(amount) AS total_amount
    FROM chocolate_sales
    GROUP BY sales_person
) AS person_totals
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM chocolate_sales
        GROUP BY sales_person
    ) AS avg_calc
)
ORDER BY total_amount DESC;

-- 5b. Find products whose average sale amount is higher than the
--     overall average sale amount across all products
SELECT product, AVG(amount) AS avg_product_amount
FROM chocolate_sales
GROUP BY product
HAVING AVG(amount) > (
    SELECT AVG(amount)
    FROM chocolate_sales
)
ORDER BY avg_product_amount DESC;

/* Explanation:
   Both queries use a subquery to first compute an overall benchmark
   (the average of per-person or per-product totals), then compare
   each group's aggregate against that benchmark in the outer query
   / HAVING clause. */
