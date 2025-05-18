SELECT
p.id,
sa.id AS owner_id,

-- Search for plan type from name or description column
CASE
WHEN LOWER(p.name) LIKE '%savings%' OR LOWER(p.description) LIKE '%saving%'
	THEN 'savings'
WHEN LOWER(p.name) LIKE '%investment%' OR LOWER(p.description) LIKE '%investment%'
	THEN 'investment'
ELSE 'savings'
END AS type,
MAX(sa.transaction_date) AS last_transaction_date,
DATEDIFF(CURDATE(), MAX(sa.transaction_date)) as inactivity_days
FROM
savings_savingsaccount sa
JOIN
plans_plan p ON sa.plan_id = p.id
GROUP BY
p.id, sa.id, type

-- Only include accounts with no activity in the past 365 days
HAVING
last_transaction_date < CURDATE() - INTERVAL 365 DAY
ORDER BY
