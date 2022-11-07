with
    address_type  as (
        select
            rowguid as address_sk
            , addresstypeid as address_type_id
            , name as address_type_name
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'person_addresstype') }}

    )

    select * from address_type