with
    raw_products as (
        select
            product_id
            , product_subcategory_id
            , product_model_id
            , product_number
            , product_name
            , product_make_flag
            , product_salable_item
            , product_color
            , safetystocklevel
            , reorderpoint
            , standardcost
            , listprice
            , sizeunitmeasurecode
            , weightunitmeasureCode
            , product_weight
            , daystomanufacture
            , productline
            , class
            , style
            , sell_start_date
            , sell_end_date
            , modified_date
        from {{ ref('stg_production__products') }}
    )

    , raw_models_info as (
        select
            product_model_id
            , model_name
        from {{ ref('stg_production__product_model') }}
    )

    , raw_category_info as (
        select
            product_category_id
            , category_name
        from {{ ref('stg_production__product_category') }}
    )

    , raw_subcategory_info as (
        select
            product_subcategory_id
            , product_category_id
            , subcategory_name
        from {{ ref('stg_production__product_subcategory') }}

    )

    , category_subcategory_joined as (
        select
            raw_subcategory_info.product_category_id
            , raw_subcategory_info.product_subcategory_id
            , raw_category_info.category_name
            , raw_subcategory_info.subcategory_name
        from raw_subcategory_info
        left join raw_category_info on raw_subcategory_info.product_category_id = raw_category_info.product_category_id
    )


    , product_with_model as (
        select
              raw_products.product_id
            , raw_products.product_subcategory_id
            , raw_products.product_model_id
            , raw_products.product_number
            , raw_products.product_name
            , raw_models_info.model_name
            , raw_products.product_make_flag
            , raw_products.product_salable_item
            , raw_products.product_color
            , raw_products.safetystocklevel
            , raw_products.reorderpoint
            , raw_products.standardcost
            , raw_products.listprice
            , raw_products.sizeunitmeasurecode
            , raw_products.weightunitmeasureCode
            , raw_products.product_weight
            , raw_products.daystomanufacture
            , raw_products.productline
            , raw_products.class
            , raw_products.style
            , raw_products.sell_start_date
            , raw_products.sell_end_date
        from raw_products
        left join raw_models_info on raw_products.product_model_id = raw_models_info.product_model_id
    )

    , product_category_subcategory as (
        select
              product_with_model.product_id
            , category_subcategory_joined.product_category_id  
            , product_with_model.product_subcategory_id
            , product_with_model.product_model_id
            , product_with_model.product_number
            , product_with_model.product_name
            , product_with_model.model_name
            , category_subcategory_joined.category_name
            , category_subcategory_joined.subcategory_name
            , product_with_model.product_make_flag
            , product_with_model.product_salable_item
            , product_with_model.product_color
            , product_with_model.safetystocklevel
            , product_with_model.reorderpoint
            , product_with_model.standardcost
            , product_with_model.listprice
            , product_with_model.sizeunitmeasurecode
            , product_with_model.weightunitmeasureCode
            , product_with_model.product_weight
            , product_with_model.daystomanufacture
            , product_with_model.productline
            , product_with_model.class
            , product_with_model.style
            , product_with_model.sell_start_date
            , product_with_model.sell_end_date
        from product_with_model
        left join category_subcategory_joined on product_with_model.product_subcategory_id = category_subcategory_joined.product_subcategory_id
    )

    , final as (
        select
            {{ dbt_utils.surrogate_key(['product_id', 'product_name', 'product_category_id', 'product_subcategory_id']) }} as product_sk
            , product_id
            , product_category_id 
            , product_subcategory_id
            , product_model_id
            , product_number
            , product_name
            , model_name
            , category_name
            , subcategory_name
            , product_make_flag
            , product_salable_item
            , product_color
            , safetystocklevel
            , reorderpoint
            , standardcost
            , listprice
            , sizeunitmeasurecode
            , weightunitmeasureCode
            , product_weight
            , daystomanufacture
            , productline
            , class
            , style
            , sell_start_date
            , sell_end_date
        from product_category_subcategory
    )

    select * from final