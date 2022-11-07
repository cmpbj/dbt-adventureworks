with
    product_subcategory as (
        select
            productsubcategoryid as product_subcategory_id
            , productcategoryid as product_category_id
            , name as subcategory_name
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'production_productsubcategory') }}
    )

    select * from product_subcategory