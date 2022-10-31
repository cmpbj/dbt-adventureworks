with
    customers as (
        select
            cast(customerid as int) as customer_id_pk
            , cast(personid as int) as person_id_fk
            , cast(territoryid as int) as territory_id_fk
            , cast(storeid as int) as store_id_fk
            
        from {{ source('adventureworksdw', 'sales_customer') }}

    )

    select * from customers 