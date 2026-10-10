SELECT
  LOWER(framework),
  ROUND(AVG(accuracy), 2)
FROM ml_models
WHERE version LIKE "%2.0%"
  OR version LIKE "1.%"
  OR version LIKE "v1.%"
GROUP BY 1
