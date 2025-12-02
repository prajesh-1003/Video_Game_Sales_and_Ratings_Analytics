select
    platform_id,
    platform_name
from {{ source('public', 'platform') }}
