# Data Dictionary

## Project

**Under Armour Customer Retention, Personalization & Experimentation Analytics**

## Dataset Type

Synthetic ecommerce customer behavior dataset generated for SQL and Power BI analytics.

## Dataset Purpose

This dataset was created to analyze:

* Customer churn
* Retention behavior
* RFM segmentation
* Cohort retention
* Personalized recommendation performance
* A/B testing uplift
* Revenue and transaction health

---

## Dataset Overview

| Table                 |                                    Rows | Description                                                        |
| --------------------- | --------------------------------------: | ------------------------------------------------------------------ |
| customers             |                                 200,000 | Customer profile and churn information                             |
| products              |                                  10,000 | Product catalog and product attributes                             |
| transactions          |                               3,000,000 | Purchase transactions and order status                             |
| sessions              |                               2,000,000 | Website and app browsing sessions                                  |
| reviews               |                                 500,000 | Product reviews submitted by customers                             |
| experiments           | 399,996 raw rows / 399,995 cleaned rows | A/B experiment exposures and outcomes                              |
| recommendation_events |                                 600,000 | Product recommendation impressions, clicks, purchases, and revenue |

---

# 1. customers

## Description

One row per unique customer.

## Primary Key

| Column      | Description                |
| ----------- | -------------------------- |
| customer_id | Unique customer identifier |

## Columns

| Column            | Type    | Description                           |
| ----------------- | ------- | ------------------------------------- |
| customer_id       | string  | Unique customer ID                    |
| signup_date       | date    | Customer registration date            |
| age               | float   | Customer age                          |
| gender            | string  | Customer gender                       |
| country           | string  | Customer country                      |
| segment           | string  | Customer lifecycle segment            |
| is_churned        | integer | 1 = churned, 0 = active               |
| lifetime_value    | float   | Historical customer lifetime value    |
| is_loyalty_member | integer | 1 = UA Rewards member, 0 = non-member |
| ua_rewards_points | integer | Loyalty points balance                |
| email_opt_in      | integer | 1 = subscribed to marketing email     |
| has_app           | integer | 1 = has Under Armour app              |
| preferred_sport   | string  | Customer preferred sport category     |

## Important Columns for Analysis

| Column            | Used For                         |
| ----------------- | -------------------------------- |
| is_churned        | Churn analysis                   |
| segment           | Segment-level retention analysis |
| lifetime_value    | Customer value analysis          |
| is_loyalty_member | Loyalty impact analysis          |
| has_app           | App usage analysis               |
| email_opt_in      | Email channel analysis           |
| preferred_sport   | Personalization analysis         |

---

# 2. products

## Description

One row per product SKU.

## Primary Key

| Column     | Description               |
| ---------- | ------------------------- |
| product_id | Unique product identifier |

## Columns

| Column         | Type    | Description                 |
| -------------- | ------- | --------------------------- |
| product_id     | string  | Unique product ID           |
| product_name   | string  | Product name                |
| category       | string  | Product category            |
| brand          | string  | Under Armour product line   |
| gender_target  | string  | Men, Women, Unisex, or Kids |
| price          | float   | Product price               |
| avg_rating     | float   | Average product rating      |
| num_ratings    | float   | Number of product ratings   |
| stock_quantity | float   | Units available in stock    |
| discount_pct   | integer | Product discount percentage |
| is_featured    | integer | 1 = featured product        |
| is_new_arrival | integer | 1 = new arrival             |
| weight_kg      | float   | Product shipping weight     |

## Important Columns for Analysis

| Column       | Used For                            |
| ------------ | ----------------------------------- |
| category     | Product-level analysis              |
| brand        | Product line analysis               |
| price        | Revenue and recommendation analysis |
| avg_rating   | Product quality analysis            |
| discount_pct | Discount behavior analysis          |

---

# 3. transactions

## Description

One row per transaction event.

## Primary Key

| Column         | Description                   |
| -------------- | ----------------------------- |
| transaction_id | Unique transaction identifier |

## Foreign Keys

| Column      | References            |
| ----------- | --------------------- |
| customer_id | customers.customer_id |
| product_id  | products.product_id   |

## Columns

| Column           | Type     | Description                                |
| ---------------- | -------- | ------------------------------------------ |
| transaction_id   | string   | Unique transaction ID                      |
| customer_id      | string   | Customer who made the transaction          |
| product_id       | string   | Product purchased                          |
| transaction_date | datetime | Date and time of transaction               |
| quantity         | integer  | Units purchased                            |
| unit_price       | float    | Unit price after discount                  |
| total_amount     | float    | Total transaction amount                   |
| discount_applied | float    | Discount applied to product                |
| loyalty_discount | float    | Extra loyalty discount                     |
| status           | string   | completed, returned, cancelled, or pending |
| payment_method   | string   | Payment method used                        |
| shipping_cost    | float    | Shipping cost                              |

