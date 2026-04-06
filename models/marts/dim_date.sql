{{ config(
    materialized='table',
    schema='marts'
) }}

WITH date_spine AS (
    SELECT DATE_TRUNC(order_date, DAY) AS date_day
    FROM {{ ref('stg_orders') }}
    WHERE order_date IS NOT NULL
    GROUP BY DATE_TRUNC(order_date, DAY)
)

SELECT
    FORMAT_DATE('%Y%m%d', date_day) AS date_key,
    date_day AS calendar_date,
    EXTRACT(YEAR FROM date_day) AS year,
    EXTRACT(MONTH FROM date_day) AS month,
    EXTRACT(DAY FROM date_day) AS day,
    EXTRACT(QUARTER FROM date_day) AS quarter,
    FORMAT_DATE('%Y-Q%Q', date_day) AS quarter_label,
    FORMAT_DATE('%Y-%m', date_day) AS year_month,
    FORMAT_DATE('%A', date_day) AS day_of_week,
    EXTRACT(DAYOFWEEK FROM date_day) AS day_of_week_num,
    EXTRACT(WEEK FROM date_day) AS week_of_year,
    EXTRACT(DAYOFYEAR FROM date_day) AS day_of_year,
    CASE WHEN EXTRACT(DAYOFWEEK FROM date_day) IN (1, 7) THEN 1 ELSE 0 END AS is_weekend,
    CURRENT_TIMESTAMP() AS dbt_loaded_at
FROM date_spine
ORDER BY date_day