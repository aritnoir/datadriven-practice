select
  count (distinct owner_id) as distinct_owners
  from
    api_tokens
  where issued >= "2026-01-01"
