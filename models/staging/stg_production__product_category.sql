with
    product_category as (
        select
            productcategoryid as product_category_id
            , name as category_name
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'production_productcategory') }}
    )

    select * from product_category