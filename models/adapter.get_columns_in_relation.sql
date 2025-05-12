{{ config(materialized = 'view') }}

{% set raw_table = adapter.get_relation(
    database = 'RAW_SPRING_RECORDS',
    schema = 'RAW_DATA',
    identifier = 'raw_evergreen_applications'
) %}

{% set column_list = adapter.get_columns_in_relation(raw_table) %}

select
    {% for col in column_list %}
    {{ log("Column Name: " ~ col.name ~ " Data type: " ~ col.dtype ~ "." , info = true) }}
    {{ col.name }}
        {% if not loop.last %}
            ,
         {% endif %}
{% endfor %}
from {{ source("spring_loan_applications","raw_evergreen_applications") }}