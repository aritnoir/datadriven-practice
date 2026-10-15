with cte as (
select 
  category,
  product_name,
  sum(total_amount) as total_revenue
from transactions as t inner join products as p on
      t.product_id = p.product_id
WHERE EXTRACT(YEAR FROM t.transaction_date::timestamp) = EXTRACT(YEAR FROM CURRENT_DATE)
group by 1, 2),
cte2 as(
select
  category,
  product_name,
  total_revenue,
  row_number() over(partition by category order by total_revenue desc) as rn
from cte
)
select
  category,
  product_name,
  total_revenue
from cte2
where rn = 1
order by 3 desc
