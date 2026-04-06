{{ config(
    materialized='table',
    schema='marts'
) }}

WITH sales_data AS (
    SELECT
        DATE_TRUNC(fs.order_date, MONTH) AS sales_month,
        fs.store_id,
        dp.category_id,
        dc.category_name,
        COUNT(DISTINCT fs.order_id) AS num_orders,
        SUM(fs.quantity) AS total_quantity,
        ROUND(SUM(fs.net_revenue), 2) AS total_net_revenue,
        ROUND(AVG(fs.discount), 4) AS avg_discount_rate,
        COUNT(DISTINCT fs.customer_id) AS unique_customers
    FROM {{ ref('fact_sales') }} fs
    LEFT JOIN {{ ref('dim_products') }} dp ON fs.product_id = dp.product_id
    LEFT JOIN {{ ref('stg_categories') }} dc ON dp.category_id = dc.category_id
    GROUP BY
        DATE_TRUNC(fs.order_date, MONTH),
        fs.store_id,
        dp.category_id,
        dc.category_name
)

SELECT
    sales_month,
    store_id,
    category_id,
    category_name,
    num_orders,
    total_quantity,
    total_net_revenue,
    avg_discount_rate,
    unique_customers,
    ROUND(total_net_revenue / NULLIF(num_orders, 0), 2) AS avg_order_value,
    CURRENT_TIMESTAMP() AS dbt_loaded_at
FROM sales_data
ORDER BY sales_month DESC, store_id, category_id