
# 📊 S&P 500 Historical & Predictive Analysis (1950–2030)

### 🧠 Data Analytics | PostgreSQL | Financial Market Research

---

## 📘 Project Overview
This project delivers an in-depth **PostgreSQL-based analysis of the S&P 500 index**, focusing on its **real price, earnings, dividends, inflation, and market cycles** between **1950 and 2023**, followed by a **forecast up to 2030**.

The analysis applies **financial and statistical methods** such as:
- Year-over-Year growth rate
- Dividend Yield and Equity Premium Gap
- Correlation and Linear Regression
- Inflation comparison
- Forecast modeling (2024–2030)

---

## 🧱 Project Structure

| Step | Description | Focus |
|------|--------------|--------|
| **1️⃣ Base Data Selection** | Filters and prepares dataset for 1950–2023. | Ensures clean data pipeline |
| **2️⃣ Yearly Real Growth** | Calculates annual average and YoY growth for real prices. | Market growth patterns |
| **3️⃣ Equity Premium Gap** | Compares stock yields vs bond interest rates. | Identifies outperforming market phases |
| **4️⃣ Annual Averages Summary** | Computes yearly averages of price, earnings, dividends, P/E ratio. | Historical performance |
| **5️⃣ Yearly Growth Rates** | Calculates YoY growth in price, earnings, and dividends. | Annual comparison |
| **6️⃣ Decade-Wise Summary** | Groups data by decades for trend analysis. | Long-term pattern discovery |
| **7️⃣ Inflation Impact** | Compares real growth vs CPI inflation. | Detects market cycle phases |
| **8️⃣ Correlation Analysis** | Analyzes relationships among key metrics. | Statistical dependencies |
| **9️⃣ Linear Regression** | Builds regression models for prediction. | Statistical modeling |
| **🔟 Forecasting Model** | Projects 2024–2030 price trends. | Predictive analytics |

---

## 📈 Example: YoY Real Growth
```sql
WITH yearly_avg AS (
    SELECT 
        EXTRACT(YEAR FROM date) AS year,
        AVG(real_price) AS avg_real_price
    FROM sp500
    WHERE EXTRACT(YEAR FROM date) BETWEEN 1950 AND 2023
    GROUP BY EXTRACT(YEAR FROM date)
)
SELECT 
    year,
    ROUND(avg_real_price::numeric, 2) AS avg_real_price,
    ROUND(
        ((avg_real_price / LAG(avg_real_price) OVER (ORDER BY year) - 1) * 100)::numeric,
        2
    ) AS yoy_real_growth
FROM yearly_avg
ORDER BY year;
```

**Purpose:** Evaluates year-over-year real price growth for S&P 500 to identify market expansion or contraction periods.

---

## 📊 Key Analytical Insights

### 🔹 Historical Growth (1950–2023)
- S&P 500 showed **consistent long-term growth**, with notable increases during **1980s, 1990s, and 2010s**.
- **Average P/E ratio** trended upward, reflecting stronger investor confidence.
- Market contractions aligned with **inflation spikes** (1970s oil crisis, 2008 recession).

### 🔹 Correlation Findings
| Variable Pair | Correlation (r) | Interpretation |
|----------------|------------------|----------------|
| Price ↔ Earnings | **0.910** | Very strong positive correlation |
| Price ↔ CPI | **0.871** | Inflation-sensitive growth |
| Earnings ↔ CPI | **0.840** | Growth partly inflation-driven |

### 🔹 Inflation & Market Cycles
- Markets **outperformed inflation** during most of the 1990s and post-2010s.
- **Negative cycles** appeared during high inflation decades (1970s & 2020s).

---

## 🔮 Forecast (2024–2030)

| Year | Forecast Real Price |
|------|----------------------|
| 2024 | 2873.80 |
| 2025 | 2915.42 |
| 2026 | 2957.04 |
| 2027 | 2998.66 |
| 2028 | 3040.28 |
| 2029 | 3081.90 |
| 2030 | 3123.52 |

📌 **Interpretation:**  
According to the linear regression model, the **S&P 500’s real value** is projected to **grow steadily through 2030**, supported by positive slope and high R², indicating strong model reliability.

---

## ⚙️ Technical Stack

| Component | Tool |
|------------|------|
| Database | **PostgreSQL 16+** |
| Query Language | **SQL (CTE, Window Functions, Regression, Correlation)** |
| Visualization | (Optional) Power BI / Tableau |
| Data Source | Historical S&P 500 dataset (inflation-adjusted) |

---

## 🧩 Key Analytical Functions Used
- `AVG()`, `ROUND()`, `LAG()`, `CASE`
- `REGR_SLOPE()`, `REGR_INTERCEPT()`, `REGR_R2()`
- `CORR()` — Statistical correlation
- `generate_series()` — Forecast year generator

---

## 🏁 Conclusion
This project demonstrates a **complete data analytics pipeline** — from **data cleaning and financial modeling** to **statistical forecasting**.  
It highlights how **SQL alone** can be used for deep financial market analysis, combining **economic insight with quantitative rigor**.

---

## 🧑‍💻 Author
**Muhiddin Axmadov**  
_Data Analyst | Financial Data Researcher_  
📍 Focus: Data Analytics • SQL • Market Forecasting • Investment Insight  
