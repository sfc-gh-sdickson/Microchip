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
  orchestration: claude-4-sonnet

instructions:
  response: 'Use semantic views, search services, and ML procedures in the RN environment.'
  system: 'RN environment agent for Microchip analytics.'

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


