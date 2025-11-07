-- ============================================================================
-- Microchip Intelligence Agent - Create Agent (ST)
-- ============================================================================
USE ROLE ACCOUNTADMIN;
USE DATABASE MICROCHIP_INTELLIGENCE_ST;
USE SCHEMA ANALYTICS_ST;
USE WAREHOUSE MICROCHIP_WH_ST;


-- Create Agent
CREATE OR REPLACE AGENT MICROCHIP_INTELLIGENCE_AGENT_ST
  COMMENT = 'Microchip Intelligence Agent (ST)'
  PROFILE = '{"display_name": "Microchip Agent ST", "avatar": "chip", "color": "blue"}'
  FROM SPECIFICATION
  $$
models:
  orchestration: AUTO

instructions:
  response: 'Use semantic views, search services, and ML procedures in the ST environment.'
  system: 'ST environment agent for Microchip analytics.'
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
      answer: 'I will call the PredictRevenueST procedure and present monthly forecasts.'
    - question: 'Which customers are most likely to churn next quarter? Show top 10.'
      answer: 'I will call PredictCustomerChurnST and return customers with highest risk.'
    - question: 'Which design wins have high probability to convert?'
      answer: 'I will call PredictDesignWinConversionST and rank designs by probability.'
    - question: 'Forecast revenue for the Microcontrollers family.'
      answer: 'I will filter inputs and run the revenue forecast by family.'
    - question: 'Identify churn risk for Distributor customers and summarize drivers.'
      answer: 'I will run churn predictions for Distributors and summarize key drivers.'

tools:
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'DesignEngineeringAnalystST'
      description: 'Analyzes design & engineering metrics (ST)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SalesRevenueAnalystST'
      description: 'Analyzes sales & revenue metrics (ST)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SupportQualityAnalystST'
      description: 'Analyzes support & quality metrics (ST)'
  - tool_spec:
      type: 'cortex_search'
      name: 'SupportTranscriptsSearchST'
      description: 'Search support transcripts (ST)'
  - tool_spec:
      type: 'cortex_search'
      name: 'ApplicationNotesSearchST'
      description: 'Search application notes (ST)'
  - tool_spec:
      type: 'cortex_search'
      name: 'QualityReportsSearchST'
      description: 'Search quality investigation reports (ST)'
  - tool_spec:
      type: 'generic'
      name: 'PredictRevenueST'
      description: 'Forecast revenue (ST)'
      input_schema:
        type: 'object'
        properties:
          months_ahead:
            type: 'integer'
        required: ['months_ahead']
  - tool_spec:
      type: 'generic'
      name: 'PredictCustomerChurnST'
      description: 'Predict churn (ST)'
      input_schema:
        type: 'object'
        properties:
          customer_segment:
            type: 'string'
        required: []
  - tool_spec:
      type: 'generic'
      name: 'PredictDesignWinConversionST'
      description: 'Predict design win conversion (ST)'
      input_schema:
        type: 'object'
        properties:
          product_family:
            type: 'string'
        required: []

tool_resources:
  DesignEngineeringAnalystST:
    semantic_view: 'MICROCHIP_INTELLIGENCE_ST.ANALYTICS_ST.SV_DESIGN_ENGINEERING_INTELLIGENCE_ST'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_ST'
      query_timeout: 60
  SalesRevenueAnalystST:
    semantic_view: 'MICROCHIP_INTELLIGENCE_ST.ANALYTICS_ST.SV_SALES_REVENUE_INTELLIGENCE_ST'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_ST'
      query_timeout: 60
  SupportQualityAnalystST:
    semantic_view: 'MICROCHIP_INTELLIGENCE_ST.ANALYTICS_ST.SV_CUSTOMER_SUPPORT_INTELLIGENCE_ST'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_ST'
      query_timeout: 60
  SupportTranscriptsSearchST:
    search_service: 'MICROCHIP_INTELLIGENCE_ST.RAW_ST.SUPPORT_TRANSCRIPTS_SEARCH_ST'
    max_results: 10
    title_column: 'ticket_id'
    id_column: 'transcript_id'
  ApplicationNotesSearchST:
    search_service: 'MICROCHIP_INTELLIGENCE_ST.RAW_ST.APPLICATION_NOTES_SEARCH_ST'
    max_results: 10
    title_column: 'title'
    id_column: 'appnote_id'
  QualityReportsSearchST:
    search_service: 'MICROCHIP_INTELLIGENCE_ST.RAW_ST.QUALITY_INVESTIGATION_REPORTS_SEARCH_ST'
    max_results: 10
    title_column: 'investigation_type'
    id_column: 'investigation_report_id'
  PredictRevenueST:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_ST.ANALYTICS_ST.PREDICT_REVENUE_ST'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_ST'
      query_timeout: 60
  PredictCustomerChurnST:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_ST.ANALYTICS_ST.PREDICT_CUSTOMER_CHURN_ST'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_ST'
      query_timeout: 60
  PredictDesignWinConversionST:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_ST.ANALYTICS_ST.PREDICT_DESIGN_WIN_CONVERSION_ST'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_ST'
      query_timeout: 60
  $$;

SHOW AGENTS LIKE 'MICROCHIP_INTELLIGENCE_AGENT_ST';
DESCRIBE AGENT MICROCHIP_INTELLIGENCE_AGENT_ST;
SELECT 'Microchip Intelligence Agent (ST) created successfully' AS status;


