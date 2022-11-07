with
    product_vendor  as (
        select
            productid as product_id
            , businessentityid as vendor_id
            , averageleadtime as average_time_order_receiving_product
            , standardprice as product_standard_price
            , lastreceiptcost as last_purchased_cost
            , cast(lastreceiptdate as datetime) as last_receipt_date
            , minorderqty as min_order_qty
            , maxorderqty as max_order_qty
            , onorderqty as qty_currently_on_order
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'purchasing_productvendor') }}

    )

    select * from product_vendor