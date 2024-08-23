{#
 intent: Use this to help in comparing data between this and what we have
 deployed.
 usage: pull latest,
  - dbt seed --full-refresh
  - dbt run -s +dim_stations
  - dbt compile -s dim_stations_audit.sql
 notes:
  - add/remove columns you care about.
#}

{%- set columns_to_compare=adapter.get_columns_in_relation(ref('dim_stations')) -%} -- noqa:LT05
{%- set columns_to_keep = ['station_id',
'station_name',
'line_id',
'line_name',
'shop_id',
'shop_name'
] -%}

{% set old_etl_relation_query %}
 select
   *
 from mfg.mes.dim_stations

{% endset %}

{% set new_etl_relation_query %}
select
  *
from {{ ref('dim_stations') }}
{% endset %}

{% if execute %}
  {% for column in columns_to_compare %}
    {% if column.name.lower() in columns_to_keep %}

      {% set audit_query = audit_helper.compare_column_values(
          a_query=old_etl_relation_query,
          b_query=new_etl_relation_query,
          primary_key="station_id",
          column_to_compare=column.name
      ) %}

      {% set audit_results = run_query(audit_query) %}
      {% do audit_results.print_table() %}
      {{ log("", info=True) }}
    {% endif %}
  {% endfor %}

{% endif %}
