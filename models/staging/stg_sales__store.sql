with
    stores as (
        select
            rowguid as store_sk
            , cast(businessentityid as int) as store_id
            , cast(salespersonid as int) as sales_person_id
            , name as store_name
            , cast(modifieddate as datetime) as modified_date
            
        from {{ source('adventureworksdw', 'sales_store') }}

    )

    select * from stores 