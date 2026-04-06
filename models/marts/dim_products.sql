{{ config(
    materialized='table',
    schema='marts'
) }}

WITH stg_products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

stg_brands AS (
    SELECT * FROM {{ ref('stg_brands') }}
),

stg_categories AS (
    SELECT * FROM {{ ref('stg_categories') }}
),

enriched AS (
    SELECT
        p.product_id,
        p.product_name,
        b.brand_id,
        b.brand_name,
        c.category_id,
        c.category_name,
        p.model_year,
        p.list_price,
        CASE
            WHEN p.list_price < 500 THEN 'Budget'
            WHEN p.list_price < 1500 THEN 'Mid-Range'
            WHEN p.list_price < 3000 THEN 'Premium'
            ELSE 'Ultra-Premium'
        END AS price_segment,
        CURRENT_TIMESTAMP() AS dbt_loaded_at
    FROM stg_products p
    LEFT JOIN stg_brands b ON p.brand_id = b.brand_id
    LEFT JOIN stg_categories c ON p.category_id = c.category_id
)

SELECT * FROM enriched