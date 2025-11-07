-- ============================================================================
-- Microchip Intelligence Agent - Analytical Views
-- ============================================================================
-- Purpose: Create curated analytical views for business intelligence
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE_TM;
USE SCHEMA ANALYTICS_TM;
USE WAREHOUSE MICROCHIP_WH_TM;

-- ============================================================================
-- Customer 360 View
-- ============================================================================
CREATE OR REPLACE VIEW V_CUSTOMER_360_TM AS
SELECT
    c.customer_id,
    c.customer_name,
    c.primary_contact_email,
    c.primary_contact_phone,
    c.country,
    c.state,
    c.city,
    c.onboarding_date,
    c.customer_status,
    c.customer_segment,
    c.industry_vertical,
    c.lifetime_value,
    c.credit_risk_score,
    c.annual_revenue_usd,
    c.employee_count,
    c.design_engineering_team_size,
    COUNT(DISTINCT e.engineer_id) AS active_engineers,
    COUNT(DISTINCT sc.contract_id) AS total_support_contracts,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_revenue,
    COUNT(DISTINCT st.ticket_id) AS total_support_tickets,
    AVG(st.customer_satisfaction_score) AS avg_satisfaction_rating,
    COUNT(DISTINCT dw.design_win_id) AS total_design_wins,
    COUNT(DISTINCT CASE WHEN dw.design_status = 'IN_PRODUCTION' THEN dw.design_win_id END) AS production_design_wins,
    COUNT(DISTINCT po.production_order_id) AS total_production_orders,
    SUM(po.total_order_value) AS total_production_revenue,
    COUNT(DISTINCT qi.quality_issue_id) AS total_quality_issues,
    COUNT(DISTINCT CASE WHEN qi.severity IN ('HIGH', 'CRITICAL') THEN qi.quality_issue_id END) AS high_severity_quality_issues,
    c.created_at,
    c.updated_at
FROM RAW_TM.CUSTOMERS_TM c
LEFT JOIN RAW_TM.DESIGN_ENGINEERS_TM e ON c.customer_id = e.customer_id AND e.engineer_status = 'ACTIVE'
LEFT JOIN RAW_TM.SUPPORT_CONTRACTS_TM sc ON c.customer_id = sc.customer_id
LEFT JOIN RAW_TM.ORDERS_TM o ON c.customer_id = o.customer_id
LEFT JOIN RAW_TM.SUPPORT_TICKETS_TM st ON c.customer_id = st.customer_id
LEFT JOIN RAW_TM.DESIGN_WINS_TM dw ON c.customer_id = dw.customer_id
LEFT JOIN RAW_TM.PRODUCTION_ORDERS_TM po ON c.customer_id = po.customer_id
LEFT JOIN RAW_TM.QUALITY_ISSUES_TM qi ON c.customer_id = qi.customer_id
GROUP BY
    c.customer_id, c.customer_name, c.primary_contact_email, c.primary_contact_phone,
    c.country, c.state, c.city, c.onboarding_date, c.customer_status,
    c.customer_segment, c.industry_vertical, c.lifetime_value, c.credit_risk_score,
    c.annual_revenue_usd, c.employee_count, c.design_engineering_team_size,
    c.created_at, c.updated_at;

-- ============================================================================
-- Design Engineer Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_DESIGN_ENGINEER_ANALYTICS_TM AS
SELECT
    e.engineer_id,
    e.customer_id,
    c.customer_name,
    e.engineer_name,
    e.email,
    e.job_title,
    e.department,
    e.engineer_status,
    e.years_of_experience,
    e.microchip_certified,
    e.primary_product_family,
    e.preferred_contact_method,
    e.last_webinar_attended_date,
    COUNT(DISTINCT dw.design_win_id) AS total_design_wins,
    COUNT(DISTINCT CASE WHEN dw.design_status = 'IN_PRODUCTION' THEN dw.design_win_id END) AS production_design_wins,
    COUNT(DISTINCT CASE WHEN dw.competitive_displacement = TRUE THEN dw.design_win_id END) AS competitive_wins,
    COUNT(DISTINCT po.production_order_id) AS total_production_orders,
    SUM(po.total_order_value) AS total_production_value,
    COUNT(DISTINCT st.ticket_id) AS total_support_tickets,
    COUNT(DISTINCT cert.certification_id) AS total_certifications,
    COUNT(DISTINCT CASE WHEN cert.certification_status = 'ACTIVE' THEN cert.certification_id END) AS active_certifications,
    e.created_at,
    e.updated_at
