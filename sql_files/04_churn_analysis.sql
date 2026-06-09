-- 04_churn_analysis.sql
-- Purpose: Analyze churn by segment, loyalty, app, email, and country.

-- Churn by customer segment
SELECT
    segment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
    ROUND(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
    ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value,
    SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) AS loyalty_members,
    ROUND(100.0 * SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loyalty_member_pct
FROM customers_clean
GROUP BY segment
ORDER BY churn_rate_pct DESC;


-- Churn by loyalty membership
SELECT
    CASE WHEN is_loyalty_member = 1 THEN 'Loyalty Member' ELSE 'Non-Loyalty Member' END AS loyalty_status,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
    ROUND(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
    ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value,
    ROUND(AVG(ua_rewards_points), 2) AS avg_rewards_points,
    ROUND(100.0 * SUM(CASE WHEN has_app = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS app_user_pct,
    ROUND(100.0 * SUM(CASE WHEN email_opt_in = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS email_opt_in_pct
FROM customers_clean
GROUP BY loyalty_status
ORDER BY churn_rate_pct DESC;


-- Churn by app usage
SELECT
    CASE WHEN has_app = 1 THEN 'App User' ELSE 'Non-App User' END AS app_status,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
    ROUND(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
    ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value,
    ROUND(100.0 * SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loyalty_member_pct,
    ROUND(100.0 * SUM(CASE WHEN email_opt_in = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS email_opt_in_pct
FROM customers_clean
GROUP BY app_status
ORDER BY churn_rate_pct DESC;


-- Churn by email opt-in
SELECT
    CASE WHEN email_opt_in = 1 THEN 'Email Opt-in' ELSE 'No Email Opt-in' END AS email_status,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
    ROUND(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
    ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value,
    ROUND(100.0 * SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loyalty_member_pct,
    ROUND(100.0 * SUM(CASE WHEN has_app = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS app_user_pct
FROM customers_clean
GROUP BY email_status
ORDER BY churn_rate_pct DESC;


-- Churn by country
SELECT
    country,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
    ROUND(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
    ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value,
    ROUND(100.0 * SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loyalty_member_pct,
    ROUND(100.0 * SUM(CASE WHEN has_app = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS app_user_pct,
    ROUND(100.0 * SUM(CASE WHEN email_opt_in = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS email_opt_in_pct
FROM customers_clean
GROUP BY country
ORDER BY churn_rate_pct DESC;
