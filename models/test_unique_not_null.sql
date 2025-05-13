{{ config(materialize = 'view') }}
with source as 
(
    select * from {{ source("Raw_Inserted_Layer","raw_loan_applications_7")}}
)
select * from source

