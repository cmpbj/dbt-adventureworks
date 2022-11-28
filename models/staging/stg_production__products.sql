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
            , safetystocklevel as safety_stock_level
            , reorderpoint as reorder_point
            , standardcost as stardard_cost
            , listprice as list_price
            , sizeunitmeasurecode as size_unit_measure_code
            , weightunitmeasureCode as weight_unit_measure_code
            , weight as product_weight
            , daystomanufacture as days_to_manufacture
            , productline as product_line
            , class as product_class
            , style as product_style
            , cast(sellstartdate as datetime) as sell_start_date
            , cast(sellenddate as datetime) as sell_end_date
            , cast(modifieddate as datetime) as modified_date
            
        from {{ source('adventureworksdw', 'production_product') }}

    )

    select * from products 