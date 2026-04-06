{{ config(materialized='view', schema='intermediate') }}

WITH stocks AS (
    SELECT * FROM {{ ref('stg_stocks') }}
),
products AS (
    SELECT * FROM {{ ref('stg_products') }}
),
stores AS (
    SELECT * FROM {{ ref('stg_stores') }}
)

SELECT
    st.store_id,
    st.product_id,
    st.stock_quantity,
    
    -- Informations produit
    p.product_name,
    p.list_price,
    ROUND(st.stock_quantity * p.list_price, 2) AS stock_value,
    
    -- Informations magasin
    s.store_name,
    s.city,
    s.state

FROM stocks st
LEFT JOIN products p ON st.product_id = p.product_id
LEFT JOIN stores s ON st.store_id = s.store_id