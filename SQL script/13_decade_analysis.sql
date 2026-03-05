-- =====================================
-- STEP 14: DECADE ANALYSIS
-- O'n yillik bozor o'sishi
-- =====================================

WITH r AS (

SELECT
year,
(sp500 / LAG(sp500) OVER (ORDER BY year) - 1)
AS annual_return

FROM sp500_annual
)

SELECT
FLOOR(year/10)*10 AS decade,
AVG(annual_return) AS avg_return

FROM r
GROUP BY decade
ORDER BY decade;