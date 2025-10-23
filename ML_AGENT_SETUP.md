# Adding ML Models to Your Intelligence Agent - Step-by-Step

## Complete UI Instructions

**Time:** 10-15 minutes  
**Prerequisite:** Core agent setup complete, ML functions SQL executed

---

## Step 1: Execute ML Functions SQL

In Snowflake Snowsight:

1. Open new SQL worksheet
2. Execute:
   ```sql
   @sql/ml/07_create_ml_models.sql
   ```
3. Wait for confirmation and test results
4. Verify 7 functions created successfully

**Time:** 2 minutes

---

## Step 2: Grant Permissions

```sql
USE ROLE ACCOUNTADMIN;

-- Replace <your_role> with your actual role
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.FORECAST_MONTHLY_REVENUE(INT) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.FORECAST_DESIGN_WINS(VARCHAR, INT) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.DETECT_QUALITY_ANOMALIES() TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.DETECT_ORDER_ANOMALIES() TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_CUSTOMER_CHURN_RISK() TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_DESIGN_WIN_CONVERSION() TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.DETECT_SUPPORT_ANOMALIES() TO ROLE <your_role>;
```

**Time:** 1 minute

---

## Step 3: Add ML Functions to Agent

### Navigate to Agent

1. In Snowsight, click **AI & ML** (left sidebar)
2. Click **Agents**
3. Click on **MICROCHIP_INTELLIGENCE_AGENT**
4. Click **Tools** (left sidebar in agent editor)

### Add Function 1: FORECAST_MONTHLY_REVENUE

1. Click **+ Add** button (top right)
2. Click **Function** tile
3. In "Select a function" dropdown:
   - Type: `FORECAST_MONTHLY_REVENUE`
   - Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.FORECAST_MONTHLY_REVENUE`
4. In **Description** box, paste:
   ```
   Revenue Forecasting Model
   
   Predicts future monthly revenue based on historical order patterns using linear regression.
   
   Use when users ask to:
   - Forecast revenue
   - Predict future sales
   - Project revenue trends
   - Estimate upcoming revenue
   
   Parameter:
   - months_ahead: Number of months to forecast (typically 3-12)
   
   Returns:
   - Forecast month
   - Forecasted revenue
   - Lower bound (95% confidence)
   - Upper bound (95% confidence)
   
   Example: "Forecast revenue for the next 6 months"
   ```
5. Click **Add**

### Add Function 2: FORECAST_DESIGN_WINS

1. Click **+ Add** → **Function**
2. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.FORECAST_DESIGN_WINS`
3. Description:
   ```
   Design Win Forecasting Model
   
   Predicts future design wins by product family using historical patterns.
   
   Use when users ask to:
   - Forecast design wins
   - Predict future design activity
   - Project design win trends
   
   Parameters:
   - product_family_filter: Product family (PIC, AVR, SAM, etc.) or NULL for all
   - months_ahead: Number of months to forecast
   
   Returns:
   - Forecast month
   - Product family
   - Forecasted design win count
   - Confidence level (HIGH/MEDIUM/LOW)
   
   Example: "Forecast design wins for PIC family next 6 months"
   ```
4. Click **Add**

### Add Function 3: DETECT_QUALITY_ANOMALIES

1. Click **+ Add** → **Function**
2. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.DETECT_QUALITY_ANOMALIES`
3. Description:
   ```
   Quality Issue Anomaly Detector
   
   Identifies products with statistically unusual quality issue rates using z-score analysis.
   
   Use when users ask to:
   - Detect quality anomalies
   - Find products with unusual defect rates
   - Identify quality outliers
   - Flag products with abnormal issues
   
   No parameters required - analyzes all active products
   
   Returns:
   - Product details
   - Actual quality issue count
   - Expected range
   - Anomaly score (z-score)
   - Severity (CRITICAL/HIGH/MEDIUM/NORMAL)
   
   Example: "Which products have anomalous quality issue rates?"
   ```
4. Click **Add**

### Add Function 4: DETECT_ORDER_ANOMALIES

1. Click **+ Add** → **Function**
2. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.DETECT_ORDER_ANOMALIES`
3. Description:
   ```
   Customer Order Anomaly Detector
   
   Detects customers with unusual ordering patterns (sudden drops or spikes).
   
   Use when users ask to:
   - Detect unusual order patterns
   - Find customers with declining orders
   - Identify ordering anomalies
   - Flag at-risk customers
   
   No parameters required
   
   Returns:
   - Customer details
   - Recent vs historical order counts
   - Deviation percentage
   - Anomaly type (SIGNIFICANT_DROP/SIGNIFICANT_SPIKE)
   
   Example: "Which customers have unusual order patterns?"
   ```
4. Click **Add**

### Add Function 5: PREDICT_CUSTOMER_CHURN_RISK

