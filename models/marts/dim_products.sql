{{ config(materialized='table', schema='marts') }}

WITH products AS (
    SELECT * FROM {{ ref('stg_products') }}
),

brands AS (
    SELECT * FROM {{ ref('stg_brands') }}
),

categories AS (
    SELECT * FROM {{ ref('stg_categories') }}
)

SELECT
    p.product_id,
    p.product_name,
    p.brand_id,
    b.brand_name,
    p.category_id,
    c.category_name,
    p.model_year,
    p.list_price,
    CASE
        WHEN p.list_price < 500  THEN 'Budget'
        WHEN p.list_price < 1500 THEN 'Mid-Range'
        WHEN p.list_price < 3000 THEN 'Premium'
        ELSE 'Ultra-Premium'
    END AS price_segment
FROM products p
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
