{{ config(materialized = 'ephemeral' )}}
with cte as
(
  Select *,
  row_number() over (partition by application_id order by application_created_at Desc) as rn
  from {{ source ("spring_loan_applications","raw_loan_applications") }}
) Select * from cte where rn = 1