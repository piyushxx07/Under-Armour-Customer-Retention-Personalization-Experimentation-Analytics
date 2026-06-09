# Project Summary

## Project Title

**Under Armour Customer Retention, Personalization & Experimentation Analytics**

## Project Type

SQL + Power BI ecommerce product analytics project.

## Target Business Area

Customer retention, lifecycle analytics, personalization, and experimentation.

---

## Business Context

Under Armour wants to understand how customers behave after signup and purchase. The business wants to identify which customers are retained, which customers are at risk, and whether personalization can improve conversion, revenue, and retention.

The project is designed around the following business problem:

> Customers may purchase once, become inactive, or churn. The business needs a retention and personalization strategy supported by data.

---

## Core Business Questions

1. What is the overall customer retention and churn rate?
2. Which customer segments have the highest churn risk?
3. Are loyalty members more valuable and better retained?
4. Which customer groups should be protected, reactivated, or won back?
5. How does revenue behave over time?
6. Which cohorts retain better over time?
7. Do personalized recommendations outperform generic recommendations?
8. Which A/B experiments created the strongest uplift?
9. Which treatments should be rolled out?

---

## Dataset

The project uses a synthetic Under Armour ecommerce customer behavior dataset.

### Tables Used

| Table                 | Purpose                                                    |
| --------------------- | ---------------------------------------------------------- |
| customers             | Customer profile, churn, loyalty, app usage, email opt-in  |
| products              | Product attributes                                         |
| transactions          | Purchase activity, revenue, order status                   |
| sessions              | Browsing and conversion behavior                           |
| reviews               | Customer review behavior                                   |
| experiments           | A/B testing exposures and outcomes                         |
| recommendation_events | Recommendation impressions, clicks, purchases, and revenue |

---

## Data Preparation

The SQL workflow included:

* Row count validation
* Duplicate key checks
* Foreign key checks
* Date range validation
* Null handling
* Clean view creation
* BI-ready summary table creation

One duplicate experiment exposure was identified and removed using a cleaned view.

---

## SQL Analysis Completed

### 1. Data Validation

Confirmed all tables were loaded correctly.

Final row counts:

| Table                 |      Rows |
| --------------------- | --------: |
| customers             |   200,000 |
| products              |    10,000 |
| transactions          | 3,000,000 |
| sessions              | 2,000,000 |
| reviews               |   500,000 |
| experiments_clean     |   399,995 |
| recommendation_events |   600,000 |

---

### 2. Executive KPI Analysis

Key results:

| KPI                |     Value |
| ------------------ | --------: |
| Total Customers    |   200,000 |
| Active Customers   |   162,869 |
| Churned Customers  |    37,131 |
| Churn Rate         |    18.57% |
| Retention Rate     |    81.43% |
| Loyalty Member %   |    54.51% |
| Avg Lifetime Value | $2,219.95 |

---

### 3. Churn Analysis

Churn by segment showed that churn is concentrated in low-engagement segments.

| Segment             | Churn Rate |
| ------------------- | ---------: |
| One-Time Buyer      |     55.10% |
| Discount Hunter     |     32.44% |
| Casual Buyer        |     21.96% |
| UA Rewards Member   |      8.93% |
| Performance Athlete |      6.96% |
| UA Rewards Elite    |      4.01% |

Main finding:

> Loyalty and engagement are stronger churn indicators than country, app usage, or email opt-in.

---

### 4. Revenue Health Analysis

Key revenue metrics:

| Metric                          |     Value |
| ------------------------------- | --------: |
| Completed Revenue               |  $190.14M |
| Completed Transactions          | 1,875,600 |
| Avg Completed Transaction Value |   $101.38 |
| Completed Units Sold            | 2,907,305 |
| Completed Transaction %         |    62.52% |

Returns and cancellations represented a major revenue leakage area.

---

### 5. RFM Segmentation

RFM segmentation created customer groups based on recency, frequency, and monetary value.

Final RFM segments:

