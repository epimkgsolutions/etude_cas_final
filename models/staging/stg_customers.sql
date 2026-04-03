{{ config(materialized='view', schema='staging') }}

SELECT
    customer_id,
    first_name,
    last_name,
    CONCAT(first_name, ' ', last_name) AS full_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code
FROM {{ source('local_bike', 'customers') }}