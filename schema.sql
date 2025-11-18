-- Project Schema

-- TABLE: platform
CREATE TABLE platform (
    platform_id SERIAL PRIMARY KEY,
    platform_name VARCHAR(50) NOT NULL UNIQUE
);

-- TABLE: genre
CREATE TABLE genre (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL UNIQUE
);

-- TABLE: publisher
CREATE TABLE publisher (
    publisher_id SERIAL PRIMARY KEY,
    publisher_name VARCHAR(100) NOT NULL UNIQUE
);

-- TABLE: developer
CREATE TABLE developer (
    developer_id SERIAL PRIMARY KEY,
    developer_name VARCHAR(100) NOT NULL UNIQUE
);

-- TABLE: game
CREATE TABLE game (
    game_id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    year_of_release INT CHECK (year_of_release >= 1970 AND year_of_release <= 2030),
    rating VARCHAR(10),
    platform_id INT NOT NULL REFERENCES platform(platform_id) ON DELETE RESTRICT,
    genre_id INT NOT NULL REFERENCES genre(genre_id) ON DELETE RESTRICT,
    publisher_id INT NOT NULL REFERENCES publisher(publisher_id) ON DELETE RESTRICT,
    developer_id INT NOT NULL REFERENCES developer(developer_id) ON DELETE RESTRICT
);

-- TABLE: sales
CREATE TABLE sales (
    sales_id SERIAL PRIMARY KEY,
    game_id INT NOT NULL UNIQUE REFERENCES game(game_id) ON DELETE CASCADE,
    na_sales NUMERIC(6,2) DEFAULT 0 CHECK (na_sales >= 0),
    eu_sales NUMERIC(6,2) DEFAULT 0 CHECK (eu_sales >= 0),
    jp_sales NUMERIC(6,2) DEFAULT 0 CHECK (jp_sales >= 0),
    other_sales NUMERIC(6,2) DEFAULT 0 CHECK (other_sales >= 0),
    global_sales NUMERIC(6,2) DEFAULT 0 CHECK (global_sales >= 0)
);

-- TABLE: reviews
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    game_id INT NOT NULL UNIQUE REFERENCES game(game_id) ON DELETE CASCADE,
    critic_score NUMERIC(4,1) CHECK (critic_score >= 0 AND critic_score <= 100),
    critic_count INT CHECK (critic_count >= 0),
    user_score NUMERIC(3,1) CHECK (user_score >= 0 AND user_score <= 10),
    user_count INT CHECK (user_count >= 0)
);
