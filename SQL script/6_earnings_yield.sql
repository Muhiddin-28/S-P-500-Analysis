-- =====================================
-- STEP 7: EARNINGS YIELD
-- Earnings daromadi
-- =====================================

SELECT
year,
earnings,
sp500,

(earnings / sp500) AS earnings_yield

FROM sp500_annual;