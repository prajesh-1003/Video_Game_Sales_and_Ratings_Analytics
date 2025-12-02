/* The below indexing is done based on the complexity of Query No 5: GAMES WHOSE SALES > AVG SALES OF THEIR GENRE*/

/* Improve JOIN performance: sales ↔ game */
CREATE INDEX idx_sales_game_id 
    ON sales(game_id);

/* Improve JOIN + GROUP BY performance on genre */
CREATE INDEX idx_game_genre_id 
    ON game(genre_id);

/* Improve sorting + filtering + join on global_sales */
CREATE INDEX idx_sales_global_sales_game_id 
    ON sales(global_sales, game_id);

/* Multi-column index to speed correlated subquery */
CREATE INDEX idx_game_genre_game_id 
    ON game(genre_id, game_id);