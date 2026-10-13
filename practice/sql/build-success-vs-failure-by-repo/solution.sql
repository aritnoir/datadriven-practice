with cte as (select
  repo_name,
  case
    when status = "success" then 1 else 0 end as success_count,
  case
    when status = 'failure' then 1 else 0 end as failure_count,
   dur_secs
from ci_builds )
select
  repo_name,
  sum(success_count) as success_count,
  sum(failure_count) as failure_count,
  avg(dur_secs) as avg_duration
from cte
group by 1
