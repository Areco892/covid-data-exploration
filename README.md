# Covid Analysis - Data Exploration
In this repository, we will do some data exploration on the Covid dataset obtained from: https://ourworldindata.org/covid-deaths. 

# Technologies Used
- Python - pandas
- VSCode with PostgreSQL from Microsoft extension - SQL queries
- pgAdmin - table creations

# Setup
- Download the CovidDeaths and CovidVaccinations excel files.
- In setup.py, use python and pandas to convert those excel files into csv files.
- In pgAdmin, create two tables, one for deaths and one for vaccinations, using the commands in *table_creation.sql*.
- Populate the tables with data using the command: `\copy <table_name> FROM '<csv_file>.csv' CSV HEADER;`

# Queries Created
- Death Rate Percentage
- Infection Rate Percentage in the United States
- Highest Infection Rate Countries with Rank
- Highest Death Rate Countries
- Total Deaths per Continent

# Acknowledgement
I stumbled upon a youtube video title "Data Analyst Portfolio Project | SQL Data Exploration | Project 1/4" from Alex The Analyst, very cool stuff! So, I created this repository to practice my data exploration skills using PostgreSQL and also to have a way of keep track my progress in becoming a Data Analyst.

- Link to AlexTheAnalyst youtube video: https://www.youtube.com/watch?v=qfyynHBFOsM
- Link to AlexTheAnalyst repository: https://github.com/AlexTheAnalyst/PortfolioProjects/tree/main
