{{ config(materialized='view', schema='staging') }}

SELECT
    product_id,
    product_name,
    brand_id,
    category_id,
    model_year,
    CAST(list_price AS NUMERIC) AS list_price
FROM {{ source('local_bike', 'products') }}