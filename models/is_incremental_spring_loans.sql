{{ config(materialized = 'incremental', unique_key = 'application_id', incremental_strategy = 'merge') }}
Select
    application_id,
    customer_id,
    product_type,
    application_created_at
from {{ source ("spring_loan_applications","raw_loan_applications")}} t1

{% if is_incremental() %}
where t1.application_id > (select max(application_id) from {{this}} )
--application_created_at > (select max(application_created_at) from {{ this }})
{% endif %}
