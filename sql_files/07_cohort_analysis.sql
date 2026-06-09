-- 07_cohort_analysis.sql
-- Purpose: Cohort retention and repeat behavior analysis.

CREATE OR REPLACE VIEW cohort_base AS
WITH first_purchase AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(transaction_date)) AS cohort_month
    FROM transactions_clean
    WHERE status = 'completed'
    GROUP BY customer_id
),

customer_purchase_months AS (
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', transaction_date) AS purchase_month
    FROM transactions_clean
    WHERE status = 'completed'
)

SELECT
    fp.customer_id,
    fp.cohort_month,
    cpm.purchase_month,
    DATE_DIFF('month', fp.cohort_month, cpm.purchase_month) AS cohort_age_month
FROM first_purchase fp
JOIN customer_purchase_months cpm ON fp.customer_id = cpm.customer_id
WHERE cpm.purchase_month >= fp.cohort_month;


CREATE OR REPLACE VIEW bi_cohort_retention_summary AS
WITH cohort_counts AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_id) AS cohort_size
    FROM cohort_base
    WHERE cohort_age_month = 0
    GROUP BY cohort_month
),

retention_counts AS (
    SELECT
        cohort_month,
        cohort_age_month,
        COUNT(DISTINCT customer_id) AS retained_customers
    FROM cohort_base
    GROUP BY cohort_month, cohort_age_month
)

SELECT
    rc.cohort_month,
    rc.cohort_age_month,
    cc.cohort_size,
    rc.retained_customers,
    ROUND(100.0 * rc.retained_customers / cc.cohort_size, 2) AS retention_rate_pct
FROM retention_counts rc
JOIN cohort_counts cc ON rc.cohort_month = cc.cohort_month
ORDER BY rc.cohort_month, rc.cohort_age_month;


CREATE OR REPLACE VIEW bi_cohort_milestone_summary AS
SELECT
    cohort_month,
    MAX(CASE WHEN cohort_age_month = 0 THEN cohort_size END) AS cohort_size,
    MAX(CASE WHEN cohort_age_month = 1 THEN retention_rate_pct END) AS month_1_retention_pct,
    MAX(CASE WHEN cohort_age_month = 3 THEN retention_rate_pct END) AS month_3_retention_pct,
    MAX(CASE WHEN cohort_age_month = 6 THEN retention_rate_pct END) AS month_6_retention_pct,
    MAX(CASE WHEN cohort_age_month = 12 THEN retention_rate_pct END) AS month_12_retention_pct,
    MAX(CASE WHEN cohort_age_month = 1 THEN retained_customers END) AS month_1_retained_customers,
    MAX(CASE WHEN cohort_age_month = 3 THEN retained_customers END) AS month_3_retained_customers,
    MAX(CASE WHEN cohort_age_month = 6 THEN retained_customers END) AS month_6_retained_customers,
    MAX(CASE WHEN cohort_age_month = 12 THEN retained_customers END) AS month_12_retained_customers
FROM bi_cohort_retention_summary
GROUP BY cohort_month
ORDER BY cohort_month;
