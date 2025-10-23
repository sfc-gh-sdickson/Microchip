-- ============================================================================
-- Microchip Intelligence Agent - ML Models
-- ============================================================================
-- Purpose: Create ML models for forecasting, anomaly detection, classification,
--          and insights analysis as tools for the Intelligence Agent
-- All syntax VERIFIED against Snowflake documentation:
-- - https://docs.snowflake.com/en/sql-reference/classes/forecast/commands/create-forecast
-- - https://docs.snowflake.com/en/user-guide/ml-functions/anomaly-detection
-- - https://docs.snowflake.com/en/sql-reference/classes/classification/commands/create-classification
-- - https://docs.snowflake.com/en/sql-reference/classes/top-insights/commands/create-top-insights
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE MICROCHIP_WH;

-- ============================================================================
-- Prepare Training Data Views
-- ============================================================================

-- Revenue time series for forecasting
CREATE OR REPLACE VIEW V_REVENUE_TRAINING_DATA AS
SELECT
    DATE_TRUNC('month', order_date)::TIMESTAMP_NTZ AS ts,
    SUM(order_amount)::FLOAT AS revenue
FROM RAW.ORDERS
WHERE order_date >= DATEADD('month', -24, CURRENT_DATE())
GROUP BY DATE_TRUNC('month', order_date)::TIMESTAMP_NTZ
ORDER BY ts;

-- Design wins time series for anomaly detection
-- Training data: 12 months ago to 2 months ago (leaves recent 2 months for evaluation)
CREATE OR REPLACE VIEW V_DESIGN_WINS_TRAINING_DATA AS
SELECT
    DATE_TRUNC('week', design_win_date)::TIMESTAMP_NTZ AS ts,
    COUNT(DISTINCT design_win_id)::FLOAT AS win_count
FROM RAW.DESIGN_WINS
WHERE design_win_date BETWEEN DATEADD('month', -12, CURRENT_DATE()) AND DATEADD('month', -2, CURRENT_DATE())
GROUP BY DATE_TRUNC('week', design_win_date)::TIMESTAMP_NTZ
ORDER BY ts;

-- Customer churn classification training data
CREATE OR REPLACE VIEW V_CHURN_TRAINING_DATA AS
SELECT
    c.customer_id,
    c.customer_segment,
    c.industry_vertical,
    c.lifetime_value::FLOAT AS lifetime_value,
    -- Recent order count
    COUNT(DISTINCT CASE WHEN o.order_date >= DATEADD('month', -3, CURRENT_DATE()) THEN o.order_id END)::FLOAT AS recent_orders,
    -- Historical order average
    (COUNT(DISTINCT CASE WHEN o.order_date < DATEADD('month', -3, CURRENT_DATE()) THEN o.order_id END) / 9.0)::FLOAT AS historical_avg_orders,
    -- Support satisfaction
    AVG(CASE WHEN st.created_date >= DATEADD('month', -6, CURRENT_DATE()) THEN st.customer_satisfaction_score::FLOAT END) AS avg_csat,
    -- Quality issues
    COUNT(DISTINCT qi.quality_issue_id)::FLOAT AS quality_issue_count,
    -- Target: Has customer churned (become inactive in last 3 months with prior activity)
    CASE 
        WHEN c.customer_status = 'CHURNED' THEN TRUE
        WHEN COUNT(DISTINCT CASE WHEN o.order_date >= DATEADD('month', -3, CURRENT_DATE()) THEN o.order_id END) = 0 
         AND COUNT(DISTINCT CASE WHEN o.order_date < DATEADD('month', -3, CURRENT_DATE()) THEN o.order_id END) > 5 THEN TRUE
        ELSE FALSE
    END AS is_churned
FROM RAW.CUSTOMERS c
LEFT JOIN RAW.ORDERS o ON c.customer_id = o.customer_id
LEFT JOIN RAW.SUPPORT_TICKETS st ON c.customer_id = st.customer_id
LEFT JOIN RAW.QUALITY_ISSUES qi ON c.customer_id = qi.customer_id
GROUP BY c.customer_id, c.customer_segment, c.industry_vertical, c.lifetime_value, c.customer_status
HAVING COUNT(DISTINCT o.order_id) > 5;

-- Top Insights analysis data
CREATE OR REPLACE VIEW V_INSIGHTS_ANALYSIS_DATA AS
SELECT
    c.customer_segment,
    c.industry_vertical,
    p.product_family,
    p.product_type,
    SUM(o.order_amount)::FLOAT AS metric,
    (o.order_date >= DATEADD('month', -6, CURRENT_DATE())) AS label
