-- ============================================================
-- 04_cohort_retention.sql
-- Customer cohort retention analysis
-- Grain: one row per cohort month and activity month
-- ============================================================


-- ============================================================
-- DROP EXISTING VIEW
-- ============================================================

DROP VIEW IF EXISTS vw_cohort_retention;


-- ============================================================
-- COHORT RETENTION
-- Cohort month = customer's first realized purchase month
-- Activity month = month in which customer made a realized order
-- Month offset = months since first purchase
-- ============================================================

CREATE VIEW vw_cohort_retention AS

WITH customer_cohorts AS (

    SELECT
        c.customer_unique_id,

        DATE_FORMAT(
            MIN(o.order_purchase_timestamp),
            '%Y-%m-01'
        ) AS cohort_month

    FROM customers c

    INNER JOIN orders o
        ON c.customer_id = o.customer_id

    WHERE o.is_realized_revenue = 1

    GROUP BY
        c.customer_unique_id

),

customer_activity AS (

    SELECT DISTINCT
        c.customer_unique_id,

        DATE_FORMAT(
            o.order_purchase_timestamp,
            '%Y-%m-01'
        ) AS activity_month

    FROM customers c

    INNER JOIN orders o
        ON c.customer_id = o.customer_id

    WHERE o.is_realized_revenue = 1

),

cohort_activity AS (

    SELECT
        cc.cohort_month,
        ca.activity_month,

        COUNT(DISTINCT ca.customer_unique_id)
            AS customers_active

    FROM customer_cohorts cc

    INNER JOIN customer_activity ca
        ON cc.customer_unique_id = ca.customer_unique_id

    WHERE ca.activity_month >= cc.cohort_month

    GROUP BY
        cc.cohort_month,
        ca.activity_month

)

SELECT
    cohort_month,
    activity_month,

    TIMESTAMPDIFF(
        MONTH,
        cohort_month,
        activity_month
    ) AS month_offset,

    customers_active

FROM cohort_activity;
