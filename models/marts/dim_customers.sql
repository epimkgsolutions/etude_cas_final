{{ config(
    materialized='table',
    schema='marts'
) }}

WITH stg_customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

order_metrics AS (
    SELECT
        o.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS lifetime_revenue,
        MAX(o.order_date) AS last_order_date,
        DATE_DIFF(CURRENT_DATE(), CAST(MAX(o.order_date) AS DATE), DAY) AS days_since_last_order
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_order_items') }} oi ON o.order_id = oi.order_id
    GROUP BY o.customer_id
),

customer_segments AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.phone,
        c.street,
        c.city,
        c.state,
        c.zip_code,
        COALESCE(om.total_orders, 0) AS total_orders,
        COALESCE(om.lifetime_revenue, 0) AS lifetime_revenue,
        COALESCE(om.last_order_date, NULL) AS last_order_date,
        COALESCE(om.days_since_last_order, 999) AS days_since_last_order,
        CASE
            WHEN COALESCE(om.total_orders, 0) >= 5 THEN 'Loyal'
            WHEN COALESCE(om.total_orders, 0) >= 2 THEN 'Regular'
            ELSE 'One-Time'
        END AS customer_segment,
        CASE
            WHEN COALESCE(om.days_since_last_order, 999) < 30 THEN 'Active'
            WHEN COALESCE(om.days_since_last_order, 999) < 90 THEN 'At Risk'
            ELSE 'Churned'
        END AS recency_segment,
        CURRENT_TIMESTAMP() AS dbt_loaded_at
    FROM stg_customers c
    LEFT JOIN order_metrics om ON c.customer_id = om.customer_id
)

SELECT * FROM customer_segments