# Agent Creation SQL Script (Main)

This directory contains the SQL script for creating the Microchip Snowflake Intelligence Agent.

## File

### 08_create_intelligence_agent.sql

Creates a complete Intelligence Agent with:
- Cortex Analyst tools (3 semantic views)
- Cortex Search tools (3 search services)
- ML Model tools (3 stored procedures)

### Prerequisites
- Run scripts 01–07 successfully (database, schemas, tables, data, views, semantic views, search services, ML procedures)
- Warehouse `MICROCHIP_WH` exists and is usable

## Quick Start

```sql
-- Execute in order after 01–07
@sql/agent/08_create_intelligence_agent.sql
```

## What This Script Does
1. Grants required permissions for Analyst, Search, and ML tools
2. Creates the Agent with tools wired to the main environment objects
3. Verifies creation and grants usage on the Agent

## Troubleshooting
- Verify semantic views exist:
  ```sql
  SHOW SEMANTIC VIEWS IN SCHEMA MICROCHIP_INTELLIGENCE.ANALYTICS;
  ```
- Verify Cortex Search services:
  ```sql
  SHOW CORTEX SEARCH SERVICES IN SCHEMA MICROCHIP_INTELLIGENCE.RAW;
  ```
- Verify ML procedures:
  ```sql
  SHOW PROCEDURES IN SCHEMA MICROCHIP_INTELLIGENCE.ANALYTICS;
  ```

