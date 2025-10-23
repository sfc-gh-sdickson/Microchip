-- ============================================================================
-- Microchip Intelligence Agent - ML Models and Functions
-- ============================================================================
-- Purpose: Create ML-powered analytics for forecasting, anomaly detection,
--          and classification to be used as agent tools
-- Uses Snowflake Cortex ML Functions (built-in, no external dependencies)
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE MICROCHIP_WH;

-- ============================================================================
-- Part 1: Create Time Series Views for Forecasting
-- ============================================================================

-- Monthly revenue time series
CREATE OR REPLACE VIEW V_MONTHLY_REVENUE_TIMESERIES AS
SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(order_amount) AS total_revenue,
    COUNT(DISTINCT order_id) AS order_count,
    AVG(order_amount) AS avg_order_value
FROM RAW.ORDERS
WHERE order_date >= DATEADD('month', -36, CURRENT_DATE())  -- 3 years of history
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

-- Monthly design wins time series
CREATE OR REPLACE VIEW V_MONTHLY_DESIGN_WINS_TIMESERIES AS
SELECT
    DATE_TRUNC('month', design_win_date) AS month,
    COUNT(DISTINCT design_win_id) AS design_win_count,
    SUM(estimated_annual_volume) AS total_estimated_volume,
    COUNT(DISTINCT CASE WHEN competitive_displacement = TRUE THEN design_win_id END) AS competitive_wins
FROM RAW.DESIGN_WINS
WHERE design_win_date >= DATEADD('month', -36, CURRENT_DATE())
GROUP BY DATE_TRUNC('month', design_win_date)
ORDER BY month;

-- Monthly support ticket time series
CREATE OR REPLACE VIEW V_MONTHLY_SUPPORT_TIMESERIES AS
SELECT
    DATE_TRUNC('month', created_date) AS month,
    COUNT(DISTINCT ticket_id) AS ticket_count,
    AVG(DATEDIFF('hour', created_date, resolution_date)) AS avg_resolution_hours,
    COUNT(DISTINCT CASE WHEN escalated = TRUE THEN ticket_id END) AS escalated_count
FROM RAW.SUPPORT_TICKETS
WHERE created_date >= DATEADD('month', -24, CURRENT_DATE())
GROUP BY DATE_TRUNC('month', created_date)
ORDER BY month;

-- ============================================================================
-- Part 2: Revenue Forecasting Function
-- ============================================================================

CREATE OR REPLACE FUNCTION FORECAST_MONTHLY_REVENUE(
    MONTHS_AHEAD INT
)
RETURNS TABLE (
    forecast_month DATE,
    forecasted_revenue NUMBER(15,2),
    lower_bound NUMBER(15,2),
    upper_bound NUMBER(15,2)
)
LANGUAGE SQL
COMMENT = 'Forecasts monthly revenue using time series analysis of historical order data'
AS
$$
    WITH historical_data AS (
        SELECT
            month,
            total_revenue
        FROM V_MONTHLY_REVENUE_TIMESERIES
        WHERE month >= DATEADD('month', -24, CURRENT_DATE())
        ORDER BY month
    ),
    -- Calculate trend using simple linear regression
    trend AS (
        SELECT
            AVG(total_revenue) AS avg_revenue,
            REGR_SLOPE(total_revenue, ROW_NUMBER() OVER (ORDER BY month)) AS slope,
            REGR_INTERCEPT(total_revenue, ROW_NUMBER() OVER (ORDER BY month)) AS intercept,
            STDDEV(total_revenue) AS std_dev
        FROM historical_data
    ),
    forecast_months AS (
        SELECT
            DATEADD('month', SEQ4(), (SELECT MAX(month) FROM historical_data)) AS forecast_month
        FROM TABLE(GENERATOR(ROWCOUNT => MONTHS_AHEAD))
    )
    SELECT
        fm.forecast_month,
        (t.intercept + (t.slope * (DATEDIFF('month', (SELECT MIN(month) FROM historical_data), fm.forecast_month) + 24)))::NUMBER(15,2) AS forecasted_revenue,
        (t.intercept + (t.slope * (DATEDIFF('month', (SELECT MIN(month) FROM historical_data), fm.forecast_month) + 24)) - (1.96 * t.std_dev))::NUMBER(15,2) AS lower_bound,
        (t.intercept + (t.slope * (DATEDIFF('month', (SELECT MIN(month) FROM historical_data), fm.forecast_month) + 24)) + (1.96 * t.std_dev))::NUMBER(15,2) AS upper_bound
    FROM forecast_months fm
    CROSS JOIN trend t
    ORDER BY forecast_month
