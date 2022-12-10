with
    order_detail as (
        select
            rowguid as order_detail_sk
            , cast(salesorderdetailid as int) as sales_orderdetail_id
            , cast(salesorderid as int) as sales_order_id
            , productid as product_id
            , specialofferid as special_offer_id
            , carriertrackingnumber as carrier_tracking_number
<<<<<<< HEAD
            , cast(orderqty as float64) as order_qty
            , cast(unitprice as float64) as unit_price
            , cast(unitpricediscount as float64) as unit_price_discount
=======
            , orderqty as order_qty
            , cast(unitprice as float) as unit_price
            , cast(unitpricediscount as float) as unit_price_discount
>>>>>>> b4184df8c221cbcab9c89450165633484c522a09
            , cast(modifieddate as datetime) as modified_date

        from {{ source('adventureworksdw', 'sales_salesorderdetail') }}

    )

    select * from order_detail 