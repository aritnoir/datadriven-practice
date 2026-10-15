WITH product_revenue AS (
    -- Step 1: Join transactions and products, filter for the current year, and aggregate total sales
    SELECT 
        p.category,
        p.product_name,
        SUM(t.total_amount) AS total_revenue,
        -- Step 2: Rank products within each category by revenue in descending order
        ROW_NUMBER() OVER (PARTITION BY p.category ORDER BY SUM(t.total_amount) DESC) AS rank_num
    FROM transactions t
    JOIN products p ON t.product_id = p.product_id
    WHERE EXTRACT(YEAR FROM t.transaction_date::timestamp) = EXTRACT(YEAR FROM CURRENT_DATE)
    GROUP BY p.category, p.product_name
)
-- Step 3: Filter for the top product in each category and sort from biggest earner down
SELECT 
    category,
    product_name,
    total_revenue
FROM product_revenue
WHERE rank_num = 1
ORDER BY total_revenue DESC;
