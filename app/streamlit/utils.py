# utils.py
# Helper functions for database connection and data loading

import pandas as pd
from sqlalchemy import create_engine

# Create SQLAlchemy engine
DB_USER = "admin"
DB_PASSWORD = "admin"
DB_HOST = "postgres"
DB_PORT = "5432"
DB_NAME = "videogamesdb"

DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

# FORCE DW schema priority
engine = create_engine(
    DATABASE_URL,
    connect_args={"options": "-csearch_path=dw,public"}
)

def load_data(query: str) -> pd.DataFrame:
    """
    Executes a SQL query and returns a Pandas DataFrame.
    """
    try:
        with engine.connect() as connection:
            return pd.read_sql(query, connection)
    except Exception as e:
        print(f"Error executing query: {e}")
        return pd.DataFrame()
