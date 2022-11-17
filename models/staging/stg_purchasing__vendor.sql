with
    vendor_info  as (
        select
            businessentityid as vendor_id
            , accountnumber as account_number
            , name as company_name
            , creditrating as credit_rating
            , {{ transforms_boolean_values('preferredvendorstatus') }} as preferred_vendor_status
            , {{ transforms_boolean_values('activeflag') }} as is_vendor_used
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'purchasing_vendor') }}

    )

    select * from vendor_info