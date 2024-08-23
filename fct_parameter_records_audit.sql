{#
 intent: Use this to help in comparing data between this and what we have
 deployed.
 usage: pull latest,
  - dbt seed --full-refresh
  - dbt run -s +fct_parameter_records
  - dbt compile -s fct_parameter_records_audit.sql
 notes:
  - add/remove columns you care about.
#}

{%- set columns_to_compare=adapter.get_columns_in_relation(ref('fct_parameter_records')) -%} -- noqa:LT05
{%- set columns_to_keep = [
  'parameter_record_id',
  'recorded_at',
  'product_serial',
  'product_part',
  'product_model',
  'order_number',
  'parameter_name',
  'parameter_value_raw'
] -%}

{% set old_etl_relation_query %}
  select *
  from mfg.mes.fct_parameter_records
  where recorded_at_utc >= current_date - interval '90 day'
    and recorded_at_utc <= current_timestamp - interval '30 min'
{% endset %}

{% set new_etl_relation_query %}
  select *
  from {{ ref('fct_parameter_records') }}
  where recorded_at_utc >= current_date - interval '90 day'
    and recorded_at_utc <= current_timestamp - interval '30 min'
{% endset %}

{% if execute %}
  {% for column in columns_to_compare %}
    {% if column.name.lower() in columns_to_keep %}

      {% set audit_query = audit_helper.compare_column_values(
          a_query=old_etl_relation_query,
          b_query=new_etl_relation_query,
          primary_key="parameter_record_id",
          column_to_compare=column.name
      ) %}

      {% set audit_results = run_query(audit_query) %}
      {% do audit_results.print_table() %}
      {{ log("", info=True) }}
    {% endif %}
  {% endfor %}

{% endif %}
