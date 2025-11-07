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
  orchestration: claude-4-sonnet

instructions:
  response: 'Use semantic views, search services, and ML procedures in the MB environment.'
  system: 'MB environment agent for Microchip analytics.'

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


