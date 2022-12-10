with
    order_header as (
        select
            rowguid as order_headrer_sk
            , cast(salesorderid as int) as sales_order_id_pk
            , cast(revisionnumber as int) as sales_revision_number
            , customerid as customer_id
            , salespersonid as sales_person_id
            , territoryid as sales_territory_id
            , billtoaddressid as customer_billing_address_id
            , shiptoaddressid as customer_shipping_address_id
            , shipmethodid as shipping_method_id
            , currencyrateid as currency_rate_id
            , creditcardid as credit_card_id
            , cast(orderdate as datetime) as order_date
            , cast(duedate as datetime) as due_date
            , cast (shipdate as datetime) as ship_date
            , status as order_status
            , {{ transforms_boolean_values('onlineorderflag') }} as is_ordered_online
            , purchaseordernumber as purchase_order_number
            , accountnumber as account_number
            , creditcardapprovalcode as credit_card_approval_code
<<<<<<< HEAD
            , cast(subtotal as float64) as order_sales_sub_total
            , cast(taxamt as float64) as order_tax_amount
            , cast(freight as float64) as order_freight
            , cast(totaldue as float64) as order_total_due_from_customers
=======
            , cast(subtotal as float) as order_sales_sub_total
            , cast(taxamt as float) as order_tax_amount
            , cast(freight as float) as order_freight
            , cast(totaldue as float) as order_total_due_from_customers
>>>>>>> b4184df8c221cbcab9c89450165633484c522a09
            , cast(modifieddate as datetime) as modified_date

        from {{ source('adventureworksdw', 'sales_salesorderheader') }}

    )

    select * from order_header 