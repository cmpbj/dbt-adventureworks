with
    products as (
        select
            rowguid as product_sk
            , cast(productid as int) as product_id
            , cast(productsubcategoryid as int) as product_subcategory_id
            , cast(productmodelid as int) as product_model_id
            , cast(productnumber as string) as product_number
            , cast(name as string) as product_name
            , case
                when makeflag = false then 0
                when makeflag = true then 1
            end as product_make_flag
            , case
                when finishedgoodsflag = false then 0
                when finishedgoodsflag = true then 1
            end as product_salable_item
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