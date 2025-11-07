-- ============================================================================
-- Microchip Intelligence Agent - Create Agent (MB)
-- ============================================================================
USE ROLE ACCOUNTADMIN;
USE DATABASE MICROCHIP_INTELLIGENCE_MB;
USE SCHEMA ANALYTICS_MB;
USE WAREHOUSE MICROCHIP_WH_MB;


-- Create Agent
CREATE OR REPLACE AGENT MICROCHIP_INTELLIGENCE_AGENT_MB
  COMMENT = 'Microchip Intelligence Agent (MB)'
  PROFILE = '{"display_name": "Microchip Agent MB", "avatar": "chip", "color": "blue"}'
  FROM SPECIFICATION
  $$
models:
  orchestration: AUTO

instructions:
  response: 'Use semantic views, search services, and ML procedures in the MB environment.'
  system: 'MB environment agent for Microchip analytics.'
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
      answer: 'I will call the PredictRevenueMB procedure and present monthly forecasts.'
    - question: 'Which customers are most likely to churn next quarter? Show top 10.'
      answer: 'I will call PredictCustomerChurnMB and return customers with highest risk.'
    - question: 'Which design wins have high probability to convert?'
      answer: 'I will call PredictDesignWinConversionMB and rank designs by probability.'
    - question: 'Forecast revenue for the Microcontrollers family.'
      answer: 'I will filter inputs and run the revenue forecast by family.'
    - question: 'Identify churn risk for Distributor customers and summarize drivers.'
      answer: 'I will run churn predictions for Distributors and summarize key drivers.'

tools:
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'DesignEngineeringAnalystMB'
      description: 'Analyzes design & engineering metrics (MB)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SalesRevenueAnalystMB'
      description: 'Analyzes sales & revenue metrics (MB)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SupportQualityAnalystMB'
      description: 'Analyzes support & quality metrics (MB)'
  - tool_spec:
      type: 'cortex_search'
      name: 'SupportTranscriptsSearchMB'
      description: 'Search support transcripts (MB)'
  - tool_spec:
      type: 'cortex_search'
      name: 'ApplicationNotesSearchMB'
      description: 'Search application notes (MB)'
  - tool_spec:
      type: 'cortex_search'
      name: 'QualityReportsSearchMB'
      description: 'Search quality investigation reports (MB)'
  - tool_spec:
      type: 'generic'
      name: 'PredictRevenueMB'
      description: 'Forecast revenue (MB)'
      input_schema:
        type: 'object'
        properties:
          months_ahead:
            type: 'integer'
        required: ['months_ahead']
  - tool_spec:
      type: 'generic'
      name: 'PredictCustomerChurnMB'
      description: 'Predict churn (MB)'
      input_schema:
        type: 'object'
        properties:
          customer_segment:
            type: 'string'
        required: []
  - tool_spec:
      type: 'generic'
      name: 'PredictDesignWinConversionMB'
      description: 'Predict design win conversion (MB)'
      input_schema:
        type: 'object'
        properties:
          product_family:
            type: 'string'
        required: []

tool_resources:
  DesignEngineeringAnalystMB:
    semantic_view: 'MICROCHIP_INTELLIGENCE_MB.ANALYTICS_MB.SV_DESIGN_ENGINEERING_INTELLIGENCE_MB'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_MB'
      query_timeout: 60
  SalesRevenueAnalystMB:
    semantic_view: 'MICROCHIP_INTELLIGENCE_MB.ANALYTICS_MB.SV_SALES_REVENUE_INTELLIGENCE_MB'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_MB'
      query_timeout: 60
  SupportQualityAnalystMB:
    semantic_view: 'MICROCHIP_INTELLIGENCE_MB.ANALYTICS_MB.SV_CUSTOMER_SUPPORT_INTELLIGENCE_MB'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_MB'
      query_timeout: 60
  SupportTranscriptsSearchMB:
    search_service: 'MICROCHIP_INTELLIGENCE_MB.RAW_MB.SUPPORT_TRANSCRIPTS_SEARCH_MB'
    max_results: 10
    title_column: 'ticket_id'
    id_column: 'transcript_id'
  ApplicationNotesSearchMB:
    search_service: 'MICROCHIP_INTELLIGENCE_MB.RAW_MB.APPLICATION_NOTES_SEARCH_MB'
    max_results: 10
    title_column: 'title'
    id_column: 'appnote_id'
  QualityReportsSearchMB:
    search_service: 'MICROCHIP_INTELLIGENCE_MB.RAW_MB.QUALITY_INVESTIGATION_REPORTS_SEARCH_MB'
    max_results: 10
    title_column: 'investigation_type'
    id_column: 'investigation_report_id'
  PredictRevenueMB:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_MB.ANALYTICS_MB.PREDICT_REVENUE_MB'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_MB'
      query_timeout: 60
  PredictCustomerChurnMB:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_MB.ANALYTICS_MB.PREDICT_CUSTOMER_CHURN_MB'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_MB'
      query_timeout: 60
  PredictDesignWinConversionMB:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_MB.ANALYTICS_MB.PREDICT_DESIGN_WIN_CONVERSION_MB'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_MB'
      query_timeout: 60
  $$;

SHOW AGENTS LIKE 'MICROCHIP_INTELLIGENCE_AGENT_MB';
DESCRIBE AGENT MICROCHIP_INTELLIGENCE_AGENT_MB;
SELECT 'Microchip Intelligence Agent (MB) created successfully' AS status;


