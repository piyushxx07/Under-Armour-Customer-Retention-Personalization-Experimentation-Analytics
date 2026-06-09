# Insights Summary

## Executive Summary

The analysis shows that Under Armour has a strong overall customer base, but churn is concentrated in specific low-engagement customer groups. Loyalty customers and high-value RFM segments show stronger retention and higher revenue contribution.

Personalized recommendations significantly outperform generic recommendations, and A/B testing results support rolling out personalization and loyalty-focused treatments.

---

## 1. Overall Customer Health

| Metric                 |     Value |
| ---------------------- | --------: |
| Total Customers        |   200,000 |
| Active Customers       |   162,869 |
| Churned Customers      |    37,131 |
| Churn Rate             |    18.57% |
| Retention Rate         |    81.43% |
| Loyalty Member %       |    54.51% |
| Average Lifetime Value | $2,219.95 |

### Insight

The overall retention rate is strong at 81.43%, but the 18.57% churn rate still represents a meaningful customer loss opportunity.

### Business Meaning

The company should not treat churn as a general problem across all customers. The analysis shows churn is concentrated in specific customer groups.

---

## 2. Segment-Level Churn

| Segment             | Churn Rate | Avg Lifetime Value |
| ------------------- | ---------: | -----------------: |
| One-Time Buyer      |     55.10% |            $656.17 |
| Discount Hunter     |     32.44% |            $781.11 |
| Casual Buyer        |     21.96% |          $1,123.41 |
| UA Rewards Member   |      8.93% |          $2,764.40 |
| Performance Athlete |      6.96% |          $3,460.63 |
| UA Rewards Elite    |      4.01% |          $5,555.71 |

### Insight

One-Time Buyers, Discount Hunters, and Casual Buyers have the highest churn risk. UA Rewards Elite and Performance Athlete customers have much lower churn and higher customer value.

### Business Meaning

Churn is mainly a customer lifecycle and loyalty problem, not a general market problem.

### Recommendation

Focus retention campaigns on:

1. One-Time Buyers
2. Discount Hunters
3. Casual Buyers

Use loyalty conversion and personalized recommendations to move these customers toward stronger engagement.

---

## 3. Loyalty Membership Impact

| Loyalty Status     | Churn Rate | Avg Lifetime Value |
| ------------------ | ---------: | -----------------: |
| Non-Loyalty Member |     23.27% |          $1,667.09 |
| Loyalty Member     |     14.64% |          $2,681.40 |

### Insight

Loyalty members churn 8.63 percentage points less than non-loyalty members and generate about $1,014 more average lifetime value.

### Business Meaning

The loyalty program is a strong retention lever.

### Recommendation

Increase loyalty enrollment among:

* One-Time Buyers
* Discount Hunters
* Casual Buyers
* New / Promising Customers

---

## 4. App Usage and Email Opt-in

### App Usage

| Status       | Churn Rate |
| ------------ | ---------: |
| App User     |     18.76% |
| Non-App User |     18.25% |

### Email Opt-in

| Status          | Churn Rate |
| --------------- | ---------: |
| Email Opt-in    |     18.50% |
| No Email Opt-in |     18.74% |

### Insight

App usage and email opt-in do not strongly reduce churn by themselves.

### Business Meaning

Having the app or being subscribed to email is not enough. The experience inside the channel matters more than the channel itself.

### Recommendation

Improve:

* In-app personalization
* Push notification targeting
* Email personalization
* Loyalty nudges
* Product recommendation quality

---

## 5. Revenue Health

| Metric                          |     Value |
| ------------------------------- | --------: |
| Completed Revenue               |  $190.14M |
| Completed Transactions          | 1,875,600 |
| Avg Completed Transaction Value |   $101.38 |
| Completed Units Sold            | 2,907,305 |
| Completed Transaction Rate      |    62.52% |

### Insight

The business generates strong completed revenue, but returns and cancellations represent revenue leakage.

### Business Meaning

Retention strategy should also consider post-purchase satisfaction and reducing failed orders.

### Recommendation

Analyze return and cancellation drivers by:

* Product category
* Customer segment
* Discount behavior
* Channel
* Product rating

---

## 6. Revenue by Segment

| Segment             | Completed Revenue | Revenue per Customer |
| ------------------- | ----------------: | -------------------: |
| UA Rewards Member   |           $63.47M |            $1,434.60 |
| Performance Athlete |           $51.98M |            $1,304.17 |
| UA Rewards Elite    |           $33.97M |            $2,139.13 |
| Casual Buyer        |           $28.37M |              $506.10 |
| Discount Hunter     |           $10.81M |              $361.92 |
| One-Time Buyer      |            $1.55M |              $110.21 |

### Insight

High-engagement segments drive most revenue. UA Rewards Member, Performance Athlete, and UA Rewards Elite customers generate the majority of completed revenue.

### Business Meaning

Retention efforts should prioritize protecting high-value loyalty and performance-driven customers while improving low-value segment engagement.

---

## 7. RFM Segmentation