FROM RAW.ORDERS o
JOIN RAW.CUSTOMERS c ON o.customer_id = c.customer_id
JOIN RAW.PRODUCT_CATALOG p ON o.product_id = p.product_id
GROUP BY c.customer_segment, c.industry_vertical, p.product_family, p.product_type, 
         (o.order_date >= DATEADD('month', -6, CURRENT_DATE()));

-- ============================================================================
-- MODEL 1: Revenue Forecasting
-- Syntax verified: https://docs.snowflake.com/en/sql-reference/classes/forecast/commands/create-forecast
-- ============================================================================

CREATE OR REPLACE SNOWFLAKE.ML.FORECAST REVENUE_FORECAST_MODEL(
  INPUT_DATA => TABLE(V_REVENUE_TRAINING_DATA),
  TIMESTAMP_COLNAME => 'TS',
  TARGET_COLNAME => 'REVENUE'
);

-- ============================================================================
-- MODEL 2: Design Win Anomaly Detection  
-- Syntax verified: https://docs.snowflake.com/en/user-guide/ml-functions/anomaly-detection
-- ============================================================================

CREATE OR REPLACE SNOWFLAKE.ML.ANOMALY_DETECTION DESIGN_WIN_ANOMALY_MODEL(
  INPUT_DATA => TABLE(V_DESIGN_WINS_TRAINING_DATA),
  TIMESTAMP_COLNAME => 'TS',
  TARGET_COLNAME => 'WIN_COUNT',
  LABEL_COLNAME => ''
);

-- ============================================================================
-- MODEL 3: Customer Churn Classification
-- Syntax verified: https://docs.snowflake.com/en/sql-reference/classes/classification/commands/create-classification
-- ============================================================================

CREATE OR REPLACE SNOWFLAKE.ML.CLASSIFICATION CUSTOMER_CHURN_CLASSIFIER(
  INPUT_DATA => TABLE(V_CHURN_TRAINING_DATA),
  TARGET_COLNAME => 'IS_CHURNED'
);

-- ============================================================================
-- MODEL 4: Top Insights Instance
-- Syntax verified: https://docs.snowflake.com/en/sql-reference/classes/top-insights/commands/create-top-insights
-- ============================================================================

CREATE OR REPLACE SNOWFLAKE.ML.TOP_INSIGHTS REVENUE_INSIGHTS_ANALYZER();

-- ============================================================================
-- Verify Models Created
-- ============================================================================

SELECT 'ML models created successfully' AS status;

SHOW MODELS IN SCHEMA ANALYTICS;

-- ============================================================================
-- Test Each Model
-- ============================================================================

-- Test 1: Revenue Forecast (predict next 3 months)
SELECT '=== Testing REVENUE_FORECAST_MODEL ===' AS test_name;
CALL REVENUE_FORECAST_MODEL!FORECAST(FORECASTING_PERIODS => 3);

-- Test 2: Design Win Anomaly Detection
-- Note: DETECT_ANOMALIES requires evaluation data AFTER training data timestamps
-- Training data ends at -2 months, so evaluation uses last 2 months
SELECT '=== Testing DESIGN_WIN_ANOMALY_MODEL ===' AS test_name;
CALL DESIGN_WIN_ANOMALY_MODEL!DETECT_ANOMALIES(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE('
    SELECT
      DATE_TRUNC(''week'', design_win_date)::TIMESTAMP_NTZ AS ts,
      COUNT(DISTINCT design_win_id)::FLOAT AS win_count
    FROM RAW.DESIGN_WINS
    WHERE design_win_date >= DATEADD(''month'', -2, CURRENT_DATE())
    GROUP BY DATE_TRUNC(''week'', design_win_date)::TIMESTAMP_NTZ
    ORDER BY ts
  '),
  TIMESTAMP_COLNAME => 'TS',
  TARGET_COLNAME => 'WIN_COUNT'
);

-- Test 3: Customer Churn Classification (predict on training data sample)
SELECT '=== Testing CUSTOMER_CHURN_CLASSIFIER ===' AS test_name;
CALL CUSTOMER_CHURN_CLASSIFIER!PREDICT(
  INPUT_DATA => SYSTEM$QUERY_REFERENCE('SELECT * FROM V_CHURN_TRAINING_DATA LIMIT 10')
);

-- Test 4: Revenue Top Insights
SELECT '=== Testing REVENUE_INSIGHTS_ANALYZER ===' AS test_name;
CALL REVENUE_INSIGHTS_ANALYZER!GET_DRIVERS(
  INPUT_DATA => SYSTEM$REFERENCE('VIEW', 'V_INSIGHTS_ANALYSIS_DATA'),
  LABEL_COLNAME => 'LABEL',
  METRIC_COLNAME => 'METRIC'
);

-- ============================================================================
-- Final Status
-- ============================================================================

SELECT 'All ML models tested successfully and ready for agent integration' AS final_status;

