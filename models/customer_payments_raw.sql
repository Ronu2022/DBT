--select * from {{source("payments_types_sources","customer_payments")}} 
-- let's say we wish to get the details from 


SELECT 
     id,
    SUM(CASE WHEN PAYMENT_MODE = 'UPI' THEN payment_value ELSE 0 END) AS upi_payment,
    SUM(CASE WHEN PAYMENT_MODE = 'Credit Card' THEN payment_value ELSE 0 END) as CC_Payment,
    SUM(CASE WHEN PAYMENT_MODE = 'Cash' THEN payment_value ELSE 0 END) AS cash_payment,
    SUM(CASE WHEN PAYMENT_MODE = 'Cheque' THEN payment_value ELSE 0 END) AS cheque_payment,
    SUM(CASE WHEN PAYMENT_MODE = 'Debit Card' THEN payment_value ELSE 0 END) As DC_payment,
    SUM(CASE WHEN PAYMENT_MODE = 'Net Banking' THEN payment_value ELSE 0 END) AS net_banking_payment
FROM {{source("payments_types_sources","customer_payments")}}
GROUP BY id  -- Look this isnt dynamic 
-- we have to write so many case statements to get at it.
-- what if there are 10 more different payment_mode types what's next? 
-- do you think, it can be done? 
-- Dbt comes handy here. 
-- there is a module from where we can get all the names of the columns.
-- CHECK FOR THE adaptar_usage.sql file of the model, this could be made dynamic using:
-- dbt_utils.get_column_names