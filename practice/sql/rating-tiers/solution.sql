with cte as(
select
  product_name,
  category,
  rating,
  floor(rating) as whole_rating
from 
  products
)
select
  product_name,
  category,
  rating,
  dense_rank() over(partition by category order by whole_rating desc) as postion
from 
  cte
where 
  -- category = 'Automotive' and 
rating is not null
order by 2 asc, 3 desc, 1 desc
