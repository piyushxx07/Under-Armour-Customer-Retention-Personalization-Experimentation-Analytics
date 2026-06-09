-- 01_data_validation.sql
-- Purpose: Validate row counts, duplicate keys, relationship integrity, and date ranges.

-- 1. Row count validation
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'sessions', COUNT(*) FROM sessions
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'experiments', COUNT(*) FROM experiments
UNION ALL
SELECT 'recommendation_events', COUNT(*) FROM recommendation_events;


-- 2. Duplicate primary key check
SELECT 'customers' AS table_name, COUNT(*) AS total_rows, COUNT(DISTINCT customer_id) AS unique_ids,
       COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_ids
FROM customers
UNION ALL
SELECT 'products', COUNT(*), COUNT(DISTINCT product_id),
       COUNT(*) - COUNT(DISTINCT product_id)
FROM products
UNION ALL
SELECT 'transactions', COUNT(*), COUNT(DISTINCT transaction_id),
       COUNT(*) - COUNT(DISTINCT transaction_id)
FROM transactions
UNION ALL
SELECT 'sessions', COUNT(*), COUNT(DISTINCT session_id),
       COUNT(*) - COUNT(DISTINCT session_id)
FROM sessions
UNION ALL
SELECT 'reviews', COUNT(*), COUNT(DISTINCT review_id),
       COUNT(*) - COUNT(DISTINCT review_id)
FROM reviews
UNION ALL
SELECT 'experiments',
       COUNT(*),
       COUNT(DISTINCT experiment_id || '-' || customer_id || '-' || COALESCE(session_id, 'NO_SESSION') || '-' || exposure_date),
       COUNT(*) - COUNT(DISTINCT experiment_id || '-' || customer_id || '-' || COALESCE(session_id, 'NO_SESSION') || '-' || exposure_date)
FROM experiments
UNION ALL
SELECT 'recommendation_events', COUNT(*), COUNT(DISTINCT event_id),
       COUNT(*) - COUNT(DISTINCT event_id)
FROM recommendation_events;


-- 3. Find duplicate experiment exposure rows
SELECT
    experiment_id,
    customer_id,
    COALESCE(session_id, 'NO_SESSION') AS session_id_clean,
    exposure_date,
    COUNT(*) AS duplicate_count
FROM experiments
GROUP BY experiment_id, customer_id, COALESCE(session_id, 'NO_SESSION'), exposure_date
HAVING COUNT(*) > 1;


-- 4. Relationship integrity check
SELECT 'transactions → customers' AS relationship, COUNT(*) AS missing_rows
FROM transactions t
LEFT JOIN customers c ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT 'transactions → products', COUNT(*)
FROM transactions t
LEFT JOIN products p ON t.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT 'sessions → customers', COUNT(*)
FROM sessions s
LEFT JOIN customers c ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT 'reviews → customers', COUNT(*)
FROM reviews r
LEFT JOIN customers c ON r.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT 'reviews → products', COUNT(*)
FROM reviews r
LEFT JOIN products p ON r.product_id = p.product_id
WHERE p.product_id IS NULL

UNION ALL

SELECT 'experiments → customers', COUNT(*)
FROM experiments e
LEFT JOIN customers c ON e.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT 'recommendation_events → customers', COUNT(*)
FROM recommendation_events re
LEFT JOIN customers c ON re.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT 'recommendation_events → products', COUNT(*)
FROM recommendation_events re
LEFT JOIN products p ON re.product_id = p.product_id
WHERE p.product_id IS NULL;


-- 5. Date range validation
SELECT 'customers.signup_date' AS date_field,
       MIN(CAST(signup_date AS DATE)) AS min_date,
       MAX(CAST(signup_date AS DATE)) AS max_date
FROM customers

UNION ALL

SELECT 'transactions.transaction_date',
       MIN(CAST(transaction_date AS DATE)),
       MAX(CAST(transaction_date AS DATE))
FROM transactions

UNION ALL

SELECT 'sessions.session_date',
       MIN(CAST(session_date AS DATE)),
       MAX(CAST(session_date AS DATE))
FROM sessions

UNION ALL

SELECT 'reviews.review_date',
       MIN(CAST(review_date AS DATE)),
       MAX(CAST(review_date AS DATE))
FROM reviews

UNION ALL

SELECT 'experiments.exposure_date',
       MIN(CAST(exposure_date AS DATE)),
       MAX(CAST(exposure_date AS DATE))
FROM experiments

UNION ALL

SELECT 'recommendation_events.event_date',
       MIN(CAST(event_date AS DATE)),
       MAX(CAST(event_date AS DATE))
FROM recommendation_events;
