-- =====================================
-- STEP 3: CREATE ANNUAL DATA
-- Yillik dataset
-- =====================================

CREATE VIEW sp500_annual AS

SELECT DISTINCT ON (EXTRACT(YEAR FROM date))

EXTRACT(YEAR FROM date) AS year,
sp500,
dividend,
earnings,
consumer_price_index,
long_interest_rate,
real_price,
real_dividend,
real_earnings,
pe10

FROM sp500
ORDER BY EXTRACT(YEAR FROM date), date DESC;