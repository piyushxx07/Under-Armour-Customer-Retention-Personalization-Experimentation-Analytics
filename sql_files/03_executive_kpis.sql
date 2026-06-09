-- 03_executive_kpis.sql
-- Purpose: Executive customer and business KPI analysis.

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,

    ROUND(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS retention_rate_pct,

    SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) AS loyalty_members,
    ROUND(100.0 * SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loyalty_member_pct,

    SUM(CASE WHEN has_app = 1 THEN 1 ELSE 0 END) AS app_users,
    ROUND(100.0 * SUM(CASE WHEN has_app = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS app_user_pct,

    SUM(CASE WHEN email_opt_in = 1 THEN 1 ELSE 0 END) AS email_opt_in_users,
    ROUND(100.0 * SUM(CASE WHEN email_opt_in = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS email_opt_in_pct,

    ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value
FROM customers_clean;


CREATE OR REPLACE VIEW bi_executive_summary_kpis AS
WITH customer_kpis AS (
    SELECT
        COUNT(*) AS total_customers,
        SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
        SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
        ROUND(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
        ROUND(100.0 * SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS retention_rate_pct,
        ROUND(100.0 * SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loyalty_member_pct,
        ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value
    FROM customers_clean
),

revenue_kpis AS (
    SELECT
        ROUND(SUM(CASE WHEN status = 'completed' THEN total_amount ELSE 0 END), 2) AS completed_revenue,
        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_transactions,
        ROUND(AVG(CASE WHEN status = 'completed' THEN total_amount END), 2) AS avg_completed_transaction_value,
        ROUND(100.0 * SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS completion_rate_pct
    FROM transactions_clean
),

repeat_kpis AS (
    WITH customer_purchase_months AS (
        SELECT
            customer_id,
            COUNT(DISTINCT DATE_TRUNC('month', transaction_date)) AS purchase_months
        FROM transactions_clean
        WHERE status = 'completed'
        GROUP BY customer_id
    )
    SELECT
        COUNT(*) AS purchasing_customers,
        ROUND(100.0 * SUM(CASE WHEN purchase_months > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_purchase_month_rate_pct
    FROM customer_purchase_months
),

recommendation_kpis AS (
    SELECT
        COUNT(*) AS recommendation_impressions,
        ROUND(100.0 * SUM(clicked) / COUNT(*), 2) AS recommendation_ctr_pct,
        ROUND(100.0 * SUM(purchased) / NULLIF(SUM(clicked), 0), 2) AS recommendation_cvr_after_click_pct,
        ROUND(SUM(revenue), 2) AS recommendation_revenue
    FROM recommendation_events_clean
),

experiment_kpis AS (
    SELECT
        COUNT(*) AS total_experiments,
        SUM(CASE WHEN experiment_result = 'Treatment Wins' THEN 1 ELSE 0 END) AS treatment_wins,
        ROUND(AVG(revenue_per_user_uplift_pct), 2) AS avg_revenue_per_user_uplift_pct,
        ROUND(SUM(incremental_revenue), 2) AS total_incremental_revenue
    FROM bi_experiment_uplift_summary
),

significance_kpis AS (
    SELECT
        SUM(CASE WHEN significance_result = 'Statistically Significant' THEN 1 ELSE 0 END) AS significant_experiments,
        SUM(CASE WHEN recommendation = 'Roll Out Treatment' THEN 1 ELSE 0 END) AS rollout_recommendations
    FROM bi_experiment_significance_summary
)

SELECT
    ck.total_customers,
    ck.active_customers,
    ck.churned_customers,
    ck.churn_rate_pct,
    ck.retention_rate_pct,
    ck.loyalty_member_pct,
    ck.avg_lifetime_value,
    rk.completed_revenue,
    rk.completed_transactions,
    rk.avg_completed_transaction_value,
    rk.completion_rate_pct,
    rep.purchasing_customers,
    rep.repeat_purchase_month_rate_pct,
    rec.recommendation_impressions,
    rec.recommendation_ctr_pct,
    rec.recommendation_cvr_after_click_pct,
    rec.recommendation_revenue,
    exp.total_experiments,
    exp.treatment_wins,
    sig.significant_experiments,
    sig.rollout_recommendations,
    exp.avg_revenue_per_user_uplift_pct,
    exp.total_incremental_revenue
FROM customer_kpis ck
CROSS JOIN revenue_kpis rk
CROSS JOIN repeat_kpis rep
CROSS JOIN recommendation_kpis rec
CROSS JOIN experiment_kpis exp
CROSS JOIN significance_kpis sig;
