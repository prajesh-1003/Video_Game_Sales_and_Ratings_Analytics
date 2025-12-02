select
    platform_id,
    platform_name
from {{ ref('stg_platform') }}