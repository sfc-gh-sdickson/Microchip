# Adding ML Models to Intelligence Agent

## ML Models Included

Based on verified Snowflake documentation:

### 1. **REVENUE_FORECAST_MODEL** - Revenue Forecasting
- Predicts future monthly revenue
- Based on 24 months of historical data
- **Agent calls:** `REVENUE_FORECAST_MODEL!FORECAST(forecasting_periods => 6)`

### 2. **DESIGN_WIN_ANOMALY_MODEL** - Anomaly Detection
- Detects unusual spikes/drops in design wins
- Weekly pattern analysis
- **Agent calls:** `DESIGN_WIN_ANOMALY_MODEL!DETECT_ANOMALIES(...)`

### 3. **CUSTOMER_CHURN_CLASSIFIER** - Classification
- Predicts customer churn probability
- Multi-factor analysis
- **Agent calls:** `CUSTOMER_CHURN_CLASSIFIER!PREDICT(...)`

### 4. **REVENUE_INSIGHTS_ANALYZER** - Top Insights
- Identifies key drivers of revenue changes
- Segment analysis
- **Agent calls:** `REVENUE_INSIGHTS_ANALYZER!GET_DRIVERS(...)`

---

## Setup Steps (10 minutes)

### Step 1: Execute ML Models SQL (5 min)
```sql
@sql/ml/07_create_ml_models.sql
```
This will train 4 ML models on your data (may take 3-5 minutes).

### Step 2: Grant Permissions (2 min)
```sql
USE ROLE ACCOUNTADMIN;

-- Grant ML admin roles (allows calling all model methods)
GRANT DATABASE ROLE REVENUE_FORECAST_MODEL!mladmin TO ROLE <your_role>;
GRANT DATABASE ROLE DESIGN_WIN_ANOMALY_MODEL!mladmin TO ROLE <your_role>;
GRANT DATABASE ROLE CUSTOMER_CHURN_CLASSIFIER!mladmin TO ROLE <your_role>;
GRANT DATABASE ROLE REVENUE_INSIGHTS_ANALYZER!mladmin TO ROLE <your_role>;
```

### Step 3: Add Models to Agent (3 min)

In your agent → **Tools** → **+ Add** → **Model**

**Add each model:**

**Model 1: REVENUE_FORECAST_MODEL**
- Description: "Revenue forecasting model. Predicts future monthly revenue trends."

**Model 2: DESIGN_WIN_ANOMALY_MODEL**  
- Description: "Detects anomalous patterns in design win activity."

**Model 3: CUSTOMER_CHURN_CLASSIFIER**
- Description: "Predicts customer churn probability based on behavior patterns."

**Model 4: REVENUE_INSIGHTS_ANALYZER**
- Description: "Identifies key factors driving revenue changes by segment."

---

## Example Questions

### Forecasting
```
"Forecast revenue for the next 6 months"
"Predict monthly revenue trends for next quarter"
```

### Anomaly Detection
```
"Detect any unusual patterns in design win activity"
"Are there anomalies in recent design wins?"
```

### Classification
```
"Which customers are likely to churn?"
"Predict churn probability for automotive customers"
```

### Top Insights
```
"What factors are driving revenue changes?"
"Analyze revenue drivers by customer segment and product family"
```

---

**Setup time:** 10 minutes  
**All syntax:** Verified against Snowflake documentation  
**Models:** Train on your existing data automatically


