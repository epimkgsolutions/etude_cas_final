{{ config(
    materialized='table',
    schema='marts'
) }}

WITH date_range AS (
    -- Génère une plage de dates couvrant toutes les dates de commandes
    -- (du 2016-01-01 au 2018-12-31)
    SELECT DATE AS calendar_date
    FROM UNNEST(
        GENERATE_DATE_ARRAY(
            DATE('2016-01-01'),
            DATE('2018-12-31'),
            INTERVAL 1 DAY
        )
    ) AS DATE
),

enriched_dates AS (
    SELECT
        -- Clé de substitution (surrogate key) : YYYYMMDD format
        -- Ex: 2016-01-01 → 20160101
        PARSE_DATE('%Y%m%d', FORMAT_DATE('%Y%m%d', calendar_date)) AS date_key,
        
        -- Attributs de date
        calendar_date,
        EXTRACT(YEAR FROM calendar_date) AS year,
        EXTRACT(MONTH FROM calendar_date) AS month,
        EXTRACT(QUARTER FROM calendar_date) AS quarter,
        EXTRACT(DAYOFWEEK FROM calendar_date) AS day_of_week_num,  -- 1=Sun, 7=Sat
        
        -- Étiquettes lisibles
        FORMAT_DATE('%B', calendar_date) AS month_name,
        FORMAT_DATE('%A', calendar_date) AS day_name,
        
        -- Formats agrégés pour les filtres Power BI
        FORMAT_DATE('%Y-%m', calendar_date) AS year_month,
        CONCAT(EXTRACT(YEAR FROM calendar_date), '-Q', EXTRACT(QUARTER FROM calendar_date)) AS year_quarter,
        
        -- Drapeaux (flags) pour les filtres
        CASE WHEN EXTRACT(DAYOFWEEK FROM calendar_date) IN (1, 7) THEN 1 ELSE 0 END AS is_weekend,
        
        -- Numéro de semaine et jour dans l'année
        EXTRACT(WEEK FROM calendar_date) AS week_of_year,
        EXTRACT(DAYOFYEAR FROM calendar_date) AS day_of_year
        
    FROM date_range
)

SELECT
    -- Clé primaire : date_key (YYYYMMDD)
    date_key,
    
    -- Attributs principaux
    calendar_date,
    year,
    month,
    quarter,
    day_of_week_num,
    
    -- Étiquettes
    month_name,
    day_name,
    
    -- Agrégations
    year_month,
    year_quarter,
    
    -- Drapeaux
    is_weekend,
    week_of_year,
    day_of_year

FROM enriched_dates

ORDER BY calendar_date
