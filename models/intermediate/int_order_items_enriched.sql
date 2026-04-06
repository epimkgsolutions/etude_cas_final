{{ config(
    materialized='table',
    schema='intermediate'
) }}

WITH stg_order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),

stg_products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

enriched AS (
    SELECT
        oi.order_id,
        oi.item_id,
        oi.product_id,
        oi.quantity,
        oi.list_price,
        oi.discount,
        ROUND(oi.quantity * oi.list_price * (1 - oi.discount), 2) AS net_revenue,
        p.product_name,
        p.brand_id,
        p.category_id,
        p.model_year,
        CURRENT_TIMESTAMP() AS dbt_loaded_at
    FROM stg_order_items oi
    LEFT JOIN stg_products p ON oi.product_id = p.product_id
)

SELECT * FROM enriched