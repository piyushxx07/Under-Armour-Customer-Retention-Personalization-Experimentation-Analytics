-- 10_bi_ready_views.sql
-- Purpose: List all final BI-ready views used in Power BI.

-- Final exported BI-ready views:
-- 1. bi_executive_summary_kpis
-- 2. bi_monthly_revenue_kpis
-- 3. bi_segment_churn_revenue
-- 4. bi_rfm_customer_segments
-- 5. bi_rfm_segment_summary
-- 6. bi_cohort_retention_summary
-- 7. bi_cohort_milestone_summary
-- 8. bi_recommendation_model_performance
-- 9. bi_recommendation_segment_performance
-- 10. bi_personalized_vs_generic_uplift
-- 11. bi_experiment_ab_summary
-- 12. bi_experiment_uplift_summary
-- 13. bi_experiment_significance_summary


-- Preview executive KPIs
SELECT * FROM bi_executive_summary_kpis;


-- Preview monthly revenue KPIs
SELECT * FROM bi_monthly_revenue_kpis ORDER BY month;


-- Preview segment churn and revenue
SELECT * FROM bi_segment_churn_revenue;


-- Preview RFM segment summary
SELECT * FROM bi_rfm_segment_summary ORDER BY total_monetary_value DESC;


-- Preview cohort milestone summary
SELECT * FROM bi_cohort_milestone_summary ORDER BY cohort_month;


-- Preview recommendation model performance
SELECT * FROM bi_recommendation_model_performance ORDER BY recommendation_revenue DESC;


-- Preview personalized vs generic uplift
SELECT * FROM bi_personalized_vs_generic_uplift ORDER BY revenue_per_impression_uplift_pct DESC;


-- Preview experiment uplift summary
SELECT * FROM bi_experiment_uplift_summary ORDER BY revenue_per_user_uplift_pct DESC;


-- Preview experiment significance summary
SELECT * FROM bi_experiment_significance_summary ORDER BY z_score DESC;
