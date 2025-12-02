select
    publisher_id,
    publisher_name
from {{ source('public', 'publisher') }}