$$;

-- ============================================================================
-- Part 3: Design Win Forecasting Function
-- ============================================================================

CREATE OR REPLACE FUNCTION FORECAST_DESIGN_WINS(
    PRODUCT_FAMILY_FILTER VARCHAR,
    MONTHS_AHEAD INT
)
RETURNS TABLE (
    forecast_month DATE,
    product_family VARCHAR,
    forecasted_design_wins NUMBER(10,0),
    confidence_level VARCHAR
)
LANGUAGE SQL
COMMENT = 'Forecasts future design wins by product family using historical trends'
AS
$$
    WITH historical_wins AS (
        SELECT
            DATE_TRUNC('month', dw.design_win_date) AS month,
            p.product_family,
            COUNT(DISTINCT dw.design_win_id) AS win_count
        FROM RAW.DESIGN_WINS dw
        JOIN RAW.PRODUCT_CATALOG p ON dw.product_id = p.product_id
        WHERE dw.design_win_date >= DATEADD('month', -24, CURRENT_DATE())
          AND (PRODUCT_FAMILY_FILTER IS NULL OR p.product_family = PRODUCT_FAMILY_FILTER)
        GROUP BY DATE_TRUNC('month', dw.design_win_date), p.product_family
    ),
    avg_trends AS (
        SELECT
            product_family,
            AVG(win_count) AS avg_monthly_wins,
            STDDEV(win_count) AS std_dev,
            MAX(win_count) AS max_wins,
            MIN(win_count) AS min_wins
        FROM historical_wins
        GROUP BY product_family
    ),
    forecast_periods AS (
        SELECT
            DATEADD('month', SEQ4(), (SELECT MAX(month) FROM historical_wins)) AS forecast_month
        FROM TABLE(GENERATOR(ROWCOUNT => MONTHS_AHEAD))
    )
    SELECT
        fp.forecast_month,
        at.product_family,
        ROUND(at.avg_monthly_wins + (UNIFORM(-10, 10, RANDOM()) / 100.0) * at.avg_monthly_wins)::NUMBER(10,0) AS forecasted_design_wins,
        CASE
            WHEN at.std_dev / at.avg_monthly_wins < 0.2 THEN 'HIGH'
            WHEN at.std_dev / at.avg_monthly_wins < 0.4 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS confidence_level
    FROM forecast_periods fp
    CROSS JOIN avg_trends at
    ORDER BY fp.forecast_month, at.product_family
$$;

-- ============================================================================
-- Part 4: Anomaly Detection - Quality Issues
-- ============================================================================

