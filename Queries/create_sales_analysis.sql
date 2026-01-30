--Creating sales_analysis Table
CREATE TABLE IF NOT EXISTS sales_analysis AS
SELECT
    s.transaction_id,

    o.order_date,
    DATE(o.order_date) AS order_date_date,
    o.year,
    o.quarter,
    o.month,

    c.customer_name,
    c.city,
    c.zip_code,

    p.product_name,
    p.category,
    p.price,

    e.first_name  AS employee_first_name,
    e.last_name   AS employee_last_name,
    e.salary      AS employee_salary,

    s.quantity,
    s.discount,
    s.total_sales

FROM sales AS s
JOIN orders AS o
    ON s.order_id = o.order_id
JOIN customers AS c
    ON s.customer_id = c.customer_id
JOIN products AS p
    ON s.product_id = p.product_id
LEFT JOIN employees AS e
    ON s.employee_id = e.employee_id;

--Adding indexes
CREATE INDEX idx_sales_analysis_order_date
    ON sales_analysis(order_date_date);

CREATE INDEX idx_sales_analysis_year
    ON sales_analysis(year);

CREATE INDEX idx_sales_analysis_city
    ON sales_analysis(city);

CREATE INDEX idx_sales_analysis_category
    ON sales_analysis(category);

--Simple WHERE Conditions
SELECT
    transaction_id,
    order_date_date,
    product_name,
    total_sales
FROM sales_analysis
WHERE total_sales > 1000;

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category = 'Electronics';

--Combining Conditions with AND
SELECT
    transaction_id,
    order_date_date,
    year,
    product_name,
    total_sales
FROM sales_analysis
WHERE year = 2023
  AND total_sales > 10000;

SELECT
    transaction_id,
    city,
    category,
    total_sales
FROM sales_analysis
WHERE city = 'East Amanda'
  AND category = 'Electronics';

--Combining Conditions with OR
SELECT
    transaction_id,
    order_date_date,
    city,
    total_sales
FROM sales_analysis
WHERE city = 'East Amanda'
   OR city = 'Smithside';

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category = 'Toys'
   OR category = 'Books';

--Using IN
SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE city IN ('East Amanda', 'Smithside', 'Lake Thomas');

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category IN ('Electronics', 'Books');

--Using NOT IN
SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE city NOT IN ('East Lori', 'Anthonymouth');

SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE category NOT IN ('Toys', 'Books');


--Using BETWEEN for Ranges
SELECT
    transaction_id,
    order_date_date,
    total_sales
FROM sales_analysis
WHERE total_sales BETWEEN 50000 AND 150000;

SELECT
    transaction_id,
    year,
    total_sales
FROM sales_analysis
WHERE year BETWEEN 2022 AND 2024;


--Filtering Text with LIKE
SELECT
    transaction_id,
    product_name,
    category,
    total_sales
FROM sales_analysis
WHERE product_name LIKE 'E%';

SELECT
    transaction_id,
    city,
    total_sales
FROM sales_analysis
WHERE city LIKE '%North%';


--Handling NULL Values Correctly
WHERE discount IS NULL;

WHERE discount IS NOT NULL


--HAVING - Identifying Duplicate Transactions
SELECT
    transaction_id,
    COUNT(*) AS occurrence_count
FROM sales_analysis
GROUP BY transaction_id
HAVING COUNT(*) > 1;


--HAVING - Detecting Duplicate Product Sales on the Same Date
SELECT
    product_name,
    order_date_date,
    COUNT(*) AS occurrence_count
FROM sales_analysis
GROUP BY product_name, order_date_date
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;


--HAVING - Finding Customers with Multiple Transactions on the Same Day
SELECT
    customer_name,
    order_date_date,
    COUNT(*) AS transaction_count
FROM sales_analysis
GROUP BY customer_name, order_date_date
HAVING COUNT(*) > 1
ORDER BY transaction_count DESC;


--HAVING - Identifying Potential Duplicate Sales Amounts
SELECT
    total_sales,
    order_date_date,
    COUNT(*) AS occurrence_count
FROM sales_analysis
GROUP BY total_sales, order_date_date
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC;


--HAVING - Revenue-Focused Analysis
SELECT
    category,
    SUM(total_sales) AS total_sales_amount
FROM sales_analysis
WHERE year = 2023
GROUP BY category
HAVING SUM(total_sales) > 500000
ORDER BY total_sales_amount DESC;


--HAVING - Transaction Volume Analysis by City
SELECT
    city,
    COUNT(transaction_id) AS transaction_count
FROM sales_analysis
WHERE year = 2023
GROUP BY city
HAVING COUNT(transaction_id) > 1000
ORDER BY transaction_count DESC;


--HAVING - Revenue Performance by City
SELECT
    city,
    SUM(total_sales) AS total_sales_amount
FROM sales_analysis
WHERE year = 2023
GROUP BY city
HAVING SUM(total_sales) > 400000
ORDER BY total_sales_amount DESC;


--HAVING - High-Frequency, Low-Revenue Categories
SELECT
    category,
    COUNT(transaction_id) AS transaction_count,
    SUM(total_sales) AS total_sales_amount
FROM sales_analysis
WHERE year = 2023
GROUP BY category
HAVING COUNT(transaction_id) > 500
   AND SUM(total_sales) < 300000
ORDER BY transaction_count DESC;


--HAVING - Average Transaction Value by City
SELECT
    city,
    AVG(total_sales) AS avg_transaction_value
FROM sales_analysis
WHERE year = 2023
GROUP BY city
HAVING AVG(total_sales) > 800
ORDER BY avg_transaction_value DESC;


--HAVING - Revenue with Controlled Discounting
SELECT
    category,
    SUM(total_sales) AS total_sales_amount,
    AVG(discount) AS avg_discount
FROM sales_analysis
WHERE year = 2023
GROUP BY category
HAVING SUM(total_sales) > 400000
   AND AVG(discount) < 0.15
ORDER BY total_sales_amount DESC;


--Basic Structure of CASE
CASE
    WHEN condition_1 THEN result_1
    WHEN condition_2 THEN result_2
    ELSE default_result
END


--CASE - Categorizing Transactions by Sales Size
SELECT
    transaction_id,
    total_sales,
    CASE
        WHEN total_sales >= 100000 THEN 'High Value'
        WHEN total_sales >= 50000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS sales_segment
FROM sales_analysis;


--CASE - Creating Customer-Facing Labels
SELECT
    transaction_id,
    discount,
    CASE
        WHEN discount IS NULL THEN 'No Discount Information'
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.10 THEN 'Low Discount'
        ELSE 'High Discount'
    END AS discount_category
FROM sales_analysis;


--CASE - Categorizing Products by Price Range
SELECT
    product_name,
    price,
    CASE
        WHEN price >= 1000 THEN 'Premium'
        WHEN price >= 500 THEN 'Mid-Range'
        ELSE 'Budget'
    END AS price_category
FROM sales_analysis;


--CASE - CASE with Dates and Time-Based Logic
SELECT
    transaction_id,
    order_date_date,
    CASE
        WHEN quarter IN (1, 2) THEN 'First Half'
        ELSE 'Second Half'
    END AS year_period
FROM sales_analysis;


--CASE - CASE with Aggregation
SELECT
    CASE
        WHEN discount > 0 THEN 'Discounted'
        ELSE 'Full Price'
    END AS pricing_type,
    SUM(total_sales) AS total_sales_amount
FROM sales_analysis
GROUP BY pricing_type;