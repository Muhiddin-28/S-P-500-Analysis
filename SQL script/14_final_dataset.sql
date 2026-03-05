-- =====================================
-- STEP 15: FINAL ANALYSIS DATASET
-- Yakuniy tahlil jadvali
-- =====================================

CREATE VIEW sp500_final_analysis AS

SELECT
year,
sp500,
dividend,
earnings,
pe10,
long_interest_rate,

(sp500 / LAG(sp500) OVER (ORDER BY year) - 1)
AS annual_return,

(dividend / sp500) AS dividend_yield,

(earnings / sp500) AS earnings_yield

FROM sp500_annual;