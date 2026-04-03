{{ config(materialized='view', schema='staging') }}

SELECT
    brand_id,
    brand_name
FROM {{ source('local_bike', 'brands') }}