{{ config(materialized='view', schema='staging') }}

SELECT
    store_id,
    store_name,
    phone,
    email,
    street,
    city,
    state,
    CAST(zip_code AS STRING) AS zip_code
FROM {{ source('local_bike', 'stores') }}