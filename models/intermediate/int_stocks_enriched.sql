{{ config(
    materialized='table',
    schema='intermediate'
) }}

WITH stg_stocks AS (
    SELECT * FROM {{ ref('stg_stocks') }}
),

stg_products AS (
    SELECT * FROM {{ ref('stg_products') }}
)

SELECT
    s.store_id,
    s.product_id,
    CAST(s.stock_quantity AS INT64) AS quantity,
    p.product_name,
    p.brand_id,
    p.category_id,
    p.list_price,
    CURRENT_TIMESTAMP() AS dbt_loaded_at
FROM stg_stocks s
LEFT JOIN stg_products p ON s.product_id = p.product_id