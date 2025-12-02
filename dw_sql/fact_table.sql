/* FACT TABLE FOR DATA WAREHOUSE
   Grain: 1 row per game */

CREATE TABLE dw.fact_game_sales (
    fact_id SERIAL PRIMARY KEY,

    -- Dimension Foreign Keys
    game_id INTEGER,
    genre_id INTEGER,
    platform_id INTEGER,
    publisher_id INTEGER,
    developer_id INTEGER,

    -- Game metadata
    year_of_release INTEGER,
    rating VARCHAR,

    -- Sales metrics
    global_sales NUMERIC,
    na_sales NUMERIC,
    eu_sales NUMERIC,
    jp_sales NUMERIC,
    other_sales NUMERIC,

    -- Review metrics
    critic_score NUMERIC,
    user_score NUMERIC
);
