select
  user_id,
  username,
  email,
  token_id,
  scope
from
  api_tokens inner join users
    on api_tokens.owner_id = users.user_id
where scope like '%admin'
order by user_id, issued
