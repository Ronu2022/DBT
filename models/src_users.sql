SELECT ru.ID, ru.USER_,ru.COUNTRY as COUNTRY_CODE,
rc.COUNTRY as COUNTRY_NAME FROM {{ source("Ronu_Sources_3","RAW_USERS") }} as ru 
LEFT JOIN {{ source("Ronu_Sources_3","RAW_COUNTRY") }} as rc ON CAST(ru.COUNTRY AS STRING) = CAST(rc.COUNTRY_ID AS STRING)