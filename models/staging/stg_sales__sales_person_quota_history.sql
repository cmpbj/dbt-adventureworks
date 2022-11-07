with
    quota_history  as (
        select
            rowguid as sales_person_quota_history_sk
            , cast(businessentityid as int) as sales_person_id
            , cast(quotadate as datetime) as quota_date
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'sales_salespersonquotahistory') }}

    )

    select * from quota_history