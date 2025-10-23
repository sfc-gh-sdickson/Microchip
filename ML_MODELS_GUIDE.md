# ML Models for Microchip Intelligence Agent

## Overview

This adds **Machine Learning capabilities** to your Intelligence Agent using Snowflake's built-in statistical and ML functions. All models run 100% in Snowflake with no external dependencies.

---

## 🤖 ML Models Included

### 1. **Revenue Forecasting** 📈
- Predicts future monthly revenue using historical trends
- Uses linear regression on 24 months of data
- Provides confidence intervals (upper/lower bounds)
- **Agent Use:** "Forecast revenue for the next 6 months"

### 2. **Design Win Forecasting** 🎯
- Predicts future design wins by product family
- Analyzes historical win patterns
- Provides confidence levels (HIGH/MEDIUM/LOW)
- **Agent Use:** "Forecast design wins for PIC family over next 6 months"

### 3. **Quality Issue Anomaly Detection** ⚠️
- Identifies products with unusual quality issue rates
- Uses statistical analysis (z-scores, standard deviations)
- Flags products needing attention
- **Agent Use:** "Detect products with anomalous quality issue patterns"

### 4. **Customer Order Anomaly Detection** 📊
- Detects unusual spikes or drops in customer ordering
- Compares recent vs. historical patterns
- Identifies at-risk customers
- **Agent Use:** "Which customers have unusual order patterns?"

### 5. **Customer Churn Risk Prediction** 🚨
- Predicts which customers are at risk of churning
- Multi-factor scoring: orders, satisfaction, quality issues, contracts
- Provides recommended actions
- **Agent Use:** "Show me customers at high risk of churn"

### 6. **Design Win Conversion Probability** 🔮
- Predicts which designs will convert to production
- Factors: customer history, engineer certs, volume, quality
- Prioritizes high-probability wins
- **Agent Use:** "Which design wins are most likely to convert to production?"

### 7. **Support Ticket Spike Detection** 📞
- Detects unusual spikes in support volume
- Weekly analysis with deviation scoring
- Identifies top issue types during spikes
- **Agent Use:** "Detect unusual support ticket patterns"

---

## 📁 Files

- `sql/ml/07_create_ml_models.sql` - All 7 ML functions
- `ML_MODELS_GUIDE.md` - This guide
- `ML_AGENT_SETUP.md` - How to add to agent (created next)

---

## 🚀 Quick Setup (10 minutes)

### Step 1: Execute ML Functions SQL (2 min)
```sql
@sql/ml/07_create_ml_models.sql
```

### Step 2: Grant Permissions (2 min)
```sql
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.FORECAST_MONTHLY_REVENUE(INT) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.FORECAST_DESIGN_WINS(VARCHAR, INT) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.DETECT_QUALITY_ANOMALIES() TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.DETECT_ORDER_ANOMALIES() TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_CUSTOMER_CHURN_RISK() TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_DESIGN_WIN_CONVERSION() TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.DETECT_SUPPORT_ANOMALIES() TO ROLE <your_role>;
```

### Step 3: Add to Agent as Tools (5 min)

In Snowsight → AI & ML → Agents → Your Agent → Tools:

For each function, click **+ Add** → **Function** → Select function → Add description

**Detailed UI steps in:** `ML_AGENT_SETUP.md`

---

## 💡 Example Questions Agent Can Answer

### Forecasting
```
"Forecast revenue for the next 6 months"
"Predict design wins for the next quarter"
"What are the revenue projections with confidence intervals?"
```

### Anomaly Detection
```
"Which products have anomalous quality issue rates?"
"Detect customers with unusual order patterns"  
"Are there any support ticket spikes I should know about?"
"Show me quality anomalies by product family"
```

### Classification/Prediction
```
"Which customers are at high risk of churning?"
"Predict which design wins will convert to production"
"What's the churn risk score for automotive customers?"
"Show me design wins with >70% conversion probability"
```

### Combined Analysis
```
"Show me high churn risk customers and forecast their expected revenue"
"Which products have quality anomalies AND design wins in flight?"
"Detect order anomalies and classify churn risk for those customers"
```

---

## 🎯 Business Value

### For Sales Teams:
- 📈 Revenue forecasting for planning
- 🚨 Early churn detection
- 🎯 High-probability design win prioritization

### For Quality Teams:
- ⚠️ Proactive quality issue detection
- 📊 Product risk identification  
- 🔍 Anomaly investigation prioritization

### For Support Teams:
- 📞 Ticket spike early warning
- 🎯 Resource allocation optimization
- 📈 Trend analysis

### For Executives:
- 🔮 Predictive insights for planning
- 🚨 Risk mitigation opportunities
- 📊 Data-driven decision making

---

## 🔧 Technical Details

### All Models Use:
- ✅ **Snowflake SQL** - Native functions
- ✅ **Statistical methods** - Regression, z-scores, standard deviations
- ✅ **Historical data** - 24-36 months of patterns
- ✅ **Multi-factor analysis** - Combined metrics for accuracy
- ✅ **No external tools** - 100% Snowflake-native

### Data Sources:
- ORDERS (1M records with timestamps)
- DESIGN_WINS (500K records over 3 years)
- QUALITY_ISSUES (25K records)
- SUPPORT_TICKETS (75K records)
- CUSTOMERS (25K with metrics)

---

## 📊 Model Accuracy

### Revenue Forecast:
- **Method:** Linear regression on 24 months
- **Confidence:** 95% intervals provided
- **Best for:** 3-6 month projections

### Churn Prediction:
- **Method:** Multi-factor weighted scoring
- **Factors:** Order trends, CSAT, quality, contracts
- **Output:** Risk score 0-100 + recommended actions

### Anomaly Detection:
- **Method:** Statistical deviation (z-scores)
- **Threshold:** >2 standard deviations = anomaly
- **Sensitivity:** Adjustable via query parameters

### Conversion Probability:
- **Method:** Factor-based probability model
- **Factors:** Customer history, certifications, volume
- **Output:** 5-95% probability + likelihood tier

---

## ✅ Ready to Deploy

After setup, your agent can:
- ✅ Forecast future revenue and design wins
- ✅ Detect quality and ordering anomalies
- ✅ Predict customer churn risk
- ✅ Estimate design win conversion likelihood
- ✅ Identify support ticket spikes
- ✅ Provide actionable recommendations

**All using the data you've already generated!**

---

**Created:** October 22, 2025  
**Type:** Predictive Analytics & Anomaly Detection  
**Technology:** Snowflake SQL + Statistical Methods  
**External Dependencies:** None (100% Snowflake-native)


