{{ config(materialized='view', schema='staging') }}

SELECT
    store_id,
    product_id,
    quantity AS stock_quantity
FROM {{ source('local_bike', 'stocks') }}