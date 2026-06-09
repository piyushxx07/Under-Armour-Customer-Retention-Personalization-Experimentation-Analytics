-- 06_rfm_segmentation.sql
-- Purpose: Create RFM customer segmentation and recommended retention actions.

CREATE OR REPLACE VIEW rfm_base AS
WITH max_date AS (
    SELECT MAX(CAST(transaction_date AS DATE)) AS analysis_date
    FROM transactions_clean
    WHERE status = 'completed'
)

SELECT
    t.customer_id,
    MIN(CAST(t.transaction_date AS DATE)) AS first_purchase_date,
    MAX(CAST(t.transaction_date AS DATE)) AS last_purchase_date,
    DATE_DIFF('day', MAX(CAST(t.transaction_date AS DATE)), (SELECT analysis_date FROM max_date)) AS recency_days,
    COUNT(DISTINCT t.transaction_id) AS frequency,
    ROUND(SUM(t.total_amount), 2) AS monetary_value,
    ROUND(AVG(t.total_amount), 2) AS avg_order_value
FROM transactions_clean t
WHERE t.status = 'completed'
GROUP BY t.customer_id;


CREATE OR REPLACE VIEW rfm_scored AS
SELECT
    customer_id,
    first_purchase_date,
    last_purchase_date,
    recency_days,
    frequency,
    monetary_value,
    avg_order_value,
    NTILE(5) OVER (ORDER BY recency_days DESC, customer_id) AS r_score,
    NTILE(5) OVER (ORDER BY frequency ASC, customer_id) AS f_score,
    NTILE(5) OVER (ORDER BY monetary_value ASC, customer_id) AS m_score
FROM rfm_base;


CREATE OR REPLACE VIEW rfm_segments AS
SELECT
    customer_id,
    first_purchase_date,
    last_purchase_date,
    recency_days,
    frequency,
    monetary_value,
    avg_order_value,
    r_score,
    f_score,
    m_score,
    CAST(r_score AS VARCHAR) || CAST(f_score AS VARCHAR) || CAST(m_score AS VARCHAR) AS rfm_score,

    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'VIP Customers'
        WHEN r_score >= 4 AND f_score >= 3 THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New / Promising Customers'
        WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'At-Risk High-Value Customers'
        WHEN r_score <= 2 AND f_score >= 3 THEN 'At-Risk Loyal Customers'
        WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost / Dormant Customers'
        WHEN m_score >= 4 AND f_score <= 2 THEN 'Big Spenders - Low Frequency'
        ELSE 'Regular Customers'
    END AS rfm_segment
FROM rfm_scored;


CREATE OR REPLACE VIEW bi_rfm_customer_segments AS
SELECT
    r.customer_id,
    c.segment AS original_customer_segment,
    r.rfm_segment,
    r.rfm_score,
    r.first_purchase_date,
    r.last_purchase_date,
    r.recency_days,
    r.frequency,
    r.monetary_value,
    r.avg_order_value,
    r.r_score,
    r.f_score,
    r.m_score,
    c.country,
    c.gender,
    c.age,
    c.is_churned,
    c.is_loyalty_member,
    c.ua_rewards_points,
    c.email_opt_in,
    c.has_app,
    c.preferred_sport,
    c.lifetime_value,

    CASE
        WHEN r.rfm_segment IN ('At-Risk High-Value Customers', 'At-Risk Loyal Customers') THEN 'Win Back'
        WHEN r.rfm_segment = 'VIP Customers' THEN 'Protect and Reward'
        WHEN r.rfm_segment = 'Lost / Dormant Customers' THEN 'Reactivation'
        WHEN r.rfm_segment = 'New / Promising Customers' THEN 'Nurture'
        WHEN r.rfm_segment = 'Big Spenders - Low Frequency' THEN 'Increase Frequency'
        ELSE 'Maintain Engagement'
    END AS recommended_action

FROM rfm_segments r
JOIN customers_clean c ON r.customer_id = c.customer_id;


CREATE OR REPLACE VIEW bi_rfm_segment_summary AS
SELECT
    rfm_segment,
    recommended_action,
    COUNT(*) AS customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS customer_pct,
    ROUND(AVG(recency_days), 2) AS avg_recency_days,
    ROUND(AVG(frequency), 2) AS avg_frequency,
    ROUND(AVG(monetary_value), 2) AS avg_monetary_value,
    ROUND(AVG(avg_order_value), 2) AS avg_order_value,
    ROUND(SUM(monetary_value), 2) AS total_monetary_value,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
    ROUND(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) / COUNT(*), 2) AS retention_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS loyalty_member_pct,
    ROUND(100.0 * SUM(CASE WHEN has_app = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS app_user_pct,
    ROUND(100.0 * SUM(CASE WHEN email_opt_in = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS email_opt_in_pct
FROM bi_rfm_customer_segments
GROUP BY rfm_segment, recommended_action;
