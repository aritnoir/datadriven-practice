# -- SQL
# -- SELECT
# --   LOWER(framework),
# --   ROUND(AVG(accuracy), 2)
# -- FROM ml_models
# -- WHERE version LIKE "%2.0%"
# --   OR version LIKE "1.%"
# --   OR version LIKE "v1.%"
# -- GROUP BY 1

# -- SPARK

# df = (ml_models.
#       .filter(
#         F.col("version").like("%2.0%") |
#         F.col("version").like("1.%") |
#         F.col("version").like("v1.%"))
#       .groupBy(F.lower(F.col("framework")))
#       .agg(F.round(F.avg(F.col("accuracy")),2))
#   )
      
df = (
  ml_models
  .filter(
    F.col("version").like("%2.0%") |
    F.col("version").like("1.%") |
    F.col("version").like("v1.%")
  )
  .groupBy(F.lower(F.col("framework")))
  .agg(F.round(F.avg(F.col("accuracy")), 2))  # Fixed parentheses and arguments
)
