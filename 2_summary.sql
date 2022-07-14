-- Average Monthly Active Users per Year

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
	
	active_customer AS(
		SELECT
			purchase_year,
			purchase_month,
			COUNT(DISTINCT customer_unique_id) AS total_customer
		FROM 
			customer_order
		GROUP BY 1,2
	),
	
	first_purchase AS (
		SELECT 
			customer_unique_id,
			MIN(purchase_year) AS purchase_year
		FROM 
			customer_order
		GROUP BY customer_unique_id
	),
	
	repeat_order AS(
		SELECT
			customer_unique_id,
			purchase_year,
			COUNT(*) AS total_order
		FROM
			customer_order
		GROUP BY 1,2
		ORDER BY 3 DESC
	),
	
	mau_year AS (
		SELECT 
			purchase_year,
			AVG(total_customer) AS mau
		FROM 
			active_customer
		GROUP BY 1
	),
	
	new_cust_year AS (
		SELECT
			purchase_year,
			COUNT(customer_unique_id) AS total_new_customer
		FROM
			first_purchase
		GROUP BY 1
		ORDER BY 1
	),
	
	repeat_cust_year AS (
		SELECT
			purchase_year,
			COUNT(customer_unique_id) AS repeat_customer
		FROM
			repeat_order
		WHERE total_order > 1
		GROUP BY 1
		ORDER BY 1 DESC
	),
	
	avg_trans_cust_year AS (
		SELECT
			purchase_year,
			AVG(total_order) AS average_transactions
		FROM
			repeat_order
		GROUP BY 1
		ORDER BY 1 DESC
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
	avg_trans_cust_year atcy ON rcy.purchase_year = atcy.purchase_year;
