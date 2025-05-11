{{ config(materialized = 'view') }}
{% set main_table = adapter.get_relation( 
    database = 'RAW_SPRING_RECORDS',
    schema = 'RAW_DATA',
    identifier = 'raw_evergreen_applications'
) %}
{% set backup_table = 'RAW_SPRING_RECORDS.RAW_DATA.raw_evergreen_applications_backup' %}
{% set a = namespace(use_backup = false) %}
{% if main_table is none %}
{% set a.use_backup = true %}
{% else %}
    {% set row_count_result = run_query("select count(*) from RAW_SPRING_RECORDS.RAW_DATA.raw_evergreen_applications_backup") %}
    {% set row_count = row_count_result.columns[0].values()[0] %}
    {% if row_count == 0 %}
        {% set a.use_backup = true %}
    {% endif %}
{% endif %}

{% if a.use_backup %}
with source_table as
(
        select *,'backup' as source_table from {{ backup_table }}

)
{% else %}
with source_table as
(
    select *, 'main' as source_table from {{ main_table }}
)
{% endif %}
select * from source_table