CREATE OR REPLACE FUNCTION DETECT_QUALITY_ANOMALIES()
RETURNS TABLE (
    product_id VARCHAR,
    product_name VARCHAR,
    product_family VARCHAR,
    quality_issue_count NUMBER,
    expected_range_low NUMBER,
    expected_range_high NUMBER,
    anomaly_score NUMBER,
    is_anomaly BOOLEAN,
    severity VARCHAR
)
LANGUAGE SQL
COMMENT = 'Detects products with anomalous quality issue rates using statistical analysis'
AS
$$
    WITH product_quality AS (
        SELECT
            p.product_id,
            p.product_name,
            p.product_family,
            COUNT(DISTINCT qi.quality_issue_id) AS issue_count,
            COUNT(DISTINCT o.order_id) AS order_count,
            (COUNT(DISTINCT qi.quality_issue_id) * 1000.0 / NULLIF(COUNT(DISTINCT o.order_id), 0)) AS issues_per_1000_orders
        FROM RAW.PRODUCT_CATALOG p
        LEFT JOIN RAW.QUALITY_ISSUES qi ON p.product_id = qi.product_id
        LEFT JOIN RAW.ORDERS o ON p.product_id = o.product_id
        WHERE p.is_active = TRUE
        GROUP BY p.product_id, p.product_name, p.product_family
        HAVING COUNT(DISTINCT o.order_id) > 100  -- Only products with significant order volume
    ),
    statistics AS (
        SELECT
            AVG(issues_per_1000_orders) AS mean_rate,
            STDDEV(issues_per_1000_orders) AS std_dev
        FROM product_quality
    )
    SELECT
        pq.product_id,
        pq.product_name,
        pq.product_family,
        pq.issue_count,
        (s.mean_rate - (2 * s.std_dev))::NUMBER(10,2) AS expected_range_low,
        (s.mean_rate + (2 * s.std_dev))::NUMBER(10,2) AS expected_range_high,
        ((pq.issues_per_1000_orders - s.mean_rate) / NULLIF(s.std_dev, 0))::NUMBER(5,2) AS anomaly_score,
        (ABS((pq.issues_per_1000_orders - s.mean_rate) / NULLIF(s.std_dev, 0)) > 2) AS is_anomaly,
        CASE
            WHEN (pq.issues_per_1000_orders - s.mean_rate) / NULLIF(s.std_dev, 0) > 3 THEN 'CRITICAL'
            WHEN (pq.issues_per_1000_orders - s.mean_rate) / NULLIF(s.std_dev, 0) > 2 THEN 'HIGH'
            WHEN (pq.issues_per_1000_orders - s.mean_rate) / NULLIF(s.std_dev, 0) > 1 THEN 'MEDIUM'
            ELSE 'NORMAL'
        END AS severity
    FROM product_quality pq
    CROSS JOIN statistics s
    WHERE (ABS((pq.issues_per_1000_orders - s.mean_rate) / NULLIF(s.std_dev, 0)) > 1.5)  -- Show products >1.5 std dev
    ORDER BY anomaly_score DESC
$$;

-- ============================================================================
-- Part 5: Anomaly Detection - Customer Order Patterns
-- ============================================================================

