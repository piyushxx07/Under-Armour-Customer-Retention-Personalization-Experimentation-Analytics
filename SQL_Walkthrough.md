# SQL Walkthrough

## Project

**Under Armour Customer Retention, Personalization & Experimentation Analytics**

## Purpose of This Document

This document explains the SQL workflow used in this project in simple language.

The project follows a complete analytics flow:

```text
Data validation → Cleaning → KPI creation → Churn analysis → Revenue analysis → RFM segmentation → Cohort analysis → Personalization analytics → A/B testing → BI-ready views
```

Each SQL file has a clear business purpose and prepares the data for Power BI dashboarding.

---

# SQL Workflow Overview

| SQL File                        | Main Purpose                                                   |
| ------------------------------- | -------------------------------------------------------------- |
| 01_data_validation.sql          | Check whether the dataset is loaded correctly                  |
| 02_clean_views.sql              | Create cleaned versions of raw tables                          |
| 03_executive_kpis.sql           | Create high-level business KPIs                                |
| 04_churn_analysis.sql           | Analyze which customers are leaving                            |
| 05_revenue_analysis.sql         | Analyze revenue, transactions, returns, and cancellations      |
| 06_rfm_segmentation.sql         | Segment customers using Recency, Frequency, and Monetary value |
| 07_cohort_analysis.sql          | Track customer retention after first purchase                  |
| 08_personalization_analysis.sql | Compare recommendation model performance                       |
| 09_ab_testing_analysis.sql      | Measure experiment uplift and statistical significance         |
| 10_bi_ready_views.sql           | Preview final Power BI-ready output views                      |

---

# 01_data_validation.sql

## What this file does

This file checks whether the raw dataset is reliable before starting analysis.

It validates:

* Row counts
* Duplicate IDs
* Duplicate experiment exposures
* Foreign key relationships
* Date ranges

## Why this is important

Before doing business analysis, we need to know whether the data is trustworthy.

If the row counts are wrong, IDs are duplicated, or relationships are broken, the final dashboard can show incorrect insights.

## Concepts used

| Concept               | Meaning                                                      |
| --------------------- | ------------------------------------------------------------ |
| Row count validation  | Checking how many records exist in each table                |
| Primary key check     | Checking whether unique ID columns are actually unique       |
| Duplicate detection   | Finding repeated rows that may distort analysis              |
| Foreign key check     | Making sure IDs in one table exist in the related table      |
| Date range validation | Checking whether date columns cover the expected time period |

## Example logic

The project checks whether:

```text
transactions.customer_id exists in customers.customer_id
transactions.product_id exists in products.product_id
sessions.customer_id exists in customers.customer_id
```

## Business meaning

This step confirms that the dataset is clean enough to support retention, revenue, and experimentation analysis.

---

# 02_clean_views.sql

## What this file does

This file creates clean SQL views from the raw tables.

Clean views created:

| Clean View                  | Purpose                                             |
| --------------------------- | --------------------------------------------------- |
| customers_clean             | Cleans customer demographic and loyalty fields      |
| products_clean              | Keeps product attributes for analysis               |
| transactions_clean          | Casts transaction dates and prepares revenue fields |
| sessions_clean              | Cleans session channels and engagement fields       |
| reviews_clean               | Casts review dates                                  |
| experiments_clean           | Removes one duplicate experiment exposure           |
| recommendation_events_clean | Replaces missing recommendation revenue with 0      |

## Why this is important

Raw data often contains missing values, mixed data types, and duplicate records.

Instead of changing the original dataset, this project creates clean views. This keeps the raw data untouched and gives analysts a safer layer for analysis.

## Concepts used

| Concept      | Meaning                                   |
| ------------ | ----------------------------------------- |
| SQL View     | A saved query that behaves like a table   |
| COALESCE     | Replaces null values with a default value |
| CAST         | Converts a column into another data type  |
| ROW_NUMBER   | Assigns row numbers to detect duplicates  |
| PARTITION BY | Groups rows before ranking or numbering   |

## Example cleaning decisions

