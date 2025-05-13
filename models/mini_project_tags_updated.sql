{{config(
    materialized = 'incremental',
    unique_key = 'application_id',
    incremental_strategy = 'merge',
    on_schema_change = 'append_new_columns',
    tags = ['spl','daily']
)
}}
with applications as(
    select
        application_id,
        customer_id,
        product_type,
        application_status,
        application_date,
        updated_at
    from {{ source("Raw_Inserted_Layer","RAW_LOAN_APPLICATIONS_6") }} t

    {% if is_incremental() %}
    where product_type = 'spl'
    and application_status <> 'incomplete'
    and t.updated_at > (select max(updated_at) from {{ this }})
    {% endif %}
),
customers as(
    select * from {{ source("Raw_Inserted_Layer","RAW_CUSTOMER_PROFILES_6") }}
) ,
calenders as(
    select * from {{ source("Raw_Inserted_Layer","REVENUE_HISTORY_DATES_6") }}
)

{% if target.name == 'prod' %}
select 
    a.application_id,
    a.application_status,
    a.customer_id,
    c.customer_name,
    c.city,
    a.application_date,
    a.updated_at
from applications as a
left join customers  as c on a.customer_id = c.customer_id
{% else %}

select 
    a.application_id,
    a.application_status,
    a.customer_id,
    c.customer_name,
    c.city,
    a.application_date,
    a.updated_at,
    '{{ target.name }}' as target_name,
    '{{ target.schema }}' as target_schema,
    '{{ invocation_id }}' as invocation_id,
    '{{ run_started_at }}' as loading_time
from applications as a
left join customers  as c on a.customer_id = c.customer_id
{% endif %}
    
