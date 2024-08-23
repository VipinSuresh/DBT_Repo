{#
 intent: Use this to help in comparing data between this and what we have
 deployed.
 usage: pull latest,
  - dbt seed --full-refresh
  - dbt run -s +fct_completed_units
  - dbt compile -s fct_completed_units_audit
 notes:
  - add/remove columns you care about.
  - Filter to prevent new records from impacting.
#}

{%- set start_date = "2023-01-01" -%}
{%- set end_date = "2023-12-20" -%}
{%- set columns_to_compare=adapter.get_columns_in_relation(ref('fct_completed_units')) -%} -- noqa:LT05
{%- set columns_to_keep = [
  'product_serial',
  'shop_group',
  'started_shop_id',
  'started_line_id',
  'completed_shop_id',
  'completed_shop_name',
  'completed_line_id',
  'completed_line_name',
  'completed_at',
  'production_date',
  'completed_shift_name',
] -%}

{% set old_etl_relation_query %}
 select
   *,
   {{ dbt_utils.generate_surrogate_key(['product_serial', 'started_shop_id']) }} as _pk
 from mfg.core.fct_completed_units
 where completed_at between '{{ start_date }}' and '{{ end_date }}'
{% endset %}

{% set new_etl_relation_query %}
select
  *,
  {{ dbt_utils.generate_surrogate_key(['product_serial', 'started_shop_id']) }} as _pk
from {{ ref('fct_completed_units') }}
where completed_at between '{{ start_date }}' and '{{ end_date }}'
{% endset %}

{% if execute %}
  {% for column in columns_to_compare %}
    {% if column.name.lower() in columns_to_keep %}

      {% set audit_query = audit_helper.compare_column_values(
          a_query=old_etl_relation_query,
          b_query=new_etl_relation_query,
          primary_key="_pk",
          column_to_compare=column.name
      ) %}

      {% set audit_results = run_query(audit_query) %}
      {% do audit_results.print_table() %}
      {{ log("", info=True) }}
    {% endif %}
  {% endfor %}

{% endif %}
