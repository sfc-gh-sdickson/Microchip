# ML Models Using Snowflake Notebook

## Overview

This notebook trains 3 ML models using Snowpark ML and registers them to the Model Registry:

1. **REVENUE_FORECAST_MODEL** - Revenue forecasting (Linear Regression)
2. **CUSTOMER_CHURN_CLASSIFIER** - Customer churn prediction (Random Forest)
3. **DESIGN_WIN_CONVERSION_PREDICTOR** - Design win conversion (Logistic Regression)

**File:** `notebooks/microchip_ml_models.ipynb`

---

## Setup Steps (15 minutes)

### Step 1: Upload Notebook to Snowflake

1. In Snowsight, click **Projects** → **Notebooks**
2. Click **+ Notebook** → **Import .ipynb file**
3. Upload: `notebooks/microchip_ml_models.ipynb`
4. Name it: `Microchip ML Models`
5. Select:
   - **Database:** MICROCHIP_INTELLIGENCE
   - **Schema:** ANALYTICS
   - **Warehouse:** MICROCHIP_WH

### Step 2: Add Required Packages

1. Click **Packages** dropdown (upper right)
2. Search and add:
   - `snowflake-ml-python`
   - `scikit-learn`
   - `xgboost`
   - `matplotlib`
3. Click **Start** to activate the notebook

### Step 3: Run All Cells

1. Click **Run All** or run each cell sequentially
2. Wait for models to train (2-3 minutes per model)
3. Verify all models registered successfully

---

## What the Notebook Does

### Model 1: Revenue Forecasting
- **Data:** Monthly revenue from ORDERS table (30 months history)
- **Features:** Month, year, order count, customer count, avg order value
- **Algorithm:** Linear Regression with StandardScaler
- **Output:** Predicted monthly revenue

### Model 2: Customer Churn
- **Data:** Customer behavior metrics (orders, satisfaction, quality issues)
- **Features:** Segment, industry, lifetime value, order trends, CSAT, quality issues
- **Algorithm:** Random Forest Classifier
- **Output:** Churn probability (0 or 1)

### Model 3: Design Win Conversion
- **Data:** Design wins with customer and product features
- **Features:** Product family, customer segment, industry, volume, competitive win
- **Algorithm:** Logistic Regression
- **Output:** Conversion probability

---

## Adding ML Procedures to Intelligence Agent

**After completing notebook execution and running file 07:**

### Step 1: Navigate to Your Agent

1. In Snowsight, click **AI & ML** (left sidebar)
2. Click **Agents**
3. Click on **MICROCHIP_INTELLIGENCE_AGENT**
4. The agent editor opens
5. Click **Tools** (left sidebar in agent editor)

---

### Step 2: Add Procedure 1 - PREDICT_REVENUE

1. Click **+ Add** button (top right of Tools section)
2. A modal window opens titled "Add tool"
3. Click on the **Procedure** tile (NOT Function)
4. In the "Select a procedure" dropdown:
   - Start typing: `PREDICT_REVENUE`
   - Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_REVENUE`
5. The procedure details appear below
6. Click in the **Description** box
7. Paste this exact text:
   ```
   Revenue Forecasting Procedure
   
   Predicts future monthly revenue using the REVENUE_PREDICTOR model from Model Registry.
   The model uses Linear Regression trained on historical order patterns.
   
   Use when users ask to:
   - Forecast revenue
   - Predict future sales
   - Project monthly revenue
   - Estimate upcoming revenue
   
   Parameter:
   - months_ahead: Number of months to forecast (1-12 recommended)
   
   Returns: JSON with predicted revenue amount
   
   Example: "Forecast revenue for the next 6 months"
   ```
8. Click **Add** button (bottom right of modal)
9. Verify "PREDICT_REVENUE" appears in your Tools list under Procedures

---

### Step 3: Add Procedure 2 - PREDICT_CUSTOMER_CHURN

1. Click **+ Add** button again
2. Click **Procedure** tile
3. In dropdown, select: `MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_CUSTOMER_CHURN`
4. In **Description** box, paste:
   ```
   Customer Churn Prediction Procedure
   
   Predicts which customers are at risk of churning using the CHURN_PREDICTOR model
   from Model Registry. Uses Random Forest classifier trained on behavior patterns.
   
   Use when users ask to:
   - Identify at-risk customers
   - Predict customer churn
   - Find customers likely to leave
   - Calculate churn risk
   
   Parameter:
   - customer_segment_filter: Filter by segment (OEM, CONTRACT_MANUFACTURER, DISTRIBUTOR)
     or empty string for all customers
   
   Returns: JSON with churn count and churn rate percentage
   
   Example: "Which OEM customers are predicted to churn?"
   ```
5. Click **Add**
6. Verify "PREDICT_CUSTOMER_CHURN" appears in Tools list

---

### Step 4: Add Procedure 3 - PREDICT_DESIGN_WIN_CONVERSION

1. Click **+ Add** button
2. Click **Procedure** tile
3. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_DESIGN_WIN_CONVERSION`
4. Paste in **Description**:
   ```
   Design Win Conversion Prediction Procedure
   
   Predicts which design wins are likely to convert to production using the
   CONVERSION_PREDICTOR model from Model Registry. Uses Logistic Regression.
   
   Use when users ask to:
   - Predict conversion probability
   - Identify high-probability designs
   - Find designs likely to go to production
   - Prioritize design wins
   
   Parameter:
   - product_family_filter: Filter by family (PIC, AVR, SAM, dsPIC, FPGA, etc.)
     or empty string for all families
   
   Returns: JSON with conversion count and conversion rate percentage
   
   Example: "Which PIC family design wins will likely convert to production?"
   ```
5. Click **Add**
6. Verify "PREDICT_DESIGN_WIN_CONVERSION" appears in Tools list

---

### Step 5: Verify All Procedures Added

In your agent's **Tools** section, you should now see under **Procedures (3)**:
- ✅ PREDICT_REVENUE
- ✅ PREDICT_CUSTOMER_CHURN
- ✅ PREDICT_DESIGN_WIN_CONVERSION

Also under **Cortex Analyst (3)** and **Cortex Search (3)** from core setup.

**Total tools: 9** (3 semantic views + 3 search services + 3 ML procedures)

---

## Example Questions for Agent

Once models are added as tools:

```
"Forecast revenue for the next 3 months using the revenue model"
"Which customers does the churn classifier predict will leave?"
"Show me design wins with high conversion probability"
"Use the churn model to identify at-risk automotive customers"
```

---

## Benefits of Model Registry Approach

✅ **Real ML Models** - sklearn, XGBoost, Random Forest  
✅ **Versioned** - Track model versions over time  
✅ **Metrics Tracked** - Performance metrics stored with each version  
✅ **Retrainable** - Easy to retrain and update models  
✅ **Agent Compatible** - Can be added as Model tools to agent  
✅ **Python-based** - Full ML library ecosystem available

---

**Time to complete:** 15-20 minutes  
**Approach:** Snowpark ML + Model Registry (proper ML workflow)  
**Based on:** Official Snowflake Tasty Bytes example


