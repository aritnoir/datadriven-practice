select
  coalesce(ack_by, "unassigned"),
  count(alert_id)
from alert_events
  group by 1