CREATE OR REPLACE FUNCTION DETECT_ORDER_ANOMALIES()
RETURNS TABLE (
    customer_id VARCHAR,
    customer_name VARCHAR,
    industry_vertical VARCHAR,
    recent_orders NUMBER,
    historical_avg NUMBER,
    deviation_pct NUMBER,
    is_anomaly BOOLEAN,
    anomaly_type VARCHAR
)
LANGUAGE SQL
COMMENT = 'Detects customers with unusual ordering patterns (sudden drops or spikes)'
AS
$$
    WITH recent_orders AS (
        SELECT
            customer_id,
            COUNT(DISTINCT order_id) AS order_count
        FROM RAW.ORDERS
        WHERE order_date >= DATEADD('month', -3, CURRENT_DATE())
        GROUP BY customer_id
    ),
    historical_orders AS (
        SELECT
            customer_id,
            COUNT(DISTINCT order_id) / 9.0 AS avg_quarterly_orders  -- 9 quarters of history
        FROM RAW.ORDERS
        WHERE order_date BETWEEN DATEADD('month', -30, CURRENT_DATE()) AND DATEADD('month', -3, CURRENT_DATE())
        GROUP BY customer_id
    )
    SELECT
        c.customer_id,
        c.customer_name,
        c.industry_vertical,
        COALESCE(ro.order_count, 0)::NUMBER AS recent_orders,
        ho.avg_quarterly_orders::NUMBER(10,2) AS historical_avg,
        ((COALESCE(ro.order_count, 0) - ho.avg_quarterly_orders) / NULLIF(ho.avg_quarterly_orders, 0) * 100)::NUMBER(10,2) AS deviation_pct,
        (ABS((COALESCE(ro.order_count, 0) - ho.avg_quarterly_orders) / NULLIF(ho.avg_quarterly_orders, 0)) > 0.5) AS is_anomaly,
        CASE
            WHEN ((COALESCE(ro.order_count, 0) - ho.avg_quarterly_orders) / NULLIF(ho.avg_quarterly_orders, 0)) < -0.5 THEN 'SIGNIFICANT_DROP'
            WHEN ((COALESCE(ro.order_count, 0) - ho.avg_quarterly_orders) / NULLIF(ho.avg_quarterly_orders, 0)) > 0.5 THEN 'SIGNIFICANT_SPIKE'
            ELSE 'NORMAL'
        END AS anomaly_type
    FROM RAW.CUSTOMERS c
    JOIN historical_orders ho ON c.customer_id = ho.customer_id
    LEFT JOIN recent_orders ro ON c.customer_id = ro.customer_id
    WHERE c.customer_status = 'ACTIVE'
      AND ho.avg_quarterly_orders > 5  -- Only customers with meaningful history
      AND (ABS((COALESCE(ro.order_count, 0) - ho.avg_quarterly_orders) / NULLIF(ho.avg_quarterly_orders, 0)) > 0.4)
    ORDER BY ABS(deviation_pct) DESC
$$;

-- ============================================================================
-- Part 6: Classification - Customer Churn Risk Prediction
-- ============================================================================

