-- Data types in Jinja
{{"Ronu"}}
{{23456}}
{{['a','b','c','d']}}
{{true}}

{% raw %}


--------------------------------------------------------------------------------------------------------------------------------- {% end raw %}
-- ** TAGS IN JINJA ** 

/*In Jinja (which is the templating language used in dbt), we use special symbols to do things like:
    -- set variables
    -- run logic like if/else
    -- print values
These are called tags.*/

/*-- Logic tags: {% raw %} {% ... %} {% endraw %}
    -- These are used for instructions like set, if, for, etc.
    -- {% raw %} {% set my_name = "Ajay" %} {% endraw %}

-- Output tags: {% raw %} {{ ... }} {% endraw %}
    -- These are used to set output.
    -- {% raw %} {{ my_name }} {% endraw %} → shows "Ajay"

-- Trimming White Spaces

    -- {% raw %} {% ... %} {% endraw %}	Normal logic, keeps whitespace
    -- {% raw %} {%- ... %}	 {% endraw %}Trims whitespace before the tag
    -- {% raw %} {% ... -%} {% endraw %}	Trims whitespace after the tag
    -- {% raw %} {%- ... -%} {% endraw %}	Trims both before and after

*/



-- ** VARIABLES IN JINJA **
{{23456}}
{% set var1 = "Ronu" %}
{{var1}} -- mark here there is a space after the first line

{{23456}}
{% set var1 = "Ronu" %} 
{{var1}} -- observe it is printed sideby side without any space

{{123456}}
{%- set var1 = "Ronu"%} -- means remove the white space before the tag, i.e after 123456
{{var1}} -- observe: there are spaces


{%set var1 = "Ronu"%}
{%set var2 = "Ajay"%}
{{var1}} -- observe here there are blank spaces (2) above the print
{{var2}}

{%- set var1 = "Ronu" -%}
{%- set var2 = "Ajay" %}
{{var1}}
{{var2}}


{{1234}}
{% set var2 = "Ajay" %}
{{var2}}

{{1234}}{%- set var2 = "Ajay" %}{{var2}}-- observe prints side by side

-- CONDITIONAL LOGIC:

    -- “If something is true, then do this. Otherwise, do something else.”
    -- Think of it like instructions:
    -- If it’s raining → take an umbrella.
    -- Else → wear sunglasses.
    -- In Jinja, we use {% raw %} {% if ... %} {% endraw %} */ for this kind of decision-making.

/* Basic IF */

{% set var2 = 10 %}
{% if (var2 % 2) == 0 %}
Divisible!
{% endif %} -- mark two balnk spaces: what I need is remove sapces after the tag for first and the spaces after the tag for the2nd


{%- set a = 14 -%}
{%- if (a % 2) == 0  -%}
Divisible
{%- endif -%}



{% set var2 = 10 -%}
{% if (var2 % 2) == 0 -%}
Divisible!
{% endif %} -- white sapces removed


{% set y = 3 -%}
{% if y == 3 -%}
y is equal to 3
{% endif %} -- conditions matched 


{%- set y  =  4 -%}
{%- if y == 4 -%}
y is equal to 4!
{%- endif -%}


{% set y = 5 -%}
{% if y == 3 -%}
y is equal to 3
{% endif %}  -- no coditions macthed hence blank o/p


{% set y = 5 -%}
{% if y > 5 -%}
y is greater than 5
{% elif y == 0  -%}
y is sero
{% elif y > 0 and y < 5 -%}
y is lesser than 5
{% else -%}
y is negative
{% endif %}


{% set name = 'Rohit' -%}
{% if name == 'Rohit' -%}
Hello Rohit, How are you?
{% else -%}
Who are you?
{% endif %}

{% set city = 'MUMBAI' -%}
{% if city.lower() == 'mumbai' -%}
Welcome to Mumbai!
{% else -%}
You need to come to Mumbai
{%endif%}



