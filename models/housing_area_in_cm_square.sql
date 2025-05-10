select HOUSE_NAME,AREA,
{{ mtocm("AREA") }} as area_in_cm_square
from {{ref('house_area')}}

