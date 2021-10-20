WITH tmp_variables AS (
        SELECT '2020-01-01' AS beg_date, CURRENT_DATE-1 AS end_date
)
SELECT time::DATE AS date,
       COUNT(DISTINCT session_id) AS num_sessions
FROM heap.sessions p
WHERE p.time::DATE BETWEEN (SELECT beg_date FROM tmp_variables) AND (SELECT end_date FROM tmp_variables)
GROUP BY 1
ORDER BY 1;