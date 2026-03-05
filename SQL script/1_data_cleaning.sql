-- =====================================
-- STEP 2: DATA CLEANING
-- Ma'lumotlarni tozalash
-- =====================================

-- UZ: bo'sh qiymatlarni aniqlash
-- EN: detect missing values

SELECT
COUNT(*) total_rows,
COUNT(sp500) price_count,
COUNT(dividend) dividend_count,
COUNT(earnings) earnings_count,
COUNT(pe10) pe_count
FROM sp500;