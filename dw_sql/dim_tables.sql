/* DIMENSION TABLES FOR DATA WAREHOUSE */

-- Genre Dimension
CREATE TABLE dw.dim_genre (
    genre_id INTEGER PRIMARY KEY,
    genre_name VARCHAR
);

-- Platform Dimension
CREATE TABLE dw.dim_platform (
    platform_id INTEGER PRIMARY KEY,
    platform_name VARCHAR
);

-- Publisher Dimension
CREATE TABLE dw.dim_publisher (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name VARCHAR
);

-- Developer Dimension
CREATE TABLE dw.dim_developer (
    developer_id INTEGER PRIMARY KEY,
    developer_name VARCHAR
);

-- Game Dimension
CREATE TABLE dw.dim_game (
    game_id INTEGER PRIMARY KEY,
    game_name VARCHAR,
    rating VARCHAR,
    year_of_release INTEGER
);
