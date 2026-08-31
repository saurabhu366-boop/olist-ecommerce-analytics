-- ============================================================
-- 02_analytical_views.sql
-- Core analytical views for Power BI
-- ============================================================


-- ============================================================
-- DROP EXISTING VIEWS
-- ============================================================

DROP VIEW IF EXISTS vw_customer_geo_distribution;
DROP VIEW IF EXISTS vw_customer_repeat_purchase_summary;
DROP VIEW IF EXISTS vw_customer_first_purchase;
DROP VIEW IF EXISTS vw_dim_customer;
DROP VIEW IF EXISTS vw_order_reviews_latest;
DROP VIEW IF EXISTS vw_seller_performance;
DROP VIEW IF EXISTS vw_category_performance;
DROP VIEW IF EXISTS vw_monthly_sales_trend;
DROP VIEW IF EXISTS vw_order_summary;
DROP VIEW IF EXISTS vw_sales_summary;


-- ============================================================
-- 1. SALES SUMMARY
-- Grain: one row per order item
-- ============================================================

CREATE VIEW vw_sales_summary AS
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,

    o.customer_id,
    o.order_purchase_timestamp,
    o.order_status,
    o.business_status,
    o.is_realized_revenue,

    p.product_category_name,
    p.product_category_name_english,

    oi.price,
    oi.freight_value,

    CASE
        WHEN o.is_realized_revenue = 1
        THEN oi.price
        ELSE 0
    END AS realized_revenue,

    CASE
        WHEN o.is_realized_revenue = 1
        THEN 1
        ELSE 0
    END AS realized_item_count,

    oi.price AS gross_item_value

FROM order_items oi

INNER JOIN orders o
    ON oi.order_id = o.order_id

LEFT JOIN products p
    ON oi.product_id = p.product_id;


-- ============================================================
-- 2. ORDER SUMMARY
-- Grain: one row per order
-- ============================================================

CREATE VIEW vw_order_summary AS
SELECT
    o.*,

    CASE
        WHEN o.order_delivered_customer_date IS NOT NULL
         AND o.order_estimated_delivery_date IS NOT NULL
        THEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        )
        ELSE NULL
    END AS delivery_delay_days,

    CASE
        WHEN o.order_purchase_timestamp IS NOT NULL
         AND o.order_delivered_customer_date IS NOT NULL
        THEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_purchase_timestamp
        )
        ELSE NULL
    END AS delivery_days

FROM orders o;


-- ============================================================
-- 3. MONTHLY SALES TREND
-- Grain: one row per month
-- ============================================================

CREATE VIEW vw_monthly_sales_trend AS
SELECT
    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m-01'
    ) AS month_start,

    YEAR(o.order_purchase_timestamp) AS order_year,

    MONTH(o.order_purchase_timestamp) AS order_month,

    COUNT(DISTINCT CASE
        WHEN o.is_realized_revenue = 1
        THEN o.order_id
    END) AS realized_orders,

    SUM(
        CASE
            WHEN o.is_realized_revenue = 1
            THEN oi.price
            ELSE 0
        END
    ) AS total_revenue,

    SUM(
        CASE
            WHEN o.is_realized_revenue = 1
            THEN 1
            ELSE 0
        END
    ) AS delivered_items,

    AVG(
        CASE
            WHEN o.is_realized_revenue = 1
            THEN oi.price
        END
    ) AS average_item_price

FROM orders o

INNER JOIN order_items oi
    ON o.order_id = oi.order_id

GROUP BY
    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m-01'
    ),
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp);


-- ============================================================
-- 4. CATEGORY PERFORMANCE
-- Grain: one row per category
-- ============================================================

CREATE VIEW vw_category_performance AS
SELECT
    COALESCE(
        product_category_name_english,
        'Unknown'
    ) AS category,

    SUM(realized_revenue) AS total_revenue,

    SUM(realized_item_count) AS delivered_items,

    AVG(
        CASE
            WHEN is_realized_revenue = 1
            THEN price
        END
    ) AS average_item_price

FROM vw_sales_summary

GROUP BY
    COALESCE(
        product_category_name_english,
        'Unknown'
    );


-- ============================================================
-- 5. SELLER PERFORMANCE
-- Grain: one row per seller
-- ============================================================

CREATE VIEW vw_seller_performance AS
SELECT
    seller_id,

    SUM(realized_revenue) AS realized_revenue,

    SUM(realized_item_count) AS realized_item_count,

    COUNT(DISTINCT CASE
        WHEN is_realized_revenue = 1
        THEN order_id
    END) AS realized_orders

FROM vw_sales_summary

GROUP BY seller_id;


-- ============================================================
-- 6. LATEST REVIEW PER ORDER
-- Grain: one row per order
-- ============================================================

CREATE VIEW vw_order_reviews_latest AS
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp

FROM (
    SELECT
        r.*,

        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY
                review_creation_date DESC,
                review_id DESC
        ) AS rn

    FROM order_reviews r
) x

WHERE rn = 1;


-- ============================================================
-- 7. CUSTOMER DIMENSION
-- Grain: one row per customer record
-- ============================================================

CREATE VIEW vw_dim_customer AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state

FROM customers;


-- ============================================================
-- 8. CUSTOMER FIRST PURCHASE
-- Grain: one row per unique customer
-- ============================================================

CREATE VIEW vw_customer_first_purchase AS
SELECT
    c.customer_unique_id,

    MIN(o.order_purchase_timestamp)
        AS first_purchase_timestamp

FROM customers c

INNER JOIN orders o
    ON c.customer_id = o.customer_id

WHERE o.is_realized_revenue = 1

GROUP BY
    c.customer_unique_id;


-- ============================================================
-- 9. CUSTOMER REPEAT PURCHASE SUMMARY
-- Grain: one row per unique customer
-- ============================================================

CREATE VIEW vw_customer_repeat_purchase_summary AS
SELECT
    c.customer_unique_id,

    COUNT(DISTINCT o.order_id)
        AS realized_order_count,

    CASE
        WHEN COUNT(DISTINCT o.order_id) > 1
        THEN 1
        ELSE 0
    END AS is_repeat_customer

FROM customers c

INNER JOIN orders o
    ON c.customer_id = o.customer_id

WHERE o.is_realized_revenue = 1

GROUP BY
    c.customer_unique_id;


-- ============================================================
-- 10. CUSTOMER GEO DISTRIBUTION
-- Grain: one row per state
-- ============================================================

CREATE VIEW vw_customer_geo_distribution AS
SELECT
    COALESCE(
        g.geolocation_state,
        'Unknown / Unmapped'
    ) AS state,

    COUNT(DISTINCT c.customer_unique_id)
        AS customers,

    COUNT(DISTINCT s.order_id)
        AS realized_orders,

    SUM(s.realized_revenue)
        AS total_revenue

FROM vw_sales_summary s

INNER JOIN customers c
    ON s.customer_id = c.customer_id

LEFT JOIN dim_geolocation g
    ON c.customer_zip_code_prefix =
       g.geolocation_zip_code_prefix

WHERE s.is_realized_revenue = 1

GROUP BY
    COALESCE(
        g.geolocation_state,
        'Unknown / Unmapped'
    );
