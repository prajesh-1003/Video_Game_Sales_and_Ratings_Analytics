# app.py (Updated with full filters + custom colors)

import streamlit as st
import plotly.express as px
import pandas as pd
from utils import load_data
from queries import (
    TOP_SELLING_GAMES,
    SALES_BY_GENRE,
    CRITIC_USER_SCORE,
    SALES_TREND_YEAR,
)

# ----------------------
# PAGE CONFIG
# ----------------------
st.set_page_config(page_title="Video Game Analytics Dashboard", layout="wide")

# ----------------------
# IMAGE BANNER (supports exactly 5 images safely)
# ----------------------
import os
from PIL import Image

image_folder = os.path.join(os.path.dirname(__file__), "images")

if os.path.exists(image_folder):
    img_files = [
        f for f in sorted(os.listdir(image_folder))
        if f.lower().endswith((".png", ".jpg", ".jpeg"))
    ][:5]

    if img_files:
        cols = st.columns(len(img_files))
        for idx, img_name in enumerate(img_files):
            try:
                img_path = os.path.join(image_folder, img_name)
                img = Image.open(img_path)
                cols[idx].image(img, use_container_width=True)
            except Exception:
                cols[idx].write(f"Error loading {img_name}")

st.title("🎮 Video Game Sales & Ratings Analytics Dashboard")
st.markdown("Use the filters in the sidebar to explore the dataset interactively.")

# ----------------------
# SIDEBAR FILTERS
# ----------------------
st.sidebar.header("Filters")

# Load dropdown lists from database
genres_df = load_data("SELECT DISTINCT genre_name FROM dw.dim_genre ORDER BY genre_name;")
platform_df = load_data("SELECT DISTINCT platform_name FROM dw.dim_platform ORDER BY platform_name;")
publisher_df = load_data("SELECT DISTINCT publisher_name FROM dw.dim_publisher ORDER BY publisher_name;")
years_df = load_data("SELECT DISTINCT year_of_release FROM dw.dim_game WHERE year_of_release IS NOT NULL ORDER BY year_of_release;")

# Dropdowns
genre_filter = st.sidebar.selectbox("Genre", ["All"] + genres_df["genre_name"].tolist())
platform_filter = st.sidebar.selectbox("Platform", ["All"] + platform_df["platform_name"].tolist())
publisher_filter = st.sidebar.selectbox("Publisher", ["All"] + publisher_df["publisher_name"].tolist())

# Year slider
year_min = int(years_df["year_of_release"].min()) if not years_df.empty else 1980
year_max = int(years_df["year_of_release"].max()) if not years_df.empty else 2020
year_range = st.sidebar.slider("Year Range", min_value=year_min, max_value=year_max, value=(year_min, year_max))

# ----------------------
# APPLY FILTERS TO QUERIES
# ----------------------
filter_conditions = ""

if genre_filter != "All":
    filter_conditions += f" AND ge.genre_name = '{genre_filter}' "
if platform_filter != "All":
    filter_conditions += f" AND p.platform_name = '{platform_filter}' "
if publisher_filter != "All":
    filter_conditions += f" AND pub.publisher_name = '{publisher_filter}' "

filter_conditions += f" AND g.year_of_release BETWEEN {year_range[0]} AND {year_range[1]} "

# Top Selling Games Query
top_games_query = f"""
SELECT g.game_name, f.global_sales
FROM dw.fact_sales f
JOIN dw.dim_game g ON f.game_id = g.game_id
JOIN dw.dim_genre ge ON g.genre_id = ge.genre_id
JOIN dw.dim_platform p ON g.platform_id = p.platform_id
JOIN dw.dim_publisher pub ON g.publisher_id = pub.publisher_id
WHERE 1=1 {filter_conditions}
ORDER BY f.global_sales DESC
LIMIT 10;
"""

# Genre Sales Query
genre_sales_query = f"""
SELECT ge.genre_name, SUM(f.global_sales) AS total_sales
FROM dw.fact_sales f
JOIN dw.dim_game g ON f.game_id = g.game_id
JOIN dw.dim_genre ge ON g.genre_id = ge.genre_id
WHERE 1=1 {filter_conditions}
GROUP BY ge.genre_name
ORDER BY total_sales DESC;
"""

# Sales Trend Query
sales_trend_query = f"""
SELECT g.year_of_release, SUM(f.global_sales) AS total_sales
FROM dw.fact_sales f
JOIN dw.dim_game g ON f.game_id = g.game_id
JOIN dw.dim_genre ge ON g.genre_id = ge.genre_id
WHERE 1=1 {filter_conditions}
GROUP BY g.year_of_release
ORDER BY g.year_of_release;
"""

# ----------------------
# FETCH FILTERED DATA
# ----------------------
top_games_df = load_data(top_games_query)
genre_sales_df = load_data(genre_sales_query)
review_df = load_data(CRITIC_USER_SCORE)
trend_df = load_data(sales_trend_query)

# ----------------------
# VISUALIZATION 1 — Top Selling Games
# ----------------------
st.subheader("Top 10 Best-Selling Games")
if not top_games_df.empty:
    fig1 = px.bar(
        top_games_df,
        x="global_sales",
        y="game_name",
        orientation="h",
        title="Top 10 Games",
        color_discrete_sequence=["#4CAF50"],  # green
    )
    st.plotly_chart(fig1, use_container_width=True)
else:
    st.warning("No data for Top 10 Games after filters.")

# ----------------------
# VISUALIZATION 2 — Sales by Genre (Bar <-> Pie)
# ----------------------
st.subheader("Global Sales by Genre")

chart_type = st.radio(
    "Select Chart Type for Genre Sales:",
    ["Bar Chart", "Pie Chart"],
    horizontal=True
)

if not genre_sales_df.empty:
    if chart_type == "Bar Chart":
        fig2 = px.bar(
            genre_sales_df,
            x="genre_name",
            y="total_sales",
            title="Sales by Genre",
            color_discrete_sequence=["#2196F3"],  
        )
    else:
        fig2 = px.pie(
            genre_sales_df,
            names="genre_name",
            values="total_sales",
            title="Sales by Genre (Pie Chart)",
            color_discrete_sequence=px.colors.qualitative.Pastel
        )

    st.plotly_chart(fig2, use_container_width=True)
else:
    st.warning("No genre sales data for selected filters.")


# ----------------------
# VISUALIZATION 3 — Critic vs User Score
# ----------------------
st.subheader("Critic Score vs User Score")
if not review_df.empty:
    fig3 = px.scatter(
        review_df,
        x="critic_score",
        y="user_score",
        hover_name="game_name",
        title="Critic vs User Score",
        color_discrete_sequence=["#F50000"],  
    )
    st.plotly_chart(fig3, use_container_width=True)
else:
    st.warning("No critic/user review data.")

# ----------------------
# VISUALIZATION 4 — Sales Trend
# ----------------------
st.subheader("Sales Trend Over Years")
if not trend_df.empty:
    fig4 = px.line(
        trend_df,
        x="year_of_release",
        y="total_sales",
        title="Sales Trend",
        color_discrete_sequence=["#FF9800"], 
    )
    st.plotly_chart(fig4, use_container_width=True)
else:
    st.warning("No sales trend data after filters.")
