{{ config(materialized='view', schema='staging') }}

SELECT
    staff_id,
    first_name,
    last_name,
    email,
    phone,
    CAST(active AS BOOLEAN) AS active,
    store_id,
    CAST(manager_id AS INT64) AS manager_id
FROM {{ source('local_bike', 'staffs') }}