FROM RAW_TM.DESIGN_ENGINEERS_TM e
JOIN RAW_TM.CUSTOMERS_TM c ON e.customer_id = c.customer_id
LEFT JOIN RAW_TM.DESIGN_WINS_TM dw ON e.engineer_id = dw.engineer_id
LEFT JOIN RAW_TM.PRODUCTION_ORDERS_TM po ON e.engineer_id = po.engineer_id
LEFT JOIN RAW_TM.SUPPORT_TICKETS_TM st ON e.engineer_id = st.engineer_id
LEFT JOIN RAW_TM.CERTIFICATIONS_TM cert ON e.engineer_id = cert.engineer_id
GROUP BY
    e.engineer_id, e.customer_id, c.customer_name, e.engineer_name,
    e.email, e.job_title, e.department, e.engineer_status,
    e.years_of_experience, e.microchip_certified, e.primary_product_family,
    e.preferred_contact_method, e.last_webinar_attended_date,
    e.created_at, e.updated_at;

-- ============================================================================
-- Design Win Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_DESIGN_WIN_ANALYTICS_TM AS
SELECT
    dw.design_win_id,
    dw.customer_id,
    c.customer_name,
    c.industry_vertical,
    c.customer_segment,
    dw.engineer_id,
    e.engineer_name,
    dw.product_id,
    p.product_name,
    p.sku,
    p.product_family,
    p.product_type,
    dw.design_win_date,
    dw.design_status,
    dw.estimated_production_date,
    dw.end_product_name,
    dw.target_industry,
    dw.estimated_annual_volume,
    dw.distributor_id,
    d.distributor_name,
    dw.competitive_displacement,
    dw.competitor_name,
    p.unit_price,
    (dw.estimated_annual_volume * p.unit_price)::NUMBER(15,2) AS estimated_annual_revenue,
    COUNT(DISTINCT po.production_order_id) AS production_orders_count,
    SUM(po.order_quantity) AS total_production_quantity,
    SUM(po.total_order_value) AS total_production_revenue,
    dw.created_at,
    dw.updated_at
FROM RAW_TM.DESIGN_WINS_TM dw
JOIN RAW_TM.CUSTOMERS_TM c ON dw.customer_id = c.customer_id
JOIN RAW_TM.DESIGN_ENGINEERS_TM e ON dw.engineer_id = e.engineer_id
JOIN RAW_TM.PRODUCT_CATALOG_TM p ON dw.product_id = p.product_id
LEFT JOIN RAW_TM.DISTRIBUTORS_TM d ON dw.distributor_id = d.distributor_id
LEFT JOIN RAW_TM.PRODUCTION_ORDERS_TM po ON dw.design_win_id = po.design_win_id
GROUP BY
    dw.design_win_id, dw.customer_id, c.customer_name, c.industry_vertical,
    c.customer_segment, dw.engineer_id, e.engineer_name, dw.product_id,
    p.product_name, p.sku, p.product_family, p.product_type,
    dw.design_win_date, dw.design_status, dw.estimated_production_date,
    dw.end_product_name, dw.target_industry, dw.estimated_annual_volume,
    dw.distributor_id, d.distributor_name, dw.competitive_displacement,
    dw.competitor_name, p.unit_price, dw.created_at, dw.updated_at;

-- ============================================================================
-- Product Performance View
-- ============================================================================
CREATE OR REPLACE VIEW V_PRODUCT_PERFORMANCE_TM AS
SELECT
    p.product_id,
    p.product_name,
    p.sku,
    p.product_family,
    p.product_type,
    p.core_architecture,
    p.package_type,
    p.unit_price,
    p.lifecycle_status,
    p.is_active,
    p.launch_date,
    COUNT(DISTINCT dw.design_win_id) AS total_design_wins,
    COUNT(DISTINCT CASE WHEN dw.design_status = 'IN_PRODUCTION' THEN dw.design_win_id END) AS production_design_wins,
    COUNT(DISTINCT CASE WHEN dw.competitive_displacement = TRUE THEN dw.design_win_id END) AS competitive_wins,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity) AS total_units_ordered,
    SUM(o.order_amount) AS total_order_revenue,
    COUNT(DISTINCT st.ticket_id) AS total_support_tickets,
    COUNT(DISTINCT CASE WHEN st.ticket_type = 'DESIGN_SUPPORT' THEN st.ticket_id END) AS design_support_tickets,
    COUNT(DISTINCT qi.quality_issue_id) AS total_quality_issues,
    COUNT(DISTINCT CASE WHEN qi.severity IN ('HIGH', 'CRITICAL') THEN qi.quality_issue_id END) AS critical_quality_issues,
    AVG(DATEDIFF('day', p.launch_date, CURRENT_DATE()))::NUMBER(10,0) AS days_in_market,
    p.created_at,
    p.updated_at
