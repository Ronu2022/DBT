{%- set payment_mode_values = dbt_utils.get_column_values
(
    source("payments_types_sources", "customer_payments"),
    "payment_mode"
) -%}
Select 
id
{% for v in payment_mode_values -%}
,SUM(CASE WHEN payment_mode = '{{v}}' THEN payment_value ELSE 0 END) AS {{ v | replace(' ','') | lower }}_payment
{% endfor %}
FROM {{ source("payments_types_sources","customer_payments") }}
group by id



