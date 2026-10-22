WITH jobs AS (
    SELECT job_id,
           MIN(started) AS s,
           MAX(ended)   AS e
    FROM batch_jobs
    GROUP BY job_id
    HAVING SUM(CASE WHEN LOWER(TRIM(status)) = 'completed' THEN 1 ELSE 0 END) > 0
       AND MIN(started) IS NOT NULL
       AND MAX(ended)   IS NOT NULL
),
events AS (
    SELECT s AS ts,  1 AS delta FROM jobs
    UNION ALL
    SELECT e AS ts, -1 AS delta FROM jobs
),
running AS (
    SELECT SUM(delta) OVER (
               ORDER BY ts, delta DESC      -- +1 (start) before -1 (end) at the same ts
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS workers
    FROM events
)
SELECT MAX(workers) AS min_parallel_workers
FROM running;
