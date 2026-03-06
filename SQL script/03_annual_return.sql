-- =====================================
-- STEP 4: ANNUAL RETURN
-- Yillik return
-- =====================================

SELECT
year,
sp500,

(sp500 / LAG(sp500) OVER (ORDER BY year) - 1)
AS annual_return

FROM sp500_annual;