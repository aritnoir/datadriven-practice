WITH cte AS (
  SELECT
    team_name,
    CASE
      WHEN category = 'compute' THEN 1
      ELSE 0
    END AS compute,
    amount
  FROM cost_allocs
)

SELECT
  team_name,
  SUM(compute) AS compute_count,
  SUM(amount) AS total_cost
FROM cte
GROUP BY team_name
