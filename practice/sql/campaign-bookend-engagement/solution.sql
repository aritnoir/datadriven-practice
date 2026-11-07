WITH campaign_range AS (
    SELECT 
        ad_campaign,
        MIN(impression_time::date) AS first_day,
        MAX(impression_time::date) AS last_day,
        COUNT(*) AS total_impressions
    FROM ad_impressions
    GROUP BY ad_campaign
),
bookend_counts AS (
    SELECT 
        t.ad_campaign,
        r.total_impressions,
        SUM(CASE WHEN t.impression_time::date = r.first_day THEN 1 ELSE 0 END) 
    AS first_day_impressions,
        SUM(CASE WHEN t.impression_time::date = r.last_day THEN 1 ELSE 0 END) 
    AS last_day_impressions
    FROM ad_impressions t
    JOIN campaign_range r ON t.ad_campaign = r.ad_campaign
    GROUP BY t.ad_campaign, r.total_impressions
)
SELECT 
    ad_campaign,
    (first_day_impressions * 100.0 / total_impressions) AS first_day_pct,
    (last_day_impressions * 100.0 / total_impressions) AS last_day_pct
FROM bookend_counts
ORDER BY ad_campaign ASC;
