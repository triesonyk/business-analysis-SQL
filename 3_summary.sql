-- 1

WITH 
	revenue AS 
		(
			SELECT
				date_part('year', o.order_purchase_timestamp) AS purchase_year,
				SUM(oi.price + oi.freight_value) AS revenue,
				COUNT(DISTINCT o.order_id) AS transactions
			FROM
				orders o
					JOIN
				order_items oi ON o.order_id = oi.order_id
			WHERE
				o.order_status = 'delivered'
			GROUP BY
				1
			ORDER BY
				1	
		),

-- 2

	canceled AS
		(
			SELECT
				date_part('year', order_purchase_timestamp) AS purchase_year,
				COUNT(order_id) AS total_cancelled
			FROM
				orders
			WHERE
				order_status = 'canceled'
			GROUP BY
				1
			ORDER BY
				1		
		),

-- 3

	most_rev AS 
		(
			SELECT
				*
			FROM
				(
					SELECT
						*,
						RANK() OVER (PARTITION BY purchase_year ORDER BY revenue DESC) AS rank_rev
					FROM 
						(
							SELECT 
								date_part('year', o.order_purchase_timestamp) AS purchase_year,
								pr.product_category_name AS category,
								SUM(oi.price + oi.freight_value) AS revenue
							FROM
								orders o
									JOIN
								order_items oi ON o.order_id = oi.order_id
									JOIN
								product pr ON oi.product_id = pr.product_id
							WHERE
								o.order_status = 'delivered'
							GROUP BY
								1,2
							ORDER BY 
								1,3
						) AS category_revenue 
				) AS most_rev
			WHERE
				rank_rev = 1		
		),

-- 4
	most_canceled AS
		(
			SELECT
				*
			FROM
				(
					SELECT
						*,
						RANK() OVER (PARTITION BY purchase_year ORDER BY total_canceled DESC) AS rank_canceled
					FROM 
						(
							SELECT 
								date_part('year', o.order_purchase_timestamp) AS purchase_year,
								pr.product_category_name,
								COUNT(*) AS total_canceled
							FROM 
								orders o 
									JOIN
								order_items oi ON o.order_id = oi.order_id
									JOIN
								product pr ON oi.product_id = pr.product_id
							WHERE
								order_status = 'canceled'
							GROUP BY
								1,2
							ORDER BY
								1, 3 DESC
						) AS category_canceled
				) AS most_canceled
			WHERE
				rank_canceled = 1			
		)

SELECT 
	r.purchase_year AS year_,
	r.revenue,
	cl.total_cancelled,
	mr.category AS most_rev,
	mc.product_category_name AS most_canceled
FROM
	revenue r
		JOIN
	canceled cl ON r.purchase_year = cl.purchase_year
		JOIN
	most_rev mr ON cl.purchase_year = mr.purchase_year
		JOIN
	most_canceled mc ON mr.purchase_year = mc.purchase_year
