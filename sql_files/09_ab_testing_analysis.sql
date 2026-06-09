-- 09_ab_testing_analysis.sql
-- Purpose: A/B testing, uplift calculation, and statistical significance.

CREATE OR REPLACE VIEW bi_experiment_ab_summary AS
SELECT
    experiment_id,
    experiment_name,
    experiment_goal,
    variant,
    COUNT(*) AS exposed_users,
    SUM(clicked_recommendation) AS clicks,
    SUM(converted) AS conversions,
    ROUND(100.0 * SUM(clicked_recommendation) / COUNT(*), 2) AS ctr_pct,
    ROUND(100.0 * SUM(converted) / COUNT(*), 2) AS conversion_rate_pct,
    ROUND(SUM(revenue), 2) AS revenue,
    ROUND(SUM(revenue) / COUNT(*), 2) AS revenue_per_exposed_user
FROM experiments_clean
GROUP BY experiment_id, experiment_name, experiment_goal, variant;


CREATE OR REPLACE VIEW bi_experiment_uplift_summary AS
WITH pivoted AS (
    SELECT
        experiment_id,
        experiment_name,
        experiment_goal,
        MAX(CASE WHEN variant = 'control' THEN exposed_users END) AS control_users,
        MAX(CASE WHEN variant = 'treatment' THEN exposed_users END) AS treatment_users,
        MAX(CASE WHEN variant = 'control' THEN ctr_pct END) AS control_ctr_pct,
        MAX(CASE WHEN variant = 'treatment' THEN ctr_pct END) AS treatment_ctr_pct,
        MAX(CASE WHEN variant = 'control' THEN conversion_rate_pct END) AS control_conversion_rate_pct,
        MAX(CASE WHEN variant = 'treatment' THEN conversion_rate_pct END) AS treatment_conversion_rate_pct,
        MAX(CASE WHEN variant = 'control' THEN revenue END) AS control_revenue,
        MAX(CASE WHEN variant = 'treatment' THEN revenue END) AS treatment_revenue,
        MAX(CASE WHEN variant = 'control' THEN revenue_per_exposed_user END) AS control_revenue_per_user,
        MAX(CASE WHEN variant = 'treatment' THEN revenue_per_exposed_user END) AS treatment_revenue_per_user
    FROM bi_experiment_ab_summary
    GROUP BY experiment_id, experiment_name, experiment_goal
)

SELECT
    experiment_id,
    experiment_name,
    experiment_goal,
    control_users,
    treatment_users,
    control_ctr_pct,
    treatment_ctr_pct,
    ROUND(treatment_ctr_pct - control_ctr_pct, 2) AS ctr_lift_pp,
    ROUND(100.0 * (treatment_ctr_pct - control_ctr_pct) / NULLIF(control_ctr_pct, 0), 2) AS ctr_uplift_pct,
    control_conversion_rate_pct,
    treatment_conversion_rate_pct,
    ROUND(treatment_conversion_rate_pct - control_conversion_rate_pct, 2) AS conversion_lift_pp,
    ROUND(100.0 * (treatment_conversion_rate_pct - control_conversion_rate_pct) / NULLIF(control_conversion_rate_pct, 0), 2) AS conversion_uplift_pct,
    control_revenue,
    treatment_revenue,
    ROUND(treatment_revenue - control_revenue, 2) AS incremental_revenue,
    control_revenue_per_user,
    treatment_revenue_per_user,
    ROUND(treatment_revenue_per_user - control_revenue_per_user, 2) AS revenue_per_user_lift,
    ROUND(100.0 * (treatment_revenue_per_user - control_revenue_per_user) / NULLIF(control_revenue_per_user, 0), 2) AS revenue_per_user_uplift_pct,
    CASE
        WHEN treatment_conversion_rate_pct > control_conversion_rate_pct
             AND treatment_revenue_per_user > control_revenue_per_user
        THEN 'Treatment Wins'
        WHEN treatment_conversion_rate_pct < control_conversion_rate_pct
             AND treatment_revenue_per_user < control_revenue_per_user
        THEN 'Control Wins'
        ELSE 'Mixed Result'
    END AS experiment_result
FROM pivoted
ORDER BY revenue_per_user_uplift_pct DESC;


CREATE OR REPLACE VIEW bi_experiment_significance_summary AS
WITH base AS (
    SELECT
        experiment_id,
        experiment_name,
        experiment_goal,
        variant,
        COUNT(*) AS users,
        SUM(converted) AS conversions,
        1.0 * SUM(converted) / COUNT(*) AS conversion_rate
    FROM experiments_clean
    GROUP BY experiment_id, experiment_name, experiment_goal, variant
),

pivoted AS (
    SELECT
        experiment_id,
        experiment_name,
        experiment_goal,
        MAX(CASE WHEN variant = 'control' THEN users END) AS control_users,
        MAX(CASE WHEN variant = 'treatment' THEN users END) AS treatment_users,
        MAX(CASE WHEN variant = 'control' THEN conversions END) AS control_conversions,
        MAX(CASE WHEN variant = 'treatment' THEN conversions END) AS treatment_conversions,
        MAX(CASE WHEN variant = 'control' THEN conversion_rate END) AS control_conversion_rate,
        MAX(CASE WHEN variant = 'treatment' THEN conversion_rate END) AS treatment_conversion_rate
    FROM base
    GROUP BY experiment_id, experiment_name, experiment_goal
),

stats AS (
    SELECT
        *,
        1.0 * (control_conversions + treatment_conversions) / (control_users + treatment_users) AS pooled_conversion_rate
    FROM pivoted
),

z_calc AS (
    SELECT
        *,
        SQRT(
            pooled_conversion_rate
            * (1 - pooled_conversion_rate)
            * (1.0 / control_users + 1.0 / treatment_users)
        ) AS standard_error
    FROM stats
)

SELECT
    experiment_id,
    experiment_name,
    experiment_goal,
    control_users,
    treatment_users,
    control_conversions,
    treatment_conversions,
    ROUND(100 * control_conversion_rate, 2) AS control_conversion_rate_pct,
    ROUND(100 * treatment_conversion_rate, 2) AS treatment_conversion_rate_pct,
    ROUND(100 * (treatment_conversion_rate - control_conversion_rate), 2) AS conversion_lift_pp,
    ROUND(100 * (treatment_conversion_rate - control_conversion_rate) / NULLIF(control_conversion_rate, 0), 2) AS conversion_uplift_pct,
    ROUND((treatment_conversion_rate - control_conversion_rate) / NULLIF(standard_error, 0), 2) AS z_score,
    CASE
        WHEN ABS((treatment_conversion_rate - control_conversion_rate) / NULLIF(standard_error, 0)) >= 1.96
        THEN 'Statistically Significant'
        ELSE 'Not Significant'
    END AS significance_result,
    CASE
        WHEN treatment_conversion_rate > control_conversion_rate
             AND ABS((treatment_conversion_rate - control_conversion_rate) / NULLIF(standard_error, 0)) >= 1.96
        THEN 'Roll Out Treatment'
        WHEN treatment_conversion_rate > control_conversion_rate
        THEN 'Promising, Need More Data'
        ELSE 'Do Not Roll Out'
    END AS recommendation
FROM z_calc
ORDER BY z_score DESC;
