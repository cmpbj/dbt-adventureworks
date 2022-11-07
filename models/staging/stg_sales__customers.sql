with
    customers as (
        select
            rowguid as customers_sk
            , cast(customerid as int) as customer_id
            , cast(personid as int) as person_information_id
            , cast(territoryid as int) as customer_territory_id
            , cast(storeid as int) as store_id
            , cast(modifieddate as datetime) as modified_date
            
        from {{ source('adventureworksdw', 'sales_customer') }}

    )

    select * from customers 