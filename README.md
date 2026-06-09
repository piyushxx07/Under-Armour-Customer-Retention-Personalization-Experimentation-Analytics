# Under Armour Customer Retention, Personalization & Experimentation Analytics

## Project Overview

This project analyzes a synthetic Under Armour ecommerce customer behavior dataset to understand customer retention, churn risk, RFM segmentation, cohort retention, personalization performance, and A/B experiment uplift.

The project is built using a SQL-first analytics workflow and Power BI for dashboard storytelling.

The goal is to answer one core business question:

> How can Under Armour improve customer retention, personalize customer experiences, and validate business decisions through experimentation?

---

## Business Problem

Ecommerce brands often acquire customers who purchase once, become inactive, or churn over time. Retention becomes harder when customers behave differently across loyalty status, purchase frequency, product interest, and engagement level.

This project focuses on identifying:

* Which customer segments are most likely to churn
* Which customers are high-value and should be protected
* Which dormant customers should be reactivated
* Whether personalized recommendations outperform generic recommendations
* Which A/B experiments should be rolled out based on uplift and statistical significance

---

## Tools Used

| Tool                | Purpose                                                                                                     |
| ------------------- | ----------------------------------------------------------------------------------------------------------- |
| SQL / DuckDB        | Data validation, cleaning, KPI creation, churn analysis, RFM, cohort analysis, personalization, A/B testing |
| Kaggle Notebook     | SQL execution and CSV export                                                                                |
| Power BI            | Dashboard design and business storytelling                                                                  |
| Power BI Theme JSON | Custom Under Armour-inspired dark visual theme                                                              |

---

## Dataset Overview

The dataset contains synthetic Under Armour ecommerce behavior data.

| Table                 | Description                                                 |
| --------------------- | ----------------------------------------------------------- |
| customers             | Customer profile, churn flag, loyalty membership, app usage |
| products              | Product catalog and product attributes                      |
| transactions          | Purchase events, revenue, order status, discounts           |
| sessions              | Website/app session behavior                                |
| reviews               | Product review behavior                                     |
| experiments           | A/B testing exposures and outcomes                          |
| recommendation_events | Recommendation impressions, clicks, purchases, and revenue  |

Final dataset scale:

| Metric                |                Value |
| --------------------- | -------------------: |
| Total customers       |              200,000 |
| Products              |               10,000 |
| Transactions          |            3,000,000 |
| Sessions              |            2,000,000 |
| Reviews               |              500,000 |
| Experiments           | 399,995 cleaned rows |
| Recommendation events |              600,000 |

---

## Analysis Modules

### 1. Data Validation

Performed checks for:

* Row counts
* Duplicate primary keys
* Foreign key relationship integrity
* Date ranges
* Null handling
* Clean SQL views

### 2. Executive KPI Analysis

Calculated:

* Total customers
* Active customers
* Churned customers
* Churn rate
* Retention rate
* Completed revenue
* Average transaction value
* Recommendation CTR
* Incremental experiment revenue

### 3. Churn & Segment Analysis

Analyzed churn by:

* Customer segment
* Loyalty membership
* App usage
* Email opt-in
* Country

### 4. Revenue Health Analysis

Analyzed:

* Completed revenue
* Transaction status mix
* Return rate
* Cancellation rate
* Units sold
* Monthly revenue seasonality

### 5. RFM Customer Segmentation

Built RFM segmentation using:

* Recency
* Frequency
* Monetary value

Created business action groups:

* VIP Customers
* Loyal Customers
* At-Risk High-Value Customers
* At-Risk Loyal Customers
* Lost / Dormant Customers
* New / Promising Customers
* Big Spenders - Low Frequency
* Regular Customers

### 6. Cohort Retention Analysis

Created cohort views to track:

* First purchase cohort
* Monthly retention
* Month 1 retention
* Month 3 retention
* Month 6 retention
* Month 12 retention

### 7. Personalization Analytics

Compared recommendation models:

* Generic
* Personalized
* Sport-based
* Loyalty-based

Measured:

* CTR
* CVR after click
* Purchase rate per impression
* Revenue per impression
* Revenue per click