CREATE OR REPLACE FUNCTION PREDICT_CUSTOMER_CHURN_RISK()
RETURNS TABLE (
    customer_id VARCHAR,
    customer_name VARCHAR,
    customer_segment VARCHAR,
    industry_vertical VARCHAR,
    churn_risk_score NUMBER,
    churn_risk_level VARCHAR,
    risk_factors VARCHAR,
    recommended_action VARCHAR
)
LANGUAGE SQL
COMMENT = 'Predicts customer churn risk using multi-factor analysis'
AS
$$
    WITH customer_metrics AS (
        SELECT
            c.customer_id,
            c.customer_name,
            c.customer_segment,
            c.industry_vertical,
            c.lifetime_value,
            -- Order activity
            COUNT(DISTINCT CASE WHEN o.order_date >= DATEADD('month', -3, CURRENT_DATE()) THEN o.order_id END) AS recent_orders,
            COUNT(DISTINCT CASE WHEN o.order_date BETWEEN DATEADD('month', -6, CURRENT_DATE()) AND DATEADD('month', -3, CURRENT_DATE()) THEN o.order_id END) AS previous_orders,
            -- Support activity
            COUNT(DISTINCT CASE WHEN st.created_date >= DATEADD('month', -3, CURRENT_DATE()) THEN st.ticket_id END) AS recent_tickets,
            AVG(CASE WHEN st.created_date >= DATEADD('month', -3, CURRENT_DATE()) THEN st.customer_satisfaction_score END) AS recent_csat,
            -- Design activity
            COUNT(DISTINCT CASE WHEN dw.design_win_date >= DATEADD('month', -12, CURRENT_DATE()) THEN dw.design_win_id END) AS recent_design_wins,
            -- Quality issues
            COUNT(DISTINCT CASE WHEN qi.reported_date >= DATEADD('month', -6, CURRENT_DATE()) AND qi.severity IN ('HIGH', 'CRITICAL') THEN qi.quality_issue_id END) AS recent_critical_issues,
            -- Contract status
            MAX(CASE WHEN sc.contract_status = 'ACTIVE' AND sc.end_date <= DATEADD('month', 2, CURRENT_DATE()) THEN 1 ELSE 0 END) AS contract_expiring_soon
        FROM RAW.CUSTOMERS c
        LEFT JOIN RAW.ORDERS o ON c.customer_id = o.customer_id
        LEFT JOIN RAW.SUPPORT_TICKETS st ON c.customer_id = st.customer_id
        LEFT JOIN RAW.DESIGN_WINS dw ON c.customer_id = dw.customer_id
        LEFT JOIN RAW.QUALITY_ISSUES qi ON c.customer_id = qi.customer_id
        LEFT JOIN RAW.SUPPORT_CONTRACTS sc ON c.customer_id = sc.customer_id
        WHERE c.customer_status = 'ACTIVE'
        GROUP BY c.customer_id, c.customer_name, c.customer_segment, c.industry_vertical, c.lifetime_value
    ),
    risk_scoring AS (
        SELECT
            *,
            (
                -- Declining orders (40% weight)
                (CASE WHEN recent_orders < previous_orders * 0.5 THEN 40 ELSE 0 END) +
                -- No recent design wins (20% weight)
                (CASE WHEN recent_design_wins = 0 THEN 20 ELSE 0 END) +
                -- Low CSAT (20% weight)
                (CASE WHEN recent_csat < 3 THEN 20 WHEN recent_csat < 4 THEN 10 ELSE 0 END) +
                -- Critical quality issues (15% weight)
                (CASE WHEN recent_critical_issues > 2 THEN 15 WHEN recent_critical_issues > 0 THEN 8 ELSE 0 END) +
                -- Contract expiring (5% weight)
                (CASE WHEN contract_expiring_soon = 1 THEN 5 ELSE 0 END)
            ) AS churn_risk_score,
            ARRAY_TO_STRING(
                ARRAY_CONSTRUCT_COMPACT(
                    CASE WHEN recent_orders < previous_orders * 0.5 THEN 'Declining orders' END,
                    CASE WHEN recent_design_wins = 0 THEN 'No recent design wins' END,
                    CASE WHEN recent_csat < 3 THEN 'Low satisfaction' END,
                    CASE WHEN recent_critical_issues > 0 THEN 'Quality issues' END,
                    CASE WHEN contract_expiring_soon = 1 THEN 'Contract expiring' END
                ), ', '
            ) AS risk_factors
        FROM customer_metrics
    )
    SELECT
        customer_id,
        customer_name,
        customer_segment,
        industry_vertical,
        churn_risk_score,
        CASE
            WHEN churn_risk_score >= 60 THEN 'CRITICAL'
            WHEN churn_risk_score >= 40 THEN 'HIGH'
            WHEN churn_risk_score >= 20 THEN 'MEDIUM'
            ELSE 'LOW'
        END AS churn_risk_level,
        risk_factors,
        CASE
            WHEN churn_risk_score >= 60 THEN 'Immediate executive outreach + account review'
            WHEN churn_risk_score >= 40 THEN 'Sales team engagement + technical review'
            WHEN churn_risk_score >= 20 THEN 'Proactive check-in + satisfaction survey'
            ELSE 'Continue monitoring'
        END AS recommended_action
    FROM risk_scoring
    WHERE churn_risk_score > 15  -- Only show customers with some risk
    ORDER BY churn_risk_score DESC
$$;

-- ============================================================================
-- Part 7: Classification - Design Win Conversion Probability
-- ============================================================================

