with cte as (select
  case
    when lower(trim(err_type)) like '%timeout%' then 'timeout'
    when lower(trim(err_type)) like '%memory%' then 'memory'
    else 'other'
    end as error_category
from err_tracks)
select 
  error_category,
  count(1)
from cte
group by 1
