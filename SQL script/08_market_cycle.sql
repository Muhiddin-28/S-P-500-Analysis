-- =====================================
-- STEP 9: MARKET CYCLES
-- Bozor sikllari
-- =====================================

WITH draw AS (

SELECT
year,
sp500,
MAX(sp500) OVER (ORDER BY year) AS peak

FROM sp500_annual
)

SELECT
year,
sp500,
peak,

(sp500 / peak - 1) AS drawdown

FROM draw;