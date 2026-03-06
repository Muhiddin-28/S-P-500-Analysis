-- =====================================
-- STEP 6: DIVIDEND YIELD
-- Dividend daromadi
-- =====================================

SELECT
year,
dividend,
sp500,

(dividend / sp500) AS dividend_yield

FROM sp500_annual;