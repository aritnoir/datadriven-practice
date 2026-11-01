-- select
--   distinct campaign
-- from push_notifs
-- where lower(status) = 'delivered' 

select
ad_campaign,
count(1),
round((sum(clicked)*100.0)/count(1), 2),
100 - round((sum(clicked)*100.0)/count(1), 2)
from ad_impressions
group by 1
