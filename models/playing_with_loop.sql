{% set column_values = dbt_utils.get_column_values(
    source("payments_types_sources","customer_payments"),"payment_mode"
)%}
select
    id,
    {% for c in column_values %}
    sum(case when payment_mode = '{{ c }}' THEN payment_value ELSE 0 END) AS {{ c | replace(' ','') | lower }}_payments
    {% if not loop.last %},{% endif %}
    {% endfor %}
FROM {{ source("payments_types_sources","customer_payments")}}
group by id

-- Getting the first of the Loop:

{% set column_values = dbt_utils.get_column_values(
    source("payments_types_sources","customer_payments"),"payment_mode"
) %}
select
    id,
    {% for col in column_values -%}
    {%- if not loop.first -%},{%- endif %}
    sum(case when payment_mode = '{{ col }}' then payment_value else 0 end) 
    as {{ col | replace(' ','') | lower }}_payments
    {% endfor -%}
from {{ source("payments_types_sources","customer_payments")}}
group by id