| Column                        | Cleaning Logic                                  |
| ----------------------------- | ----------------------------------------------- |
| customers.gender              | Null replaced with `Unknown`                    |
| customers.preferred_sport     | Null replaced with `Unknown`                    |
| customers.lifetime_value      | Null replaced with `0`                          |
| sessions.channel              | Null replaced with `unknown`                    |
| recommendation_events.revenue | Null replaced with `0`                          |
| experiments                   | Duplicate exposure removed using `ROW_NUMBER()` |

## Business meaning

This creates a clean foundation for all later KPIs, churn analysis, RFM segmentation, cohort analysis, recommendation analytics, and A/B testing.

---

# 03_executive_kpis.sql

## What this file does

This file creates high-level business KPIs.

It calculates:

* Total customers
* Active customers
* Churned customers
* Churn rate
* Retention rate
* Loyalty membership percentage
* Completed revenue
* Average transaction value
* Repeat purchase rate
* Recommendation CTR
* Experiment uplift summary

## Why this is important

Executives need a quick view of business health before going into detailed analysis.

This file creates the one-row table:

```text
bi_executive_summary_kpis
```

This table is used for the main KPI cards in Power BI.

## Concepts used

| Concept             | Meaning                                           |
| ------------------- | ------------------------------------------------- |
| KPI                 | Key Performance Indicator                         |
| Churn rate          | Percentage of customers who left                  |
| Retention rate      | Percentage of customers who stayed                |
| Revenue             | Money generated from completed transactions       |
| CTR                 | Click-through rate                                |
| Incremental revenue | Extra revenue generated by treatment over control |

## Business meaning

This file answers:

```text
How healthy is the business overall?
```

It gives the main numbers used on the Executive Overview dashboard page.

---

# 04_churn_analysis.sql

## What this file does

This file analyzes churn from different angles.

It calculates churn by:

* Customer segment
* Loyalty membership
* App usage
* Email opt-in
* Country

## Why this is important

Churn is not always spread evenly across all customers.

This file helps identify which customer groups are more likely to leave.

## Concepts used

| Concept          | Meaning                                   |
| ---------------- | ----------------------------------------- |
| Churned customer | Customer marked as inactive or lost       |
| Active customer  | Customer not marked as churned            |
| Segment analysis | Comparing behavior across customer groups |
| Loyalty analysis | Comparing loyalty members vs non-members  |

## Key business finding

Churn is concentrated in low-engagement segments:

| Segment         | Churn Rate |
| --------------- | ---------: |
| One-Time Buyer  |     55.10% |
| Discount Hunter |     32.44% |
| Casual Buyer    |     21.96% |

Loyalty segments have much lower churn:

| Segment             | Churn Rate |
| ------------------- | ---------: |
| UA Rewards Member   |      8.93% |
| Performance Athlete |      6.96% |
| UA Rewards Elite    |      4.01% |

## Business meaning

This file answers:

```text
Who is leaving and where should retention teams focus?
```

---

# 05_revenue_analysis.sql

## What this file does

This file analyzes revenue and transaction health.

It calculates:

* Total transaction rows
* Completed transactions
* Returned transactions
* Cancelled transactions
* Pending transactions
* Completed revenue
* Average transaction value
* Units sold
* Return rate
* Cancellation rate
* Monthly revenue trends
* Revenue by customer segment

## Why this is important

Retention is not only about customers staying or leaving. It is also about whether purchases successfully become revenue.

Returns and cancellations can reduce actual business value.

## Concepts used

| Concept           | Meaning                                                                   |
| ----------------- | ------------------------------------------------------------------------- |
| Completed revenue | Revenue from completed transactions only                                  |
| Return rate       | Percentage of transaction rows returned                                   |
| Cancellation rate | Percentage of transaction rows cancelled                                  |
| AOV               | Average order or transaction value                                        |
| Revenue leakage   | Revenue lost or delayed through returns, cancellations, or pending orders |

## BI-ready views created

| View                     | Purpose                                             |
| ------------------------ | --------------------------------------------------- |
| bi_monthly_revenue_kpis  | Monthly revenue, transaction, and order status KPIs |
| bi_segment_churn_revenue | Segment-level churn and revenue summary             |

## Business meaning

This file answers:

```text
Is the business generating healthy revenue, and where is revenue leaking?
```

---

# 06_rfm_segmentation.sql

