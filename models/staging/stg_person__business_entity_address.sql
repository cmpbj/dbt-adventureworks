with
    business_address  as (
        select
            rowguid as business_address_sk
            , businessentityid as business_entity_id
            , addressid as address_id
            , addresstypeid as address_type_id
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'person_businessentityaddress') }}

    )

    select * from business_address 