-- ============================================================================
-- Microchip Intelligence Agent - Create Agent (TM)
-- ============================================================================
USE ROLE SYSADMIN;
USE DATABASE MICROCHIP_INTELLIGENCE_TM;
USE SCHEMA ANALYTICS_TM;
USE WAREHOUSE MICROCHIP_WH_TM;

-- Grants
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER TO ROLE SYSADMIN;
GRANT USAGE ON DATABASE MICROCHIP_INTELLIGENCE_TM TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA MICROCHIP_INTELLIGENCE_TM.RAW_TM TO ROLE SYSADMIN;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.SV_DESIGN_ENGINEERING_INTELLIGENCE_TM TO ROLE SYSADMIN;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.SV_SALES_REVENUE_INTELLIGENCE_TM TO ROLE SYSADMIN;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.SV_CUSTOMER_SUPPORT_INTELLIGENCE_TM TO ROLE SYSADMIN;
GRANT USAGE ON WAREHOUSE MICROCHIP_WH_TM TO ROLE SYSADMIN;
GRANT USAGE ON CORTEX SEARCH SERVICE MICROCHIP_INTELLIGENCE_TM.RAW_TM.SUPPORT_TRANSCRIPTS_SEARCH_TM TO ROLE SYSADMIN;
GRANT USAGE ON CORTEX SEARCH SERVICE MICROCHIP_INTELLIGENCE_TM.RAW_TM.APPLICATION_NOTES_SEARCH_TM TO ROLE SYSADMIN;
GRANT USAGE ON CORTEX SEARCH SERVICE MICROCHIP_INTELLIGENCE_TM.RAW_TM.QUALITY_INVESTIGATION_REPORTS_SEARCH_TM TO ROLE SYSADMIN;
GRANT USAGE ON PROCEDURE MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.PREDICT_REVENUE_TM(INT) TO ROLE SYSADMIN;
GRANT USAGE ON PROCEDURE MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.PREDICT_CUSTOMER_CHURN_TM(STRING) TO ROLE SYSADMIN;
GRANT USAGE ON PROCEDURE MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.PREDICT_DESIGN_WIN_CONVERSION_TM(STRING) TO ROLE SYSADMIN;

-- Create Agent
CREATE OR REPLACE AGENT MICROCHIP_INTELLIGENCE_AGENT_TM
  COMMENT = 'Microchip Intelligence Agent (TM)'
  PROFILE = '{"display_name": "Microchip Agent TM", "avatar": "chip", "color": "blue"}'
  FROM SPECIFICATION
  $$
models:
  orchestration: claude-4-sonnet

instructions:
  response: 'Use semantic views, search services, and ML procedures in the TM environment.'
  system: 'TM environment agent for Microchip analytics.'

tools:
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'DesignEngineeringAnalystTM'
      description: 'Analyzes design & engineering metrics (TM)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SalesRevenueAnalystTM'
      description: 'Analyzes sales & revenue metrics (TM)'
  - tool_spec:
      type: 'cortex_analyst_text_to_sql'
      name: 'SupportQualityAnalystTM'
      description: 'Analyzes support & quality metrics (TM)'
  - tool_spec:
      type: 'cortex_search'
      name: 'SupportTranscriptsSearchTM'
      description: 'Search support transcripts (TM)'
  - tool_spec:
      type: 'cortex_search'
      name: 'ApplicationNotesSearchTM'
      description: 'Search application notes (TM)'
  - tool_spec:
      type: 'cortex_search'
      name: 'QualityReportsSearchTM'
      description: 'Search quality investigation reports (TM)'
  - tool_spec:
      type: 'generic'
      name: 'PredictRevenueTM'
      description: 'Forecast revenue (TM)'
      input_schema:
        type: 'object'
        properties:
          months_ahead:
            type: 'integer'
        required: ['months_ahead']
  - tool_spec:
      type: 'generic'
      name: 'PredictCustomerChurnTM'
      description: 'Predict churn (TM)'
      input_schema:
        type: 'object'
        properties:
          customer_segment:
            type: 'string'
        required: []
  - tool_spec:
      type: 'generic'
      name: 'PredictDesignWinConversionTM'
      description: 'Predict design win conversion (TM)'
      input_schema:
        type: 'object'
        properties:
          product_family:
            type: 'string'
        required: []

tool_resources:
  DesignEngineeringAnalystTM:
    semantic_view: 'MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.SV_DESIGN_ENGINEERING_INTELLIGENCE_TM'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_TM'
      query_timeout: 60
  SalesRevenueAnalystTM:
    semantic_view: 'MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.SV_SALES_REVENUE_INTELLIGENCE_TM'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_TM'
      query_timeout: 60
  SupportQualityAnalystTM:
    semantic_view: 'MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.SV_CUSTOMER_SUPPORT_INTELLIGENCE_TM'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_TM'
      query_timeout: 60
  SupportTranscriptsSearchTM:
    search_service: 'MICROCHIP_INTELLIGENCE_TM.RAW_TM.SUPPORT_TRANSCRIPTS_SEARCH_TM'
    max_results: 10
    title_column: 'ticket_id'
    id_column: 'transcript_id'
  ApplicationNotesSearchTM:
    search_service: 'MICROCHIP_INTELLIGENCE_TM.RAW_TM.APPLICATION_NOTES_SEARCH_TM'
    max_results: 10
    title_column: 'title'
    id_column: 'appnote_id'
  QualityReportsSearchTM:
    search_service: 'MICROCHIP_INTELLIGENCE_TM.RAW_TM.QUALITY_INVESTIGATION_REPORTS_SEARCH_TM'
    max_results: 10
    title_column: 'investigation_type'
    id_column: 'investigation_report_id'
  PredictRevenueTM:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.PREDICT_REVENUE_TM'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_TM'
      query_timeout: 60
  PredictCustomerChurnTM:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.PREDICT_CUSTOMER_CHURN_TM'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_TM'
      query_timeout: 60
  PredictDesignWinConversionTM:
    type: 'procedure'
    identifier: 'MICROCHIP_INTELLIGENCE_TM.ANALYTICS_TM.PREDICT_DESIGN_WIN_CONVERSION_TM'
    execution_environment:
      type: 'warehouse'
      warehouse: 'MICROCHIP_WH_TM'
      query_timeout: 60
  $$;

SHOW AGENTS LIKE 'MICROCHIP_INTELLIGENCE_AGENT_TM';
DESCRIBE AGENT MICROCHIP_INTELLIGENCE_AGENT_TM;
GRANT USAGE ON AGENT MICROCHIP_INTELLIGENCE_AGENT_TM TO ROLE SYSADMIN;
SELECT 'Microchip Intelligence Agent (TM) created successfully' AS status;


