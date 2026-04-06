{{ config(
    materialized='table',
    schema='marts'
) }}

SELECT
    store_id,
    store_name,
    phone,
    email,
    street,
    city,
    state,
    zip_code,
    CURRENT_TIMESTAMP() AS dbt_loaded_at
FROM {{ ref('stg_stores') }}