{{ config(materialized='view', schema='staging') }}

SELECT
    category_id,
    category_name
FROM {{ source('local_bike', 'categories') }}