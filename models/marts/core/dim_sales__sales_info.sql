with
    raw_order_header as (
        select
            sales_order_id_pk
            , customer_id
            , sales_person_id
            , customer_billing_address_id
            , customer_shipping_address_id
            , shipping_method_id
            , currency_rate_id
            , credit_card_id
            , order_date
            , due_date
            , ship_date
            , order_status
            , is_ordered_online
            , purchase_order_number
            , account_number
            , credit_card_approval_code
            , order_sales_sub_total
            , order_tax_amount
            , order_freight
            , order_total_due_from_customers
            , modified_date
        from {{ ref('stg_sales__order_header') }}
    )
    , raw_reference_reason as (
        select
            sales_reason_id
            , sales_order_id
        from {{ ref('stg_sales__order_sales_reason') }}
    )
    , raw_sales_reason as (
        select
            sales_reason_id
            , sales_reason_name
            , reason_type
        from {{ ref('stg_sales__sales_reason') }}
    )
    , raw_sales_credit_card as (
        select
            credit_card_id
            , credit_card_name
        from {{ ref('stg_sales__customer_creditcard_infos') }}
    )
    , grouped_reasons as (
        select
            raw_reference_reason.sales_order_id
            , string_agg(distinct raw_sales_reason.reason_type, ', ') as reason_per_order
      from raw_reference_reason
      left join raw_sales_reason on raw_reference_reason.sales_reason_id = raw_sales_reason.sales_reason_id
      group by raw_reference_reason.sales_order_id
    )
        , order_header_reasons as (
        select
            raw_order_header.sales_order_id_pk
            ,  raw_order_header.customer_id
            ,  raw_order_header.sales_person_id
            ,  raw_order_header.customer_billing_address_id
            ,  raw_order_header.customer_shipping_address_id
            ,  raw_order_header.shipping_method_id
            ,  raw_order_header.currency_rate_id
            ,  raw_order_header.credit_card_id
            ,  grouped_reasons.reason_per_order
            ,  raw_order_header.order_date
            ,  raw_order_header.due_date
            ,  raw_order_header.ship_date
            ,  raw_order_header.order_status
            ,  raw_order_header.is_ordered_online
            ,  raw_order_header.purchase_order_number
            ,  raw_order_header.account_number
            ,  raw_order_header.credit_card_approval_code
            ,  raw_order_header.order_sales_sub_total
            ,  raw_order_header.order_tax_amount
            ,  raw_order_header.order_freight
            ,  raw_order_header.order_total_due_from_customers
            ,  raw_order_header.modified_date
        from raw_order_header
        left join grouped_reasons on raw_order_header.sales_order_id_pk = grouped_reasons.sales_order_id
    )
    , order_credit_card as (
        select
            order_header_reasons.sales_order_id_pk
            , order_header_reasons.customer_id
            , order_header_reasons.sales_person_id
            , order_header_reasons.customer_billing_address_id
            , order_header_reasons.customer_shipping_address_id
            , order_header_reasons.shipping_method_id
            , order_header_reasons.currency_rate_id
            , order_header_reasons.credit_card_id
            , order_header_reasons.reason_per_order
            , raw_sales_credit_card.credit_card_name
            , order_header_reasons.order_date
            , order_header_reasons.due_date
            , order_header_reasons.ship_date
            , order_header_reasons.order_status
            , order_header_reasons.is_ordered_online
            , order_header_reasons.purchase_order_number
            , order_header_reasons.account_number
            , order_header_reasons.credit_card_approval_code
            , order_header_reasons.order_sales_sub_total
            , order_header_reasons.order_tax_amount
            , order_header_reasons.order_freight
            , order_header_reasons.order_total_due_from_customers
            , order_header_reasons.modified_date
        from order_header_reasons
        left join raw_sales_credit_card on order_header_reasons.credit_card_id = raw_sales_credit_card.credit_card_id
    )
    , surrogate_key as (
        select
            {{ dbt_utils.surrogate_key(['sales_order_id_pk', 'customer_id']) }} as sales_order_sk
            , sales_order_id_pk
            , customer_id
            , sales_person_id
            , customer_billing_address_id
            , customer_shipping_address_id
            , shipping_method_id
            , currency_rate_id
            , credit_card_id
            , coalesce(reason_per_order, 'No Reason Registered') as reason_per_order
            , credit_card_name
            , order_date
            , due_date
            , ship_date
            , order_status
            , is_ordered_online
            , purchase_order_number
            , account_number
            , credit_card_approval_code
            , order_sales_sub_total
            , order_tax_amount
            , order_freight
            , order_total_due_from_customers
            , modified_date
        from order_credit_card
    )

select
  *
from surrogate_key
