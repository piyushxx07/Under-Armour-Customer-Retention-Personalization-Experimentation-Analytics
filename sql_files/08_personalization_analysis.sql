-- 08_personalization_analysis.sql
-- Purpose: Analyze recommendation model performance and personalized vs generic uplift.

CREATE OR REPLACE VIEW bi_recommendation_model_performance AS
SELECT
    recommendation_model,
    COUNT(*) AS impressions,
    SUM(clicked) AS clicks,
    SUM(purchased) AS purchases,
    ROUND(100.0 * SUM(clicked) / COUNT(*), 2) AS ctr_pct,
    ROUND(100.0 * SUM(purchased) / NULLIF(SUM(clicked), 0), 2) AS cvr_after_click_pct,
    ROUND(100.0 * SUM(purchased) / COUNT(*), 2) AS purchase_rate_per_impression_pct,
    ROUND(SUM(revenue), 2) AS recommendation_revenue,
    ROUND(SUM(revenue) / COUNT(*), 4) AS revenue_per_impression,
    ROUND(SUM(revenue) / NULLIF(SUM(clicked), 0), 2) AS revenue_per_click
FROM recommendation_events_clean
GROUP BY recommendation_model
ORDER BY recommendation_revenue DESC;


CREATE OR REPLACE VIEW bi_recommendation_segment_performance AS
SELECT
    c.segment,
    re.recommendation_model,
    COUNT(*) AS impressions,
    SUM(re.clicked) AS clicks,
    SUM(re.purchased) AS purchases,
    ROUND(100.0 * SUM(re.clicked) / COUNT(*), 2) AS ctr_pct,
    ROUND(100.0 * SUM(re.purchased) / NULLIF(SUM(re.clicked), 0), 2) AS cvr_after_click_pct,
    ROUND(100.0 * SUM(re.purchased) / COUNT(*), 2) AS purchase_rate_per_impression_pct,
    ROUND(SUM(re.revenue), 2) AS recommendation_revenue,
    ROUND(SUM(re.revenue) / COUNT(*), 4) AS revenue_per_impression
FROM recommendation_events_clean re
JOIN customers_clean c ON re.customer_id = c.customer_id
GROUP BY c.segment, re.recommendation_model;


CREATE OR REPLACE VIEW bi_personalized_vs_generic_uplift AS
WITH model_perf AS (
    SELECT
        c.segment,
        re.recommendation_model,
        COUNT(*) AS impressions,
        SUM(re.clicked) AS clicks,
        SUM(re.purchased) AS purchases,
        SUM(re.revenue) AS revenue,
        1.0 * SUM(re.clicked) / COUNT(*) AS ctr,
        1.0 * SUM(re.purchased) / COUNT(*) AS purchase_rate,
        1.0 * SUM(re.revenue) / COUNT(*) AS revenue_per_impression
    FROM recommendation_events_clean re
    JOIN customers_clean c ON re.customer_id = c.customer_id
    WHERE re.recommendation_model IN ('personalized', 'generic')
    GROUP BY c.segment, re.recommendation_model
),

pivoted AS (
    SELECT
        segment,
        MAX(CASE WHEN recommendation_model = 'personalized' THEN impressions END) AS personalized_impressions,
        MAX(CASE WHEN recommendation_model = 'generic' THEN impressions END) AS generic_impressions,
        MAX(CASE WHEN recommendation_model = 'personalized' THEN ctr END) AS personalized_ctr,
        MAX(CASE WHEN recommendation_model = 'generic' THEN ctr END) AS generic_ctr,
        MAX(CASE WHEN recommendation_model = 'personalized' THEN purchase_rate END) AS personalized_purchase_rate,
        MAX(CASE WHEN recommendation_model = 'generic' THEN purchase_rate END) AS generic_purchase_rate,
        MAX(CASE WHEN recommendation_model = 'personalized' THEN revenue_per_impression END) AS personalized_revenue_per_impression,
        MAX(CASE WHEN recommendation_model = 'generic' THEN revenue_per_impression END) AS generic_revenue_per_impression,
        MAX(CASE WHEN recommendation_model = 'personalized' THEN revenue END) AS personalized_revenue,
        MAX(CASE WHEN recommendation_model = 'generic' THEN revenue END) AS generic_revenue
    FROM model_perf
    GROUP BY segment
)

SELECT
    segment,
    personalized_impressions,
    generic_impressions,
    ROUND(100 * personalized_ctr, 2) AS personalized_ctr_pct,
    ROUND(100 * generic_ctr, 2) AS generic_ctr_pct,
    ROUND(100.0 * (personalized_ctr - generic_ctr) / NULLIF(generic_ctr, 0), 2) AS ctr_uplift_pct,
    ROUND(100 * personalized_purchase_rate, 2) AS personalized_purchase_rate_pct,
    ROUND(100 * generic_purchase_rate, 2) AS generic_purchase_rate_pct,
    ROUND(100.0 * (personalized_purchase_rate - generic_purchase_rate) / NULLIF(generic_purchase_rate, 0), 2) AS purchase_rate_uplift_pct,
    ROUND(personalized_revenue_per_impression, 4) AS personalized_revenue_per_impression,
    ROUND(generic_revenue_per_impression, 4) AS generic_revenue_per_impression,
    ROUND(100.0 * (personalized_revenue_per_impression - generic_revenue_per_impression) / NULLIF(generic_revenue_per_impression, 0), 2) AS revenue_per_impression_uplift_pct,
    ROUND(personalized_revenue, 2) AS personalized_revenue,
    ROUND(generic_revenue, 2) AS generic_revenue
FROM pivoted
ORDER BY revenue_per_impression_uplift_pct DESC;
