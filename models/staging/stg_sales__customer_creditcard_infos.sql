with
    creditcard_info  as (
        select
            creditcardid as credit_card_id
            , cardtype as credit_card_name
            , sha256(cast(cardnumber as string)) as card_number_hashed
            , sha256(cast(expmonth as string)) as exp_month_hashed
            , sha256(cast(expyear as string)) as exp_year_hashed
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'sales_creditcard') }}

    )

    select * from creditcard_info