CREATE TABLE public.customers
(
    customer_id VARCHAR,
    customer_unique_id VARCHAR,
    customer_zip_code_prefix INT,
    customer_city VARCHAR,
    customer_state VARCHAR
);

ALTER TABLE customers 
ADD PRIMARY KEY (customer_id);

COPY customers
(
	customer_id, 
	customer_unique_id, 
	customer_zip_code_prefix, 
	customer_city, 
	customer_state
)

FROM 'D:\10._DATA_SCIENCE\Rakamin\JGP\Mini Project\1\Dataset\customers_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.geolocation
(
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL,
    geolocation_lng DECIMAL,
	geolocation_city VARCHAR,
    geolocation_state VARCHAR
);

COPY geolocation
(
	geolocation_zip_code_prefix, 
	geolocation_lat,
	geolocation_lng,
	geolocation_city,
	geolocation_state
)
FROM 'D:\10._DATA_SCIENCE\Rakamin\JGP\Mini Project\1\Dataset\geolocation_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.order_items
(
    order_id VARCHAR,
    order_item_id SMALLINT,
    product_id VARCHAR,
	seller_id VARCHAR,
    shipping_limit_date TIMESTAMP WITHOUT TIME ZONE,
	price NUMERIC,
	freight_value NUMERIC
);

COPY order_items
(
	order_id,
	order_item_id,
	product_id,
	seller_id,
	shipping_limit_date,
	price,
	freight_value
)
FROM 'D:\10._DATA_SCIENCE\Rakamin\JGP\Mini Project\1\Dataset\order_items_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.order_payments
(
    order_id VARCHAR,
    payment_sequential SMALLINT,
    payment_type VARCHAR,
	payment_installments SMALLINT,
    payment_value NUMERIC
);

COPY order_payments
(
	order_id,
	payment_sequential,
	payment_type,
	payment_installments,
	payment_value
)
FROM 'D:\10._DATA_SCIENCE\Rakamin\JGP\Mini Project\1\Dataset\order_payments_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.order_reviews
(
    review_id VARCHAR,
    order_id VARCHAR,
    review_score SMALLINT,
	review_comment_title VARCHAR,
    review_comment_message VARCHAR,
	review_creation_date TIMESTAMP WITHOUT TIME ZONE,
	review_answer_timestamp TIMESTAMP WITHOUT TIME ZONE
);

COPY order_reviews
(
	review_id,
	order_id,
	review_score,
	review_comment_title,
	review_comment_message,
	review_creation_date,
	review_answer_timestamp
)
FROM 'D:\10._DATA_SCIENCE\Rakamin\JGP\Mini Project\1\Dataset\order_reviews_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.orders
(
    order_id VARCHAR,
    customer_id VARCHAR,
    order_status VARCHAR,
	order_purchase_timestamp TIMESTAMP WITHOUT TIME ZONE,
    order_approved_at TIMESTAMP WITHOUT TIME ZONE,
	order_delivered_carrier_date TIMESTAMP WITHOUT TIME ZONE,
	order_delivered_customer_date TIMESTAMP WITHOUT TIME ZONE,
	order_estimated_delivery_date TIMESTAMP WITHOUT TIME ZONE
);

ALTER TABLE orders 
ADD PRIMARY KEY (order_id);

COPY orders
(
	order_id, 
	customer_id, 
	order_status, 
	order_purchase_timestamp, 
	order_approved_at, 
	order_delivered_carrier_date, 
	order_delivered_customer_date, 
	order_estimated_delivery_date
)
FROM 'D:\10._DATA_SCIENCE\Rakamin\JGP\Mini Project\1\Dataset\orders_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.product
(
    inc_num int,
    product_id VARCHAR,
    product_category_name VARCHAR,
	product_name_lenght NUMERIC,
    product_description_lenght NUMERIC,
	product_photos_qty NUMERIC,
	product_weight_g NUMERIC,
	product_length_cm NUMERIC,
	product_height_cm NUMERIC,
	product_width_cm NUMERIC
);

ALTER TABLE product
ADD PRIMARY KEY (product_id);

COPY product
(
	inc_num,
	product_id,
	product_category_name,
	product_name_lenght,
	product_description_lenght,
	product_photos_qty,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
FROM 'D:\10._DATA_SCIENCE\Rakamin\JGP\Mini Project\1\Dataset\product_dataset.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE public.sellers
(
    seller_id VARCHAR,
    seller_zip_code_prefix INT,
    seller_city VARCHAR,
	seller_state VARCHAR
);

ALTER TABLE sellers 
ADD PRIMARY KEY (seller_id);

COPY sellers
(
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
FROM 'D:\10._DATA_SCIENCE\Rakamin\JGP\Mini Project\1\Dataset\sellers_dataset.csv'
DELIMITER ','
CSV HEADER;

ALTER TABLE order_items
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id),
ADD FOREIGN KEY (product_id) REFERENCES product(product_id),
ADD FOREIGN KEY (seller_id) REFERENCES sellers(seller_id);

ALTER TABLE order_payments
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE order_reviews
ADD FOREIGN KEY (order_id) REFERENCES orders(order_id);

ALTER TABLE orders
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);