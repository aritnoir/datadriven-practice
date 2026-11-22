with api_max_latency as (
select
  TRIM(BOTH '·' FROM endpoint) as end_points,
  -- replace(endpoint, '·', ''),
  max(latency) as max_latency
from
  api_calls
group by 1
),
ranked_latency as(
select
  end_points,
  max_latency,
  row_number() over(order by max_latency desc) as rnk
from
  api_max_latency
)
select * from ranked_latency where rnk <= 10