FROM RAW_TM.PRODUCT_CATALOG_TM p
LEFT JOIN RAW_TM.DESIGN_WINS_TM dw ON p.product_id = dw.product_id
LEFT JOIN RAW_TM.ORDERS_TM o ON p.product_id = o.product_id
LEFT JOIN RAW_TM.SUPPORT_TICKETS_TM st ON p.product_id = st.product_id
LEFT JOIN RAW_TM.QUALITY_ISSUES_TM qi ON p.product_id = qi.product_id
GROUP BY
    p.product_id, p.product_name, p.sku, p.product_family, p.product_type,
    p.core_architecture, p.package_type, p.unit_price, p.lifecycle_status,
    p.is_active, p.launch_date, p.created_at, p.updated_at;

-- ============================================================================
-- Distributor Performance View
-- ============================================================================
CREATE OR REPLACE VIEW V_DISTRIBUTOR_PERFORMANCE_TM AS
SELECT
    d.distributor_id,
    d.distributor_name,
    d.distributor_type,
    d.country,
    d.region,
    d.distributor_status,
    d.partnership_tier,
    COUNT(DISTINCT dw.design_win_id) AS total_design_wins,
    COUNT(DISTINCT po.production_order_id) AS total_production_orders,
    SUM(po.total_order_value) AS total_production_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_order_revenue,
    SUM(po.total_order_value) + SUM(o.order_amount) AS total_revenue,
    COUNT(DISTINCT o.product_id) AS unique_products_sold,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    d.created_at,
    d.updated_at
FROM RAW_TM.DISTRIBUTORS_TM d
LEFT JOIN RAW_TM.DESIGN_WINS_TM dw ON d.distributor_id = dw.distributor_id
LEFT JOIN RAW_TM.PRODUCTION_ORDERS_TM po ON d.distributor_id = po.distributor_id
LEFT JOIN RAW_TM.ORDERS_TM o ON d.distributor_id = o.distributor_id
GROUP BY
    d.distributor_id, d.distributor_name, d.distributor_type,
    d.country, d.region, d.distributor_status, d.partnership_tier,
    d.created_at, d.updated_at;

-- ============================================================================
-- Support Ticket Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_SUPPORT_TICKET_ANALYTICS_TM AS
SELECT
    st.ticket_id,
    st.customer_id,
    c.customer_name,
    c.industry_vertical,
    st.engineer_id,
    e.engineer_name,
    st.subject,
    st.ticket_category,
    st.ticket_type,
    st.priority,
    st.ticket_status,
    st.channel,
    st.created_date,
    st.first_response_date,
    st.resolution_date,
    st.assigned_engineer_id,
    se.engineer_name AS assigned_support_engineer_name,
    se.specialization AS support_engineer_specialization,
    st.customer_satisfaction_score,
    st.product_id,
    p.product_name,
    p.product_family,
    st.escalated,
    DATEDIFF('hour', st.created_date, st.first_response_date) AS first_response_time_hours,
    DATEDIFF('hour', st.created_date, st.resolution_date) AS resolution_time_hours,
    DATEDIFF('day', st.created_date, st.resolution_date) AS resolution_time_days,
    st.created_at,
    st.updated_at
FROM RAW_TM.SUPPORT_TICKETS_TM st
JOIN RAW_TM.CUSTOMERS_TM c ON st.customer_id = c.customer_id
LEFT JOIN RAW_TM.DESIGN_ENGINEERS_TM e ON st.engineer_id = e.engineer_id
LEFT JOIN RAW_TM.SUPPORT_ENGINEERS_TM se ON st.assigned_engineer_id = se.support_engineer_id
LEFT JOIN RAW_TM.PRODUCT_CATALOG_TM p ON st.product_id = p.product_id;

