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

## Adding Models to Intelligence Agent

### After Notebook Execution:

1. **Navigate to Agent:**
   - Snowsight → AI & ML → Agents → MICROCHIP_INTELLIGENCE_AGENT

2. **Add Model 1: Revenue Forecast**
   - Tools → + Add → Model
   - Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.REVENUE_FORECAST_MODEL`
   - Description: "Forecasts monthly revenue using regression on historical order data"
   - Save

3. **Add Model 2: Churn Classifier**
   - Tools → + Add → Model
   - Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.CUSTOMER_CHURN_CLASSIFIER`
   - Description: "Predicts customer churn risk using Random Forest classification"
   - Save

4. **Add Model 3: Conversion Predictor**
   - Tools → + Add → Model
   - Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.DESIGN_WIN_CONVERSION_PREDICTOR`
   - Description: "Predicts design win to production conversion probability"
   - Save

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


