-- First, join customers and orders table as customer_order table, this table will be used for all query

WITH
	customer_order AS (
		SELECT 
			c.customer_unique_id,
			date_part('year', o.order_purchase_timestamp) AS purchase_year,
			date_part('month', o.order_purchase_timestamp) AS purchase_month,
			o.order_id
		FROM
			customers c 
				JOIN
			orders o ON c.customer_id = o.customer_id
		ORDER BY 2, 3
	),
	
-- Average Monthly Active Users per Year	

	mau_year AS (
		SELECT
			purchase_year,
			ROUND(AVG(total_customer),2) AS mau
		FROM
			(
				SELECT
					purchase_year,
					purchase_month,
					COUNT(DISTINCT customer_unique_id) AS total_customer
				FROM 
					customer_order
				GROUP BY
					1, 2
			) AS active_customer
		GROUP BY 
			1
	),

-- New Customer per Year

	new_cust_year AS (
		SELECT
			purchase_year,
			COUNT(customer_unique_id) AS total_new_customer
		FROM
			(
				SELECT
					customer_unique_id,
					MIN(purchase_year) AS purchase_year
				FROM
					customer_order
				GROUP BY
					1
			) AS first_purchase
		GROUP BY 
			1
		ORDER BY
			1	
	),

-- Repeat Customer per Year

	repeat_cust_year AS (
		SELECT
			purchase_year,
			COUNT(customer_unique_id) AS repeat_customer
		FROM
			(
				SELECT
					customer_unique_id,
					purchase_year,
					COUNT(*) AS total_order
				FROM
					customer_order
				GROUP BY 1,2
				ORDER BY 3 DESC
			) AS repeat_order
		WHERE
			total_order > 1
		GROUP BY
			1
		ORDER BY
			1 DESC
	),
	
-- Average Number of Transactions per Customer per Year
	
	avg_trans_cust_year AS (
		SELECT
			purchase_year,
			ROUND(AVG(total_order),4) AS average_transactions	
		FROM
			(
				SELECT
					customer_unique_id,
					purchase_year,
					COUNT(*) AS total_order
				FROM
					customer_order
				GROUP BY 1,2
				ORDER BY 3 DESC
			) AS repeat_order
		GROUP BY 
			1
		ORDER BY 
			1 DESC
	)

SELECT 
	my.purchase_year,
	my.mau,
	ncy.total_new_customer,
	rcy.repeat_customer,
	atcy.average_transactions
	
FROM
	mau_year my
		JOIN
	new_cust_year ncy ON my.purchase_year = ncy.purchase_year
		JOIN
	repeat_cust_year rcy ON ncy.purchase_year = rcy.purchase_year
		JOIN
	avg_trans_cust_year atcy ON rcy.purchase_year = atcy.purchase_year