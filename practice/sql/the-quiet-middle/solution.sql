-- WITH cte AS (
--   SELECT
--     job_name,
--     SUM(rows_done) AS total_row
--   FROM batch_jobs
--   GROUP BY job_name
-- ),
with cte2 AS (
  SELECT
    job_name,
    DENSE_RANK() OVER (
      ORDER BY rows_done desc
    ) AS rnk
  FROM batch_jobs
)

SELECT
  job_name,
  rnk
FROM cte2
WHERE rnk > 7
  AND rnk < 11
order by rnk
