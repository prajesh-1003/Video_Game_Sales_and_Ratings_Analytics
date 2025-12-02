select
    game_id,
    name,
    year_of_release,
    rating,
    platform_id,
    genre_id,
    publisher_id,
    developer_id
from {{ source('public', 'game') }}
