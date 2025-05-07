SELECT
    DATE,
    CONCAT(REVENUE,' ', CURRENCY) AS claimed_revenue,
    CASE
        WHEN CURRENCY = 'USD' THEN {{ dollar_to_inr("REVENUE") }}
        WHEN CURRENCY = 'EUR' THEN {{ euros_to_inr("REVENUE") }}
        WHEN CURRENCY = 'GBP' THEN {{ pounds_to_inr("REVENUE") }}
    END AS Revenue_in_INR
FROM {{source("Ronu_Source_Revenue_date","REVENUE_HISTORY_DATES")}}