-- IMPORTANT : NAMESPACE()

-- look in python you can use break statement
/* option 1*/

{% set fruits = ["apple", "banana", "cherry"] -%}
{% set banana_found = false -%}

{% for f in fruits -%}
  {% if f == "banana" -%}
    banana is present.
    {% break -%}
{% else -%}
    banana is not present.
{% endif -%}
{% endfor -%}  -- look here it still shows not present because 
-- in dbt the concept of updating values inside loop doesnt arise.
-- here banana_found was set to be false, but it never updates inside the loop
-- thus, in dbt we use a concept called namespace.

{% set fruits = ["apple", "banana", "cherry"] -%}
{% set ns = namespace(found = true) -%}
{% for f in fruits -%}
    {% if f == "banana" -%}
        {% set ns.found = true -%}
    {% endif -%}
{% endfor -%}

{% if ns.found -%}
The fruit is present.
{% else -%}
The fruit is not present.
{% endif -%}


{% set fruits = ["apple","banana"] -%}
{%- set ns = namespace(found = true) -%}
{% for n in fruits -%}
    {% if n == "banana" -%}
        {% set ns.found = true -%}
    {% endif -%}
{% endfor -%}



{% set fruits = ["apple","banana"] -%}
{%- set ns = namespace(found = true) -%}
{%- for f in fruits -%}
    {%- if f == "banana" -%}
        {%- set ns.found = true -%}
    {%- else -%}
        {%- set ns.found = false -%}
    {%- endif -%}
{%- endfor -%}
{%- if ns.found == true -%}
Banana in the list!
    {%- else -%}
        Banana not in the list!
{%- endif -%}


{# LOOP.index#}

{% set names = ['Ronu', 'Vishal', 'Ajay'] -%}
{% set a = namespace(found = true) -%}
{% for n in names -%}
    {% if n == 'Ronu' -%}
        {% set a.found = true -%}
    {% endif -%}
{% endfor -%}

{% if a.found == true -%}
Ronu has worked with us.
{% else -%}
Ronu has not worked with us.
{% endif -%}

{% for na in names -%}
    {{loop.index}}: {{na}} -- index starts from 1
{% endfor %}


{%- set a = ["ajay","ronu","vishal"] -%}
{%- for n in a -%}
    {{loop.index}}: {{n}}
{%- endfor -%}




{# LOOP.index0#}

{% set names = ['Ronu', 'Vishal', 'Ajay'] -%}
{% set a = namespace(found = true) -%}
{% for n in names -%}
    {% if n == 'Ronu' -%}
        {% set a.found = true -%}
    {% endif -%}
{% endfor -%}

{% if a.found == true -%}
Ronu has worked with us.
{% else -%}
Ronu has not worked with us.
{% endif -%}

{% for na in names -%}
    {{loop.index0}}: {{na}} {# index starts from 0 #}
{% endfor %}


{# loop.first - True on first iteration #}

{% set names = ['Ronu', 'Vishal', 'Ajay'] -%}
{% for name in names -%}
    {% if loop.first -%}
    {{name}} is the first Name in the DB.
    {% elif loop.last -%}
    {{name}} is the last Name is the DB.
    {% endif -%} {# look here in the second line of op there is a space in the left #}
{% endfor -%}
{# thus you can left align all #}

{% set names = ['Ronu', 'Vishal', 'Ajay'] -%}
{% for name in names -%}
{% if loop.first -%}
{{name}} is the first Name in the DB.{% elif loop.last -%}
{{name}} is the last Name is the DB.
{% endif -%} {# left aligned #}
{% endfor -%}


{% set names = ['Ronu', 'Vishal', 'Ajay'] -%}
{% for name in names -%}
  {% if loop.first -%}
{{ name }} is the first Name in the DB.
{%- elif loop.last -%}
{{ name }} is the last Name in the DB.
  {% endif -%}
{% endfor -%}



  








