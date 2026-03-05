-- =====================================
-- STEP 5: REAL RETURN
-- Inflyatsiya hisobga olingan return
-- =====================================

SELECT
year,
real_price,

(real_price / LAG(real_price) OVER (ORDER BY year) - 1)
AS real_return

FROM sp500_annual;