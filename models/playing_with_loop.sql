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

