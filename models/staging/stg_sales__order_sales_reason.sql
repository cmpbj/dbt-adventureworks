with
    sales_order_reason as (
        select
            cast(salesreasonid as int) as sales_reason_id
            , cast(salesorderid as int) as sales_order_id
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'sales_salesorderheadersalesreason') }}

    )

    select * from sales_order_reason