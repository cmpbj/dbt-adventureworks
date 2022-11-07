with
    employee  as (
        select
            rowguid as employee_sk
            , cast(businessentityid as int) as employee_id
            , sha256(nationalidnumber) as national_number_hashed
            , loginid as network_login_id
            , jobtitle as employee_job
            , cast(birthdate as datetime) as birth_date 
            , maritalstatus as marital_status
            , gender as employee_gender
            , cast(hiredate as datetime) as hire_date
            , salariedflag as is_salaried
            , vacationhours as vacation_hours
            , sickleavehours as sick_leave_hours
            , currentflag as is_employee_active
            , cast(modifieddate as datetime) as modified_date
        from {{ source('adventureworksdw', 'humanresources_employee') }}

    )

    select * from employee