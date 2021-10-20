WITH tmp_variables AS (
    SELECT '2020-01-01' AS beg_date, CURRENT_DATE-1 AS end_date
)
SELECT m.date::DATE AS date,
       SUM(m.spend) AS total_spend,
       SUM(CASE WHEN advertiser = 'Facebook' THEN m.spend ELSE 0 END) AS fb_spend,
       SUM(CASE WHEN advertiser = 'Google Adwords' THEN m.spend ELSE 0 END) AS google_spend,
       SUM(CASE WHEN advertiser = 'Pinterest' THEN m.spend ELSE 0 END) AS pinterest_spend,
       SUM(CASE WHEN advertiser = 'Bing' THEN m.spend ELSE 0 END) AS bing_spend
FROM public.mv_view_pivot_daily_all m
WHERE m.date::DATE BETWEEN (SELECT beg_date FROM tmp_variables) AND (SELECT end_date FROM tmp_variables)
GROUP BY 1
ORDER BY 1;