## Important Columns for Analysis

| Column           | Used For                                  |
| ---------------- | ----------------------------------------- |
| transaction_date | Revenue trend and cohort analysis         |
| total_amount     | Revenue and monetary value                |
| status           | Completed revenue, returns, cancellations |
| customer_id      | RFM and customer-level analysis           |
| quantity         | Units sold analysis                       |

---

# 4. sessions

## Description

One row per website or app browsing session.

## Primary Key

| Column     | Description               |
| ---------- | ------------------------- |
| session_id | Unique session identifier |

## Foreign Key

| Column      | References            |
| ----------- | --------------------- |
| customer_id | customers.customer_id |

## Columns

| Column             | Type     | Description                          |
| ------------------ | -------- | ------------------------------------ |
| session_id         | string   | Unique session ID                    |
| customer_id        | string   | Customer associated with the session |
| session_date       | datetime | Session timestamp                    |
| device             | string   | mobile, desktop, or tablet           |
| channel            | string   | Traffic channel                      |
| duration_seconds   | float    | Session duration                     |
| pages_viewed       | float    | Pages viewed in session              |
| converted          | integer  | 1 = session converted                |
| bounced            | integer  | 1 = bounced session                  |
| cart_additions     | integer  | Items added to cart                  |
| is_loyalty_session | integer  | 1 = loyalty member session           |

## Important Columns for Analysis

| Column         | Used For                     |
| -------------- | ---------------------------- |
| device         | Device analysis              |
| channel        | Acquisition channel analysis |
| converted      | Session conversion           |
| bounced        | Engagement quality           |
| cart_additions | Shopping intent              |

---

# 5. reviews

## Description

One row per product review.

## Primary Key

| Column    | Description              |
| --------- | ------------------------ |
| review_id | Unique review identifier |

## Foreign Keys

| Column      | References            |
| ----------- | --------------------- |
| customer_id | customers.customer_id |
| product_id  | products.product_id   |

## Columns

| Column            | Type    | Description                                 |
| ----------------- | ------- | ------------------------------------------- |
| review_id         | string  | Unique review ID                            |
| customer_id       | string  | Review author                               |
| product_id        | string  | Reviewed product                            |
| review_date       | date    | Review date                                 |
| rating            | integer | Rating from 1 to 5                          |
| review_text       | string  | Written review text                         |
| helpful_votes     | float   | Number of helpful votes                     |
| verified_purchase | integer | 1 = verified buyer                          |
| review_source     | string  | Website, mobile app, or post-purchase email |

## Important Columns for Analysis

| Column            | Used For                |
| ----------------- | ----------------------- |
| rating            | Product satisfaction    |
| verified_purchase | Review credibility      |
| review_source     | Review channel analysis |

---

# 6. experiments

## Description

One row per customer exposed to an A/B test variant.

A cleaned version named `experiments_clean` was created to remove one duplicate exposure row.

## Composite Key Used for Cleaning

| Columns                                                  |
| -------------------------------------------------------- |
| experiment_id + customer_id + session_id + exposure_date |

## Foreign Keys

| Column      | References            |
| ----------- | --------------------- |
| customer_id | customers.customer_id |
| session_id  | sessions.session_id   |

## Columns

| Column                 | Type    | Description                                          |
| ---------------------- | ------- | ---------------------------------------------------- |
| experiment_id          | string  | Experiment code                                      |
| experiment_name        | string  | Experiment name                                      |
| experiment_goal        | string  | Business goal of the experiment                      |
| customer_id            | string  | Exposed customer                                     |
| session_id             | string  | Session where exposure happened                      |
| variant                | string  | control or treatment                                 |
| recommendation_type    | string  | generic, personalized, sport_based, or loyalty_based |
| exposure_date          | date    | Date of experiment exposure                          |
| clicked_recommendation | integer | 1 = clicked recommendation                           |
| converted              | integer | 1 = converted after exposure                         |
| revenue                | float   | Revenue generated by exposure                        |

## Important Columns for Analysis

| Column                 | Used For                      |
| ---------------------- | ----------------------------- |
| variant                | Control vs treatment analysis |
| clicked_recommendation | CTR calculation               |
| converted              | Conversion rate calculation   |
| revenue                | Revenue uplift                |
| experiment_goal        | Business goal grouping        |

---

# 7. recommendation_events

## Description

One row per product recommendation shown to a customer.

## Primary Key

| Column   | Description                            |
| -------- | -------------------------------------- |
| event_id | Unique recommendation event identifier |

## Foreign Keys

| Column      | References            |
| ----------- | --------------------- |
| customer_id | customers.customer_id |
| session_id  | sessions.session_id   |
| product_id  | products.product_id   |

