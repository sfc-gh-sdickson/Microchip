-- ============================================================================
-- Microchip Intelligence Agent - ML Analytics Views
-- ============================================================================
-- Purpose: Create ML-powered analytical views for forecasting and anomaly detection
-- Using VIEWS (not table functions) for guaranteed compatibility
-- All syntax verified to work in Snowflake
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE MICROCHIP_WH;

-- ============================================================================
-- ML View 1: Revenue Forecast (Simple Moving Average)
-- ============================================================================
CREATE OR REPLACE VIEW V_REVENUE_FORECAST AS
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS order_month,
        SUM(order_amount) AS monthly_revenue,
        COUNT(DISTINCT order_id) AS order_count
    FROM RAW.ORDERS
    WHERE order_date >= DATEADD('month', -24, CURRENT_DATE())
    GROUP BY DATE_TRUNC('month', order_date)::DATE
),
moving_avg AS (
    SELECT
        order_month,
        monthly_revenue,
        AVG(monthly_revenue) OVER (ORDER BY order_month ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS ma_6month,
        AVG(monthly_revenue) OVER (ORDER BY order_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS ma_3month
    FROM monthly_revenue
)
SELECT
    order_month,
    monthly_revenue AS actual_revenue,
    ma_6month::NUMBER(15,2) AS forecast_6month_avg,
    ma_3month::NUMBER(15,2) AS forecast_3month_avg,
    ((monthly_revenue - ma_6month) / NULLIF(ma_6month, 0) * 100)::NUMBER(10,2) AS pct_variance_from_trend
FROM moving_avg
ORDER BY order_month DESC;

-- ============================================================================
-- ML View 2: Customer Churn Risk Scoring
-- ============================================================================
CREATE OR REPLACE VIEW V_CUSTOMER_CHURN_RISK AS
WITH customer_metrics AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.customer_segment,
        c.industry_vertical,
        c.lifetime_value,
        -- Recent orders (last 3 months)
        COUNT(DISTINCT CASE WHEN o.order_date >= DATEADD('month', -3, CURRENT_DATE()) THEN o.order_id END) AS recent_orders,
        -- Previous period orders (3-6 months ago)
        COUNT(DISTINCT CASE WHEN o.order_date BETWEEN DATEADD('month', -6, CURRENT_DATE()) AND DATEADD('month', -3, CURRENT_DATE()) THEN o.order_id END) AS previous_orders,
        -- Support satisfaction
        AVG(CASE WHEN st.created_date >= DATEADD('month', -3, CURRENT_DATE()) THEN st.customer_satisfaction_score END) AS recent_csat,
        -- Recent design wins
        COUNT(DISTINCT CASE WHEN dw.design_win_date >= DATEADD('month', -12, CURRENT_DATE()) THEN dw.design_win_id END) AS recent_design_wins,
        -- Quality issues
        COUNT(DISTINCT CASE WHEN qi.reported_date >= DATEADD('month', -6, CURRENT_DATE()) AND qi.severity IN ('HIGH', 'CRITICAL') THEN qi.quality_issue_id END) AS critical_quality_issues
    FROM RAW.CUSTOMERS c
    LEFT JOIN RAW.ORDERS o ON c.customer_id = o.customer_id
    LEFT JOIN RAW.SUPPORT_TICKETS st ON c.customer_id = st.customer_id
    LEFT JOIN RAW.DESIGN_WINS dw ON c.customer_id = dw.customer_id
    LEFT JOIN RAW.QUALITY_ISSUES qi ON c.customer_id = qi.customer_id
    WHERE c.customer_status = 'ACTIVE'
    GROUP BY c.customer_id, c.customer_name, c.customer_segment, c.industry_vertical, c.lifetime_value
)
SELECT
    customer_id,
    customer_name,
    customer_segment,
    industry_vertical,
    lifetime_value,
    recent_orders,
    previous_orders,
    recent_csat,
    recent_design_wins,
    critical_quality_issues,
    -- Calculate churn risk score (0-100)
    (
        (CASE WHEN recent_orders < previous_orders * 0.5 THEN 40 ELSE 0 END) +
        (CASE WHEN recent_design_wins = 0 THEN 20 ELSE 0 END) +
        (CASE WHEN recent_csat < 3 THEN 20 WHEN recent_csat < 4 THEN 10 ELSE 0 END) +
        (CASE WHEN critical_quality_issues > 2 THEN 15 WHEN critical_quality_issues > 0 THEN 8 ELSE 0 END)
    ) AS churn_risk_score,
    CASE
        WHEN (
            (CASE WHEN recent_orders < previous_orders * 0.5 THEN 40 ELSE 0 END) +
            (CASE WHEN recent_design_wins = 0 THEN 20 ELSE 0 END) +
            (CASE WHEN recent_csat < 3 THEN 20 WHEN recent_csat < 4 THEN 10 ELSE 0 END) +
            (CASE WHEN critical_quality_issues > 2 THEN 15 WHEN critical_quality_issues > 0 THEN 8 ELSE 0 END)
        ) >= 60 THEN 'CRITICAL'
        WHEN (
            (CASE WHEN recent_orders < previous_orders * 0.5 THEN 40 ELSE 0 END) +
            (CASE WHEN recent_design_wins = 0 THEN 20 ELSE 0 END) +
            (CASE WHEN recent_csat < 3 THEN 20 WHEN recent_csat < 4 THEN 10 ELSE 0 END) +
            (CASE WHEN critical_quality_issues > 2 THEN 15 WHEN critical_quality_issues > 0 THEN 8 ELSE 0 END)
        ) >= 40 THEN 'HIGH'
        WHEN (
            (CASE WHEN recent_orders < previous_orders * 0.5 THEN 40 ELSE 0 END) +
            (CASE WHEN recent_design_wins = 0 THEN 20 ELSE 0 END) +
            (CASE WHEN recent_csat < 3 THEN 20 WHEN recent_csat < 4 THEN 10 ELSE 0 END) +
            (CASE WHEN critical_quality_issues > 2 THEN 15 WHEN critical_quality_issues > 0 THEN 8 ELSE 0 END)
        ) >= 20 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS churn_risk_level
FROM customer_metrics
WHERE (
    (CASE WHEN recent_orders < previous_orders * 0.5 THEN 40 ELSE 0 END) +
    (CASE WHEN recent_design_wins = 0 THEN 20 ELSE 0 END) +
    (CASE WHEN recent_csat < 3 THEN 20 WHEN recent_csat < 4 THEN 10 ELSE 0 END) +
    (CASE WHEN critical_quality_issues > 2 THEN 15 WHEN critical_quality_issues > 0 THEN 8 ELSE 0 END)
) > 15
ORDER BY churn_risk_score DESC;

-- ============================================================================
-- ML View 3: Quality Issue Anomaly Detection
-- ============================================================================
CREATE OR REPLACE VIEW V_QUALITY_ANOMALIES AS
WITH product_quality_metrics AS (
    SELECT
        p.product_id,
        p.product_name,
        p.product_family,
        p.product_type,
        COUNT(DISTINCT qi.quality_issue_id) AS total_quality_issues,
        COUNT(DISTINCT o.order_id) AS total_orders,
        (COUNT(DISTINCT qi.quality_issue_id) * 1000.0 / NULLIF(COUNT(DISTINCT o.order_id), 0))::NUMBER(10,2) AS issues_per_1000_orders
    FROM RAW.PRODUCT_CATALOG p
    LEFT JOIN RAW.QUALITY_ISSUES qi ON p.product_id = qi.product_id
    LEFT JOIN RAW.ORDERS o ON p.product_id = o.product_id
    WHERE p.is_active = TRUE
    GROUP BY p.product_id, p.product_name, p.product_family, p.product_type
    HAVING COUNT(DISTINCT o.order_id) > 50
),
quality_stats AS (
    SELECT
        AVG(issues_per_1000_orders) AS mean_rate,
        STDDEV(issues_per_1000_orders) AS std_dev
    FROM product_quality_metrics
)
SELECT
    pqm.product_id,
    pqm.product_name,
    pqm.product_family,
    pqm.product_type,
    pqm.total_quality_issues,
    pqm.total_orders,
    pqm.issues_per_1000_orders,
    qs.mean_rate::NUMBER(10,2) AS expected_rate,
    ((pqm.issues_per_1000_orders - qs.mean_rate) / NULLIF(qs.std_dev, 0))::NUMBER(5,2) AS z_score,
    (ABS((pqm.issues_per_1000_orders - qs.mean_rate) / NULLIF(qs.std_dev, 0)) > 2) AS is_anomaly,
    CASE
        WHEN (pqm.issues_per_1000_orders - qs.mean_rate) / NULLIF(qs.std_dev, 0) > 3 THEN 'CRITICAL'
        WHEN (pqm.issues_per_1000_orders - qs.mean_rate) / NULLIF(qs.std_dev, 0) > 2 THEN 'HIGH'
        WHEN (pqm.issues_per_1000_orders - qs.mean_rate) / NULLIF(qs.std_dev, 0) > 1 THEN 'MEDIUM'
        ELSE 'NORMAL'
    END AS severity
FROM product_quality_metrics pqm
CROSS JOIN quality_stats qs
WHERE (ABS((pqm.issues_per_1000_orders - qs.mean_rate) / NULLIF(qs.std_dev, 0)) > 1.5)
ORDER BY z_score DESC;

-- ============================================================================
-- ML View 4: Customer Order Anomaly Detection
-- ============================================================================
CREATE OR REPLACE VIEW V_ORDER_ANOMALIES AS
WITH recent_activity AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS recent_order_count
    FROM RAW.ORDERS
    WHERE order_date >= DATEADD('month', -3, CURRENT_DATE())
    GROUP BY customer_id
),
historical_activity AS (
    SELECT
        customer_id,
        (COUNT(DISTINCT order_id) / 9.0)::NUMBER(10,2) AS avg_quarterly_orders
    FROM RAW.ORDERS
    WHERE order_date BETWEEN DATEADD('month', -30, CURRENT_DATE()) AND DATEADD('month', -3, CURRENT_DATE())
    GROUP BY customer_id
    HAVING COUNT(DISTINCT order_id) > 10
)
SELECT
    c.customer_id,
    c.customer_name,
    c.customer_segment,
    c.industry_vertical,
    COALESCE(ra.recent_order_count, 0) AS recent_orders,
    ha.avg_quarterly_orders AS historical_avg,
    ((COALESCE(ra.recent_order_count, 0) - ha.avg_quarterly_orders) / NULLIF(ha.avg_quarterly_orders, 0) * 100)::NUMBER(10,2) AS deviation_pct,
    (ABS((COALESCE(ra.recent_order_count, 0) - ha.avg_quarterly_orders) / NULLIF(ha.avg_quarterly_orders, 0)) > 0.5) AS is_anomaly,
    CASE
        WHEN ((COALESCE(ra.recent_order_count, 0) - ha.avg_quarterly_orders) / NULLIF(ha.avg_quarterly_orders, 0)) < -0.5 THEN 'SIGNIFICANT_DROP'
        WHEN ((COALESCE(ra.recent_order_count, 0) - ha.avg_quarterly_orders) / NULLIF(ha.avg_quarterly_orders, 0)) > 0.5 THEN 'SIGNIFICANT_SPIKE'
        ELSE 'NORMAL'
    END AS anomaly_type
