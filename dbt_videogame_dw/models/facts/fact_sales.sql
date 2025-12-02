select
    s.sales_id,
    s.game_id,
    s.na_sales,
    s.eu_sales,
    s.jp_sales,
    s.other_sales,
    s.global_sales
from {{ ref('stg_sales') }} s
