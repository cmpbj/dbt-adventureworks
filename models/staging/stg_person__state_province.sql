with
    state_province  as (
        select
            rowguid as state_province_sk
            , cast(stateprovinceid as int) as state_province_id
            , territoryid as state_province_territory_id
            , stateprovincecode as state_province_code
            , countryregioncode as country_region_code
            , {{ transforms_boolean_values('isonlystateprovinceflag') }} as is_province_code_available
            , name as state_province_name
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'person_stateprovince') }}

    )

    select * from state_province