1. Click **+ Add** → **Function**
2. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_CUSTOMER_CHURN_RISK`
3. Description:
   ```
   Customer Churn Risk Predictor
   
   Predicts customer churn risk using multi-factor analysis:
   - Order trends (40% weight)
   - Design win activity (20%)
   - Satisfaction scores (20%)
   - Quality issues (15%)
   - Contract expiration (5%)
   
   Use when users ask to:
   - Predict churn risk
   - Identify at-risk customers
   - Show customers likely to leave
   - Calculate churn probability
   
   No parameters required
   
   Returns:
   - Customer details
   - Churn risk score (0-100)
   - Risk level (CRITICAL/HIGH/MEDIUM/LOW)
   - Specific risk factors
   - Recommended action
   
   Example: "Which customers are at high risk of churning?"
   ```
5. Click **Add**

### Add Function 6: PREDICT_DESIGN_WIN_CONVERSION

1. Click **+ Add** → **Function**
2. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_DESIGN_WIN_CONVERSION`
3. Description:
   ```
   Design Win Conversion Probability Predictor
   
   Predicts likelihood that design wins will convert to production orders.
   
   Factors considered:
   - Customer historical conversion rate
   - Engineer certifications
   - Competitive displacement
   - Estimated volume
   - Recent satisfaction scores
   - Product quality history
   
   Use when users ask to:
   - Predict conversion probability
   - Identify high-probability designs
   - Forecast production ramp
   - Prioritize design wins
   
   No parameters required
   
   Returns:
   - Design win details
   - Conversion probability (5-95%)
   - Likelihood tier (VERY_LIKELY/LIKELY/MODERATE/UNLIKELY)
   - Key influencing factors
   
   Example: "Which design wins are most likely to go to production?"
   ```
4. Click **Add**

### Add Function 7: DETECT_SUPPORT_ANOMALIES

1. Click **+ Add** → **Function**
2. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.DETECT_SUPPORT_ANOMALIES`
3. Description:
   ```
   Support Ticket Spike Detector
   
   Detects unusual spikes or drops in weekly support ticket volume.
   
   Use when users ask to:
   - Detect support ticket spikes
   - Find unusual support patterns
   - Identify support volume anomalies
   - Flag abnormal ticket weeks
   
   No parameters required
   
   Returns:
   - Week start date
   - Actual ticket count
   - Expected count
   - Deviation (z-score)
   - Anomaly severity
   - Top issue types during anomaly
   
   Example: "Detect unusual support ticket volume patterns"
   ```
4. Click **Add**

---

## Step 4: Verify Functions Added

In your agent's **Tools** section, you should now see:

```
Functions (11 total)
├─ Forecasting (2)
│  ├─ FORECAST_MONTHLY_REVENUE
│  └─ FORECAST_DESIGN_WINS
├─ Anomaly Detection (3)
│  ├─ DETECT_QUALITY_ANOMALIES
│  ├─ DETECT_ORDER_ANOMALIES
│  └─ DETECT_SUPPORT_ANOMALIES
└─ Prediction/Classification (2)
   ├─ PREDICT_CUSTOMER_CHURN_RISK
   └─ PREDICT_DESIGN_WIN_CONVERSION
```

---

## Step 5: Test ML Functions

Ask your agent:

### Test 1: Revenue Forecast
```
"Forecast revenue for the next 6 months with confidence intervals"
```

**Expected:** Table showing forecasted revenue by month with upper/lower bounds

### Test 2: Churn Risk
```
"Which customers are at high risk of churning?"
```

**Expected:** List of at-risk customers with risk scores and recommended actions

### Test 3: Quality Anomalies
```
"Detect products with anomalous quality issue rates"
```

**Expected:** Products with unusual defect patterns, anomaly scores, severity

### Test 4: Design Win Conversion
```
"Which design wins have the highest probability of converting to production?"
```

**Expected:** Ranked list with conversion probabilities and key factors

### Test 5: Order Anomalies
```
"Show me customers with unusual order patterns in the last quarter"
```

**Expected:** Customers with significant deviations from historical patterns

---

## 🎯 Advanced Usage

### Combined Queries
```
"Show me customers at high churn risk and forecast their revenue impact"

"Detect quality anomalies and check if those products have design wins at risk"

"Which product families should we forecast for next quarter based on current anomalies?"
```

### Parameterized Queries
```
"Forecast design wins for AVR family over next 12 months"

"Show churn risk specifically for automotive customers"

"Forecast revenue for next 3 months vs next 12 months"
```

---

## 📈 What Makes This Special

### 1. Predictive Intelligence
- Not just historical reporting
- Forward-looking insights
- Proactive risk identification

### 2. Fully Integrated
- ML functions callable directly from agent
- No separate tools or exports
- Seamless conversational interface

### 3. Actionable Insights
- Not just predictions - includes recommendations
- Risk scores with severity levels
- Specific actions to take

### 4. 100% Snowflake-Native
- No external ML services
- No Python notebooks to maintain
- All compute in Snowflake warehouse

---

## 🔍 Verification

After adding all functions, test that they work:

```sql
-- Test each function directly
SELECT * FROM TABLE(FORECAST_MONTHLY_REVENUE(6));
SELECT * FROM TABLE(DETECT_QUALITY_ANOMALIES()) LIMIT 5;
SELECT * FROM TABLE(PREDICT_CUSTOMER_CHURN_RISK()) LIMIT 5;
SELECT * FROM TABLE(PREDICT_DESIGN_WIN_CONVERSION()) LIMIT 5;
SELECT * FROM TABLE(DETECT_ORDER_ANOMALIES()) LIMIT 5;
SELECT * FROM TABLE(DETECT_SUPPORT_ANOMALIES()) LIMIT 5;
```

All should return results without errors.

---

**Setup time:** 10-15 minutes  
**Result:** Agent can now do forecasting, anomaly detection, and predictions!  
**Business value:** Proactive insights, risk mitigation, data-driven planning

🤖 **Your agent just got a lot smarter!**


