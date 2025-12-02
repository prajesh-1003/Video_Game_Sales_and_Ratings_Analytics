select
    sales_id,
    game_id,
    na_sales,
    eu_sales,
    jp_sales,
    other_sales,
    global_sales
from {{ source('public', 'sales') }}