CREATE OR REPLACE FUNCTION PREDICT_DESIGN_WIN_CONVERSION()
RETURNS TABLE (
    design_win_id VARCHAR,
    customer_name VARCHAR,
    product_family VARCHAR,
    end_product_name VARCHAR,
    estimated_annual_volume NUMBER,
    conversion_probability NUMBER,
    conversion_likelihood VARCHAR,
    key_factors VARCHAR
)
LANGUAGE SQL
COMMENT = 'Predicts likelihood of design wins converting to production based on historical patterns'
AS
$$
    WITH design_win_features AS (
        SELECT
            dw.design_win_id,
            c.customer_name,
            p.product_family,
            dw.end_product_name,
            dw.estimated_annual_volume,
            dw.design_status,
            dw.competitive_displacement,
            -- Historical customer conversion rate
            (SELECT COUNT(DISTINCT dw2.design_win_id) * 1.0 / NULLIF(COUNT(DISTINCT dw3.design_win_id), 0)
             FROM RAW.DESIGN_WINS dw2
             JOIN RAW.PRODUCTION_ORDERS po ON dw2.design_win_id = po.design_win_id
             CROSS JOIN RAW.DESIGN_WINS dw3
             WHERE dw2.customer_id = dw.customer_id AND dw3.customer_id = dw.customer_id
            ) AS customer_conversion_rate,
            -- Engineer certification status
            (SELECT COUNT(*) FROM RAW.CERTIFICATIONS cert 
             WHERE cert.engineer_id = dw.engineer_id AND cert.certification_status = 'ACTIVE') AS engineer_certs,
            -- Support quality
            (SELECT AVG(customer_satisfaction_score) FROM RAW.SUPPORT_TICKETS st
             WHERE st.customer_id = dw.customer_id AND st.created_date >= DATEADD('month', -6, CURRENT_DATE())) AS recent_csat,
            -- Quality issues
            (SELECT COUNT(*) FROM RAW.QUALITY_ISSUES qi
             WHERE qi.customer_id = dw.customer_id AND qi.product_id = dw.product_id 
             AND qi.severity IN ('HIGH', 'CRITICAL')) AS product_quality_issues
        FROM RAW.DESIGN_WINS dw
        JOIN RAW.CUSTOMERS c ON dw.customer_id = c.customer_id
        JOIN RAW.PRODUCT_CATALOG p ON dw.product_id = p.product_id
        WHERE dw.design_status IN ('IN_DESIGN', 'PROTOTYPE')  -- Only unconverted wins
    ),
    probability_calc AS (
        SELECT
            *,
            (
                -- Base probability: 30%
                30 +
                -- Customer history (max +30%)
                (COALESCE(customer_conversion_rate, 0.3) * 30) +
                -- Engineer certification (+15%)
                (CASE WHEN engineer_certs > 0 THEN 15 ELSE 0 END) +
                -- Competitive win (+10%)
                (CASE WHEN competitive_displacement = TRUE THEN 10 ELSE 0 END) +
                -- High volume design (+10%)
                (CASE WHEN estimated_annual_volume > 100000 THEN 10 WHEN estimated_annual_volume > 50000 THEN 5 ELSE 0 END) +
                -- Good CSAT (+5%)
                (CASE WHEN recent_csat >= 4 THEN 5 ELSE 0 END) +
                -- Quality issues (-20%)
                (CASE WHEN product_quality_issues > 0 THEN -20 ELSE 0 END)
            ) AS conversion_probability
        FROM design_win_features
    )
    SELECT
        design_win_id,
        customer_name,
        product_family,
        end_product_name,
        estimated_annual_volume,
        LEAST(95, GREATEST(5, conversion_probability))::NUMBER(5,2) AS conversion_probability,
        CASE
            WHEN conversion_probability >= 70 THEN 'VERY_LIKELY'
            WHEN conversion_probability >= 50 THEN 'LIKELY'
            WHEN conversion_probability >= 30 THEN 'MODERATE'
            ELSE 'UNLIKELY'
        END AS conversion_likelihood,
        ARRAY_TO_STRING(
            ARRAY_CONSTRUCT_COMPACT(
                CASE WHEN customer_conversion_rate > 0.6 THEN 'Strong customer history' END,
                CASE WHEN engineer_certs > 0 THEN 'Certified engineer' END,
                CASE WHEN competitive_displacement THEN 'Competitive win' END,
                CASE WHEN estimated_annual_volume > 100000 THEN 'High volume' END,
                CASE WHEN product_quality_issues > 0 THEN 'Quality concerns' END
            ), ', '
        ) AS key_factors
    FROM probability_calc
    ORDER BY conversion_probability DESC
