-- ===========================================
-- 🧾 STEP 1: BASE DATA SELECTION (1950–2023)
-- ===========================================
-- Filter S&P 500 dataset for the modern period (1950–2023)
WITH modern_sp500 AS (
    SELECT *
    FROM sp500
    WHERE EXTRACT(YEAR FROM date) BETWEEN 1950 AND 2023
)
SELECT
    date,
    ROUND(real_price::numeric, 2) AS real_price,
    ROUND(real_earnings::numeric, 2) AS real_earnings,
    ROUND(real_dividend::numeric, 2) AS real_dividend,

    -- Calculate Price-to-Earnings (P/E) ratio
    CASE 
        WHEN real_earnings = 0 THEN NULL
        ELSE ROUND((real_price / real_earnings)::numeric, 2)
    END AS pe_ratio,

    -- Calculate Dividend Yield (as a percentage)
    CASE 
        WHEN real_price = 0 THEN NULL
        ELSE ROUND(((real_dividend / real_price) * 100)::numeric, 2)
    END AS dividend_yield

FROM modern_sp500
ORDER BY date;


-- ===========================================
-- 📈 STEP 2: YEARLY REAL GROWTH (YoY)
-- ===========================================
-- Calculate annual average real price and its Year-over-Year growth rate
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


-- ===========================================
-- 💰 STEP 3: EQUITY PREMIUM GAP ANALYSIS
-- (Dividend Yield - Long-Term Interest Rate)
-- ===========================================
-- Compare stock market returns with bond yields to find relative performance
SELECT
    date,
    ROUND((real_dividend / real_price * 100)::numeric, 2) AS dividend_yield,
    ROUND(long_interest_rate::numeric, 2) AS long_interest_rate,
    ROUND(((real_dividend / real_price * 100) - long_interest_rate)::numeric, 2) AS equity_premium_gap,
    CASE
        WHEN ((real_dividend / real_price * 100) - long_interest_rate) > 0 
            THEN '✅ Equity outperforming Bonds'
        ELSE '⚠️ Bonds outperforming Equities (Risk Zone)'
    END AS market_condition
FROM sp500
WHERE EXTRACT(YEAR FROM date) BETWEEN 1950 AND 2023
ORDER BY date;


-- ===========================================
-- 🧮 STEP 4: ANNUAL AVERAGES SUMMARY
-- ===========================================
-- Compute yearly averages for key financial indicators
SELECT
    DATE_PART('year', date) AS year,
    ROUND(AVG(real_price)::numeric, 2) AS avg_real_price,
    ROUND(AVG(real_earnings)::numeric, 2) AS avg_real_earnings,
    ROUND(AVG(real_dividend)::numeric, 2) AS avg_real_dividend,
    ROUND(AVG(pe10)::numeric, 2) AS avg_pe10
FROM sp500
GROUP BY DATE_PART('year', date)
ORDER BY year;


-- ===========================================
-- 📊 STEP 5: YEARLY GROWTH RATES
-- ===========================================
-- Calculate YoY growth for real price, earnings, and dividends
WITH yearly_data AS (
    SELECT
        DATE_PART('year', date) AS year,
        ROUND(AVG(real_price)::numeric, 2) AS avg_real_price,
        ROUND(AVG(real_earnings)::numeric, 2) AS avg_real_earnings,
        ROUND(AVG(real_dividend)::numeric, 2) AS avg_real_dividend
    FROM sp500
    GROUP BY DATE_PART('year', date)
)
SELECT
    year,
    avg_real_price,
    avg_real_earnings,
    avg_real_dividend,
    ROUND(((avg_real_price - LAG(avg_real_price) OVER (ORDER BY year)) / LAG(avg_real_price) OVER (ORDER BY year)) * 100, 2) AS price_growth_percent,
    ROUND(((avg_real_earnings - LAG(avg_real_earnings) OVER (ORDER BY year)) / LAG(avg_real_earnings) OVER (ORDER BY year)) * 100, 2) AS earnings_growth_percent,
    ROUND(((avg_real_dividend - LAG(avg_real_dividend) OVER (ORDER BY year)) / LAG(avg_real_dividend) OVER (ORDER BY year)) * 100, 2) AS dividend_growth_percent