FROM RAW.CUSTOMERS c
JOIN historical_activity ha ON c.customer_id = ha.customer_id
LEFT JOIN recent_activity ra ON c.customer_id = ra.customer_id
WHERE c.customer_status = 'ACTIVE'
  AND (ABS((COALESCE(ra.recent_order_count, 0) - ha.avg_quarterly_orders) / NULLIF(ha.avg_quarterly_orders, 0)) > 0.4)
ORDER BY ABS(deviation_pct) DESC;

-- ============================================================================
-- ML View 5: Design Win Conversion Probability
-- ============================================================================
CREATE OR REPLACE VIEW V_DESIGN_WIN_CONVERSION_PROBABILITY AS
WITH design_win_metrics AS (
    SELECT
        dw.design_win_id,
        dw.customer_id,
        c.customer_name,
        p.product_family,
        p.product_name,
        dw.end_product_name,
        dw.estimated_annual_volume,
        dw.competitive_displacement,
        dw.design_status,
        dw.engineer_id,
        -- Count certifications for this engineer
        (SELECT COUNT(*) FROM RAW.CERTIFICATIONS cert 
         WHERE cert.engineer_id = dw.engineer_id 
         AND cert.certification_status = 'ACTIVE') AS engineer_cert_count,
        -- Customer satisfaction
        (SELECT AVG(customer_satisfaction_score) FROM RAW.SUPPORT_TICKETS st
         WHERE st.customer_id = dw.customer_id 
         AND st.created_date >= DATEADD('month', -6, CURRENT_DATE())) AS recent_csat,
        -- Quality issues for this product
        (SELECT COUNT(*) FROM RAW.QUALITY_ISSUES qi
         WHERE qi.customer_id = dw.customer_id 
         AND qi.product_id = dw.product_id 
         AND qi.severity IN ('HIGH', 'CRITICAL')) AS product_quality_issues
    FROM RAW.DESIGN_WINS dw
    JOIN RAW.CUSTOMERS c ON dw.customer_id = c.customer_id
    JOIN RAW.PRODUCT_CATALOG p ON dw.product_id = p.product_id
    WHERE dw.design_status IN ('IN_DESIGN', 'PROTOTYPE')
)
SELECT
    design_win_id,
    customer_id,
    customer_name,
    product_family,
    product_name,
    end_product_name,
    estimated_annual_volume,
    design_status,
    -- Calculate conversion probability
    LEAST(95, GREATEST(5,
        30 +  -- Base 30%
        (CASE WHEN engineer_cert_count > 0 THEN 15 ELSE 0 END) +
        (CASE WHEN competitive_displacement = TRUE THEN 10 ELSE 0 END) +
        (CASE WHEN estimated_annual_volume > 100000 THEN 10 WHEN estimated_annual_volume > 50000 THEN 5 ELSE 0 END) +
        (CASE WHEN recent_csat >= 4 THEN 5 ELSE 0 END) +
        (CASE WHEN product_quality_issues > 0 THEN -20 ELSE 0 END)
    ))::NUMBER(5,2) AS conversion_probability_pct,
    CASE
        WHEN (30 + (CASE WHEN engineer_cert_count > 0 THEN 15 ELSE 0 END) + 
              (CASE WHEN competitive_displacement = TRUE THEN 10 ELSE 0 END) +
              (CASE WHEN estimated_annual_volume > 100000 THEN 10 WHEN estimated_annual_volume > 50000 THEN 5 ELSE 0 END) +
              (CASE WHEN recent_csat >= 4 THEN 5 ELSE 0 END) +
              (CASE WHEN product_quality_issues > 0 THEN -20 ELSE 0 END)) >= 70 THEN 'VERY_LIKELY'
        WHEN (30 + (CASE WHEN engineer_cert_count > 0 THEN 15 ELSE 0 END) + 
              (CASE WHEN competitive_displacement = TRUE THEN 10 ELSE 0 END) +
              (CASE WHEN estimated_annual_volume > 100000 THEN 10 WHEN estimated_annual_volume > 50000 THEN 5 ELSE 0 END) +
              (CASE WHEN recent_csat >= 4 THEN 5 ELSE 0 END) +
              (CASE WHEN product_quality_issues > 0 THEN -20 ELSE 0 END)) >= 50 THEN 'LIKELY'
        WHEN (30 + (CASE WHEN engineer_cert_count > 0 THEN 15 ELSE 0 END) + 
              (CASE WHEN competitive_displacement = TRUE THEN 10 ELSE 0 END) +
              (CASE WHEN estimated_annual_volume > 100000 THEN 10 WHEN estimated_annual_volume > 50000 THEN 5 ELSE 0 END) +
              (CASE WHEN recent_csat >= 4 THEN 5 ELSE 0 END) +
              (CASE WHEN product_quality_issues > 0 THEN -20 ELSE 0 END)) >= 30 THEN 'MODERATE'
        ELSE 'UNLIKELY'
    END AS conversion_likelihood,
    engineer_cert_count,
    recent_csat,
    product_quality_issues
FROM design_win_metrics
ORDER BY conversion_probability_pct DESC;

-- ============================================================================
-- Verify views created successfully
-- ============================================================================
SELECT 'ML analytical views created successfully' AS status;

-- Show what was created
SHOW VIEWS LIKE 'V_%FORECAST%' IN SCHEMA ANALYTICS;
SHOW VIEWS LIKE 'V_%CHURN%' IN SCHEMA ANALYTICS;
SHOW VIEWS LIKE 'V_%ANOMAL%' IN SCHEMA ANALYTICS;
SHOW VIEWS LIKE 'V_%CONVERSION%' IN SCHEMA ANALYTICS;

SELECT 'All ML views ready - agent can query these directly' AS final_status;

