{{ config(
    materialized = 'incremental',
    unique_key = 'application_id',
    incremental_strategy = 'merge',
    on_schema_change = 'append_new_columns',
    schema  = target.schema)
    }}
with stage_cte as
(
    select
    application_id
    ,COALESCE
    (
        try_to_timestamp(application_created_at,'YYYY/MM/DD HH24:MI'),
        try_to_timestamp(application_created_at,'YYYY-MM-DD HH24:MI:SS'),
        try_to_timestamp(application_created_at,'MON DD YYYY HH24:MI:SS'),
        '1900-01-01'
    ) as application_created_timestamp
    ,customer_email
    ,CASE 
        WHEN trim(lower(customer_email)) like '%@%@%' THEN NULL -- if it has 2 @
        WHEN trim(lower(customer_email)) not like '%@%' THEN NULL -- if it has no @
        WHEN (length(trim(lower(customer_email))) - length(replace(trim(lower(customer_email)),'@',''))) <> 1 THEN NULL
        -- if it has  more than 1 @
        WHEN position('@' in trim(lower(customer_email))) = 1 THEN NULL -- if it starts with @
        WHEN (length(trim(lower(customer_email))) - length(replace(trim(lower(customer_email)),'.',''))) > 2 THEN NULL
        -- if it has more than 2 dots.
        ELSE trim(lower(customer_email))
    END AS cleaned_email

    {% if target.name == 'dev'  %}

    ,'{{target.name }}' as env_name
    ,'{{ target.schema }}' as schema_used
    ,'{{ run_started_at }}'  as run_time
    '{{ invocation_id }}' as invocation_id
    {% endif %}
    from {{ source("spring_loan_applications","raw_loan_applications_4")}} t

{% if is_incremental() %}
where t.application_id > (select max(application_id) from {{ source("spring_loan_applications","raw_loan_applications_4")}})
{% endif %}
)
Select * from stage_cte

