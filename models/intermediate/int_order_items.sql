{{ config(materialized='view', schema='intermediate') }}

WITH order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),
orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
),
products AS (
    SELECT * FROM {{ ref('stg_products') }}
),
brands AS (
    SELECT * FROM {{ ref('stg_brands') }}
),
categories AS (
    SELECT * FROM {{ ref('stg_categories') }}
),
stores AS (
    SELECT * FROM {{ ref('stg_stores') }}
)

SELECT
    oi.order_id,
    oi.item_id,
    oi.product_id,
    oi.quantity,
    oi.list_price,
    oi.discount,
    
    -- Calculs de revenu
    ROUND(oi.list_price * oi.quantity, 2) AS gross_revenue,
    ROUND(oi.list_price * oi.quantity * oi.discount, 2) AS discount_amount,
    ROUND((oi.list_price * oi.quantity) - (oi.list_price * oi.quantity * oi.discount), 2) AS net_revenue,
    
    -- Informations de commande
    o.order_date,
    o.shipped_date,
    o.order_status,
    o.customer_id,
    o.store_id,
    o.staff_id,
    
    -- Informations produit
    p.product_name,
    b.brand_name,
    c.category_name,
    c.category_id,
    p.model_year,
    
    -- Informations magasin
    s.store_name,
    s.city,
    s.state

FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN brands b ON p.brand_id = b.brand_id
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN stores s ON o.store_id = s.store_id