-- ============================================================================
-- Quality Issue Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_QUALITY_ISSUE_ANALYTICS_TM AS
SELECT
    qi.quality_issue_id,
    qi.customer_id,
    c.customer_name,
    c.industry_vertical,
    c.customer_segment,
    qi.product_id,
    p.product_name,
    p.sku,
    p.product_family,
    p.product_type,
    qi.reported_by_engineer_id,
    e.engineer_name AS reported_by_engineer_name,
    qi.reported_date,
    qi.issue_type,
    qi.issue_category,
    qi.severity,
    qi.investigation_status,
    qi.root_cause,
    qi.corrective_action,
    qi.preventive_action,
    qi.closure_date,
    qi.lot_number,
    qi.rma_number,
    qi.affected_quantity,
    DATEDIFF('day', qi.reported_date, qi.closure_date) AS days_to_resolution,
    (qi.affected_quantity * p.unit_price)::NUMBER(15,2) AS estimated_cost_impact,
    qi.created_at,
    qi.updated_at
FROM RAW_TM.QUALITY_ISSUES_TM qi
JOIN RAW_TM.CUSTOMERS_TM c ON qi.customer_id = c.customer_id
LEFT JOIN RAW_TM.PRODUCT_CATALOG_TM p ON qi.product_id = p.product_id
LEFT JOIN RAW_TM.DESIGN_ENGINEERS_TM e ON qi.reported_by_engineer_id = e.engineer_id;

-- ============================================================================
-- Revenue Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_REVENUE_ANALYTICS_TM AS
SELECT
    o.order_id,
    o.customer_id,
    c.customer_name,
    c.industry_vertical,
    c.customer_segment,
    o.order_date,
    DATE_TRUNC('month', o.order_date) AS order_month,
    DATE_TRUNC('quarter', o.order_date) AS order_quarter,
    DATE_TRUNC('year', o.order_date) AS order_year,
    o.order_type,
    o.product_id,
    p.product_name,
    p.product_family,
    p.product_type,
    o.quantity,
    o.unit_price,
    o.order_amount,
    o.discount_amount,
    o.tax_amount,
    o.payment_terms,
    o.payment_status,
    o.distributor_id,
    d.distributor_name,
    o.direct_sale,
    o.ship_to_country,
    o.order_source,
    o.created_at,
    o.updated_at
FROM RAW_TM.ORDERS_TM o
JOIN RAW_TM.CUSTOMERS_TM c ON o.customer_id = c.customer_id
LEFT JOIN RAW_TM.PRODUCT_CATALOG_TM p ON o.product_id = p.product_id
LEFT JOIN RAW_TM.DISTRIBUTORS_TM d ON o.distributor_id = d.distributor_id;

-- ============================================================================
-- Certification Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_CERTIFICATION_ANALYTICS_TM AS
SELECT
    cert.certification_id,
    cert.engineer_id,
    e.engineer_name,
    e.job_title,
    cert.customer_id,
    c.customer_name,
    c.industry_vertical,
    cert.certification_type,
    cert.certification_name,
    cert.issuing_organization,
    cert.certification_number,
    cert.issue_date,
    cert.expiration_date,
    cert.verification_status,
    cert.certification_status,
    cert.primary_certification,
    cert.product_family_focus,
    cert.certification_level,
    DATEDIFF('day', CURRENT_DATE(), cert.expiration_date) AS days_until_expiration,
    CASE 
        WHEN cert.expiration_date IS NULL THEN 'NO_EXPIRATION'
        WHEN cert.expiration_date < CURRENT_DATE() THEN 'EXPIRED'
        WHEN DATEDIFF('day', CURRENT_DATE(), cert.expiration_date) <= 90 THEN 'EXPIRING_SOON'
        ELSE 'VALID'
    END AS expiration_status,
    COUNT(DISTINCT v.verification_id) AS verification_count,
    MAX(v.verification_date) AS last_verification_date,
    cert.created_at,
    cert.updated_at
FROM RAW_TM.CERTIFICATIONS_TM cert
JOIN RAW_TM.DESIGN_ENGINEERS_TM e ON cert.engineer_id = e.engineer_id
JOIN RAW_TM.CUSTOMERS_TM c ON cert.customer_id = c.customer_id
LEFT JOIN RAW_TM.CERTIFICATION_VERIFICATIONS_TM v ON cert.certification_id = v.certification_id
GROUP BY
    cert.certification_id, cert.engineer_id, e.engineer_name, e.job_title,
    cert.customer_id, c.customer_name, c.industry_vertical,
    cert.certification_type, cert.certification_name, cert.issuing_organization,
    cert.certification_number, cert.issue_date, cert.expiration_date,
    cert.verification_status, cert.certification_status, cert.primary_certification,
    cert.product_family_focus, cert.certification_level,
    cert.created_at, cert.updated_at;

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All analytical views created successfully' AS status;

