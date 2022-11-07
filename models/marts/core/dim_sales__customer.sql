with
    raw_customers as (
        select 
            customer_id
            , person_information_id
            , customer_territory_id
            , store_id
        from {{ ref('stg_sales__customers') }}
    ),

    raw_person as (
        select
            business_entity_id
            , person_first_name
            , person_middle_name
            , person_last_name    
        
        from {{ ref('stg_person__people_information') }}
    ), 


    customer_people as (

         SELECT 
             customers.customer_id
             , person.business_entity_id
             , person.person_first_name
             , person.person_middle_name
             , person.person_last_name 
             , customers.store_id
             , customers.customer_territory_id
        FROM raw_customers as customers
        left join raw_person as person on customers.person_information_id = person.business_entity_id
    ),


    transform as (
        select
            customer_id
            , business_entity_id
            , store_id
            , customer_territory_id
            , concat(person_first_name, ' ', coalesce(person_middle_name, ''), ' ', person_last_name) as full_customer_name
        from customer_people
    ),

    final as (
        select
            {{ dbt_utils.surrogate_key(['customer_id', 'business_entity_id']) }} as customer_sk
            , customer_id
            , business_entity_id
            , store_id
            , customer_territory_id
            , full_customer_name
        from transform
    )


    select * from final
