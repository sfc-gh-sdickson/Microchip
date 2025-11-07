-- ============================================================================
-- Microchip Intelligence Agent - Create Agent (SL)
-- ============================================================================
USE ROLE ACCOUNTADMIN;
USE DATABASE MICROCHIP_INTELLIGENCE_SL;
USE SCHEMA ANALYTICS_SL;
USE WAREHOUSE MICROCHIP_WH_SL;


-- Create Agent
CREATE OR REPLACE AGENT MICROCHIP_INTELLIGENCE_AGENT_SL
  COMMENT = 'Microchip Intelligence Agent (SL)'
  PROFILE = '{"display_name": "Microchip Agent SL", "avatar": "chip", "color": "blue"}'
  FROM SPECIFICATION
  $$
models:
  orchestration: AUTO

instructions:
  response: 'Use semantic views, search services, and ML procedures in the SL environment.'
  system: 'SL environment agent for Microchip analytics.'
  sample_questions:
    - question: 'How many customers do we have?'
      answer: 'I will query the customer dimension to count total customers.'
    - question: 'What was total revenue last month?'
      answer: 'I will use the Sales Revenue Intelligence view filtered to last month.'
    - question: 'Show orders by product family for the last 30 days.'
      answer: 'I will group orders by product family in the semantic view.'
    - question: 'How many open support tickets do we have right now?'
      answer: 'I will count open tickets in the Customer Support Intelligence view.'
    - question: 'List the top 5 customers by lifetime value.'
      answer: 'I will rank customers by lifetime value from the semantic model.'

    - question: 'Break down quarterly revenue by product family YTD and compare vs last year.'
      answer: 'I will aggregate revenue by quarter and compute year-over-year changes.'
    - question: 'Which product families have the highest ticket rates per 1,000 orders over 90 days?'
      answer: 'I will normalize support tickets by order volume by product family.'
    - question: 'What is design win conversion to production by product family in the last 12 months?'
      answer: 'I will compute conversion using design wins and production orders.'
    - question: 'Analyze correlation between quality issues and churn indicators.'
      answer: 'I will analyze quality issues with support and order activity for churn signals.'
    - question: 'Which customers contribute the top 20% of revenue and what are their attributes?'
      answer: 'I will identify top contributors and summarize common segments/industries.'

    - question: 'Forecast total revenue for the next 6 months.'
      answer: 'I will call the PredictRevenueSL procedure and present monthly forecasts.'
    - question: 'Which customers are most likely to churn next quarter? Show top 10.'
      answer: 'I will call PredictCustomerChurnSL and return customers with highest risk.'
    - question: 'Which design wins have high probability to convert?'
      answer: 'I will call PredictDesignWinConversionSL and rank designs by probability.'
    - question: 'Forecast revenue for the Microcontrollers family.'
      answer: 'I will filter inputs and run the revenue forecast by family.'
    - question: 'Identify churn risk for Distributor customers and summarize drivers.'
      answer: 'I will run churn predictions for Distributors and summarize key drivers.'

tools:
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'DesignEngineeringAnalystSL'
      description: 'Analyzes design & engineering metrics (SL)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SalesRevenueAnalystSL'
      description: 'Analyzes sales & revenue metrics (SL)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SupportQualityAnalystSL'
      description: 'Analyzes support & quality metrics (SL)'
  - tool_spec:
      type: 'cortex_search'
      name: 'SupportTranscriptsSearchSL'
      description: 'Search support transcripts (SL)'
  - tool_spec:
      type: 'cortex_search'
      name: 'ApplicationNotesSearchSL'
      description: 'Search application notes (SL)'
  - tool_spec:
      type: 'cortex_search'
      name: 'QualityReportsSearchSL'
      description: 'Search quality investigation reports (SL)'
  - tool_spec:
      type: 'generic'
      name: 'PredictRevenueSL'
      description: 'Forecast revenue (SL)'
      input_schema:
        type: 'object'
        properties:
          months_ahead:
            type: 'integer'
        required: ['months_ahead']
  - tool_spec:
      type: 'generic'
      name: 'PredictCustomerChurnSL'
      description: 'Predict churn (SL)'
      input_schema:
        type: 'object'
        properties:
          customer_segment:
            type: 'string'
        required: []
  - tool_spec:
      type: 'generic'
      name: 'PredictDesignWinConversionSL'
      description: 'Predict design win conversion (SL)'
      input_schema:
        type: 'object'
        properties:
          product_family:
            type: 'string'
        required: []

tool_resources:
  DesignEngineeringAnalystSL:
    semantic_view: 'MICROCHIP_INTELLIGENCE_SL.ANALYTICS_SL.SV_DESIGN_ENGINEERING_INTELLIGENCE_SL'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_SL'
      query_timeout: 60
  SalesRevenueAnalystSL:
    semantic_view: 'MICROCHIP_INTELLIGENCE_SL.ANALYTICS_SL.SV_SALES_REVENUE_INTELLIGENCE_SL'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_SL'
      query_timeout: 60
  SupportQualityAnalystSL:
    semantic_view: 'MICROCHIP_INTELLIGENCE_SL.ANALYTICS_SL.SV_CUSTOMER_SUPPORT_INTELLIGENCE_SL'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_SL'
      query_timeout: 60
  SupportTranscriptsSearchSL:
    search_service: 'MICROCHIP_INTELLIGENCE_SL.RAW_SL.SUPPORT_TRANSCRIPTS_SEARCH_SL'
    max_results: 10
    title_column: 'ticket_id'
    id_column: 'transcript_id'
  ApplicationNotesSearchSL:
    search_service: 'MICROCHIP_INTELLIGENCE_SL.RAW_SL.APPLICATION_NOTES_SEARCH_SL'
    max_results: 10
    title_column: 'title'
    id_column: 'appnote_id'
  QualityReportsSearchSL:
    search_service: 'MICROCHIP_INTELLIGENCE_SL.RAW_SL.QUALITY_INVESTIGATION_REPORTS_SEARCH_SL'
    max_results: 10
    title_column: 'investigation_type'
    id_column: 'investigation_report_id'
  PredictRevenueSL:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_SL.ANALYTICS_SL.PREDICT_REVENUE_SL'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_SL'
      query_timeout: 60
  PredictCustomerChurnSL:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_SL.ANALYTICS_SL.PREDICT_CUSTOMER_CHURN_SL'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_SL'
      query_timeout: 60
  PredictDesignWinConversionSL:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_SL.ANALYTICS_SL.PREDICT_DESIGN_WIN_CONVERSION_SL'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_SL'
      query_timeout: 60
  $$;

SHOW AGENTS LIKE 'MICROCHIP_INTELLIGENCE_AGENT_SL';
DESCRIBE AGENT MICROCHIP_INTELLIGENCE_AGENT_SL;
SELECT 'Microchip Intelligence Agent (SL) created successfully' AS status;


