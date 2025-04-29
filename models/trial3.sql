SELECT 
CUSTOMER_ID,
CONCAT(first_name,'',last_name) as customer_name,
email,
REPLACE(phone_number,'+','') as phone_number_cleaned,
CONVERT_TIMEZONE('UTC','America/Vancouver',REGISTRATION_DATE)::DATE as regis_date,
CONVERT_TIMEZONE('UTC','America/Vancouver',LAST_LOGIN)::DATE as last_login_date,
PARSE_JSON(PREFERENCES):theme::STRING as preference
FROM  DB_ECOM.DBT_RMOHANTY.TRIAL2