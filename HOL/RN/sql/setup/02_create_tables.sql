-- ============================================================================
-- Microchip Intelligence Agent - Table Definitions
-- ============================================================================
-- Purpose: Create all necessary tables for the Microchip business model
-- Based on verified MedTrainer template structure
-- All columns verified against MAPPING_DOCUMENT.md
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE_RN;
USE SCHEMA RAW_RN;
USE WAREHOUSE MICROCHIP_WH_RN;

-- ============================================================================
-- CUSTOMERS TABLE (from ORGANIZATIONS)
-- ============================================================================
CREATE OR REPLACE TABLE CUSTOMERS_RN (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(200) NOT NULL,
    primary_contact_email VARCHAR(200) NOT NULL,
    primary_contact_phone VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    state VARCHAR(50),
    city VARCHAR(100),
    onboarding_date DATE NOT NULL,
    customer_status VARCHAR(20) DEFAULT 'ACTIVE',
    customer_segment VARCHAR(30),
    lifetime_value NUMBER(12,2) DEFAULT 0.00,
    credit_risk_score NUMBER(5,2),
    industry_vertical VARCHAR(50),
    annual_revenue_usd NUMBER(15,2),
    employee_count NUMBER(10,0),
    design_engineering_team_size NUMBER(8,0),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- DESIGN_ENGINEERS TABLE (from EMPLOYEES)
-- ============================================================================
CREATE OR REPLACE TABLE DESIGN_ENGINEERS_RN (
    engineer_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    engineer_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    job_title VARCHAR(100),
    department VARCHAR(100),
    engineer_status VARCHAR(20) DEFAULT 'ACTIVE',
    years_of_experience NUMBER(5,0),
    microchip_certified BOOLEAN DEFAULT FALSE,
    primary_product_family VARCHAR(50),
    preferred_contact_method VARCHAR(30),
    last_webinar_attended_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_RN(customer_id)
);

-- ============================================================================
-- SUPPORT_CONTRACTS TABLE (from SUBSCRIPTIONS)
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_CONTRACTS_RN (
    contract_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    service_tier VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    billing_cycle VARCHAR(20),
    monthly_fee NUMBER(10,2),
    tool_license_access VARCHAR(50),
    priority_support BOOLEAN DEFAULT FALSE,
    includes_nda BOOLEAN DEFAULT FALSE,
    includes_early_access BOOLEAN DEFAULT FALSE,
    dedicated_fae BOOLEAN DEFAULT FALSE,
    contract_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_RN(customer_id)
);

-- ============================================================================
-- PRODUCT_CATALOG TABLE (from COURSES/PRODUCTS)
-- ============================================================================
CREATE OR REPLACE TABLE PRODUCT_CATALOG_RN (
    product_id VARCHAR(30) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    sku VARCHAR(50) NOT NULL,
    product_family VARCHAR(50) NOT NULL,
    product_type VARCHAR(50),
    unit_price NUMBER(10,4),
    package_type VARCHAR(50),
    core_architecture VARCHAR(50),
    flash_size_kb NUMBER(10,0),
    ram_size_kb NUMBER(10,0),
    operating_voltage_range VARCHAR(30),
    temperature_range VARCHAR(30),
    product_description VARCHAR(1000),
    lifecycle_status VARCHAR(30) DEFAULT 'ACTIVE',
    is_active BOOLEAN DEFAULT TRUE,
    launch_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- DISTRIBUTORS TABLE (new for Microchip)
-- ============================================================================
CREATE OR REPLACE TABLE DISTRIBUTORS_RN (
    distributor_id VARCHAR(20) PRIMARY KEY,
    distributor_name VARCHAR(200) NOT NULL,
    distributor_type VARCHAR(30),
    contact_email VARCHAR(200),
    contact_phone VARCHAR(20),
    country VARCHAR(50),
    region VARCHAR(50),
    distributor_status VARCHAR(20) DEFAULT 'ACTIVE',
    partnership_tier VARCHAR(30),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- DESIGN_WINS TABLE (from COURSE_ENROLLMENTS)
-- ============================================================================
CREATE OR REPLACE TABLE DESIGN_WINS_RN (
    design_win_id VARCHAR(30) PRIMARY KEY,
    engineer_id VARCHAR(30) NOT NULL,
    product_id VARCHAR(30) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    design_win_date DATE NOT NULL,
    design_status VARCHAR(30) DEFAULT 'IN_DESIGN',
    estimated_production_date DATE,
    end_product_name VARCHAR(200),
    target_industry VARCHAR(50),
    estimated_annual_volume NUMBER(12,0),
    distributor_id VARCHAR(20),
    competitive_displacement BOOLEAN DEFAULT FALSE,
    competitor_name VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (engineer_id) REFERENCES DESIGN_ENGINEERS_RN(engineer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG_RN(product_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_RN(customer_id),
    FOREIGN KEY (distributor_id) REFERENCES DISTRIBUTORS_RN(distributor_id)
);

-- ============================================================================
-- PRODUCTION_ORDERS TABLE (from COURSE_COMPLETIONS)
-- ============================================================================
CREATE OR REPLACE TABLE PRODUCTION_ORDERS_RN (
    production_order_id VARCHAR(30) PRIMARY KEY,
    design_win_id VARCHAR(30) NOT NULL,
    engineer_id VARCHAR(30) NOT NULL,
    product_id VARCHAR(30) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    production_start_date DATE NOT NULL,
    order_quantity NUMBER(12,0) NOT NULL,
    unit_price NUMBER(10,4),
    total_order_value NUMBER(15,2),
    order_date DATE NOT NULL,
    ship_date DATE,
    distributor_id VARCHAR(20),
    production_status VARCHAR(30) DEFAULT 'ORDERED',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (design_win_id) REFERENCES DESIGN_WINS_RN(design_win_id),
    FOREIGN KEY (engineer_id) REFERENCES DESIGN_ENGINEERS_RN(engineer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG_RN(product_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_RN(customer_id),
    FOREIGN KEY (distributor_id) REFERENCES DISTRIBUTORS_RN(distributor_id)
);

-- ============================================================================
-- CERTIFICATIONS TABLE (from CREDENTIALS)
-- ============================================================================
CREATE OR REPLACE TABLE CERTIFICATIONS_RN (
    certification_id VARCHAR(30) PRIMARY KEY,
    engineer_id VARCHAR(30) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    certification_type VARCHAR(50) NOT NULL,
    certification_name VARCHAR(200) NOT NULL,
    issuing_organization VARCHAR(200),
    certification_number VARCHAR(100),
    issue_date DATE NOT NULL,
    expiration_date DATE,
    verification_status VARCHAR(30) DEFAULT 'VERIFIED',
    certification_status VARCHAR(30) DEFAULT 'ACTIVE',
    primary_certification BOOLEAN DEFAULT FALSE,
    product_family_focus VARCHAR(50),
    certification_level VARCHAR(30),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (engineer_id) REFERENCES DESIGN_ENGINEERS_RN(engineer_id),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_RN(customer_id)
);

-- ============================================================================
-- CERTIFICATION_VERIFICATIONS TABLE (from CREDENTIAL_VERIFICATIONS)
-- ============================================================================
CREATE OR REPLACE TABLE CERTIFICATION_VERIFICATIONS_RN (
    verification_id VARCHAR(30) PRIMARY KEY,
    certification_id VARCHAR(30) NOT NULL,
    verification_date TIMESTAMP_NTZ NOT NULL,
    verification_method VARCHAR(50),
    verification_status VARCHAR(30) NOT NULL,
    verified_by VARCHAR(100),
    verification_source VARCHAR(200),
    notes VARCHAR(1000),
    next_verification_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (certification_id) REFERENCES CERTIFICATIONS_RN(certification_id)
);

-- ============================================================================
-- ORDERS TABLE (from TRANSACTIONS)
-- ============================================================================
CREATE OR REPLACE TABLE ORDERS_RN (
    order_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    order_date TIMESTAMP_NTZ NOT NULL,
    order_type VARCHAR(50) NOT NULL,
    order_amount NUMBER(12,2) NOT NULL,
    payment_terms VARCHAR(30),
    payment_status VARCHAR(30) DEFAULT 'COMPLETED',
    currency VARCHAR(10) DEFAULT 'USD',
    product_id VARCHAR(30),
    quantity NUMBER(12,0),
    unit_price NUMBER(10,4),
    discount_amount NUMBER(10,2) DEFAULT 0.00,
    tax_amount NUMBER(10,2) DEFAULT 0.00,
    distributor_id VARCHAR(20),
    direct_sale BOOLEAN DEFAULT FALSE,
    ship_to_country VARCHAR(50),
    order_source VARCHAR(30),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_RN(customer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG_RN(product_id),
    FOREIGN KEY (distributor_id) REFERENCES DISTRIBUTORS_RN(distributor_id)
);

-- ============================================================================
-- SUPPORT_TICKETS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_TICKETS_RN (
    ticket_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    engineer_id VARCHAR(30),
    subject VARCHAR(500) NOT NULL,
    description VARCHAR(5000),
    ticket_category VARCHAR(50) NOT NULL,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    ticket_status VARCHAR(30) DEFAULT 'OPEN',
    channel VARCHAR(30),
    created_date TIMESTAMP_NTZ NOT NULL,
    first_response_date TIMESTAMP_NTZ,
    resolution_date TIMESTAMP_NTZ,
    assigned_engineer_id VARCHAR(20),
    customer_satisfaction_score NUMBER(3,0),
    product_id VARCHAR(30),
    ticket_type VARCHAR(30),
    escalated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_RN(customer_id),
    FOREIGN KEY (engineer_id) REFERENCES DESIGN_ENGINEERS_RN(engineer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG_RN(product_id)
);

-- ============================================================================
-- SUPPORT_ENGINEERS TABLE (from SUPPORT_AGENTS)
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_ENGINEERS_RN (
    support_engineer_id VARCHAR(20) PRIMARY KEY,
    engineer_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    department VARCHAR(50),
    specialization VARCHAR(100),
    hire_date DATE,
    average_satisfaction_rating NUMBER(3,2),
    total_tickets_resolved NUMBER(10,0) DEFAULT 0,
    engineer_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- QUALITY_ISSUES TABLE (from INCIDENTS)
-- ============================================================================
CREATE OR REPLACE TABLE QUALITY_ISSUES_RN (
    quality_issue_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(30),
    reported_by_engineer_id VARCHAR(30),
    reported_date TIMESTAMP_NTZ NOT NULL,
    issue_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) DEFAULT 'MEDIUM',
    description VARCHAR(5000),
    investigation_status VARCHAR(30) DEFAULT 'OPEN',
    root_cause VARCHAR(5000),
    corrective_action VARCHAR(5000),
    preventive_action VARCHAR(5000),
    closure_date TIMESTAMP_NTZ,
    lot_number VARCHAR(50),
    rma_number VARCHAR(30),
    affected_quantity NUMBER(12,0),
    issue_category VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_RN(customer_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCT_CATALOG_RN(product_id),
    FOREIGN KEY (reported_by_engineer_id) REFERENCES DESIGN_ENGINEERS_RN(engineer_id)
);

-- ============================================================================
-- MARKETING_CAMPAIGNS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE MARKETING_CAMPAIGNS_RN (
    campaign_id VARCHAR(30) PRIMARY KEY,
    campaign_name VARCHAR(200) NOT NULL,
    campaign_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    target_audience VARCHAR(100),
    budget NUMBER(12,2),
    channel VARCHAR(50),
    campaign_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- CUSTOMER_CAMPAIGN_INTERACTIONS TABLE (from ORGANIZATION_CAMPAIGN_INTERACTIONS)
-- ============================================================================
CREATE OR REPLACE TABLE CUSTOMER_CAMPAIGN_INTERACTIONS_RN (
    interaction_id VARCHAR(30) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    campaign_id VARCHAR(30) NOT NULL,
    interaction_date TIMESTAMP_NTZ NOT NULL,
    interaction_type VARCHAR(50) NOT NULL,
    conversion_flag BOOLEAN DEFAULT FALSE,
    revenue_generated NUMBER(12,2) DEFAULT 0.00,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS_RN(customer_id),
    FOREIGN KEY (campaign_id) REFERENCES MARKETING_CAMPAIGNS_RN(campaign_id)
);

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All tables created successfully' AS status;

