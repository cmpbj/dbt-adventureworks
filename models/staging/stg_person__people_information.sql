with
    person  as (
        select
            rowguid as person_sk
            , cast(businessentityid as int) as business_entity_id
            , case
                when persontype = 'SC' then 'Store Contact'
                when persontype = 'IN' then 'Customer (retail)'
                when persontype = 'SP' then 'Sales Person'
                when persontype = 'EM' then 'Employee (non-sales)'
                when persontype = 'VC' then 'Vendor'
                when persontype = 'GC' then 'General Contact'
                else null
            end as person_type
            , title as person_title
            , firstname as person_first_name
            , middlename as person_middle_name
            , lastname as person_last_name
            , emailpromotion as want_email_promotion
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'person_person') }}

    )

    select * from person