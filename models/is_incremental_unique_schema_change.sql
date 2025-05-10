{{ config(
    materialized = 'incremental',unique_key = 'application_id', incremental_strategy = 'merge',
    on_schema_change = 'append_new_columns'
)}}
select * from {{source("spring_loan_applications","raw_loan_applications_2")}} t
{% if is_incremental() %}
where t.application_id > (select max(application_id) from {{ this }})
{% endif %}
