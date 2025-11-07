-- ============================================================================
-- Microchip Intelligence Agent - Model Registry Wrapper Functions
-- ============================================================================
-- Purpose: Create SQL functions that wrap Model Registry models
--          so they can be added as tools to the Intelligence Agent
-- Based on: Model Registry integration pattern
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE_ST;
USE SCHEMA ANALYTICS_ST;
USE WAREHOUSE MICROCHIP_WH_ST;

-- ============================================================================
-- Procedure 1: Revenue Forecast Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_REVENUE_ST(INT);

CREATE OR REPLACE PROCEDURE PREDICT_REVENUE_ST(
    MONTHS_AHEAD INT
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_revenue'
COMMENT = 'Calls REVENUE_PREDICTOR model from Model Registry to forecast revenue'
AS
$$
def predict_revenue(session, months_ahead):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model from registry
    reg = Registry(session)
    model = reg.get_model("REVENUE_PREDICTOR").default
    
    # Get recent revenue data for prediction
    recent_data_query = f"""
    SELECT
        MONTH(CURRENT_DATE()) + {months_ahead} AS month_num,
        YEAR(CURRENT_DATE()) AS year_num,
        AVG(order_count)::FLOAT AS order_count,
        AVG(customer_count)::FLOAT AS customer_count,
        AVG(avg_order_value)::FLOAT AS avg_order_value
    FROM (
        SELECT
            COUNT(DISTINCT order_id)::FLOAT AS order_count,
            COUNT(DISTINCT customer_id)::FLOAT AS customer_count,
            AVG(order_amount)::FLOAT AS avg_order_value
        FROM RAW_ST.ORDERS_ST
        WHERE order_date >= DATEADD('month', -6, CURRENT_DATE())
        GROUP BY DATE_TRUNC('month', order_date)
    )
    """
    
    input_df = session.sql(recent_data_query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Convert to pandas and format as JSON string
    result = predictions.select("PREDICTED_REVENUE").to_pandas()
    
    return json.dumps({
        "months_ahead": months_ahead,
        "predicted_revenue": float(result['PREDICTED_REVENUE'].iloc[0])
    })
$$;

-- ============================================================================
-- Procedure 2: Customer Churn Prediction Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_CUSTOMER_CHURN_ST(STRING);

CREATE OR REPLACE PROCEDURE PREDICT_CUSTOMER_CHURN_ST(
    CUSTOMER_SEGMENT_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_churn'
COMMENT = 'Calls CHURN_PREDICTOR model from Model Registry to identify at-risk customers'
AS
$$
def predict_churn(session, customer_segment_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model
    reg = Registry(session)
    model = reg.get_model("CHURN_PREDICTOR").default
    
    # Build query with optional filter
    segment_filter = f"AND c.customer_segment = '{customer_segment_filter}'" if customer_segment_filter else ""
    
    query = f"""
    SELECT
        c.customer_segment,
        c.industry_vertical,
        c.lifetime_value::FLOAT AS lifetime_value,
        c.credit_risk_score::FLOAT AS credit_risk_score,
        COUNT(DISTINCT CASE WHEN o.order_date >= DATEADD('month', -3, CURRENT_DATE()) 
                       THEN o.order_id END)::FLOAT AS recent_orders,
        (COUNT(DISTINCT CASE WHEN o.order_date < DATEADD('month', -3, CURRENT_DATE()) 
                        THEN o.order_id END) / 9.0)::FLOAT AS historical_avg_orders,
        AVG(CASE WHEN st.created_date >= DATEADD('month', -6, CURRENT_DATE()) 
            THEN st.customer_satisfaction_score::FLOAT END) AS avg_csat,
        COUNT(DISTINCT qi.quality_issue_id)::FLOAT AS quality_issue_count,
        COUNT(DISTINCT CASE WHEN dw.design_win_date >= DATEADD('month', -12, CURRENT_DATE()) 
                       THEN dw.design_win_id END)::FLOAT AS recent_design_wins,
        FALSE::BOOLEAN AS is_churned
    FROM RAW_ST.CUSTOMERS_ST c
    LEFT JOIN RAW_ST.ORDERS_ST o ON c.customer_id = o.customer_id
    LEFT JOIN RAW_ST.SUPPORT_TICKETS_ST st ON c.customer_id = st.customer_id
    LEFT JOIN RAW_ST.QUALITY_ISSUES_ST qi ON c.customer_id = qi.customer_id
    LEFT JOIN RAW_ST.DESIGN_WINS_ST dw ON c.customer_id = dw.customer_id
    WHERE c.customer_status = 'ACTIVE' {segment_filter}
    GROUP BY c.customer_id, c.customer_segment, c.industry_vertical, c.lifetime_value, c.credit_risk_score
    LIMIT 10
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Count high-risk customers (assuming 1 = churned)
    result = predictions.select("CHURN_PREDICTION").to_pandas()
    churn_count = int(result['CHURN_PREDICTION'].sum())
    total_count = len(result)
    
    return json.dumps({
        "segment_filter": customer_segment_filter or "ALL",
        "total_customers_analyzed": total_count,
        "predicted_to_churn": churn_count,
        "churn_rate_pct": round(churn_count / total_count * 100, 2) if total_count > 0 else 0
    })
$$;

-- ============================================================================
-- Procedure 3: Design Win Conversion Prediction Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_DESIGN_WIN_CONVERSION_ST(STRING);

CREATE OR REPLACE PROCEDURE PREDICT_DESIGN_WIN_CONVERSION_ST(
    PRODUCT_FAMILY_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_conversion'
COMMENT = 'Calls CONVERSION_PREDICTOR model to predict design win conversion probability'
AS
$$
def predict_conversion(session, product_family_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model
    reg = Registry(session)
    model = reg.get_model("CONVERSION_PREDICTOR").default
    
    # Build query
    family_filter = f"AND p.product_family = '{product_family_filter}'" if product_family_filter else ""
    
    query = f"""
    SELECT
        p.product_family,
        c.customer_segment,
        c.industry_vertical,
        dw.estimated_annual_volume::FLOAT AS estimated_volume,
        dw.competitive_displacement::BOOLEAN AS is_competitive_win,
        FALSE::BOOLEAN AS converted_to_production
    FROM RAW_ST.DESIGN_WINS_ST dw
    JOIN RAW_ST.PRODUCT_CATALOG_ST p ON dw.product_id = p.product_id
    JOIN RAW_ST.CUSTOMERS_ST c ON dw.customer_id = c.customer_id
    WHERE dw.design_status IN ('IN_DESIGN', 'PROTOTYPE') {family_filter}
    LIMIT 20
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Calculate conversion rate
    result = predictions.select("CONVERSION_PREDICTION").to_pandas()
    likely_to_convert = int(result['CONVERSION_PREDICTION'].sum())
    total_designs = len(result)
    
    return json.dumps({
        "product_family_filter": product_family_filter or "ALL",
        "total_design_wins_analyzed": total_designs,
        "predicted_to_convert": likely_to_convert,
        "conversion_rate_pct": round(likely_to_convert / total_designs * 100, 2) if total_designs > 0 else 0
    })
$$;

-- ============================================================================
-- Test the wrapper functions
-- ============================================================================

SELECT 'ML model wrapper functions created successfully' AS status;

-- Test each procedure (uncomment after models are registered via notebook)
/*
CALL PREDICT_REVENUE_ST(6);
CALL PREDICT_CUSTOMER_CHURN_ST('OEM');
CALL PREDICT_DESIGN_WIN_CONVERSION_ST('PIC');
*/

SELECT 'Execute notebook first to register models, then uncomment tests above' AS instruction;

