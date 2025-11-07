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
  orchestration: claude-4-sonnet

instructions:
  response: 'Use semantic views, search services, and ML procedures in the SL environment.'
  system: 'SL environment agent for Microchip analytics.'

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


