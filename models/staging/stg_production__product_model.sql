with
    product_model  as (
        select
            rowguid as product_model_sk
            , productmodelid as product_model_id
            , name as model_name
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'production_productmodel') }}

    )

    select * from product_model