# ML Analytics Views - Simple Approach

## What's Included

**4 ML-powered analytical VIEWS** (not functions) that the agent can query directly.

### 1. V_REVENUE_FORECAST
- Revenue trends with moving averages
- 6-month and 3-month forecasts
- Variance from trend analysis

### 2. V_CUSTOMER_CHURN_RISK
- Churn risk scoring (0-100)
- Risk levels: CRITICAL/HIGH/MEDIUM/LOW
- Based on orders, design wins, CSAT, quality issues

### 3. V_QUALITY_ANOMALIES
- Products with unusual defect rates
- Statistical anomaly detection (z-scores)
- Severity levels

### 4. V_ORDER_ANOMALIES
- Customers with unusual order patterns
- Drops vs spikes identification
- Deviation percentages

### 5. V_DESIGN_WIN_CONVERSION_PROBABILITY
- Conversion likelihood for each design win
- Probability percentages
- Key influencing factors

---

## Setup (5 minutes)

1. Execute: `@sql/ml/07_create_ml_views.sql`
2. That's it - agent can query these views directly using Cortex Analyst

**No functions to add. No complex setup. Just views the agent can query.**

---

## Example Questions

```
"Show me customers at high churn risk"
→ Agent queries V_CUSTOMER_CHURN_RISK

"Which products have quality anomalies?"
→ Agent queries V_QUALITY_ANOMALIES

"Show revenue forecast with trends"
→ Agent queries V_REVENUE_FORECAST

"Which design wins are likely to convert?"
→ Agent queries V_DESIGN_WIN_CONVERSION_PROBABILITY

"Detect customers with unusual order patterns"
→ Agent queries V_ORDER_ANOMALIES
```

---

**Simple. Verified. Works.**


