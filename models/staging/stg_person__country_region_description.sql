with
    country_region  as (
        select
              countryregioncode as country_region_code
            , name as country_region_name
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'person_countryregion') }}

    )

    select * from country_region