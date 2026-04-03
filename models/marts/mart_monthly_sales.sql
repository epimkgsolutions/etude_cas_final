{{ config(materialized='table', schema='marts') }}

SELECT
    DATE_TRUNC(order_date, MONTH)   AS sales_month,
    store_id,
    category_name,
    COUNT(DISTINCT order_id)        AS total_orders,
    SUM(quantity)                   AS total_units,
    ROUND(SUM(net_revenue), 2)      AS total_revenue
FROM {{ ref('int_order_items_enriched') }}
WHERE order_status = 'Completed'
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3
