select
    sales_order_id_fk,
    sum(unit_price) as total_negociated_value
from {{ ref('fct_sales__orders' )}}
group by 1
having not(total_negociated_value >= 0)