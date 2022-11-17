with
    products as (
        select
            rowguid as product_sk
            , cast(productid as int) as product_id
            , cast(productsubcategoryid as int) as product_subcategory_id
            , cast(productmodelid as int) as product_model_id
            , cast(productnumber as string) as product_number
            , cast(name as string) as product_name
            , {{ transforms_boolean_values('makeflag') }} as product_make_flag
            , {{ transforms_boolean_values('finishedgoodsflag') }} as product_salable_item
            , color as product_color
            , safetystocklevel
            , reorderpoint
            , standardcost
            , listprice
            , sizeunitmeasurecode
            , weightunitmeasureCode
            , weight as product_weight
            , daystomanufacture
            , productline
            , class
            , style 
            , cast(sellstartdate as datetime) as sell_start_date
            , cast(sellenddate as datetime) as sell_end_date
            , cast(modifieddate as datetime) as modified_date
            
        from {{ source('adventureworksdw', 'production_product') }}

    )

    select * from products 