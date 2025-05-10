select application_created_at FROM  {{ source ("spring_loan_applications","raw_loan_applications")}}
where application_created_at > 
(select max(application_created_at) from {{ source ("spring_loan_applications","raw_loan_applications")}} )
 