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



-- STEP 1 -- Tabel overview


SELECT
	transaction_id,
	total_sales,
	discount,
	category,
	city
FROM public.sales_analysis
LIMIT 100;



-- STEP2 -- Ranges overview


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



-- STEP3 -- Segment1


SELECT
	-- category,
	-- CEIL((discount*100)/10)*10 AS discount_range,
	CEIL(total_sales/100)*100 AS sales_range,
	COUNT(transaction_id),
	-- SUM(total_sales) AS total_sales,
	-- AVG(total_sales) AS average_sales,
	-- AVG(discount) AS average_discount,
	CASE
		WHEN CEIL(total_sales/100)*100 = 100 THEN 'Super low value'
		WHEN CEIL(total_sales/100)*100 = 200 THEN 'Low value'
		WHEN CEIL(total_sales/100)*100 = 300 THEN 'Mid value'
		WHEN CEIL(total_sales/100)*100 = 400 THEN 'High value'
		WHEN CEIL(total_sales/100)*100 >= 500 THEN 'Super high value'
		ELSE 'Red Flag'
	END segment1
	-- discount,
	-- city
FROM public.sales_analysis
WHERE category = 'Electronics'
GROUP BY category
-- , CEIL((discount*100)/10)*10
, CEIL(total_sales/100)*100;


-- STEP4 -- joined_segments


SELECT
	-- city,
	-- transaction_id,
	-- category,
	-- total_sales,
	COUNT(transaction_id),
	
	CASE
		WHEN CEIL(total_sales/100)*100 = 100 THEN 'Super low value'
		WHEN CEIL(total_sales/100)*100 = 200 THEN 'Low value'
		WHEN CEIL(total_sales/100)*100 = 300 THEN 'Mid value'
		WHEN CEIL(total_sales/100)*100 = 400 THEN 'High value'
		WHEN CEIL(total_sales/100)*100 >= 500 THEN 'Super high value'
		ELSE 'Red Flag'
	END segment1,
	
	CASE
		WHEN CEIL(discount*100/10)*10 = 10 THEN 'Super high value'
		WHEN CEIL(discount*100/10)*10 = 20 THEN 'High value'
		WHEN CEIL(discount*100/10)*10 = 30 THEN 'Mid value'
		WHEN CEIL(discount*100/10)*10 = 40 THEN 'Low value'
		WHEN CEIL(discount*100/10)*10 >= 50 THEN 'Super Low value'
		ELSE 'Super Low value'
	END segment2,
	
CONCAT (CASE
		WHEN CEIL(total_sales/100)*100 = 100 THEN 'Super low value'
		WHEN CEIL(total_sales/100)*100 = 200 THEN 'Low value'
		WHEN CEIL(total_sales/100)*100 = 300 THEN 'Mid value'
		WHEN CEIL(total_sales/100)*100 = 400 THEN 'High value'
		WHEN CEIL(total_sales/100)*100 >= 500 THEN 'E.Super high value'
		ELSE 'Red Flag'
		END,
		' & ',
		CASE
		WHEN CEIL(discount*100/10)*10 = 10 THEN 'Super high value'
		WHEN CEIL(discount*100/10)*10 = 20 THEN 'High value'
		WHEN CEIL(discount*100/10)*10 = 30 THEN 'Mid value'
		WHEN CEIL(discount*100/10)*10 = 40 THEN 'Low value'
		WHEN CEIL(discount*100/10)*10 >= 50 THEN 'Super Low value'
		ELSE 'Super Low value'
		END) AS joined_segments

FROM public.sales_analysis
WHERE category = 'Electronics'
GROUP BY category, segment1, segment2, joined_segments
ORDER BY segment1, segment2;