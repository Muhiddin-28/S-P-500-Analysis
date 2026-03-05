-- =====================================
-- STEP 12: INTEREST RATE ANALYSIS
-- Foiz stavkasi ta'siri
-- =====================================

SELECT
year,
long_interest_rate,

(sp500 / LAG(sp500) OVER (ORDER BY year) - 1)
AS annual_return

FROM sp500_annual;