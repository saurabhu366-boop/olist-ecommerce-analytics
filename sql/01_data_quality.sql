-- ============================================================
-- 01_data_quality.sql
-- Raw data profiling and quality checks
-- ============================================================


-- ============================================================
-- 1. RAW TABLE ROW COUNTS
-- ============================================================

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM raw_customers

UNION ALL

SELECT 'geolocation', COUNT(*)
FROM raw_geolocation

UNION ALL

SELECT 'order_items', COUNT(*)
FROM raw_order_items

UNION ALL

SELECT 'order_payments', COUNT(*)
FROM raw_order_payments

UNION ALL

SELECT 'order_reviews', COUNT(*)
FROM raw_order_reviews

UNION ALL

SELECT 'orders', COUNT(*)
FROM raw_orders

UNION ALL

SELECT 'products', COUNT(*)
FROM raw_products

UNION ALL

SELECT 'sellers', COUNT(*)
FROM raw_sellers

UNION ALL

SELECT 'product_category_translation', COUNT(*)
FROM raw_product_category_translation;


-- ============================================================
-- 2. ORDERS: NULL / MISSING DATE CHECKS
-- ============================================================

SELECT
    COUNT(*) AS total_orders,
    SUM(order_approved_at IS NULL) AS null_approved,
    SUM(order_delivered_carrier_date IS NULL) AS null_carrier,
    SUM(order_delivered_customer_date IS NULL) AS null_customer,
    SUM(order_estimated_delivery_date IS NULL) AS null_estimated
FROM orders;


-- ============================================================
-- 3. ORDER ITEMS: COMPLETENESS & COVERAGE
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(DISTINCT product_id) AS distinct_products,
    COUNT(DISTINCT seller_id) AS distinct_sellers,
    SUM(price IS NULL) AS null_price,
    SUM(freight_value IS NULL) AS null_freight
FROM order_items;


-- ============================================================
-- 4. REVIEWS: SCORE VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_reviews,
    SUM(review_score IS NULL) AS null_scores,
    SUM(review_score < 1 OR review_score > 5) AS invalid_scores
FROM order_reviews;


-- ============================================================
-- 5. PRODUCTS: ATTRIBUTE COMPLETENESS
-- ============================================================

SELECT
    COUNT(*) AS total_products,
    SUM(product_category_name IS NULL) AS null_category,
    SUM(product_weight_g IS NULL) AS null_weight,
    SUM(product_length_cm IS NULL) AS null_length,
    SUM(product_height_cm IS NULL) AS null_height,
    SUM(product_width_cm IS NULL) AS null_width
FROM products;


-- ============================================================
-- 6. RAW VS CLEANED RECORD COUNTS
-- ============================================================

SELECT
    'customers' AS table_name,
    (SELECT COUNT(*) FROM raw_customers) AS raw_count,
    (SELECT COUNT(*) FROM customers) AS clean_count

UNION ALL

SELECT
    'sellers',
    (SELECT COUNT(*) FROM raw_sellers),
    (SELECT COUNT(*) FROM sellers)

UNION ALL

SELECT
    'products',
    (SELECT COUNT(*) FROM raw_products),
    (SELECT COUNT(*) FROM products)

UNION ALL

SELECT
    'orders',
    (SELECT COUNT(*) FROM raw_orders),
    (SELECT COUNT(*) FROM orders)

UNION ALL

SELECT
    'order_items',
    (SELECT COUNT(*) FROM raw_order_items),
    (SELECT COUNT(*) FROM order_items)

UNION ALL

SELECT
    'order_payments',
    (SELECT COUNT(*) FROM raw_order_payments),
    (SELECT COUNT(*) FROM order_payments)

UNION ALL

SELECT
    'order_reviews',
    (SELECT COUNT(*) FROM raw_order_reviews),
    (SELECT COUNT(*) FROM order_reviews)

UNION ALL

SELECT
    'product_category_translation',
    (SELECT COUNT(*) FROM raw_product_category_translation),
    (SELECT COUNT(*) FROM product_category_translation);