| RFM Segment                  | Customers | Churn Rate | Total Monetary Value | Recommended Action  |
| ---------------------------- | --------: | ---------: | -------------------: | ------------------- |
| VIP Customers                |    41,345 |      7.37% |              $76.43M | Protect and Reward  |
| Regular Customers            |    38,439 |     14.99% |              $41.33M | Maintain Engagement |
| Loyal Customers              |    21,900 |     12.23% |              $19.82M | Maintain Engagement |
| Lost / Dormant Customers     |    51,862 |     30.42% |              $16.71M | Reactivation        |
| At-Risk High-Value Customers |     9,345 |      7.17% |              $15.47M | Win Back            |
| At-Risk Loyal Customers      |    16,335 |     14.48% |              $13.76M | Win Back            |
| New / Promising Customers    |    14,296 |     26.25% |               $6.16M | Nurture             |
| Big Spenders - Low Frequency |       332 |     20.78% |               $0.45M | Increase Frequency  |

### Insight

VIP customers create the highest monetary value and have low churn. Lost / Dormant customers form the largest inactive group. At-Risk High-Value customers represent a major win-back opportunity.

### Business Meaning

The business should use different strategies for different customer groups instead of one generic retention campaign.

### Recommendation

* VIP Customers: protect and reward
* At-Risk High-Value Customers: win back
* Lost / Dormant Customers: reactivate
* New / Promising Customers: nurture
* Big Spenders - Low Frequency: increase purchase frequency

---

## 8. Cohort Retention

### Insight

Cohort analysis shows how customer retention changes after first purchase. Month 0 represents the first purchase month, while later months show repeat activity.

### Business Meaning

Cohort analysis helps determine whether newer acquisition cohorts are retaining as strongly as older cohorts.

### Recommendation

Use cohort retention trends to evaluate:

* Acquisition quality
* Campaign performance
* Retention strategy effectiveness
* Long-term repeat behavior

---

## 9. Recommendation Model Performance

| Model         |    CTR | CVR After Click | Purchase Rate per Impression | Revenue per Impression |
| ------------- | -----: | --------------: | ---------------------------: | ---------------------: |
| Personalized  | 19.54% |           9.91% |                        1.94% |                $1.3224 |
| Sport Based   | 16.61% |           8.20% |                        1.36% |                $0.9340 |
| Loyalty Based | 14.80% |           6.90% |                        1.02% |                $0.7070 |
| Generic       |  9.77% |           3.97% |                        0.39% |                $0.2605 |

### Insight

Personalized recommendations outperform generic recommendations across every major metric.

### Business Meaning

Personalization improves both engagement and revenue efficiency.

### Recommendation

Use personalized recommendations as a core retention and monetization lever.

---

## 10. Personalized vs Generic Uplift

| Segment             | Revenue per Impression Uplift |
| ------------------- | ----------------------------: |
| One-Time Buyer      |                       561.11% |
| Performance Athlete |                       458.65% |
| UA Rewards Member   |                       408.87% |
| Casual Buyer        |                       384.08% |
| Discount Hunter     |                       381.10% |
| UA Rewards Elite    |                       346.24% |

### Insight

One-Time Buyers receive the highest revenue-per-impression uplift from personalized recommendations.

### Business Meaning

The highest churn-risk segment also has the highest personalization upside.

### Recommendation

Use personalization specifically for high-risk customers before they become inactive.

---

## 11. A/B Testing Results

| Metric                                | Result |
| ------------------------------------- | -----: |
| Total Experiments                     |     12 |
| Treatment Wins                        |     12 |
| Statistically Significant Experiments |     12 |
| Rollout Recommendations               |     12 |
| Avg Revenue/User Uplift               | 79.97% |
| Total Incremental Revenue             | $1.32M |

### Strongest Experiment

| Experiment                              | Conversion Uplift | Revenue/User Uplift | Z-score |
| --------------------------------------- | ----------------: | ------------------: | ------: |
| UA Rewards Early Access Personalization |           121.64% |             118.66% |   20.53 |

### Insight

Treatment variants outperformed control variants in every experiment in this generated dataset.

### Business Meaning

Personalization and loyalty-focused experiences are strong candidates for rollout.

### Recommendation

Prioritize rollout of:

1. UA Rewards Early Access Personalization
2. Loyalty Tier Upgrade Nudge Test
3. Discount Banner Personalization Test
4. Sport-Based Recommendation Engine
5. Holiday Season Recommendation Engine

---

## Final Strategic Recommendations

### 1. Protect VIP Customers

VIP customers generate the highest monetary value and have low churn. They should receive early access, premium offers, and exclusive loyalty benefits.

### 2. Win Back At-Risk High-Value Customers

These customers have high historical value but long purchase inactivity. They should receive targeted win-back campaigns and personalized offers.

### 3. Reactivate Lost / Dormant Customers

Lost / Dormant customers form the largest inactive customer group. Reactivation campaigns should be tested with personalized recommendations and loyalty incentives.

### 4. Convert One-Time Buyers into Loyalty Members

One-Time Buyers have the highest churn rate but also the highest personalization uplift. They should be targeted quickly after first purchase.

### 5. Use Personalization as a Retention Lever

Personalized recommendations outperform generic recommendations across CTR, purchase rate, and revenue per impression.

### 6. Roll Out Statistically Significant Experiments

A/B testing supports rolling out treatment variants related to loyalty, personalization, sport affinity, and discount personalization.

---

## Final Business Conclusion

The analysis shows that Under Armour can improve customer retention by combining customer segmentation, loyalty strategy, personalization, and experimentation.

The strongest opportunity is to use personalized experiences to move customers from low-engagement, high-churn segments into higher-value loyalty and VIP segments.
