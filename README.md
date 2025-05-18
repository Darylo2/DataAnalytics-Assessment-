# DataAnalytics-Assessment

This repository contains optimized SQL queries for analyzing customer behavior, account activity, and estimating customer value in the Adashi database. The queries are designed using the tables below from the adashi_staging database:

users_customusers
savings_savingsaccount
plans_plan
withdrawals_withdrawal

**Query Documentation**
1. Customers with Both Funded Savings & Investment Plans
Goal: Identify users with at least one funded savings and one funded investment plan, and sort them by total deposits.
Approach:

Join users_customusers, savings_savingsaccount, and plans_plan
Filter only plans with deposits (amount > 0)
Detect plan type using keywords in name and description
Group by user and count savings vs. investment plans
Sort by total deposits


2. Frequency Categorization: Avg. Transactions per Customer per Month
Goal: Categorize customers into High, Medium, or Low frequency based on transaction activity.

Approach:
Join users_customusers and savings_savingsaccount
For each user, calculate average monthly transaction count
Categorize:
High: ≥ 10 transactions/month
Medium: 3–9
Low: ≤ 2
Group final result by frequency category


3. Inactive Accounts (>365 Days)
Goal: Detect savings or investment plans with no transactions in the last 1 year.

Approach:
Join savings_savingsaccount with plans_plan
Group by user and plan
Identify last transaction date using MAX(created_at)
Filter for inactivity > 365 days
Infer plan type from name or description


4. Customer Lifetime Value (CLV) Estimation
Goal: Estimate the CLV of each customer using transactional value and tenure.

Approach:
Join users_customusers and savings_savingsaccount

Calculate:
Tenure = months since date_joined
Total transactions and total transaction value
Profit = 0.1% of each transaction
Avg profit per transaction
CLV formula: CLV = (total_transactions)/(tenure_months)  * 12 * (average_profit_per_transaction)
Order by by CLV descending
