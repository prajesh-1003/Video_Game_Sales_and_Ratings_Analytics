select
    g.game_id,
    g.name as game_name,
    g.year_of_release,
    g.rating,
    g.platform_id,
    g.genre_id,
    g.publisher_id,
    g.developer_id
from {{ ref('stg_game') }} g
