-- Summarize users into frequency categories and show count and average transactions per user
SELECT
frequency_category,
COUNT(*) AS customer_count,
ROUND(AVG(avg_transactions_per_month), 2) AS average_transactions_per_user
FROM(
-- Subquery to compute frequency category and avg transactions per user
SELECT
u.id AS user_id,
-- Calculate average transactions per month then divide total transactions by the number of months between first and last transaction
ROUND(
COUNT(sa.owner_id)/
GREATEST(
	TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), MAX(sa.transaction_date)) +1, 1
    ), 2
    ) AS avg_transactions_per_month,
-- Categorize users based on the average monthly transaction volume
    CASE
		WHEN COUNT(sa.owner_id)/
			GREATEST(TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), MAX(sa.transaction_date)) +1, 1) >= 10
            THEN 'High frequency'
		WHEN COUNT(sa.owner_id)/
			GREATEST(TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), MAX(sa.transaction_date)) +1, 1) BETWEEN 3 AND 9
            THEN 'Medium frequency'
		ELSE 'Low frequency'
END AS frequency_category
FROM
users_customuser u
JOIN
savings_savingsaccount sa ON u.id = sa.owner_id
GROUP BY
u.id
) AS user_summary
GROUP BY
frequency_category
ORDER BY
FIELD(frequency_category, 'High frequency', 'Medium frequency', 'Low frequency');
