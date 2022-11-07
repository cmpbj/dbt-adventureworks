with 
    raw_person_address as (
        select
            address_id
            , state_province_id
            , address_first_line
            , address_second_line
            , city
            , postal_code
            , lng_lat_address
        from {{ ref('stg_person__address') }}
    )

    , raw_state_province as (
        select
            state_province_id
            , country_region_code
            , state_province_name
        from {{ ref('stg_person__state_province') }}
    )

    , raw_country_region as (
        select
            country_region_code
            , country_region_name
        from {{ ref('stg_person__country_region_description') }}
    )

    , joined as (
        select
            raw_person_address.address_id
            , raw_person_address.state_province_id
            , raw_person_address.address_first_line
            , raw_person_address.address_second_line
            , raw_person_address.city
            , raw_state_province.state_province_name
            , raw_country_region.country_region_name
            , raw_person_address.postal_code
            , raw_person_address.lng_lat_address

        from raw_person_address
        left join raw_state_province on raw_person_address.state_province_id = raw_state_province.state_province_id
        left join raw_country_region on raw_country_region.country_region_code = raw_state_province.country_region_code
    )
    , transformed as (
        select
            address_id
            , state_province_id
            , address_first_line
            , address_second_line
            , city
            , state_province_name as state_or_province
            , country_region_name as country
            , postal_code
            , lng_lat_address
        from joined
    )
    , final as (
        select
            {{ dbt_utils.surrogate_key(['address_id', 'state_province_id', 'lng_lat_address']) }} as location_sk
            , *
        from transformed

    )

    select * from final