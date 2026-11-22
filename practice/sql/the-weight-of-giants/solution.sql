WITH service_per_region_cost AS
(SELECT 
region,  svc_name,  SUM(amount) AS total_spend 
FROM 
  cloud_costs 
GROUP BY 1,  2),
costliest_services_per_region AS(
  SELECT region,  svc_name,  total_spend,  
  row_number() OVER(partition by region ORDER BY total_spend DESC) AS rnk 
  FROM 
    service_per_region_cost)
SELECT
  region,
  svc_name,
  total_spend
FROM 
  costliest_services_per_region
WHERE rnk < 3
order by total_spend desc
