-- ============================================================================
-- Microchip Intelligence Agent - Create Agent (RN)
-- ============================================================================
USE ROLE ACCOUNTADMIN;
USE DATABASE MICROCHIP_INTELLIGENCE_RN;
USE SCHEMA ANALYTICS_RN;
USE WAREHOUSE MICROCHIP_WH_RN;


-- Create Agent
CREATE OR REPLACE AGENT MICROCHIP_INTELLIGENCE_AGENT_RN
  COMMENT = 'Microchip Intelligence Agent (RN)'
  PROFILE = '{"display_name": "Microchip Agent RN", "avatar": "chip", "color": "blue"}'
  FROM SPECIFICATION
  $$
models:
  orchestration: AUTO

instructions:
  response: 'Use semantic views, search services, and ML procedures in the RN environment.'
  system: 'RN environment agent for Microchip analytics.'
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
      answer: 'I will call the PredictRevenueRN procedure and present monthly forecasts.'
    - question: 'Which customers are most likely to churn next quarter? Show top 10.'
      answer: 'I will call PredictCustomerChurnRN and return customers with highest risk.'
    - question: 'Which design wins have high probability to convert?'
      answer: 'I will call PredictDesignWinConversionRN and rank designs by probability.'
    - question: 'Forecast revenue for the Microcontrollers family.'
      answer: 'I will filter inputs and run the revenue forecast by family.'
    - question: 'Identify churn risk for Distributor customers and summarize drivers.'
      answer: 'I will run churn predictions for Distributors and summarize key drivers.'

tools:
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'DesignEngineeringAnalystRN'
      description: 'Analyzes design & engineering metrics (RN)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SalesRevenueAnalystRN'
      description: 'Analyzes sales & revenue metrics (RN)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SupportQualityAnalystRN'
      description: 'Analyzes support & quality metrics (RN)'
  - tool_spec:
      type: 'cortex_search'
      name: 'SupportTranscriptsSearchRN'
      description: 'Search support transcripts (RN)'
  - tool_spec:
      type: 'cortex_search'
      name: 'ApplicationNotesSearchRN'
      description: 'Search application notes (RN)'
  - tool_spec:
      type: 'cortex_search'
      name: 'QualityReportsSearchRN'
      description: 'Search quality investigation reports (RN)'
  - tool_spec:
      type: 'generic'
      name: 'PredictRevenueRN'
      description: 'Forecast revenue (RN)'
      input_schema:
        type: 'object'
        properties:
          months_ahead:
            type: 'integer'
        required: ['months_ahead']
  - tool_spec:
      type: 'generic'
      name: 'PredictCustomerChurnRN'
      description: 'Predict churn (RN)'
      input_schema:
        type: 'object'
        properties:
          customer_segment:
            type: 'string'
        required: []
  - tool_spec:
      type: 'generic'
      name: 'PredictDesignWinConversionRN'
      description: 'Predict design win conversion (RN)'
      input_schema:
        type: 'object'
        properties:
          product_family:
            type: 'string'
        required: []

tool_resources:
  DesignEngineeringAnalystRN:
    semantic_view: 'MICROCHIP_INTELLIGENCE_RN.ANALYTICS_RN.SV_DESIGN_ENGINEERING_INTELLIGENCE_RN'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_RN'
      query_timeout: 60
  SalesRevenueAnalystRN:
    semantic_view: 'MICROCHIP_INTELLIGENCE_RN.ANALYTICS_RN.SV_SALES_REVENUE_INTELLIGENCE_RN'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_RN'
      query_timeout: 60
  SupportQualityAnalystRN:
    semantic_view: 'MICROCHIP_INTELLIGENCE_RN.ANALYTICS_RN.SV_CUSTOMER_SUPPORT_INTELLIGENCE_RN'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_RN'
      query_timeout: 60
  SupportTranscriptsSearchRN:
    search_service: 'MICROCHIP_INTELLIGENCE_RN.RAW_RN.SUPPORT_TRANSCRIPTS_SEARCH_RN'
    max_results: 10
    title_column: 'ticket_id'
    id_column: 'transcript_id'
  ApplicationNotesSearchRN:
    search_service: 'MICROCHIP_INTELLIGENCE_RN.RAW_RN.APPLICATION_NOTES_SEARCH_RN'
    max_results: 10
    title_column: 'title'
    id_column: 'appnote_id'
  QualityReportsSearchRN:
    search_service: 'MICROCHIP_INTELLIGENCE_RN.RAW_RN.QUALITY_INVESTIGATION_REPORTS_SEARCH_RN'
    max_results: 10
    title_column: 'investigation_type'
    id_column: 'investigation_report_id'
  PredictRevenueRN:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_RN.ANALYTICS_RN.PREDICT_REVENUE_RN'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_RN'
      query_timeout: 60
  PredictCustomerChurnRN:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_RN.ANALYTICS_RN.PREDICT_CUSTOMER_CHURN_RN'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_RN'
      query_timeout: 60
  PredictDesignWinConversionRN:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_RN.ANALYTICS_RN.PREDICT_DESIGN_WIN_CONVERSION_RN'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_RN'
      query_timeout: 60
  $$;

SHOW AGENTS LIKE 'MICROCHIP_INTELLIGENCE_AGENT_RN';
DESCRIBE AGENT MICROCHIP_INTELLIGENCE_AGENT_RN;
SELECT 'Microchip Intelligence Agent (RN) created successfully' AS status;


