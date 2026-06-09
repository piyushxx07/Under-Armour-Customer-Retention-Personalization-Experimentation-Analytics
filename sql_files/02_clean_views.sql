-- 02_clean_views.sql
-- Purpose: Create clean views for analysis.

CREATE OR REPLACE VIEW experiments_clean AS
SELECT *
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY experiment_id, customer_id, COALESCE(session_id, 'NO_SESSION'), exposure_date
            ORDER BY exposure_date
        ) AS rn
    FROM experiments
)
WHERE rn = 1;


CREATE OR REPLACE VIEW customers_clean AS
SELECT
    customer_id,
    CAST(signup_date AS DATE) AS signup_date,
    age,
    COALESCE(gender, 'Unknown') AS gender,
    country,
    segment,
    is_churned,
    COALESCE(lifetime_value, 0) AS lifetime_value,
    is_loyalty_member,
    ua_rewards_points,
    email_opt_in,
    has_app,
    COALESCE(preferred_sport, 'Unknown') AS preferred_sport
FROM customers;


CREATE OR REPLACE VIEW products_clean AS
SELECT
    product_id,
    product_name,
    category,
    brand,
    gender_target,
    price,
    avg_rating,
    num_ratings,
    stock_quantity,
    discount_pct,
    is_featured,
    is_new_arrival,
    weight_kg
FROM products;


CREATE OR REPLACE VIEW transactions_clean AS
SELECT
    transaction_id,
    customer_id,
    product_id,
    CAST(transaction_date AS TIMESTAMP) AS transaction_date,
    quantity,
    unit_price,
    total_amount,
    discount_applied,
    loyalty_discount,
    status,
    payment_method,
    shipping_cost
FROM transactions;


CREATE OR REPLACE VIEW sessions_clean AS
SELECT
    session_id,
    customer_id,
    CAST(session_date AS TIMESTAMP) AS session_date,
    device,
    COALESCE(channel, 'unknown') AS channel,
    duration_seconds,
    pages_viewed,
    converted,
    bounced,
    cart_additions,
    is_loyalty_session
FROM sessions;


CREATE OR REPLACE VIEW reviews_clean AS
SELECT
    review_id,
    customer_id,
    product_id,
    CAST(review_date AS DATE) AS review_date,
    rating,
    review_text,
    helpful_votes,
    verified_purchase,
    review_source
FROM reviews;


CREATE OR REPLACE VIEW recommendation_events_clean AS
SELECT
    event_id,
    customer_id,
    session_id,
    product_id,
    recommendation_model,
    CAST(event_date AS TIMESTAMP) AS event_date,
    impression,
    clicked,
    purchased,
    COALESCE(revenue, 0) AS revenue
FROM recommendation_events;
