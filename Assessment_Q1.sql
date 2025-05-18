SHOW DATABASES;
USE adashi_staging;
SHOW TABLES;
-- QUESTION 1

SELECT
u.id AS owner_id,
concat(first_name, ' ', last_name) AS full_name,
-- Count the number of funded savings and investment plans per user
-- A plan is considered "savings" or "investment" if either the plan's name or description contains the respective keyword (case-insensitive).
-- Each count is based on distinct savings account IDs tied to matching plans.
COUNT(DISTINCT CASE 
WHEN LOWER(p.name) LIKE '%savings%'
	OR LOWER(p.description) LIKE '%savings%' 
THEN sa.owner_id END) AS savings_count,
COUNT(DISTINCT CASE 
WHEN LOWER(p.name) LIKE '%investment%'
  OR LOWER(p.description) LIKE '%investment%'
 THEN sa.owner_id END) AS investment_count,
SUM(sa.amount) AS total_deposits
FROM
users_customuser u
JOIN
savings_savingsaccount sa ON u.id = sa.owner_id
JOIN
plans_plan p ON sa.id = p.owner_id
where
sa.amount > 0
group by
u.id, full_name
HAVING
savings_count >=1
AND
investment_count >=1
ORDER BY
total_deposits DESC
