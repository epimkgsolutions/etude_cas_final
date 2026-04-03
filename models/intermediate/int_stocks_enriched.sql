{{ config(
    materialized='table',
    schema='intermediate'
) }}

WITH stg_stocks AS (
    SELECT * FROM {{ ref('stg_stocks') }}
),

stg_products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

stg_stores AS (
    SELECT * FROM {{ ref('stg_stores') }}
),

enriched AS (
    SELECT
        s.store_id,
        s.product_id,
        s.quantity,
        p.product_name,
        p.brand_id,
        p.category_id,
        p.list_price,
        st.store_name,
        st.city,
        st.state,
        CURRENT_TIMESTAMP() AS dbt_loaded_at
    FROM stg_stocks s
    LEFT JOIN stg_products p ON s.product_id = p.product_id
    LEFT JOIN stg_stores st ON s.store_id = st.store_id
)

SELECT * FROM enriched