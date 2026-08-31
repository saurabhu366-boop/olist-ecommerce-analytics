-- ============================================================
-- 03_customer_rfm.sql
-- Customer RFM analysis
-- Grain: one row per unique customer
-- ============================================================


-- ============================================================
-- DROP EXISTING VIEWS
-- ============================================================

DROP VIEW IF EXISTS vw_customer_rfm_segments;
DROP VIEW IF EXISTS vw_customer_rfm;


-- ============================================================
-- CUSTOMER RFM
-- Recency  = Days since last realized purchase
-- Frequency = Number of realized orders
-- Monetary = Realized revenue
-- ============================================================

CREATE VIEW vw_customer_rfm AS

WITH analysis_date AS (

    SELECT
        MAX(order_purchase_timestamp) AS latest_purchase_date

    FROM orders

    WHERE is_realized_revenue = 1

),

customer_metrics AS (

    SELECT
        c.customer_unique_id,

        DATEDIFF(
            a.latest_purchase_date,
            MAX(o.order_purchase_timestamp)
        ) AS recency,

        COUNT(DISTINCT o.order_id) AS frequency,

        SUM(oi.price) AS monetary

    FROM customers c

    INNER JOIN orders o
        ON c.customer_id = o.customer_id

    INNER JOIN order_items oi
        ON o.order_id = oi.order_id

    CROSS JOIN analysis_date a

    WHERE o.is_realized_revenue = 1

    GROUP BY
        c.customer_unique_id,
        a.latest_purchase_date

),

rfm_scores AS (

    SELECT
        customer_unique_id,
        recency,
        frequency,
        monetary,

        NTILE(5) OVER (
            ORDER BY recency DESC
        ) AS recency_score,

        NTILE(5) OVER (
            ORDER BY frequency
        ) AS frequency_score,

        NTILE(5) OVER (
            ORDER BY monetary
        ) AS monetary_score

    FROM customer_metrics

)

SELECT
    customer_unique_id,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,

    CONCAT(
        recency_score,
        frequency_score,
        monetary_score
    ) AS rfm_score

FROM rfm_scores;


-- ============================================================
-- RFM CUSTOMER SEGMENTS
-- ============================================================

CREATE VIEW vw_customer_rfm_segments AS

SELECT
    customer_unique_id,
    recency,
    frequency,
    monetary,
    recency_score,
    frequency_score,
    monetary_score,
    rfm_score,

    CASE

        WHEN recency_score >= 4
         AND frequency_score >= 4
         AND monetary_score >= 4
            THEN 'Champions'

        WHEN recency_score >= 3
         AND frequency_score >= 4
            THEN 'Loyal Customers'

        WHEN recency_score >= 4
         AND frequency_score <= 2
            THEN 'New / Promising'

        WHEN recency_score <= 2
         AND frequency_score >= 3
            THEN 'At Risk'

        WHEN recency_score <= 2
         AND monetary_score >= 3
            THEN 'Cannot Lose Them'

        ELSE 'Other'

    END AS rfm_segment

FROM vw_customer_rfm;
