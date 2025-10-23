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

### Step 3: Add Models to Agent as Tools (15 minutes)

#### Navigate to Your Agent

1. In Snowsight, click **AI & ML** (left sidebar)
2. Click **Agents**
3. Click on **MICROCHIP_INTELLIGENCE_AGENT**
4. The agent editor opens
5. Click **Tools** (left sidebar in agent editor)

---

#### Add Model 1: REVENUE_FORECAST_MODEL

1. Click **+ Add** button (top right of Tools section)
2. A modal window opens titled "Add tool"
3. Click on the **Model** tile
4. In the "Select a model" dropdown:
   - Start typing: `REVENUE_FORECAST`
   - Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.REVENUE_FORECAST_MODEL`
5. The model details appear below
6. Click in the **Description** box
7. Paste this exact text:
   ```
   Revenue Forecasting Model
   
   Predicts future monthly revenue using time-series forecasting on historical order data.
   
   Use when users ask to:
   - Forecast revenue
   - Predict future sales
   - Project revenue trends
   - Estimate upcoming monthly revenue
   
   The model uses 24 months of historical data and can forecast 3-12 months ahead.
   
   Call method: REVENUE_FORECAST_MODEL!FORECAST(forecasting_periods => N)
   where N is the number of months to forecast.
   
   Returns: Forecasted revenue by month with confidence intervals.
   
   Example: "Forecast revenue for the next 6 months"
   ```
8. Click **Add** button (bottom right of modal)
9. Verify "REVENUE_FORECAST_MODEL" appears in your Tools list

---

#### Add Model 2: DESIGN_WIN_ANOMALY_MODEL

1. Click **+ Add** button again
2. Click **Model** tile
3. In dropdown, select: `MICROCHIP_INTELLIGENCE.ANALYTICS.DESIGN_WIN_ANOMALY_MODEL`
4. In **Description** box, paste:
   ```
   Design Win Anomaly Detection Model
   
   Detects unusual patterns in design win activity using statistical anomaly detection.
   
   Use when users ask to:
   - Detect anomalies in design wins
   - Find unusual design win patterns
   - Identify spikes or drops in design activity
   - Flag abnormal design win weeks
   
   Analyzes weekly design win counts over the past 12 months.
   
   Call method: DESIGN_WIN_ANOMALY_MODEL!DETECT_ANOMALIES(INPUT_DATA => ...)
   
   Returns: Weeks with anomalous activity, deviation scores, and severity.
   
   Example: "Detect unusual patterns in design win activity"
   ```
5. Click **Add**
6. Verify model appears in Tools list

---

#### Add Model 3: CUSTOMER_CHURN_CLASSIFIER

1. Click **+ Add** button
2. Click **Model** tile
3. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.CUSTOMER_CHURN_CLASSIFIER`
4. Paste in **Description**:
   ```
   Customer Churn Prediction Model
   
   Predicts the probability that a customer will churn based on their behavior patterns.
   
   Use when users ask to:
   - Predict customer churn
   - Identify at-risk customers
   - Calculate churn probability
   - Find customers likely to leave
   
   Factors analyzed:
   - Order frequency trends
   - Support satisfaction scores
   - Quality issue history
   - Design win activity
   
   Call method: CUSTOMER_CHURN_CLASSIFIER!PREDICT(INPUT_DATA => ...)
   
   Returns: Churn probability (0-1) for each customer.
   
   Example: "Which customers are at high risk of churning?"
   ```
5. Click **Add**
6. Verify model appears in Tools list

---

#### Add Model 4: REVENUE_INSIGHTS_ANALYZER

1. Click **+ Add** button
2. Click **Model** tile
3. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.REVENUE_INSIGHTS_ANALYZER`
4. Paste in **Description**:
   ```
   Revenue Top Insights Analyzer
   
   Identifies the key factors (segments, product families, regions) that are driving
   changes in revenue.
   
   Use when users ask to:
   - What's driving revenue changes?
   - Analyze revenue drivers
   - Find top contributors to revenue growth/decline
   - Identify key revenue segments
   
   Analyzes combinations of:
   - Customer segments
   - Industry verticals
   - Product families
   - Product types
   
   Call method: REVENUE_INSIGHTS_ANALYZER!GET_DRIVERS(
     INPUT_DATA => TABLE(V_INSIGHTS_ANALYSIS_DATA),
     LABEL_COLNAME => 'LABEL',
     METRIC_COLNAME => 'METRIC'
   )
   
   Returns: Top contributors with their impact on revenue.
   
   Example: "What factors are driving our revenue changes?"
   ```
5. Click **Add**
6. Verify model appears in Tools list

---

#### Verify All Models Added

In your agent's **Tools** section, you should now see under **Models (4)**:
- ✅ REVENUE_FORECAST_MODEL
- ✅ DESIGN_WIN_ANOMALY_MODEL
- ✅ CUSTOMER_CHURN_CLASSIFIER
- ✅ REVENUE_INSIGHTS_ANALYZER

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


