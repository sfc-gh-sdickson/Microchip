-- ============================================================================
-- Microchip Intelligence Agent - Create Snowflake Intelligence Agent (Main)
-- ============================================================================
-- Purpose: Create and configure the Microchip Intelligence Agent with:
--          - Cortex Analyst tools (Semantic Views)
--          - Cortex Search tools (Unstructured Data)
--          - Optional ML Model tools (Stored Procedures)
-- Execution Order: Run AFTER 01-07 scripts are completed
-- ============================================================================

USE ROLE SYSADMIN;
USE DATABASE MICROCHIP_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE MICROCHIP_WH;

-- ============================================================================
-- Step 1: Grant Required Permissions (adjust role as needed)
-- ============================================================================

GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER TO ROLE SYSADMIN;

GRANT USAGE ON DATABASE MICROCHIP_INTELLIGENCE TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA MICROCHIP_INTELLIGENCE.ANALYTICS TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA MICROCHIP_INTELLIGENCE.RAW TO ROLE SYSADMIN;

-- Semantic Views for Cortex Analyst
GRANT REFERENCES, SELECT ON SEMANTIC VIEW MICROCHIP_INTELLIGENCE.ANALYTICS.SV_DESIGN_ENGINEERING_INTELLIGENCE TO ROLE SYSADMIN;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW MICROCHIP_INTELLIGENCE.ANALYTICS.SV_SALES_REVENUE_INTELLIGENCE TO ROLE SYSADMIN;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW MICROCHIP_INTELLIGENCE.ANALYTICS.SV_CUSTOMER_SUPPORT_INTELLIGENCE TO ROLE SYSADMIN;

-- Warehouse
GRANT USAGE ON WAREHOUSE MICROCHIP_WH TO ROLE SYSADMIN;

-- Cortex Search Services
GRANT USAGE ON CORTEX SEARCH SERVICE MICROCHIP_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH TO ROLE SYSADMIN;
GRANT USAGE ON CORTEX SEARCH SERVICE MICROCHIP_INTELLIGENCE.RAW.APPLICATION_NOTES_SEARCH TO ROLE SYSADMIN;
GRANT USAGE ON CORTEX SEARCH SERVICE MICROCHIP_INTELLIGENCE.RAW.QUALITY_INVESTIGATION_REPORTS_SEARCH TO ROLE SYSADMIN;

-- ML Procedures (optional tools)
GRANT USAGE ON PROCEDURE MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_REVENUE(INT) TO ROLE SYSADMIN;
GRANT USAGE ON PROCEDURE MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_CUSTOMER_CHURN(STRING) TO ROLE SYSADMIN;
GRANT USAGE ON PROCEDURE MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_DESIGN_WIN_CONVERSION(STRING) TO ROLE SYSADMIN;

-- ============================================================================
-- Step 2: Create Snowflake Intelligence Agent
-- ============================================================================

CREATE OR REPLACE AGENT MICROCHIP_INTELLIGENCE_AGENT
  COMMENT = 'Microchip Intelligence Agent for semiconductor business intelligence'
  PROFILE = '{"display_name": "Microchip Intelligence Agent", "avatar": "chip", "color": "blue"}'
  FROM SPECIFICATION
  $$
models:
  orchestration: claude-4-sonnet

instructions:
  response: 'You are a Microchip semiconductor analytics assistant. For metrics and KPIs, use Cortex Analyst semantic views. For unstructured content, use Cortex Search. For predictions, use ML procedures. Keep answers concise and data-driven.'
  orchestration: 'Prefer semantic views for structured analytics; use search services for unstructured answers; call ML procedures for forecasting/classification.'
  system: 'Analyze Microchip customers, sales, product performance, support, and quality data.'

tools:
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'DesignEngineeringAnalyst'
      description: 'Analyzes customers, engineers, design wins, production orders, certifications'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SalesRevenueAnalyst'
      description: 'Analyzes orders, revenue, distributors, contracts'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SupportQualityAnalyst'
      description: 'Analyzes support tickets, engineers, product quality issues'
  - tool_spec:
      type: 'cortex_search'
      name: 'SupportTranscriptsSearch'
      description: 'Searches support transcripts for troubleshooting and training info'
  - tool_spec:
      type: 'cortex_search'
      name: 'ApplicationNotesSearch'
      description: 'Searches application notes and technical documentation'
  - tool_spec:
      type: 'cortex_search'
      name: 'QualityReportsSearch'
      description: 'Searches quality investigation reports and RCA summaries'
  - tool_spec:
      type: 'generic'
      name: 'PredictRevenue'
      description: 'Forecasts future revenue'
      input_schema:
        type: 'object'
        properties:
          months_ahead:
            type: 'integer'
            description: 'Number of months to forecast (1-12)'
        required: ['months_ahead']
  - tool_spec:
      type: 'generic'
      name: 'PredictCustomerChurn'
      description: 'Predicts customer churn risk'
      input_schema:
        type: 'object'
        properties:
          customer_segment:
            type: 'string'
            description: 'Optional segment filter (OEM, CONTRACT_MANUFACTURER, DISTRIBUTOR)'
        required: []
  - tool_spec:
      type: 'generic'
      name: 'PredictDesignWinConversion'
      description: 'Predicts design win conversion probability'
      input_schema:
        type: 'object'
        properties:
          product_family:
            type: 'string'
            description: 'Optional product family filter (PIC, AVR, SAM, dsPIC, PIC32, FPGA, ... )'
        required: []

tool_resources:
  DesignEngineeringAnalyst:
    semantic_view: 'MICROCHIP_INTELLIGENCE.ANALYTICS.SV_DESIGN_ENGINEERING_INTELLIGENCE'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH'
      query_timeout: 60
  SalesRevenueAnalyst:
    semantic_view: 'MICROCHIP_INTELLIGENCE.ANALYTICS.SV_SALES_REVENUE_INTELLIGENCE'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH'
      query_timeout: 60
  SupportQualityAnalyst:
    semantic_view: 'MICROCHIP_INTELLIGENCE.ANALYTICS.SV_CUSTOMER_SUPPORT_INTELLIGENCE'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH'
      query_timeout: 60
  SupportTranscriptsSearch:
    search_service: 'MICROCHIP_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH'
    max_results: 10
    title_column: 'ticket_id'
    id_column: 'transcript_id'
  ApplicationNotesSearch:
    search_service: 'MICROCHIP_INTELLIGENCE.RAW.APPLICATION_NOTES_SEARCH'
    max_results: 10
    title_column: 'title'
    id_column: 'appnote_id'
  QualityReportsSearch:
    search_service: 'MICROCHIP_INTELLIGENCE.RAW.QUALITY_INVESTIGATION_REPORTS_SEARCH'
    max_results: 10
    title_column: 'investigation_type'
    id_column: 'investigation_report_id'
  PredictRevenue:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_REVENUE'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH'
      query_timeout: 60
  PredictCustomerChurn:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_CUSTOMER_CHURN'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH'
      query_timeout: 60
  PredictDesignWinConversion:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE.ANALYTICS.PREDICT_DESIGN_WIN_CONVERSION'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH'
      query_timeout: 60
  $$;

-- Verify agent
SHOW AGENTS LIKE 'MICROCHIP_INTELLIGENCE_AGENT';
DESCRIBE AGENT MICROCHIP_INTELLIGENCE_AGENT;

-- Grant usage on agent
GRANT USAGE ON AGENT MICROCHIP_INTELLIGENCE_AGENT TO ROLE SYSADMIN;

SELECT 'Microchip Intelligence Agent (main) created successfully' AS status;


