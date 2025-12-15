# queries.py
# SQL queries for Streamlit Dashboard

# Query 1: Top 10 Best-Selling Games (DW Schema)
TOP_SELLING_GAMES = """
SELECT g.game_name, f.global_sales
FROM dw.fact_sales f
JOIN dw.dim_game g ON f.game_id = g.game_id
ORDER BY f.global_sales DESC
LIMIT 10;
"""

# Query 2: Total Global Sales by Genre (DW Schema)
SALES_BY_GENRE = """
SELECT ge.genre_name, SUM(f.global_sales) AS total_sales
FROM dw.fact_sales f
JOIN dw.dim_game g ON f.game_id = g.game_id
JOIN dw.dim_genre ge ON g.genre_id = ge.genre_id
GROUP BY ge.genre_name
ORDER BY total_sales DESC;
"""


# Query 3: Critic vs User Score (OLTP Tables)
CRITIC_USER_SCORE = """
SELECT 
    g.name AS game_name,
    r.critic_score,
    r.user_score
FROM public.reviews r
JOIN public.game g 
    ON r.game_id = g.game_id
WHERE r.critic_score IS NOT NULL 
  AND r.user_score IS NOT NULL;
"""

# Query 4: Sales Trend by Year (DW Schema)
SALES_TREND_YEAR = """
SELECT g.year_of_release, SUM(f.global_sales) AS total_sales
FROM dw.fact_sales f
JOIN dw.dim_game g ON f.game_id = g.game_id
WHERE g.year_of_release IS NOT NULL
GROUP BY g.year_of_release
ORDER BY g.year_of_release;
"""

