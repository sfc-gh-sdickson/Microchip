-- ============================================================================
-- Microchip Intelligence Agent - Create Agent (VP)
-- ============================================================================
USE ROLE ACCOUNTADMIN;
USE DATABASE MICROCHIP_INTELLIGENCE_VP;
USE SCHEMA ANALYTICS_VP;
USE WAREHOUSE MICROCHIP_WH_VP;


-- Create Agent
CREATE OR REPLACE AGENT MICROCHIP_INTELLIGENCE_AGENT_VP
  COMMENT = 'Microchip Intelligence Agent (VP)'
  PROFILE = '{"display_name": "Microchip Agent VP", "avatar": "chip", "color": "blue"}'
  FROM SPECIFICATION
  $$
models:
  orchestration: AUTO

instructions:
  response: 'Use semantic views, search services, and ML procedures in the VP environment.'
  system: 'VP environment agent for Microchip analytics.'
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
      answer: 'I will call the PredictRevenueVP procedure and present monthly forecasts.'
    - question: 'Which customers are most likely to churn next quarter? Show top 10.'
      answer: 'I will call PredictCustomerChurnVP and return customers with highest risk.'
    - question: 'Which design wins have high probability to convert?'
      answer: 'I will call PredictDesignWinConversionVP and rank designs by probability.'
    - question: 'Forecast revenue for the Microcontrollers family.'
      answer: 'I will filter inputs and run the revenue forecast by family.'
    - question: 'Identify churn risk for Distributor customers and summarize drivers.'
      answer: 'I will run churn predictions for Distributors and summarize key drivers.'

tools:
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'DesignEngineeringAnalystVP'
      description: 'Analyzes design & engineering metrics (VP)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SalesRevenueAnalystVP'
      description: 'Analyzes sales & revenue metrics (VP)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SupportQualityAnalystVP'
      description: 'Analyzes support & quality metrics (VP)'
  - tool_spec:
      type: 'cortex_search'
      name: 'SupportTranscriptsSearchVP'
      description: 'Search support transcripts (VP)'
  - tool_spec:
      type: 'cortex_search'
      name: 'ApplicationNotesSearchVP'
      description: 'Search application notes (VP)'
  - tool_spec:
      type: 'cortex_search'
      name: 'QualityReportsSearchVP'
      description: 'Search quality investigation reports (VP)'
  - tool_spec:
      type: 'generic'
      name: 'PredictRevenueVP'
      description: 'Forecast revenue (VP)'
      input_schema:
        type: 'object'
        properties:
          months_ahead:
            type: 'integer'
        required: ['months_ahead']
  - tool_spec:
      type: 'generic'
      name: 'PredictCustomerChurnVP'
      description: 'Predict churn (VP)'
      input_schema:
        type: 'object'
        properties:
          customer_segment:
            type: 'string'
        required: []
  - tool_spec:
      type: 'generic'
      name: 'PredictDesignWinConversionVP'
      description: 'Predict design win conversion (VP)'
      input_schema:
        type: 'object'
        properties:
          product_family:
            type: 'string'
        required: []

tool_resources:
  DesignEngineeringAnalystVP:
    semantic_view: 'MICROCHIP_INTELLIGENCE_VP.ANALYTICS_VP.SV_DESIGN_ENGINEERING_INTELLIGENCE_VP'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_VP'
      query_timeout: 60
  SalesRevenueAnalystVP:
    semantic_view: 'MICROCHIP_INTELLIGENCE_VP.ANALYTICS_VP.SV_SALES_REVENUE_INTELLIGENCE_VP'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_VP'
      query_timeout: 60
  SupportQualityAnalystVP:
    semantic_view: 'MICROCHIP_INTELLIGENCE_VP.ANALYTICS_VP.SV_CUSTOMER_SUPPORT_INTELLIGENCE_VP'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_VP'
      query_timeout: 60
  SupportTranscriptsSearchVP:
    search_service: 'MICROCHIP_INTELLIGENCE_VP.RAW_VP.SUPPORT_TRANSCRIPTS_SEARCH_VP'
    max_results: 10
    title_column: 'ticket_id'
    id_column: 'transcript_id'
  ApplicationNotesSearchVP:
    search_service: 'MICROCHIP_INTELLIGENCE_VP.RAW_VP.APPLICATION_NOTES_SEARCH_VP'
    max_results: 10
    title_column: 'title'
    id_column: 'appnote_id'
  QualityReportsSearchVP:
    search_service: 'MICROCHIP_INTELLIGENCE_VP.RAW_VP.QUALITY_INVESTIGATION_REPORTS_SEARCH_VP'
    max_results: 10
    title_column: 'investigation_type'
    id_column: 'investigation_report_id'
  PredictRevenueVP:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_VP.ANALYTICS_VP.PREDICT_REVENUE_VP'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_VP'
      query_timeout: 60
  PredictCustomerChurnVP:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_VP.ANALYTICS_VP.PREDICT_CUSTOMER_CHURN_VP'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_VP'
      query_timeout: 60
  PredictDesignWinConversionVP:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_VP.ANALYTICS_VP.PREDICT_DESIGN_WIN_CONVERSION_VP'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_VP'
      query_timeout: 60
  $$;

SHOW AGENTS LIKE 'MICROCHIP_INTELLIGENCE_AGENT_VP';
DESCRIBE AGENT MICROCHIP_INTELLIGENCE_AGENT_VP;
SELECT 'Microchip Intelligence Agent (VP) created successfully' AS status;


