select
    developer_id,
    developer_name
from {{ source('public', 'developer') }}