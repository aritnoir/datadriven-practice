with cte as (select
  nspace,
  pod_name,
  mem_used,
  row_number() OVER(partition by nspace order by mem_used, pod_name) as rn
from
  k8s_pods
where mem_used is not null
)
select * from cte where rn = 1
