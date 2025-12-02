
/* QUERY 1: BEST PERFORMING GENRE FOR EACH PLATFORM */

WITH genre_sales AS (
    SELECT 
        p.platform_name,
        g.genre_id,
        ge.genre_name,
        SUM(s.global_sales) AS total_sales
    FROM game g
    JOIN platform p ON g.platform_id = p.platform_id
    JOIN genre ge ON g.genre_id = ge.genre_id
    JOIN sales s ON g.game_id = s.game_id
    GROUP BY p.platform_name, g.genre_id, ge.genre_name
), ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY platform_name ORDER BY total_sales DESC) AS rnk
    FROM genre_sales
)
SELECT platform_name, genre_name, total_sales
FROM ranked
WHERE rnk = 1;


/* QUERY 2: PUBLISHERS WITH THE BIGGEST CRITIC–USER SCORE GAP */

WITH score_gap AS (
    SELECT 
        pu.publisher_name,
        AVG(r.critic_score) AS avg_critic,
        AVG(r.user_score) AS avg_user,
        ABS(AVG(r.critic_score) - AVG(r.user_score)) AS gap
    FROM game g
    JOIN publisher pu ON g.publisher_id = pu.publisher_id
    JOIN reviews r ON g.game_id = r.game_id
    GROUP BY pu.publisher_name
)
SELECT *,
       RANK() OVER (ORDER BY gap DESC) AS rank_by_gap
FROM score_gap;


/* QUERY 3: SALES DOMINANCE OF NINTENDO, SONY, MICROSOFT */

SELECT 
    pu.publisher_name,
    SUM(s.global_sales) AS total_global_sales
FROM game g
JOIN publisher pu ON g.publisher_id = pu.publisher_id
JOIN sales s ON g.game_id = s.game_id
WHERE pu.publisher_name ILIKE ANY (ARRAY['%Nintendo%', '%Sony%', '%Microsoft%'])
GROUP BY pu.publisher_name
ORDER BY total_global_sales DESC;


/* QUERY 4: DECLINING PLATFORM POPULARITY OVER YEARS */

WITH yearly_counts AS (
    SELECT 
        p.platform_name,
        g.year_of_release,
        COUNT(*) AS num_games
    FROM game g
    JOIN platform p ON g.platform_id = p.platform_id
    WHERE g.year_of_release IS NOT NULL
    GROUP BY p.platform_name, g.year_of_release
), trend AS (
    SELECT 
        *,
        LAG(num_games) OVER (PARTITION BY platform_name ORDER BY year_of_release) AS prev_year
    FROM yearly_counts
)
SELECT *
FROM trend
WHERE prev_year IS NOT NULL AND num_games < prev_year
ORDER BY platform_name, year_of_release;


/* QUERY 5: GAMES WHOSE SALES > AVG SALES OF THEIR GENRE */

SELECT 
    g.name AS game_name,
    ge.genre_name,
    s.global_sales
FROM game g
JOIN genre ge ON g.genre_id = ge.genre_id
JOIN sales s ON g.game_id = s.game_id
WHERE s.global_sales > (
    SELECT AVG(s2.global_sales)
    FROM game g2
    JOIN sales s2 ON g2.game_id = s2.game_id
    WHERE g2.genre_id = g.genre_id
)
ORDER BY s.global_sales DESC;
