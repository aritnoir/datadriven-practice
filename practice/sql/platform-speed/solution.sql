select
  device_type,
  avg(session_duration_sec),
  max(session_duration_sec),
  count(session_id)
from
  user_sessions inner join devices
    using(device_id)
group by device_type
having count(session_id) > 34
