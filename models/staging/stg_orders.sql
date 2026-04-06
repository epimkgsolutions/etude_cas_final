{{ config(materialized='view', schema='staging') }}

SELECT
    order_id,
    customer_id,
    CASE 
        WHEN order_status = 1 THEN 'Pending'
        WHEN order_status = 2 THEN 'Processing'
        WHEN order_status = 3 THEN 'Rejected'
        WHEN order_status = 4 THEN 'Completed'
    END AS order_status,
    order_date,
    required_date,
    shipped_date,
    store_id,
    staff_id
FROM {{ source('local_bike', 'orders') }}