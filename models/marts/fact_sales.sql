{{ config(
    materialized='table',
    schema='marts'
) }}

WITH int_order_items AS (
    SELECT * FROM {{ ref('int_order_items_enriched') }}
),

orders_dates AS (
    SELECT
        oi.order_id,
        oi.item_id,
        oi.product_id,
        o.customer_id,
        o.store_id,
        o.staff_id,
        o.order_status,
        CAST(o.order_date AS DATE) AS order_date,
        CAST(o.shipped_date AS DATE) AS shipped_date,
        oi.quantity,
        oi.list_price,
        oi.discount,
        ROUND(oi.quantity * oi.list_price * (1 - oi.discount), 2) AS net_revenue
    FROM int_order_items oi
    LEFT JOIN {{ ref('stg_orders') }} o ON oi.order_id = o.order_id
)

SELECT
    order_id,
    item_id,
    product_id,
    customer_id,
    store_id,
    staff_id,
    order_status,
    order_date,
    shipped_date,
    quantity,
    list_price,
    discount,
    net_revenue,
    CURRENT_TIMESTAMP() AS dbt_loaded_at
FROM orders_dates
WHERE order_status = 4  -- Completed orders only