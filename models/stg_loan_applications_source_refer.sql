{{ config(
    materialized = 'incremental',
    unique_key = 'application_id',
    incremental_strategy = 'merge',
    on_schema_change = 'append_new_columns')}}

with source_data_raw_loan_cleaned as
(
    select *,
   -- try_to_timestamp(application_created_at,'MON DD YYYY HH24:MM:SS') as application_created_at_timestamp,

    COALESCE(
        try_to_timestamp(application_created_at, 'YYYY/MM/DD HH24:MI'),
        try_to_timestamp(application_created_at, 'YYYY-MM-DD HH24:MI:SS'),  
        try_to_timestamp(application_created_at, 'MON DD YYYY HH24:MI:SS') 
        ) as application_created_at_timestamp,

    row_number() over (partition by customer_id order by try_to_timestamp(application_created_at,'MON DD YYYY HH24:MM:SS') desc ) as rn,
    '{{ run_started_at }}' as loaded_at,
    '{{ invocation_id }}' as invocation_id

     from {{source("spring_loan_applications","raw_loan_applications_3")}} t

{% if is_incremental() %}
 where t.application_id > (select max(application_id) from {{ this }})
 and t.rn = 1
{% endif %}
),
source_data_raw_customer_profile as
(
    select *,
    try_to_date(date_of_birth,'YYYY/MM/DD'),
    COALESCE(
         TRY_TO_DATE(date_of_birth, 'YYYY/MM/DD'),       -- handles '1985/08/20'
         TRY_TO_DATE(date_of_birth, 'YYYY-MM-DD'),       -- handles '1990-05-15'
         TRY_TO_DATE(date_of_birth, 'MM-DD-YYYY'),       -- handles '05-12-1992'
         TRY_TO_DATE(date_of_birth)   
        ) as date_of_birth_timestamp,
    row_number() over(partition by customer_id order by customer_id asc) as rn,
    '{{ run_started_at }}' as loaded_at_cx_profile,
    '{{ invocation_id }}' as invocation_id_cx_profile
    from {{ source("spring_loan_applications","raw_customer_profiles_3")}} t
    {% if is_incremental() %}
     where t.customer_id > (select max(customer_id) from {{ this }})
     and rn = 1
     {% endif %}

) 
Select 
    c.customer_id,
    c.first_name,
    c.last_name,
    concat(c.customer_id,' ',c.first_name) as cx_name,
    c.email_address,
    c.date_of_birth_timestamp as date_of_birth,
    l.application_id,
    l.product_type,
    l.application_created_at_timestamp as application_creation_timestamp,
    trim(l.notes) as notes
from source_data_raw_customer_profile as c
left join source_data_raw_loan_cleaned as l on c.customer_id = l.customer_id
