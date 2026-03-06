-- =====================================
-- STEP 10: CRISIS DETECTION
-- Inqiroz aniqlash
-- =====================================

WITH r AS (

SELECT
year,
(sp500 / LAG(sp500) OVER (ORDER BY year) - 1) AS annual_return

FROM sp500_annual
)

SELECT
year,
annual_return,

CASE
WHEN annual_return < -0.30 THEN 'Crash'
WHEN annual_return < -0.15 THEN 'Bear Market'
ELSE 'Normal'
END AS market_condition

FROM r;