### 8. A/B Testing & Experimentation

Analyzed 12 experiments using:

* Control vs treatment comparison
* CTR uplift
* Conversion uplift
* Revenue per user uplift
* Incremental revenue
* Z-score based statistical significance
* Rollout recommendation

---

## Dashboard Pages

The Power BI dashboard contains 8 pages:

| Page | Name                                      |
| ---- | ----------------------------------------- |
| 1    | Executive Overview                        |
| 2    | Revenue & Business Health                 |
| 3    | Churn & Segment Risk                      |
| 4    | RFM Customer Segmentation                 |
| 5    | Cohort Retention Analysis                 |
| 6    | Personalization Analytics                 |
| 7    | A/B Testing Results                       |
| 8    | Retention Strategy & Business Action Plan |

---

## Key Results

| KPI                       |   Result |
| ------------------------- | -------: |
| Total Customers           |  200,000 |
| Active Customers          |  162,869 |
| Churned Customers         |   37,131 |
| Churn Rate                |   18.57% |
| Retention Rate            |   81.43% |
| Completed Revenue         | $190.14M |
| Avg Transaction Value     |  $101.38 |
| Recommendation CTR        |   15.65% |
| Total Experiments         |       12 |
| Significant Experiments   |       12 |
| Total Incremental Revenue |   $1.32M |

---

## Key Insights

* Churn is concentrated in low-engagement customer segments.
* One-Time Buyers have the highest churn rate at 55.10%.
* UA Rewards Elite customers have the lowest churn rate at 4.01%.
* Loyalty members churn less and have higher lifetime value than non-loyalty customers.
* VIP customers generate the highest monetary value.
* Lost / Dormant customers form the largest inactive customer pool.
* Personalized recommendations outperform generic recommendations across CTR, purchase rate, and revenue efficiency.
* All 12 A/B test treatments show statistically significant improvement over control in this generated dataset.

---

## Business Recommendations

1. Protect VIP customers with early access, loyalty rewards, and premium personalization.
2. Win back at-risk high-value customers using personalized offers.
3. Reactivate lost and dormant customers through targeted campaigns.
4. Convert One-Time Buyers and Discount Hunters into loyalty members.
5. Roll out statistically significant personalization and loyalty experiments.
6. Improve app and email experiences because app usage and email opt-in alone did not strongly reduce churn.

---

## Repository Structure

```text
under-armour-retention-personalization-analytics/
│
├── README.md
├── project_summary.md
├── insights_summary.md
├── data_dictionary.md
│
├── dashboard/
│   ├── Under_Armour_Retention_Dashboard.pbix
│   └── dashboard_screenshots/
│
├── sql_files/
│   ├── 01_data_validation.sql
│   ├── 02_clean_views.sql
│   ├── 03_executive_kpis.sql
│   ├── 04_churn_analysis.sql
│   ├── 05_revenue_analysis.sql
│   ├── 06_rfm_segmentation.sql
│   ├── 07_cohort_analysis.sql
│   ├── 08_personalization_analysis.sql
│   ├── 09_ab_testing_analysis.sql
│   └── 10_bi_ready_views.sql
│
├── exported_bi_tables/
│
├── theme/
│   └── Under_Armour_Dark_Theme.json
│
│
└── notebook/
```

---

## How to Use This Project

1. Open the SQL files to review the full analysis logic.
2. Use the exported BI-ready CSV tables to recreate or validate the Power BI dashboard.
3. Open the Power BI `.pbix` file to explore the dashboard.
4. Review `insights_summary.md` for final business findings and recommendations.

---

## Limitations

* The dataset is synthetic and generated for portfolio analytics practice.
* Raw customer-level ecommerce data is not publicly available from Under Armour.
* The experiment data is designed to simulate personalization lift, so treatment variants generally outperform control.
* The analysis focuses on SQL and Power BI; Python machine learning was intentionally excluded to keep the project SQL-first.

---

## Project Outcome

This project demonstrates the ability to perform end-to-end ecommerce product analytics using SQL and Power BI, covering customer retention, segmentation, personalization, cohort analysis, and experimentation.
