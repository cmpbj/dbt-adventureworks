with
    person_address  as (
        select
            rowguid as address_sk
            , cast(addressid as int) as address_id
            , stateprovinceid as state_province_id
            , addressline1 as address_first_line
            , addressline2 as address_second_line
            , city
            , postalcode as postal_code
            , spatiallocation as lng_lat_address
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'person_address') }}

    )

    select * from person_address