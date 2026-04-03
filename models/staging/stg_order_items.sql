{{ config(materialized='view', schema='staging') }}

SELECT
    order_id,
    item_id,
    product_id,
    quantity,
    CAST(list_price AS NUMERIC) AS list_price,
    CAST(discount AS NUMERIC) AS discount
FROM {{ source('local_bike', 'order_items') }}