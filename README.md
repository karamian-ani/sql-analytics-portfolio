# sql-analytics-portfolio

02.Dec.2025
-----------
Docker
Downloaded and Installed Docker Desktop then Verified Installation in my Device.

VS Code
Downloaded and Installed VS code on my device then verified the path.
Added some Extensions like:
- Python, Pylance and Jupyte for Python Development
- GitLense GitHub Pull Requests and Issues for GIT and GitHub
- Docker and Dev Containers for Containers and Development Environments
- Markdown All in One, Markdown Preview Enhanced and YAML for Markdown and Documentation
- Project Manager, Better Comments and Code Spell Checker for Productivity
 
GitHub
Downloaded and Installed GIT on my Device.
Signed Up for GitHub
Git Configuration
- Check Current Git Config: git config --global --list
- Set Username:             git config --global user.name "karamian-ani"
- Set Email:                git config --global user.email "karamian.ani@gmail.com"
- Verify Updated Config:    git config --global --list
Generated Personal Access Token (PAT)
Generated SSH Key
Created a Remote Repository on GitHub   https://github.com/karamian-ani/Homework-GIT.git
Cloning a Repository            git clone https://github.com/username/myrepo.git
Added a Dummy File
- echo "This is a test file" > test.txt
- git add test.txt
- git commit -m "This is my last Git test file."
- git push
Added a New File on GitHub (Remote)     remote_file.txt
Pulling Changes from GitHub             git pull

06.Dec.2025
-----------
Installed Docker Database

09.Dec.2025
-----------
Docker containers code explain
Practice .md, commenting
Down and Up again Docker

13.Dec.2025
-----------
Make a Data Dictionary

16.Dec.2025
-----------
DDL
CRUD
Constrains
SQL Rules

20.Dec.2025
-----------

Query Plan
Refining Your SQL Queries
- SELECT
- ORDER BY
- LIMIT
- GROUP BY
- DISTINCT
- HAVING

---- to find top five customers. 

SELECT
	customer_id,
	COUNT(customer_id) number_of_transaction,
	SUM(total_sales) AS total_revenue
FROM sales
-- WHERE customer_id=660
GROUP BY customer_id
-- ORDER BY SUM(total_sales) DESC
-- ORDER BY SUM(total_sales)
ORDER BY COUNT(customer_id) DESC, SUM(total_sales) DESC
LIMIT 5;


---- to find employees who serve top five customers.
SELECT
	-- DISTINCT
	employee_id

FROM sales
WHERE customer_id IN(

SELECT
	customer_id
FROM sales
GROUP BY customer_id
ORDER BY COUNT(customer_id) DESC, SUM(total_sales) DESC
LIMIT 5

)

Task 1 | Enforce Missing Business Rules with ALTER TABLE
ALTER TABLE employees
ADD CONSTRAINT uq_employees_email UNIQUE (email);
-- ERROR:  could not create unique index "uq_employees_email"
-- Key (email)=(pennybailey@example.org) is duplicated.

ALTER TABLE employees
ALTER COLUMN phone_number SET NOT NULL;
-- ERROR:  column "phone_number" of relation "employees" does not exist 

ALTER TABLE products
ADD CONSTRAINT chk_products_price CHECK (price >= 0);

ALTER TABLE sales
ADD CONSTRAINT chk_sales_total CHECK (total_sales >= 0);


Task 2 | Add a New Analytical Attribute
ALTER TABLE sales
ADD COLUMN sales_channel TEXT;

ALTER TABLE sales
ADD CONSTRAINT chk_sales_channel
CHECK (sales_channel IN ('online', 'store'));

UPDATE sales
SET sales_channel = 'online'
WHERE transaction_id % 2 = 0;

EXPLAIN 
SELECT *
FROM sales


Task 3 | Add Indexes for Query Performance
CREATE INDEX idx_sales_product_id
ON sales (product_id);

CREATE INDEX idx_sales_customer_id
ON sales (customer_id);

CREATE INDEX idx_products_category
ON products (category);


Task 4 | Validate Index Usage with EXPLAIN
EXPLAIN
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id;


Task 5 | Reduce Query Cost by Refining SELECT
-- Original query:
SELECT *
FROM sales;

-- Refined query:
SELECT
  transaction_id,
  product_id,
  total_sales
FROM sales;

why this reduces cost? EXPLAINed it and found that the width for original query is 41 but for refined one is 14.


Task 6 | ORDER BY and LIMIT for Business Questions
SELECT
  product_id,
  SUM(total_sales) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 5;
EXPLAIN ->  Sort  (cost=145.91..146.16 rows=100 width=36)


Task 7 | DISTINCT vs GROUP BY (Efficiency Comparison)
Using DISTINCT:EXPLAIN
SELECT DISTINCT
  category,
  price
FROM products;

Using GROUP BY:EXPLAIN
SELECT
  category,
  price
FROM products
GROUP BY category, price;

Both cost similar.


Task 8 | Constraint Enforcement Test


Task 9 | Reflection (Short Answer)