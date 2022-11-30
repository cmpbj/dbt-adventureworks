select
    unit_price_discount
from {{ ref('fct_sales__orders' )}}
group by 1
having not(unit_price_discount <= 0.8)