-- =====================================
-- STEP 11: WAR IMPACT
-- Urush ta'siri
-- =====================================

SELECT
year,
sp500,
(pe10),
long_interest_rate

FROM sp500_annual

WHERE year BETWEEN 1914 AND 1918
   OR year BETWEEN 1939 AND 1945

ORDER BY year;