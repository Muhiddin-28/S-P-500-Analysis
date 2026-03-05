-- =====================================
-- STEP 13: MARKET VALUATION
-- PE10 tahlili
-- =====================================

SELECT
year,
pe10,

CASE
WHEN pe10 > 25 THEN 'Overvalued'
WHEN pe10 BETWEEN 15 AND 25 THEN 'Fair'
ELSE 'Undervalued'
END AS valuation

FROM sp500_annual;