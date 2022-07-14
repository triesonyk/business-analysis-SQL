-- 1

SELECT 
	payment_type,
	COUNT(*) AS total_used
FROM
	order_payments op
		JOIN
	orders o ON op.order_id = o.order_id
GROUP BY
	1
ORDER BY
	2 DESC;
	
-- 2

SELECT
	date_part('year', o.order_purchase_timestamp) AS purchase_year,
	op.payment_type,
	COUNT(*) AS transactions
FROM
	orders o
		JOIN
	order_payments op ON o.order_id = op.order_id
GROUP BY 
	1,2
ORDER BY
	1, 3 DESC;
	
SELECT
	date_part('year', o.order_purchase_timestamp) AS purchase_year,
	SUM(CASE WHEN (op.payment_type='credit_card') THEN 1 ELSE 0 END) AS credit_card,
	SUM(CASE WHEN (op.payment_type='boleto') THEN 1 ELSE 0 END) AS boleto,
	SUM(CASE WHEN (op.payment_type='voucher') THEN 1 ELSE 0 END) AS voucher,
	SUM(CASE WHEN (op.payment_type='debit_card') THEN 1 ELSE 0 END) AS debit_card,
	SUM(CASE WHEN (op.payment_type='not_defined') THEN 1 ELSE 0 END) AS not_defined
FROM 
	orders o
		JOIN
	order_payments op ON o.order_id = op.order_id
GROUP BY
	1
ORDER BY
	1;
	