## What this file does

This file creates RFM customer segmentation.

RFM means:

| RFM Metric | Meaning                           |
| ---------- | --------------------------------- |
| Recency    | How recently a customer purchased |
| Frequency  | How often a customer purchased    |
| Monetary   | How much money a customer spent   |

## Why this is important

Not all customers should receive the same retention strategy.

RFM helps identify:

* Best customers
* Loyal customers
* Dormant customers
* At-risk high-value customers
* New promising customers

## Concepts used

| Concept            | Meaning                                     |
| ------------------ | ------------------------------------------- |
| Recency score      | Higher score means more recent purchase     |
| Frequency score    | Higher score means more purchases           |
| Monetary score     | Higher score means higher spend             |
| NTILE              | Divides customers into equal scoring groups |
| RFM score          | Combined customer value score               |
| Recommended action | Business action assigned to each segment    |

## RFM segments created

| RFM Segment                  | Recommended Action  |
| ---------------------------- | ------------------- |
| VIP Customers                | Protect and Reward  |
| Loyal Customers              | Maintain Engagement |
| At-Risk High-Value Customers | Win Back            |
| At-Risk Loyal Customers      | Win Back            |
| Lost / Dormant Customers     | Reactivation        |
| New / Promising Customers    | Nurture             |
| Big Spenders - Low Frequency | Increase Frequency  |
| Regular Customers            | Maintain Engagement |

## BI-ready views created

| View                     | Purpose                   |
| ------------------------ | ------------------------- |
| bi_rfm_customer_segments | Customer-level RFM output |
| bi_rfm_segment_summary   | RFM segment-level summary |

## Business meaning

This file answers:

```text
Which customers should we protect, win back, reactivate, or nurture?
```

---

# 07_cohort_analysis.sql

## What this file does

This file creates cohort retention analysis.

A cohort is a group of customers who first purchased in the same month.

This file tracks whether those customers returned in later months.

## Why this is important

Cohort analysis shows whether customer retention is improving or declining over time.

It helps compare older customers with newer customers.

## Concepts used

| Concept               | Meaning                                        |
| --------------------- | ---------------------------------------------- |
| First purchase cohort | Month when customer made first purchase        |
| Cohort month          | First purchase month                           |
| Purchase month        | Month of later purchase activity               |
| Cohort age month      | Number of months after first purchase          |
| Retained customers    | Customers who purchased again in a later month |
| Retention rate        | Retained customers divided by cohort size      |

## BI-ready views created

| View                        | Purpose                                 |
| --------------------------- | --------------------------------------- |
| bi_cohort_retention_summary | Full cohort retention table             |
| bi_cohort_milestone_summary | Month 1, 3, 6, and 12 retention summary |

## Business meaning

This file answers:

```text
Are customers coming back after their first purchase?
```

---

# 08_personalization_analysis.sql

## What this file does

This file analyzes recommendation model performance.

It compares:

* Generic recommendations
* Personalized recommendations
* Sport-based recommendations
* Loyalty-based recommendations

## Why this is important

Personalization can improve engagement, conversion, and revenue.

This file proves whether personalized recommendations perform better than generic recommendations.

## Concepts used

| Concept                      | Meaning                                 |
| ---------------------------- | --------------------------------------- |
| Impression                   | Recommendation shown to a customer      |
| Click                        | Customer clicked a recommendation       |
| Purchase                     | Customer purchased after recommendation |
| CTR                          | Clicks divided by impressions           |
| CVR after click              | Purchases divided by clicks             |
| Purchase rate per impression | Purchases divided by impressions        |
| Revenue per impression       | Revenue divided by impressions          |
| Uplift                       | Improvement compared to another model   |

## BI-ready views created

| View                                  | Purpose                                   |
| ------------------------------------- | ----------------------------------------- |
| bi_recommendation_model_performance   | Overall model performance                 |
| bi_recommendation_segment_performance | Model performance by customer segment     |
| bi_personalized_vs_generic_uplift     | Personalized vs generic uplift by segment |

## Business meaning

This file answers:

```text
Do personalized recommendations perform better than generic recommendations?
```

---

# 09_ab_testing_analysis.sql

## What this file does

This file analyzes A/B experiments.

