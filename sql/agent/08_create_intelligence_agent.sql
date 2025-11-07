-- ============================================================================
-- Microchip Intelligence Agent - Create Snowflake Intelligence Agent (Main)
-- ============================================================================
-- Purpose: Create and configure the Microchip Intelligence Agent with:
--          - Cortex Analyst tools (Semantic Views)
--          - Cortex Search tools (Unstructured Data)
--          - Optional ML Model tools (Stored Procedures)
-- Execution Order: Run AFTER 01-07 scripts are completed
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE DATABASE MICROCHIP_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE MICROCHIP_WH;

-- ============================================================================
-- Step 2: Create Snowflake Intelligence Agent
-- ============================================================================

CREATE OR REPLACE AGENT MICROCHIP_INTELLIGENCE_AGENT
  COMMENT = 'Microchip Intelligence Agent for semiconductor business intelligence'
  PROFILE = '{"display_name": "Microchip Intelligence Agent", "avatar": "chip", "color": "blue"}'
  FROM SPECIFICATION
  $$
models:
  orchestration: AUTO

instructions:
  response: 'You are a Microchip semiconductor analytics assistant. For metrics and KPIs, use Cortex Analyst semantic views. For unstructured content, use Cortex Search. For predictions, use ML procedures. Keep answers concise and data-driven.'
  orchestration: 'Prefer semantic views for structured analytics; use search services for unstructured answers; call ML procedures for forecasting/classification.'
  system: 'Analyze Microchip customers, sales, product performance, support, and quality data.'
  sample_questions:
    # Simple (5)
    - question: 'How many customers do we have?'
      answer: 'I will query the customer dimension in the semantic model to count total customers.'
    - question: 'What was total revenue last month?'
      answer: 'I will use the Sales Revenue Intelligence semantic view filtered to last month.'
    - question: 'Show orders by product family for the last 30 days.'
      answer: 'I will group orders by product family in the Sales Revenue Intelligence view.'
    - question: 'How many open support tickets do we have right now?'
      answer: 'I will count open tickets in the Customer Support Intelligence view.'
    - question: 'List the top 5 customers by lifetime value.'
      answer: 'I will rank customers by lifetime value using the semantic model.'

    # Complex (5)
    - question: 'Break down quarterly revenue by product family year-to-date and compare vs last year.'
      answer: 'I will aggregate revenue by quarter and product family and compute year-over-year deltas.'
    - question: 'Which product families have the highest support ticket rates per 1,000 orders over the last 90 days?'
      answer: 'I will join orders and support metrics in the semantic layer and normalize by order volume.'
    - question: 'What is our design win conversion rate to production by product family in the last 12 months?'
      answer: 'I will calculate conversion rates using design wins and production orders in the semantic model.'
    - question: 'Analyze correlation between quality issues and customer churn indicators.'
      answer: 'I will analyze quality issues alongside support and order activity to identify churn signals.'
    - question: 'Which customers drive the top 20% of revenue and what are their common attributes?'
      answer: 'I will compute revenue contribution and summarize common segments/industries for top contributors.'

    # ML-driven (5)
    - question: 'Forecast total revenue for the next 6 months.'
      answer: 'I will call the PredictRevenue procedure and present the forecast by month.'
    - question: 'Which customers are most likely to churn next quarter? Show top 10.'
      answer: 'I will call the PredictCustomerChurn procedure and return customers with highest risk scores.'
    - question: 'Which design wins have a high probability to convert to production?'
      answer: 'I will call the PredictDesignWinConversion procedure and rank designs by predicted conversion.'
    - question: 'Forecast revenue specifically for the Microcontrollers product family.'
      answer: 'I will filter inputs and call the revenue prediction to estimate by product family.'
    - question: 'Identify churn risk for Distributor customers and summarize drivers.'
      answer: 'I will run churn predictions for the Distributor segment and summarize key contributing features.'

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

SELECT 'Microchip Intelligence Agent (main) created successfully' AS status;


