from pyspark.sql import functions as F
from pyspark.sql.window import Window

# Assuming your input DataFrame is named `svc_health`

# Step 1: Calculate the average uptime for each service across all health checks
service_averages = svc_health.groupBy("svc_name").agg(
    F.avg("uptime").alias("avg_uptime")
)

# Step 2: Split the services into 4 equal tiers based on average uptime (ascending order)
window_spec = Window.orderBy("avg_uptime")
tiered_services = service_averages.withColumn("tier", F.ntile(4).over(window_spec))

# Step 3: Find the maximum uptime across the entire fleet
fleet_stats = service_averages.agg(F.max("avg_uptime").alias("max_fleet_uptime"))

# Step 4: Find the maximum uptime within each specific tier
tier_stats = tiered_services.groupBy("tier").agg(
    F.max("avg_uptime").alias("max_tier_uptime")
)

# Step 5: Filter for the two weakest tiers (1 and 2), join stats, and calculate metrics
result = (
    tiered_services.filter(F.col("tier").isin(1, 2))
    .crossJoin(fleet_stats)
    .join(tier_stats, on="tier", how="inner")
    .select(
        "svc_name",
        "avg_uptime",
        (F.col("max_fleet_uptime") - F.col("avg_uptime")).alias(
            "diff_from_fleet_max"
        ),
        (F.col("max_tier_uptime") - F.col("avg_uptime")).alias(
            "diff_from_tier_max"
        ),
    )
    .orderBy("avg_uptime")
)

# Show the results
result.show(truncate=False)
