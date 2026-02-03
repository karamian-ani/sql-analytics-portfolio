-- Task 1 | Complex Transaction Segmentation (CASE + WHERE)
-- Create a query that classifies each transaction into a business segment using a CASE statement.

-- Your segmentation must consider at least all of the following dimensions:

-- Transaction value (total_sales)
-- Discount level (discount)
-- Product category
-- City
-- Example ideas (you must define your own rules and labels):

-- High-value Electronics transactions with low discount
-- Medium-value transactions with moderate discount
-- Low-value or heavily discounted transactions
-- Any additional meaningful segment you define
-- Requirements:

-- Use CASE WHEN with multiple conditions combined using AND / OR
-- Use WHERE to limit the analysis to year 2023
-- Return at least:
-- transaction_id
-- city
-- category
-- total_sales
-- The derived segmentation column


-- SELECT
-- 	transaction_id,
-- 	total_sales,
-- 	discount,
-- 	category,
-- 	city
-- FROM public.sales_analysis
-- LIMIT 100;


SELECT
	category,
	CEIL(total_sales/50)*50 AS sales_range,
	COUNT(transaction_id),
	SUM(total_sales) AS total_sales,
	MIN(total_sales) AS minimal_sales,
	MAX(total_sales) AS maximal_sales,
	AVG(total_sales) AS average_sales
	-- discount,
	-- city
FROM public.sales_analysis
WHERE category = 'Electronics'
GROUP BY category, CEIL(total_sales/50)*50;
