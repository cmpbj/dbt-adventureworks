with
    sales_person  as (
        select
            rowguid as sales_person_sk
            , cast(businessentityid as int) as sales_person_id
            , territoryid as assigned_territory_sales_person_id
            , salesquota as projected_sales_quota_per_year
            , bonus as bonus_if_quota_met
            , commissionpct as commission_percent_per_sales
            , salesytd as total_sales_year_to_date
            , saleslastyear as total_sales_last_year
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'sales_salesperson') }}

    )

    select * from sales_person