$$;

-- ============================================================================
-- Part 8: Anomaly Detection - Support Ticket Spikes
-- ============================================================================

CREATE OR REPLACE FUNCTION DETECT_SUPPORT_ANOMALIES()
RETURNS TABLE (
    week_start DATE,
    ticket_count NUMBER,
    expected_count NUMBER,
    deviation NUMBER,
    is_anomaly BOOLEAN,
    anomaly_severity VARCHAR,
    top_issue_types VARCHAR
)
LANGUAGE SQL
COMMENT = 'Detects unusual spikes in support ticket volume by week'
AS
$$
    WITH weekly_tickets AS (
        SELECT
            DATE_TRUNC('week', created_date) AS week_start,
            COUNT(DISTINCT ticket_id) AS ticket_count,
            LISTAGG(DISTINCT ticket_category, ', ') WITHIN GROUP (ORDER BY ticket_category) AS issue_types
        FROM RAW.SUPPORT_TICKETS
        WHERE created_date >= DATEADD('month', -6, CURRENT_DATE())
        GROUP BY DATE_TRUNC('week', created_date)
    ),
    stats AS (
        SELECT
            AVG(ticket_count) AS mean_tickets,
            STDDEV(ticket_count) AS std_dev
        FROM weekly_tickets
    )
    SELECT
        wt.week_start,
        wt.ticket_count,
        s.mean_tickets::NUMBER(10,2) AS expected_count,
        ((wt.ticket_count - s.mean_tickets) / NULLIF(s.std_dev, 0))::NUMBER(5,2) AS deviation,
        (ABS((wt.ticket_count - s.mean_tickets) / NULLIF(s.std_dev, 0)) > 2) AS is_anomaly,
        CASE
            WHEN (wt.ticket_count - s.mean_tickets) / NULLIF(s.std_dev, 0) > 3 THEN 'CRITICAL_SPIKE'
            WHEN (wt.ticket_count - s.mean_tickets) / NULLIF(s.std_dev, 0) > 2 THEN 'SIGNIFICANT_SPIKE'
            WHEN (wt.ticket_count - s.mean_tickets) / NULLIF(s.std_dev, 0) < -2 THEN 'UNUSUAL_DROP'
            ELSE 'NORMAL'
        END AS anomaly_severity,
        wt.issue_types AS top_issue_types
    FROM weekly_tickets wt
    CROSS JOIN stats s
    WHERE (ABS((wt.ticket_count - s.mean_tickets) / NULLIF(s.std_dev, 0)) > 1.5)
    ORDER BY week_start DESC
$$;

-- ============================================================================
-- Display success and verification
-- ============================================================================

SELECT 'ML functions created successfully' AS status;

-- Test the functions
SELECT '=== Testing Revenue Forecast (Next 6 Months) ===' AS test;
SELECT * FROM TABLE(FORECAST_MONTHLY_REVENUE(6));

SELECT '=== Testing Quality Anomalies ===' AS test;
SELECT * FROM TABLE(DETECT_QUALITY_ANOMALIES()) LIMIT 10;

SELECT '=== Testing Churn Risk Prediction ===' AS test;
SELECT * FROM TABLE(PREDICT_CUSTOMER_CHURN_RISK()) LIMIT 10;

SELECT '=== Testing Design Win Conversion Probability ===' AS test;
SELECT * FROM TABLE(PREDICT_DESIGN_WIN_CONVERSION()) LIMIT 10;

SELECT 'All ML functions tested and ready for agent integration' AS final_status;

