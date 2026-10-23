select
  lower(trim(svc_name)),
  lower(trim(status)),
  sum(dur_secs)
from
  deploy_logs
group by 1, 2