FROM yearly_data
ORDER BY year;


-- ===========================================
-- 📆 STEP 6: DECADE-WISE PERFORMANCE SUMMARY
-- ===========================================
-- Aggregate data by decade and compute average growth percentages
WITH yearly_data AS (
    SELECT
        DATE_PART('year', date) AS year,
        ROUND(AVG(real_price)::numeric, 2) AS avg_real_price,
        ROUND(AVG(real_earnings)::numeric, 2) AS avg_real_earnings,
        ROUND(AVG(real_dividend)::numeric, 2) AS avg_real_dividend
    FROM sp500
    GROUP BY DATE_PART('year', date)
),
growth_data AS (
    SELECT
        year,
        avg_real_price,
        avg_real_earnings,
        avg_real_dividend,
        ROUND(((avg_real_price - LAG(avg_real_price) OVER (ORDER BY year)) / LAG(avg_real_price) OVER (ORDER BY year)) * 100, 2) AS price_growth_percent,
        ROUND(((avg_real_earnings - LAG(avg_real_earnings) OVER (ORDER BY year)) / LAG(avg_real_earnings) OVER (ORDER BY year)) * 100, 2) AS earnings_growth_percent,
        ROUND(((avg_real_dividend - LAG(avg_real_dividend) OVER (ORDER BY year)) / LAG(avg_real_dividend) OVER (ORDER BY year)) * 100, 2) AS dividend_growth_percent
    FROM yearly_data
)
SELECT
    (FLOOR(year / 10) * 10) AS decade,
    ROUND(AVG(avg_real_price)::numeric, 2) AS decade_avg_price,
    ROUND(AVG(avg_real_earnings)::numeric, 2) AS decade_avg_earnings,
    ROUND(AVG(avg_real_dividend)::numeric, 2) AS decade_avg_dividend,
    ROUND(AVG(price_growth_percent)::numeric, 2) AS avg_price_growth_percent,
    ROUND(AVG(earnings_growth_percent)::numeric, 2) AS avg_earnings_growth_percent,
    ROUND(AVG(dividend_growth_percent)::numeric, 2) AS avg_dividend_growth_percent
FROM growth_data
GROUP BY (FLOOR(year / 10) * 10)
ORDER BY decade;


-- ===========================================
-- 🧭 STEP 7: MARKET CYCLES AND INFLATION IMPACT
-- ===========================================
-- Compare market real growth with inflation (CPI) to identify cycles
WITH yearly_data AS (
    SELECT
        DATE_PART('year', date) AS year,
        ROUND(AVG(real_price)::numeric, 2) AS avg_real_price,
        ROUND(AVG(consumer_price_index)::numeric, 2) AS avg_cpi
    FROM sp500
    WHERE EXTRACT(YEAR FROM date) BETWEEN 1950 AND 2023
    GROUP BY DATE_PART('year', date)
),
growth_data AS (
    SELECT
        year,
        avg_real_price,
        avg_cpi,
        ROUND(((avg_real_price - LAG(avg_real_price) OVER (ORDER BY year)) 
              / LAG(avg_real_price) OVER (ORDER BY year) * 100)::numeric, 2) AS real_price_growth,
        ROUND(((avg_cpi - LAG(avg_cpi) OVER (ORDER BY year)) 
              / LAG(avg_cpi) OVER (ORDER BY year) * 100)::numeric, 2) AS inflation_rate
    FROM yearly_data
)
SELECT
    year,
    avg_real_price,
    avg_cpi,
    real_price_growth,
    inflation_rate,
    CASE
        WHEN real_price_growth > inflation_rate THEN '📈 Market outperforming inflation (Positive Cycle)'
        WHEN real_price_growth < inflation_rate THEN '📉 Market lagging inflation (Negative Cycle)'
        ELSE '⚖️ Stable phase'
    END AS market_cycle_status
