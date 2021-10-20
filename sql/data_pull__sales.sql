WITH tmp_variables AS (
         SELECT '2020-01-01' AS beg_date, CURRENT_DATE-1 AS end_date
         )
 SELECT
    created_date AS date,
    product_sub_type,
    size,
    function,
    CASE
        WHEN LEFT(style,2) = 'sw' OR
             LEFT(style,2) = 'dy' OR
             collection ILIKE '%disney%' OR
             LEFT(style,2) = 'cr' THEN 'licensed'
        ELSE 'non-licensed'
        END as rug_collection,
    SUM(rug_quantity) AS quantity
FROM shopify_ruggable.mv_ruggable_shopify_orders_detailed o
WHERE disc_equals_gross = 'include'
-- AND product_type = 'Rug'
AND function IN ('Outdoor','Indoor')
AND customer_email IS NOT NULL
--AND return_date IS NULL
AND product_sub_type IN ('Classic System','Cushioned System')
AND created_date BETWEEN (SELECT beg_date FROM tmp_variables) AND (SELECT end_date FROM tmp_variables)
GROUP BY 1,2,3,4,5
ORDER BY 1,2,3,4,5