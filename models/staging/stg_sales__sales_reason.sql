with
    sales_reason  as (
        select
            cast(salesreasonid as int) as sales_reason_id
                , name as sales_reason_name
                , reasontype as reason_type
                , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'sales_salesreason') }}

    )

    select * from sales_reason 