FROM growth_data
ORDER BY year;


-- ===========================================
-- 📊 STEP 8: CORRELATION ANALYSIS
-- ===========================================
-- Analyze statistical correlation between major indicators
WITH yearly_data AS (
    SELECT
        DATE_PART('year', date) AS year,
        ROUND(AVG(real_price)::numeric, 2) AS avg_real_price,
        ROUND(AVG(real_earnings)::numeric, 2) AS avg_real_earnings,
        ROUND(AVG(consumer_price_index)::numeric, 2) AS avg_cpi
    FROM sp500
    WHERE EXTRACT(YEAR FROM date) BETWEEN 1950 AND 2023
    GROUP BY DATE_PART('year', date)
)
SELECT
    ROUND(CORR(avg_real_price, avg_real_earnings)::numeric, 3) AS corr_price_earnings,
    ROUND(CORR(avg_real_price, avg_cpi)::numeric, 3) AS corr_price_cpi,
    ROUND(CORR(avg_real_earnings, avg_cpi)::numeric, 3) AS corr_earnings_cpi
FROM yearly_data;


-- ===========================================
-- 🤖 STEP 9: LINEAR REGRESSION ANALYSIS
-- ===========================================
-- Build linear regression models for Real Price vs Earnings and CPI
WITH yearly_data AS (
    SELECT
        DATE_PART('year', date) AS year,
        ROUND(AVG(real_price)::numeric, 2) AS avg_real_price,
        ROUND(AVG(real_earnings)::numeric, 2) AS avg_real_earnings,
        ROUND(AVG(consumer_price_index)::numeric, 2) AS avg_cpi
    FROM sp500
    WHERE EXTRACT(YEAR FROM date) BETWEEN 1950 AND 2023
    GROUP BY DATE_PART('year', date)
)
SELECT 
    ROUND(REGR_SLOPE(avg_real_price, avg_real_earnings)::numeric, 4) AS slope_earnings,
    ROUND(REGR_INTERCEPT(avg_real_price, avg_real_earnings)::numeric, 4) AS intercept_earnings,
    ROUND(REGR_R2(avg_real_price, avg_real_earnings)::numeric, 4) AS r2_earnings,
    ROUND(REGR_SLOPE(avg_real_price, avg_cpi)::numeric, 4) AS slope_cpi,
    ROUND(REGR_INTERCEPT(avg_real_price, avg_cpi)::numeric, 4) AS intercept_cpi,
    ROUND(REGR_R2(avg_real_price, avg_cpi)::numeric, 4) AS r2_cpi
FROM yearly_data;


-- ===========================================
-- 🔮 STEP 10: FORECASTING MODEL (LINEAR TREND)
-- ===========================================
-- Predict future real prices (2024–2030) using regression trend line
WITH yearly_data AS (
    SELECT
        DATE_PART('year', date) AS year,
        ROUND(AVG(real_price)::numeric, 2) AS avg_real_price,
        ROUND(AVG(real_earnings)::numeric, 2) AS avg_real_earnings
    FROM sp500
    WHERE EXTRACT(YEAR FROM date) BETWEEN 1950 AND 2023
    GROUP BY DATE_PART('year', date)
),
regression_stats AS (
    SELECT
        REGR_SLOPE(avg_real_price, year) AS slope,
        REGR_INTERCEPT(avg_real_price, year) AS intercept,
        REGR_R2(avg_real_price, year) AS r2
    FROM yearly_data
),
forecast_years AS (
    SELECT generate_series(2024, 2030) AS year
)
SELECT 
    f.year,
    ROUND((r.intercept + r.slope * f.year)::numeric, 2) AS forecast_real_price,
    ROUND(r.slope::numeric, 4) AS slope,
    ROUND(r.intercept::numeric, 2) AS intercept,
    ROUND(r.r2::numeric, 4) AS r_squared
FROM forecast_years f
CROSS JOIN regression_stats r
ORDER BY f.year;
