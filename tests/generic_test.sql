{% test unit_testing(model_name,column_name) %}
select * from {{ model_name }}
where {{ column_name }} > 5000
{% endtest %}