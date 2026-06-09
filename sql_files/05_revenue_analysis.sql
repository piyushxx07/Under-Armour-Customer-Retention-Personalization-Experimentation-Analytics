-- 05_revenue_analysis.sql
-- Purpose: Analyze revenue health, order status, revenue leakage, and monthly revenue KPIs.

-- Revenue overview
SELECT
    COUNT(*) AS total_transaction_rows,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_transactions,
    SUM(CASE WHEN status = 'returned' THEN 1 ELSE 0 END) AS returned_transactions,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_transactions,
    SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS pending_transactions,
    ROUND(100.0 * SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS completed_transaction_pct,
    ROUND(SUM(CASE WHEN status = 'completed' THEN total_amount ELSE 0 END), 2) AS completed_revenue,
    ROUND(AVG(CASE WHEN status = 'completed' THEN total_amount END), 2) AS avg_completed_transaction_value,
    SUM(CASE WHEN status = 'completed' THEN quantity ELSE 0 END) AS completed_units_sold,
    ROUND(SUM(CASE WHEN status = 'returned' THEN total_amount ELSE 0 END), 2) AS returned_revenue_value,
    ROUND(SUM(CASE WHEN status = 'cancelled' THEN total_amount ELSE 0 END), 2) AS cancelled_revenue_value
FROM transactions_clean;


-- Revenue and order status by customer segment
SELECT
    c.segment,
    COUNT(*) AS total_transaction_rows,
    SUM(CASE WHEN t.status = 'completed' THEN 1 ELSE 0 END) AS completed_transactions,
    SUM(CASE WHEN t.status = 'returned' THEN 1 ELSE 0 END) AS returned_transactions,
    SUM(CASE WHEN t.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_transactions,
    ROUND(100.0 * SUM(CASE WHEN t.status = 'completed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS completion_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN t.status = 'returned' THEN 1 ELSE 0 END) / COUNT(*), 2) AS return_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN t.status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate_pct,
    ROUND(SUM(CASE WHEN t.status = 'completed' THEN t.total_amount ELSE 0 END), 2) AS completed_revenue,
    ROUND(AVG(CASE WHEN t.status = 'completed' THEN t.total_amount END), 2) AS avg_completed_transaction_value,
    COUNT(DISTINCT t.customer_id) AS purchasing_customers,
    ROUND(SUM(CASE WHEN t.status = 'completed' THEN t.total_amount ELSE 0 END) / COUNT(DISTINCT t.customer_id), 2) AS revenue_per_purchasing_customer
FROM transactions_clean t
JOIN customers_clean c ON t.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY completed_revenue DESC;


-- BI-ready monthly revenue KPI view
CREATE OR REPLACE VIEW bi_monthly_revenue_kpis AS
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    COUNT(*) AS total_transaction_rows,
    SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) AS completed_transactions,
    SUM(CASE WHEN status = 'returned' THEN 1 ELSE 0 END) AS returned_transactions,
    SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_transactions,
    SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS pending_transactions,
    COUNT(DISTINCT CASE WHEN status = 'completed' THEN customer_id END) AS purchasing_customers,
    ROUND(SUM(CASE WHEN status = 'completed' THEN total_amount ELSE 0 END), 2) AS completed_revenue,
    ROUND(AVG(CASE WHEN status = 'completed' THEN total_amount END), 2) AS avg_completed_transaction_value,
    SUM(CASE WHEN status = 'completed' THEN quantity ELSE 0 END) AS completed_units_sold,
    ROUND(100.0 * SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) / COUNT(*), 2) AS completion_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN status = 'returned' THEN 1 ELSE 0 END) / COUNT(*), 2) AS return_rate_pct,
    ROUND(100.0 * SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cancellation_rate_pct
FROM transactions_clean
GROUP BY DATE_TRUNC('month', transaction_date);


-- BI-ready segment churn and revenue view
CREATE OR REPLACE VIEW bi_segment_churn_revenue AS
WITH segment_customer_base AS (
    SELECT
        segment,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
        SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
        SUM(CASE WHEN is_loyalty_member = 1 THEN 1 ELSE 0 END) AS loyalty_members,
        ROUND(AVG(lifetime_value), 2) AS avg_lifetime_value
    FROM customers_clean
    GROUP BY segment
),

segment_revenue AS (
    SELECT
        c.segment,
        COUNT(DISTINCT t.customer_id) AS purchasing_customers,
        SUM(CASE WHEN t.status = 'completed' THEN 1 ELSE 0 END) AS completed_transactions,
        ROUND(SUM(CASE WHEN t.status = 'completed' THEN t.total_amount ELSE 0 END), 2) AS completed_revenue,
        ROUND(AVG(CASE WHEN t.status = 'completed' THEN t.total_amount END), 2) AS avg_completed_transaction_value
    FROM transactions_clean t
    JOIN customers_clean c ON t.customer_id = c.customer_id
    GROUP BY c.segment
)

SELECT
    cb.segment,
    cb.total_customers,
    cb.active_customers,
    cb.churned_customers,
    ROUND(100.0 * cb.churned_customers / cb.total_customers, 2) AS churn_rate_pct,
    ROUND(100.0 * cb.active_customers / cb.total_customers, 2) AS retention_rate_pct,
    cb.loyalty_members,
    ROUND(100.0 * cb.loyalty_members / cb.total_customers, 2) AS loyalty_member_pct,
    cb.avg_lifetime_value,
    COALESCE(sr.purchasing_customers, 0) AS purchasing_customers,
    COALESCE(sr.completed_transactions, 0) AS completed_transactions,
    COALESCE(sr.completed_revenue, 0) AS completed_revenue,
    COALESCE(sr.avg_completed_transaction_value, 0) AS avg_completed_transaction_value,
    ROUND(COALESCE(sr.completed_revenue, 0) / cb.total_customers, 2) AS revenue_per_customer
FROM segment_customer_base cb
LEFT JOIN segment_revenue sr ON cb.segment = sr.segment
ORDER BY churn_rate_pct DESC;