## Columns

| Column               | Type     | Description                                          |
| -------------------- | -------- | ---------------------------------------------------- |
| event_id             | string   | Unique recommendation event ID                       |
| customer_id          | string   | Customer who saw the recommendation                  |
| session_id           | string   | Session where recommendation was shown               |
| product_id           | string   | Recommended product                                  |
| recommendation_model | string   | generic, personalized, sport_based, or loyalty_based |
| event_date           | datetime | Recommendation event timestamp                       |
| impression           | integer  | 1 = recommendation shown                             |
| clicked              | integer  | 1 = recommendation clicked                           |
| purchased            | integer  | 1 = purchase after recommendation                    |
| revenue              | float    | Revenue from recommendation                          |

## Important Columns for Analysis

| Column               | Used For                      |
| -------------------- | ----------------------------- |
| recommendation_model | Model comparison              |
| impression           | Recommendation exposure count |
| clicked              | CTR calculation               |
| purchased            | Purchase rate calculation     |
| revenue              | Recommendation revenue        |

---

# Table Relationships

```text
customers.customer_id              → transactions.customer_id
customers.customer_id              → sessions.customer_id
customers.customer_id              → reviews.customer_id
customers.customer_id              → experiments.customer_id
customers.customer_id              → recommendation_events.customer_id

products.product_id                → transactions.product_id
products.product_id                → reviews.product_id
products.product_id                → recommendation_events.product_id

sessions.session_id                → experiments.session_id
sessions.session_id                → recommendation_events.session_id
```

---

# Null Value Summary

| Table                 | Column           | Null % | Reason                          |
| --------------------- | ---------------- | -----: | ------------------------------- |
| customers             | age              |     7% | Guest checkout skipped age      |
| customers             | gender           |    11% | Optional demographic field      |
| customers             | lifetime_value   |     4% | New customer                    |
| customers             | preferred_sport  |     9% | Not filled at signup            |
| products              | avg_rating       |     8% | New product with no reviews     |
| products              | num_ratings      |     8% | New product with no reviews     |
| products              | stock_quantity   |     4% | Clearance item                  |
| transactions          | discount_applied |     3% | Not always logged               |
| transactions          | loyalty_discount |     6% | Non-member or not applicable    |
| transactions          | shipping_cost    |     5% | Digital or pickup order         |
| sessions              | channel          |     9% | Ad blocker or untracked traffic |
| sessions              | duration_seconds |     6% | Tracking failure                |
| sessions              | pages_viewed     |     6% | Tracking failure                |
| reviews               | review_text      |    22% | Rating only                     |
| reviews               | helpful_votes    |     7% | Not recorded                    |
| experiments           | session_id       |     4% | Session not tracked             |
| recommendation_events | session_id       |     5% | Session expired                 |
| recommendation_events | revenue          |     3% | Payment tracking failure        |

---

# Clean Views Created

The raw tables were converted into clean SQL views for analysis.

| Clean View                  | Purpose                                        |
| --------------------------- | ---------------------------------------------- |
| customers_clean             | Clean customer profile fields                  |
| products_clean              | Product table for analysis                     |
| transactions_clean          | Cast transaction dates and keep revenue fields |
| sessions_clean              | Clean session channel and cast dates           |
| reviews_clean               | Cast review dates                              |
| experiments_clean           | Remove duplicate experiment exposure           |
| recommendation_events_clean | Replace missing recommendation revenue with 0  |

---

# BI-Ready Views Exported

| View                                  | Purpose                                       |
| ------------------------------------- | --------------------------------------------- |
| bi_executive_summary_kpis             | Executive KPI cards                           |
| bi_monthly_revenue_kpis               | Revenue and transaction health trend          |
| bi_segment_churn_revenue              | Segment churn and revenue analysis            |
| bi_rfm_customer_segments              | Customer-level RFM segmentation               |
| bi_rfm_segment_summary                | RFM segment summary                           |
| bi_cohort_retention_summary           | Cohort retention analysis                     |
| bi_cohort_milestone_summary           | Cohort retention milestone trends             |
| bi_recommendation_model_performance   | Recommendation model comparison               |
| bi_recommendation_segment_performance | Recommendation performance by segment         |
| bi_personalized_vs_generic_uplift     | Personalized vs generic uplift                |
| bi_experiment_ab_summary              | A/B test variant-level summary                |
| bi_experiment_uplift_summary          | Experiment uplift summary                     |
| bi_experiment_significance_summary    | Experiment z-score and rollout recommendation |

---

# Notes

* The dataset is synthetic and created for analytics practice.
* Under Armour real customer data is proprietary and not included.
* The analysis uses aggregated BI-ready tables in Power BI to keep the dashboard lightweight.
* The project follows a SQL-first workflow.
