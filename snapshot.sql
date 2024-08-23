{% snapshot nametobeaddedhere %}

{{
  config(
    target_schema='snapshots',
    strategy='',
    unique_key='',
    updated_at=''
  )
}}

  with source as (

    select *
    from {{ source('', '') }}

  ),

  renamed as (

    select

      {{
        dbt_utils.generate_surrogate_key(['', ''])
      }} as somename,
      *

    from source

  )

  select * from renamed

{% endsnapshot %}
