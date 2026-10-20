WITH cte AS (
  SELECT
    token_id,
    scope,
    requests,
    ROUND(
      PERCENT_RANK() OVER (
        PARTITION BY scope
        ORDER BY requests
      ),
      2
    ) AS percentile_rank
  FROM api_tokens
)

SELECT
  token_id,
  scope,
  requests,
  percentile_rank
FROM cte
where percentile_rank >= 0.95
