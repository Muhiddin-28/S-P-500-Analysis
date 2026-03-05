-- =====================================
-- STEP 8: MARKET DRAWDOWN
-- Peakdan tushish
-- =====================================

WITH m AS (

SELECT
year,
sp500,
MAX(sp500) OVER (ORDER BY year) AS rolling_max

FROM sp500_annual
)

SELECT
year,
sp500,
rolling_max,

(sp500 / rolling_max - 1) AS drawdown

FROM m;