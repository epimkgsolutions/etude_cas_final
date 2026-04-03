{{ config(
    materialized='table',
    schema='marts'
) }}

WITH stores AS (
    SELECT * FROM {{ ref('stg_stores') }}
),

enriched AS (
    SELECT
        store_id,
        store_name,
        city,
        state,
        zip_code,
        
        -- Catégories de magasin basées sur la localisation
        CASE
            WHEN state = 'CA' THEN 'West Coast'
            WHEN state = 'NY' THEN 'Northeast'
            WHEN state = 'TX' THEN 'South'
        END AS region,
        
        -- Phone et email (non clés, mais utiles pour contact)
        phone,
        email,
        street
        
    FROM stores
)

SELECT
    -- Clé primaire
    store_id,
    
    -- Attributs du magasin
    store_name,
    city,
    state,
    zip_code,
    region,
    
    -- Informations de contact (rarement utilisées mais disponibles)
    phone,
    email,
    street

FROM enriched

ORDER BY store_id