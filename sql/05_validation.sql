-- ============================================================
-- 05_validation.sql
-- Final analytical validation and reconciliation checks
-- ============================================================


-- ============================================================
-- 1. CORE BUSINESS TOTALS
-- ============================================================
-- Validates realized revenue and realized order/item totals.

SELECT
    COUNT(DISTINCT CASE
        WHEN is_realized_revenue = 1
        THEN order_id
    END) AS delivered_orders,

    SUM(realized_item_count) AS delivered_items,

    SUM(realized_revenue) AS realized_revenue,

    SUM(gross_item_value) AS gross_booked_item_sales

FROM vw_sales_summary;


-- ============================================================
-- 2. DELIVERY PERFORMANCE
-- ============================================================
-- Validates average delivery time and late-order volume.

SELECT
    COUNT(*) AS delivered_orders,

    ROUND(
        AVG(delivery_days),
        2
    ) AS average_delivery_days,

    SUM(
        CASE
            WHEN delivery_delay_days > 0
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN delivery_delay_days > 0
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS late_delivery_rate_pct

FROM vw_order_summary

WHERE is_realized_revenue = 1
  AND order_delivered_customer_date IS NOT NULL;


-- ============================================================
-- 3. CUSTOMER TOTALS
-- ============================================================
-- Customer records vs unique customers.

SELECT
    COUNT(*) AS customer_records,

    COUNT(DISTINCT customer_unique_id)
        AS unique_customers

FROM vw_dim_customer;


-- ============================================================
-- 4. REALIZED CUSTOMER & REPEAT PURCHASE SUMMARY
-- ============================================================

SELECT
    COUNT(*) AS realized_customers,

    SUM(
        CASE
            WHEN is_repeat_customer = 0
            THEN 1
            ELSE 0
        END
    ) AS one_time_customers,

    SUM(
        CASE
            WHEN is_repeat_customer = 1
            THEN 1
            ELSE 0
        END
    ) AS repeat_customers,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN is_repeat_customer = 1
                THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate_pct

FROM vw_customer_repeat_purchase_summary;


-- ============================================================
-- 5. MONTHLY REVENUE RECONCILIATION
-- ============================================================

SELECT
    SUM(total_revenue)
        AS monthly_total_revenue,

    SUM(delivered_items)
        AS monthly_total_items

FROM vw_monthly_sales_trend;


-- ============================================================
-- 6. CATEGORY RECONCILIATION
-- ============================================================

SELECT
    SUM(total_revenue)
        AS category_total_revenue,

    SUM(delivered_items)
        AS category_total_items

FROM vw_category_performance;


-- ============================================================
-- 7. SELLER RECONCILIATION
-- ============================================================

SELECT
    SUM(realized_revenue)
        AS seller_total_revenue,

    SUM(realized_item_count)
        AS seller_total_items,

    SUM(realized_orders)
        AS seller_order_counts

FROM vw_seller_performance;


-- ============================================================
-- 8. REVIEW VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS review_count,

    ROUND(
        AVG(review_score),
        2
    ) AS average_review_score,

    SUM(
        CASE WHEN review_score = 1 THEN 1 ELSE 0 END
    ) AS score_1,

    SUM(
        CASE WHEN review_score = 2 THEN 1 ELSE 0 END
    ) AS score_2,

    SUM(
        CASE WHEN review_score = 3 THEN 1 ELSE 0 END
    ) AS score_3,

    SUM(
        CASE WHEN review_score = 4 THEN 1 ELSE 0 END
    ) AS score_4,

    SUM(
        CASE WHEN review_score = 5 THEN 1 ELSE 0 END
    ) AS score_5

FROM vw_order_reviews_latest;


-- ============================================================
-- 9. GEOGRAPHIC RECONCILIATION
-- ============================================================

SELECT
    SUM(total_revenue)
        AS geo_total_revenue,

    SUM(realized_orders)
        AS geo_total_orders

FROM vw_customer_geo_distribution;


-- ============================================================
-- 10. FINAL BASELINE VALIDATION
-- ============================================================
-- Compare the analytical model against the known project baseline.

SELECT
    13221498.11 AS expected_realized_revenue,

    (
        SELECT SUM(realized_revenue)
        FROM vw_sales_summary
    ) AS actual_realized_revenue,

    96478 AS expected_delivered_orders,

    (
        SELECT COUNT(DISTINCT order_id)
        FROM vw_sales_summary
        WHERE is_realized_revenue = 1
    ) AS actual_delivered_orders;
