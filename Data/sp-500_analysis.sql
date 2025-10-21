-- ===========================================
-- 📊 REAL RETURNS AND DIVIDEND YIELDS ANALYSIS
-- ===========================================
SELECT
    date,
    ROUND(real_price) AS real_price,
    ROUND(real_earnings) AS real_earnings,
    ROUND(real_dividend) AS real_dividend,
    -- Real Dividend Yield = Real Dividend / Real Price
    ROUND(real_dividend / real_price * 100) AS real_dividend_yield,
    -- Real Earnings Yield = Real Earnings / Real Price
    ROUND(real_earnings / real_price * 100) AS real_earnings_yield
FROM sp500
ORDER BY date;

-- ===========================================
-- 📈 YEAR-OVER-YEAR REAL PRICE GROWTH
-- ===========================================
WITH yearly_avg AS (
    SELECT 
        EXTRACT(YEAR FROM date) AS year,
        -- Average real (inflation-adjusted) price per year
        AVG(real_price) AS avg_real_price
    FROM sp500
    GROUP BY EXTRACT(YEAR FROM date)
)
SELECT 
    year,
    -- YoY growth = (Current Year Avg / Previous Year Avg - 1) * 100
    ROUND((avg_real_price / LAG(avg_real_price) OVER (ORDER BY year) - 1) * 100) AS yoy_real_growth
FROM yearly_avg
ORDER BY year;

-- ===========================================
-- 💰 EQUITY PREMIUM GAP ANALYSIS
-- (Dividend Yield - Long-Term Interest Rate)
-- ===========================================
SELECT
    date,
    -- Dividend yield represents stock income return
    ROUND(real_dividend / real_price * 100) AS dividend_yield,
    long_interest_rate,
    -- Equity Premium = Dividend Yield - Long-term Bond Yield
    ROUND((real_dividend / real_price * 100) - long_interest_rate) AS equity_premium_gap
FROM sp500
ORDER BY date;

-- ===========================================
-- 🧮 VALUATION STATUS BASED ON SHILLER PE10
-- ===========================================
SELECT 
    date,
    pe10,
    -- Classification based on CAPE (PE10) ratio
    CASE 
        WHEN pe10 < 10 THEN 'Undervalued'       -- Cheap market
        WHEN pe10 BETWEEN 10 AND 25 THEN 'Fairly Valued' -- Reasonable valuation
        ELSE 'Overvalued'                       -- Potentially expensive market
    END AS valuation_status
FROM sp500
ORDER BY date;

-- ===========================================
-- 🧾 TOTAL FUNDAMENTAL YIELD (Earnings + Dividends)
-- ===========================================
SELECT 
    date,
    -- Total return potential from fundamentals
    ROUND((real_dividend + real_earnings) / real_price * 100) AS total_fundamental_yield
FROM sp500
ORDER BY date;

-- ===========================================
-- ⚠️ ECONOMIC SIGNAL DETECTION (RECESSION RISK)
-- When Long-term Interest Rate > Earnings Yield
-- ===========================================
SELECT 
    date,
    -- Earnings Yield = Real Earnings / Real Price
    ROUND(real_earnings / real_price * 100) AS earnings_yield,
    long_interest_rate,
    CASE
        WHEN long_interest_rate > (real_earnings / real_price * 100)
        THEN ' Potential Recession'   -- Bonds outperform stocks -> Risk of downturn
        ELSE ' Stable'                -- Market conditions stable
    END AS economic_signal
FROM sp500
ORDER BY date;

-- ===========================================
-- 📈 12-MONTH MOVING AVERAGE OF REAL PRICE
-- (Used to identify long-term market trends)
-- ===========================================
SELECT 
    date,
    real_price,
    ROUND(AVG(real_price) OVER (ORDER BY date ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)) AS ma_12
FROM sp500
ORDER BY date;

-- ===========================================
-- 📉 12-MONTH ROLLING VOLATILITY OF REAL PRICE
-- (Risk measurement - price fluctuation)
-- ===========================================
SELECT 
    date,
    ROUND(STDDEV(real_price) OVER (ORDER BY date ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)) AS rolling_volatility
FROM sp500
ORDER BY date;

-- ===========================================
-- 🧠 INFLATION IMPACT ANALYSIS
-- Comparing nominal vs real price returns
-- ===========================================
WITH nominal_growth AS (
    SELECT 
        date,
        -- Nominal return = unadjusted for inflation
        ROUND((sp500 / LAG(sp500) OVER (ORDER BY date) - 1) * 100) AS nominal_return
    FROM sp500
),
real_growth AS (
    SELECT 
        date,
        -- Real return = adjusted for inflation
        ROUND((real_price / LAG(real_price) OVER (ORDER BY date) - 1) * 100) AS real_return
    FROM sp500
)
SELECT 
    n.date,
    n.nominal_return,
    r.real_return,
    -- Inflation impact = Nominal - Real return
    ROUND(n.nominal_return - r.real_return) AS inflation_impact
FROM nominal_growth n
JOIN real_growth r USING (date);

-- ===========================================
-- 🐂🐻 MARKET CYCLE DETECTION (Bull vs Bear)
-- Based on 12-Month Moving Average Trend
-- ===========================================
WITH ma_trend AS (
    SELECT 
        date,
        real_price,
        ROUND(AVG(real_price) OVER (ORDER BY date ROWS BETWEEN 11 PRECEDING AND CURRENT ROW)) AS ma_12
    FROM sp500
)
SELECT 
    date,
    real_price,
    ma_12,
    CASE 
        WHEN real_price > ma_12 THEN ' Bull Market'  -- Price above moving average
        ELSE ' Bear Market'                          -- Price below moving average
    END AS market_cycle
FROM ma_trend
ORDER BY date;
