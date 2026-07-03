# 🎬 Netflix Content Analytics | ELT Project (Python, MySQL & SQL)

## 📌 Project Overview

This project demonstrates an end-to-end **ELT (Extract, Load, Transform)** pipeline using the Netflix Movies & TV Shows dataset. Raw data is extracted and validated using **Python (Pandas)**, loaded into **MySQL**, and transformed using **SQL** to solve real-world business problems. The analysis uncovers insights related to directors, genres, countries, and content trends, showcasing practical data engineering and SQL analytics skills.

---

## 🎯 Business Problem Statement

Netflix's growing content library makes it challenging to analyze content performance, identify versatile directors, understand regional content trends, and optimize future content acquisition. This project builds an ELT pipeline to transform raw Netflix data into meaningful business insights that support data-driven decision-making.

---

## 🎯 Business Objectives

- Identify directors who have created both Movies and TV Shows.
- Find the country with the highest number of Comedy Movies.
- Determine the top movie director for each year based on the content added to Netflix.
- Calculate the average movie duration across different genres.
- Identify directors who have directed both Comedy and Horror movies.

---

## 🛠️ Technology Stack

| Technology | Purpose |
|------------|---------|
| Python (Pandas) | Data Extraction & Validation |
| MySQL | Data Storage |
| SQL | Data Cleaning, Transformation & Analysis |
| CSV Dataset | Raw Data Source |

---

## 🔄 ELT Workflow

### 1️⃣ Extract
- Imported Netflix dataset (CSV)
- Loaded data using Python Pandas
- Performed data inspection and validation

### 2️⃣ Load
- Created MySQL database and tables
- Loaded cleaned data into MySQL

### 3️⃣ Transform
- Cleaned and standardized data
- Converted data types
- Split multi-value columns
- Handled NULL values
- Performed aggregations
- Used CTEs and Window Functions
- Generated business insights

---

## 📊 Business Questions Solved

1. Count Movies and TV Shows created by each director who has directed both.
2. Identify the country with the highest number of Comedy Movies.
3. Find the director with the highest number of movies added to Netflix each year.
4. Calculate the average duration of movies for each genre.
5. Find directors who have directed both Comedy and Horror movies.

---

## 📂 Project Structure

```
Netflix-Content-Analytics/
│
├── Dataset/
│   └── netflix_titles.csv
│
├── Python/
│   └── Data_Extraction.ipynb
│
├── SQL/
│   ├── Database_Creation.sql
│   ├── Data_Load.sql
│   └── Business_Queries.sql
│
├── Presentation/
│   └── Netflix_Content_Analytics_Report.pptx
│
├── README.md
└── LICENSE
```

---

## 📈 Skills Demonstrated

- Python (Pandas)
- MySQL
- SQL
- Data Extraction
- Data Loading
- Data Transformation
- Data Cleaning
- Window Functions
- Common Table Expressions (CTEs)
- Aggregate Functions
- Business Analytics
- Data Engineering Fundamentals
- Git & GitHub

---

## 📌 Dataset

**Source:** Netflix Movies & TV Shows Dataset

---

## 🚀 Key Learnings

- Built a complete ELT pipeline using Python and SQL.
- Applied SQL transformations to solve business problems.
- Improved skills in data cleaning, aggregation, and analytical SQL.
- Generated actionable business insights from raw data.

---

If you found this project helpful, feel free to ⭐ this repository.