| Segment                      | Customers | Churn Rate | Total Monetary Value |
| ---------------------------- | --------: | ---------: | -------------------: |
| VIP Customers                |    41,345 |      7.37% |              $76.43M |
| Regular Customers            |    38,439 |     14.99% |              $41.33M |
| Loyal Customers              |    21,900 |     12.23% |              $19.82M |
| Lost / Dormant Customers     |    51,862 |     30.42% |              $16.71M |
| At-Risk High-Value Customers |     9,345 |      7.17% |              $15.47M |
| At-Risk Loyal Customers      |    16,335 |     14.48% |              $13.76M |
| New / Promising Customers    |    14,296 |     26.25% |               $6.16M |
| Big Spenders - Low Frequency |       332 |     20.78% |               $0.45M |

Main finding:

> VIP customers should be protected, while At-Risk High-Value customers represent a strong win-back opportunity.

---

### 6. Cohort Retention Analysis

Cohort analysis tracked repeat purchase behavior after first purchase.

Metrics created:

* Cohort month
* Cohort age month
* Cohort size
* Retained customers
* Retention rate
* Month 1 retention
* Month 3 retention
* Month 6 retention
* Month 12 retention

Main finding:

> Cohort analysis helps identify whether newer customer cohorts retain as well as older cohorts.

---

### 7. Personalization Analytics

Recommendation models were compared across impressions, clicks, purchases, and revenue.

| Model         |    CTR | Purchase Rate per Impression | Revenue per Impression |
| ------------- | -----: | ---------------------------: | ---------------------: |
| Personalized  | 19.54% |                        1.94% |                $1.3224 |
| Sport Based   | 16.61% |                        1.36% |                $0.9340 |
| Loyalty Based | 14.80% |                        1.02% |                $0.7070 |
| Generic       |  9.77% |                        0.39% |                $0.2605 |

Main finding:

> Personalized recommendations outperform generic recommendations across engagement, conversion, and revenue efficiency.

---

### 8. A/B Testing Analysis

A/B test analysis compared control and treatment variants across 12 experiments.

Metrics calculated:

* Control users
* Treatment users
* Control CTR
* Treatment CTR
* Control conversion rate
* Treatment conversion rate
* CTR uplift
* Conversion uplift
* Revenue per user uplift
* Incremental revenue
* Z-score
* Significance result
* Rollout recommendation

Strongest experiment:

| Experiment                              | Revenue/User Uplift | Z-score |
| --------------------------------------- | ------------------: | ------: |
| UA Rewards Early Access Personalization |             118.66% |   20.53 |

Main finding:

> Treatment variants showed statistically significant improvement in this generated experiment dataset.

---

## BI-Ready Tables Created

The following BI-ready tables were exported for Power BI:

```text
bi_executive_summary_kpis
bi_monthly_revenue_kpis
bi_segment_churn_revenue
bi_rfm_customer_segments
bi_rfm_segment_summary
bi_cohort_retention_summary
bi_cohort_milestone_summary
bi_recommendation_model_performance
bi_recommendation_segment_performance
bi_personalized_vs_generic_uplift
bi_experiment_ab_summary
bi_experiment_uplift_summary
bi_experiment_significance_summary
```

---

## Power BI Dashboard Pages

| Page | Page Name                                 | Purpose                                       |
| ---- | ----------------------------------------- | --------------------------------------------- |
| 1    | Executive Overview                        | Overall business health                       |
| 2    | Revenue & Business Health                 | Revenue, AOV, transaction completion, leakage |
| 3    | Churn & Segment Risk                      | Segment-level churn and retention             |
| 4    | RFM Customer Segmentation                 | Customer value and action segmentation        |
| 5    | Cohort Retention Analysis                 | Cohort retention and repeat behavior          |
| 6    | Personalization Analytics                 | Recommendation model performance              |
| 7    | A/B Testing Results                       | Experiment uplift and rollout decisions       |
| 8    | Retention Strategy & Business Action Plan | Final strategic recommendations               |

---

## Final Project Outcome

This project shows how SQL and Power BI can be used to build a complete ecommerce product analytics system focused on retention, personalization, and experimentation.

It demonstrates:

* Data validation
* Business KPI development
* Customer churn analysis
* RFM segmentation
* Cohort retention analysis
* Recommendation analytics
* A/B testing and uplift analysis
* Statistical significance testing
* Power BI dashboard storytelling
