WITH service_averages AS (
    -- Step 1: Calculate the average uptime for each service across all health checks
    SELECT 
        svc_name,
        AVG(uptime) AS avg_uptime
    FROM svc_health
    GROUP BY svc_name
),
tiered_services AS (
    -- Step 2: Split the services into 4 equal tiers based on average uptime (ascending order)
    -- Tier 1 = weakest, Tier 4 = strongest
    SELECT 
        svc_name,
        avg_uptime,
        NTILE(4) OVER (ORDER BY avg_uptime ASC) AS tier
    FROM service_averages
),
fleet_stats AS (
    -- Step 3: Find the maximum uptime across the entire fleet
    SELECT MAX(avg_uptime) AS max_fleet_uptime
    FROM service_averages
),
tier_stats AS (
    -- Step 4: Find the maximum uptime within each specific tier
    SELECT 
        tier,
        MAX(avg_uptime) AS max_tier_uptime
    FROM tiered_services
    GROUP BY tier
)
-- Step 5: Filter for the two weakest tiers (1 and 2) and calculate the metrics
SELECT 
    t.svc_name,
    t.avg_uptime,
    (f.max_fleet_uptime - t.avg_uptime) AS diff_from_fleet_max,
    (ts.max_tier_uptime - t.avg_uptime) AS diff_from_tier_max
FROM tiered_services t
CROSS JOIN fleet_stats f
JOIN tier_stats ts ON t.tier = ts.tier
WHERE t.tier IN (1, 2)
ORDER BY t.avg_uptime ASC;
