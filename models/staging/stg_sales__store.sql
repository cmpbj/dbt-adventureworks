with
    customers as (
        select
            rowguid as store_sk
            , cast(businessentityid as int) as store_id_pk
            , cast(salespersonid as int) as sales_person_id_fk
            , name as store_name
            , cast(modifieddate as datetime) as modified_date
            
        from {{ source('adventureworksdw', 'sales_store') }}

    )

    select * from customers 