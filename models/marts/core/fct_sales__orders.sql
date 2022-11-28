with
    raw_order_details as (
        select
            sales_orderdetail_id
            , sales_order_id
            , product_id
            , special_offer_id
            , carrier_tracking_number
            , order_qty
            , unit_price
            , unit_price_discount
            , modified_date
        from {{ ref('stg_sales__order_detail') }}
    )
    , sales_info as (
        select
            sales_order_sk
            , sales_order_id_pk
            , customer_id
            , sales_person_id
            , customer_billing_address_id
            , customer_shipping_address_id
            , shipping_method_id
            , currency_rate_id
            , credit_card_id
            , reason_per_order
            , credit_card_name
            , order_date
            , due_date
            , ship_date
            , order_status
            , is_ordered_online
            , purchase_order_number
            , account_number
            , order_tax_amount
            , order_freight

        from {{ ref('dim_sales__sales_info') }}
    )
    , products as (
        select
            product_sk
            , product_id
            , product_name
            , model_name
            , category_name
            , subcategory_name
            , product_make_flag
            , product_salable_item
            , product_line
            , product_class
            , product_style
        from {{ ref('dim_production__products') }}
    )
    , customers as (
        select
            customer_sk
            , customer_id
            , full_customer_name
        from {{ ref('dim_sales__customer') }}
    )
    , locations as (
        select
            address_id
            , city
            , state_or_province
            , country
            , location_sk
        from {{ ref('dim_person__locations') }}
    )
    , order_details as (
        select
            sales_info.sales_order_sk as sales_order_id_fk
            , sales_info.sales_order_id_pk
            , raw_order_details.product_id
            , sales_info.customer_id
            , sales_info.sales_person_id
            , sales_info.customer_billing_address_id
            , sales_info.customer_shipping_address_id
            , sales_info.reason_per_order
            , sales_info.credit_card_name
            , sales_info.order_date
            , sales_info.due_date
            , sales_info.ship_date
            , sales_info.is_ordered_online
            , raw_order_details.order_qty
            , raw_order_details.unit_price
            , raw_order_details.unit_price_discount
            , sales_info.order_tax_amount
            , sales_info.order_freight

        from raw_order_details
        left join sales_info on raw_order_details.sales_order_id = sales_info.sales_order_id_pk
    )
    , transforming_freight_tax_values as (
        select
            *
            , count(order_details.sales_order_id_fk)
            , sum(count(order_details.sales_order_id_fk)) over (
                partition by order_details.sales_order_id_fk
                order by count(order_details.sales_order_id_fk)
            ) as soma
        from order_details
        group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18
    )
    , calculating_freight_tax_per_product as (
        select
            *
            , order_tax_amount
            , order_freight
            , (order_tax_amount / soma) as order_tax_amount_per_product
            , (order_freight / soma) as order_freight_per_product
        from transforming_freight_tax_values
    )
    , order_details_with_products_names as (
        select
            calculating_freight_tax_per_product.sales_order_id_fk
            , sales_order_id_pk
            , products.product_sk as products_fk
            , calculating_freight_tax_per_product.customer_id
            , products.product_name
            , products.model_name
            , products.category_name
            , products.subcategory_name
            , products.product_make_flag
            , products.product_salable_item
            , products.product_line
            , products.product_class
            , products.product_style
            , calculating_freight_tax_per_product.sales_person_id
            , calculating_freight_tax_per_product.customer_billing_address_id
            , calculating_freight_tax_per_product.customer_shipping_address_id
            , calculating_freight_tax_per_product.reason_per_order
            , calculating_freight_tax_per_product.credit_card_name
            , calculating_freight_tax_per_product.order_date
            , calculating_freight_tax_per_product.due_date
            , calculating_freight_tax_per_product.ship_date
            , calculating_freight_tax_per_product.is_ordered_online
            , calculating_freight_tax_per_product.order_qty
            , calculating_freight_tax_per_product.unit_price
            , calculating_freight_tax_per_product.unit_price_discount
            , calculating_freight_tax_per_product.order_tax_amount_per_product
            , calculating_freight_tax_per_product.order_freight_per_product
  
        from calculating_freight_tax_per_product
        left join products on calculating_freight_tax_per_product.product_id = products.product_id
    )
    , order_details_with_customer as (
        select
        order_details_with_products_names.sales_order_id_fk
        , sales_order_id_pk
        , order_details_with_products_names.products_fk
        , customers.customer_sk as customer_fk
        , customers.full_customer_name
        , order_details_with_products_names.product_name
        , order_details_with_products_names.model_name
        , order_details_with_products_names.category_name
        , order_details_with_products_names.subcategory_name
        , order_details_with_products_names.product_make_flag
        , order_details_with_products_names.product_salable_item
        , order_details_with_products_names.product_line
        , order_details_with_products_names.product_class
        , order_details_with_products_names.product_style
        , order_details_with_products_names.sales_person_id
        , order_details_with_products_names.customer_billing_address_id
        , order_details_with_products_names.customer_shipping_address_id
        , order_details_with_products_names.reason_per_order
        , order_details_with_products_names.credit_card_name
        , order_details_with_products_names.order_date
        , order_details_with_products_names.due_date
        , order_details_with_products_names.ship_date
        , order_details_with_products_names.is_ordered_online
        , order_details_with_products_names.order_qty
        , order_details_with_products_names.unit_price
        , order_details_with_products_names.unit_price_discount
        , order_details_with_products_names.order_tax_amount_per_product
        , order_details_with_products_names.order_freight_per_product
        from order_details_with_products_names 
        left join customers on order_details_with_products_names.customer_id = customers.customer_id
    )
    , order_details_bill_address as (
        select
          sales_order_id_fk
          , products_fk
          , customer_fk
          , full_customer_name
          , product_name
          , model_name
          , category_name
          , subcategory_name
          , product_make_flag
          , product_salable_item
          , product_line
          , product_class
          , product_style
          , sales_person_id
          , customer_billing_address_id
          , customer_shipping_address_id
          , reason_per_order
          , credit_card_name
          , order_date
          , due_date
          , ship_date
          , is_ordered_online
          , order_qty
          , unit_price
          , unit_price_discount
          , order_tax_amount_per_product
          , order_freight_per_product
          , locations.city as bill_city
          , locations.state_or_province as bill_state_or_province
          , locations.country as bill_country
          , locations.location_sk
        from order_details_with_customer
        left join locations on order_details_with_customer.customer_billing_address_id = locations.address_id
    )
    , order_details_ship_address as (
      select
          sales_order_id_fk
          , products_fk
          , customer_fk
          , full_customer_name
          , product_name
          , model_name
          , category_name
          , subcategory_name
          , product_make_flag
          , product_salable_item
          , product_line
          , product_class
          , product_style
          , sales_person_id
          , customer_billing_address_id
          , customer_shipping_address_id
          , reason_per_order
          , credit_card_name
          , order_date
          , due_date
          , ship_date
          , is_ordered_online
          , order_qty
          , unit_price
          , unit_price_discount
          , order_tax_amount_per_product
          , order_freight_per_product
          , bill_city
          , bill_state_or_province
          , bill_country
          , order_details_bill_address.location_sk
          , locations.city as ship_city
          , locations.state_or_province as ship_state_or_province
          , locations.country as ship_country
        from order_details_bill_address
        left join locations on order_details_bill_address.customer_shipping_address_id = locations.address_id

    )
    , revenue_calculation as (
        select
        *
          , ((unit_price * (1 - unit_price_discount) * order_qty) + (order_tax_amount_per_product + order_freight_per_product)) as revenue
        from order_details_ship_address
    )
    , final as (
         select
        sales_order_id_fk
          , products_fk
          , customer_fk
          , location_sk
          , full_customer_name
          , bill_city
          , bill_state_or_province
          , bill_country
          , ship_city
          , ship_state_or_province
          , ship_country
          , credit_card_name
          , product_name
          , model_name
          , category_name
          , subcategory_name
          , product_make_flag
          , product_salable_item
          , product_line
          , product_class
          , product_style
          , reason_per_order
          , order_date
          , due_date
          , ship_date
          , is_ordered_online
          , order_qty
          , unit_price
          , unit_price_discount
          , order_tax_amount_per_product
          , order_freight_per_product
          , revenue
        from revenue_calculation
    )
select *
from final