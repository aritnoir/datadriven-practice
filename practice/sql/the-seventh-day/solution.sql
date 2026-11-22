WITH active_users AS (
    SELECT
        user_id,
        signup_date::date AS signup_day,
        signup_date::timestamp AS signup_ts,
        TO_CHAR(signup_date::date, 'YYYY-MM') AS cohort_month
    FROM users
    WHERE LOWER(account_status) != 'pending_verification' --'active'
),
user_return_status AS (
    SELECT
        au.cohort_month,
        au.user_id,
        MAX(
            CASE
                WHEN pv.viewed_at >= au.signup_ts + INTERVAL '7 days' THEN 1
                ELSE 0
            END
        ) AS returned_7d_plus
    FROM active_users au
    LEFT JOIN page_views pv
        ON pv.user_id = au.user_id
    GROUP BY
        au.cohort_month,
        au.user_id
)
SELECT
    cohort_month,
    COUNT(*) AS total_signups,
    SUM(returned_7d_plus) AS retained_users,
    ROUND(
        (SUM(returned_7d_plus)::numeric * 100.0) / NULLIF(COUNT(*), 0),
        1
    ) AS retention_pct
FROM user_return_status
GROUP BY cohort_month
ORDER BY cohort_month ASC;

-- select distinct account_Status from users;
-- select * from users where signup_date < '2024-01-01'