It compares control and treatment groups across 12 experiments.

It calculates:

* Control users
* Treatment users
* Control CTR
* Treatment CTR
* Control conversion rate
* Treatment conversion rate
* CTR uplift
* Conversion uplift
* Revenue uplift
* Incremental revenue
* Z-score
* Statistical significance
* Rollout recommendation

## Why this is important

A/B testing helps prove whether a business change actually works.

Instead of assuming treatment is better, this file checks whether treatment improvement is statistically strong.

## Concepts used

| Concept                  | Meaning                                       |
| ------------------------ | --------------------------------------------- |
| Control                  | Existing/default experience                   |
| Treatment                | New tested experience                         |
| Uplift                   | Improvement of treatment over control         |
| Incremental revenue      | Extra revenue created by treatment            |
| Z-score                  | Statistical test value                        |
| Statistical significance | Whether the result is likely not random       |
| Rollout recommendation   | Whether the business should use the treatment |

## BI-ready views created

| View                               | Purpose                            |
| ---------------------------------- | ---------------------------------- |
| bi_experiment_ab_summary           | Variant-level experiment metrics   |
| bi_experiment_uplift_summary       | Experiment-level uplift results    |
| bi_experiment_significance_summary | Z-score and rollout recommendation |

## Business meaning

This file answers:

```text
Which experiments worked and should be rolled out?
```

---

# 10_bi_ready_views.sql

## What this file does

This file lists and previews all final BI-ready views used in Power BI.

It does not create new analysis logic. It helps verify the final outputs.

## Why this is important

Power BI should use clean, final, analysis-ready tables.

This file documents all exported tables so the project is easier to understand.

## Final BI-ready views

| View                                  | Used For                                       |
| ------------------------------------- | ---------------------------------------------- |
| bi_executive_summary_kpis             | Executive KPI cards                            |
| bi_monthly_revenue_kpis               | Revenue and transaction trend page             |
| bi_segment_churn_revenue              | Churn and segment page                         |
| bi_rfm_customer_segments              | Customer-level RFM analysis                    |
| bi_rfm_segment_summary                | RFM dashboard page                             |
| bi_cohort_retention_summary           | Cohort retention analysis                      |
| bi_cohort_milestone_summary           | Cohort milestone charts                        |
| bi_recommendation_model_performance   | Recommendation model page                      |
| bi_recommendation_segment_performance | Recommendation by segment                      |
| bi_personalized_vs_generic_uplift     | Personalization uplift page                    |
| bi_experiment_ab_summary              | A/B test variant analysis                      |
| bi_experiment_uplift_summary          | Experiment uplift dashboard                    |
| bi_experiment_significance_summary    | Statistical significance and rollout decisions |

## Business meaning

This file answers:

```text
Which final SQL outputs are used in the dashboard?
```

---

# Complete SQL Story

The SQL workflow moves like this:

## Step 1: Validate the data

Check whether the raw data is complete and usable.

## Step 2: Clean the data

Create clean views with corrected dates, handled nulls, and duplicate removal.

## Step 3: Create executive KPIs

Summarize the business health in one table.

## Step 4: Analyze churn

Find which customer groups are leaving.

## Step 5: Analyze revenue

Understand revenue, AOV, returns, cancellations, and revenue leakage.

## Step 6: Build RFM segmentation

Classify customers by purchase recency, frequency, and monetary value.

## Step 7: Build cohort retention

Track whether customers come back after first purchase.

## Step 8: Analyze personalization

Compare recommendation models and personalization uplift.

## Step 9: Analyze experiments

Measure A/B test uplift and statistical significance.

## Step 10: Export BI-ready views

Prepare final clean tables for Power BI dashboarding.

---

# Why This SQL Workflow Is Strong

This SQL workflow demonstrates:

* Data validation
* Data cleaning
* Analytical view creation
* Business KPI development
* Customer segmentation
* Churn analysis
* RFM modeling
* Cohort retention
* Recommendation analytics
* A/B testing
* Statistical significance testing
* Power BI-ready data modeling

---

# Final Note

This project is SQL-first. Python was used only as the Kaggle execution environment to run DuckDB SQL and export CSV files.

The main analytics logic is written in SQL.
