# Microchip Intelligence Agent - Setup Guide

This guide walks through configuring a Snowflake Intelligence agent for Microchip's semiconductor business intelligence solution covering design wins, sales revenue, product performance, customer support, and quality analytics.

---

## Prerequisites

1. **Snowflake Account** with:
   - Snowflake Intelligence (Cortex) enabled
   - Appropriate warehouse size (recommended: X-SMALL or larger)
   - Permissions to create databases, schemas, tables, and semantic views

2. **Roles and Permissions**:
   - `ACCOUNTADMIN` role or equivalent for initial setup
   - `CREATE DATABASE` privilege
   - `CREATE SEMANTIC VIEW` privilege
   - `CREATE CORTEX SEARCH SERVICE` privilege
   - `USAGE` on warehouses

---

## Step 1: Execute SQL Scripts in Order

Execute the SQL files in the following sequence:

### 1.1 Database Setup
```sql
-- Execute: sql/setup/01_database_and_schema.sql
-- Creates database, schemas (RAW, ANALYTICS), and warehouse
-- Execution time: < 1 second
```

### 1.2 Create Tables
```sql
-- Execute: sql/setup/02_create_tables.sql
-- Creates all table structures with proper relationships
-- Tables: CUSTOMERS, DESIGN_ENGINEERS, PRODUCT_CATALOG, DISTRIBUTORS,
--         DESIGN_WINS, PRODUCTION_ORDERS, ORDERS, SUPPORT_CONTRACTS,
--         CERTIFICATIONS, CERTIFICATION_VERIFICATIONS, SUPPORT_TICKETS,
--         SUPPORT_ENGINEERS, QUALITY_ISSUES, MARKETING_CAMPAIGNS, etc.
-- Execution time: < 5 seconds
```

### 1.3 Generate Sample Data
```sql
-- Execute: sql/data/03_generate_synthetic_data.sql
-- Generates realistic sample data:
--   - 25,000 customers
--   - 250,000 design engineers
--   - 500,000 design wins
--   - 300,000 production orders
--   - 1,000,000 orders
--   - 40,000 certifications
--   - 75,000 support tickets
--   - 25,000 quality issues
-- Execution time: 10-20 minutes (depending on warehouse size)
```

### 1.4 Create Analytical Views
```sql
-- Execute: sql/views/04_create_views.sql
-- Creates curated analytical views:
--   - V_CUSTOMER_360
--   - V_DESIGN_ENGINEER_ANALYTICS
--   - V_DESIGN_WIN_ANALYTICS
--   - V_PRODUCT_PERFORMANCE
--   - V_DISTRIBUTOR_PERFORMANCE
--   - V_SUPPORT_TICKET_ANALYTICS
--   - V_QUALITY_ISSUE_ANALYTICS
--   - V_REVENUE_ANALYTICS
--   - V_CERTIFICATION_ANALYTICS
-- Execution time: < 5 seconds
```

### 1.5 Create Semantic Views
```sql
-- Execute: sql/views/05_create_semantic_views.sql
-- Creates semantic views for AI agents (VERIFIED SYNTAX):
--   - SV_DESIGN_ENGINEERING_INTELLIGENCE
--   - SV_SALES_REVENUE_INTELLIGENCE
--   - SV_CUSTOMER_SUPPORT_INTELLIGENCE
-- Execution time: < 5 seconds
```

### 1.6 Create Cortex Search Services
```sql
-- Execute: sql/search/06_create_cortex_search.sql
-- Creates tables for unstructured text data:
--   - SUPPORT_TRANSCRIPTS (25,000 technical support interactions)
--   - APPLICATION_NOTES (3 comprehensive technical guides)
--   - QUALITY_INVESTIGATION_REPORTS (15,000 investigation reports)
-- Creates Cortex Search services for semantic search:
--   - SUPPORT_TRANSCRIPTS_SEARCH
--   - APPLICATION_NOTES_SEARCH
--   - QUALITY_INVESTIGATION_REPORTS_SEARCH
-- Execution time: 5-10 minutes (data generation + index building)
```

---

## Step 2: Grant Cortex Analyst Permissions

Before creating the agent, ensure proper permissions are configured:

### 2.1 Grant Database Role for Cortex Analyst

```sql
USE ROLE ACCOUNTADMIN;

-- Grant Cortex Analyst user role
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER TO ROLE <your_role>;

-- Grant usage on database and schemas
GRANT USAGE ON DATABASE MICROCHIP_INTELLIGENCE TO ROLE <your_role>;
GRANT USAGE ON SCHEMA MICROCHIP_INTELLIGENCE.ANALYTICS TO ROLE <your_role>;
GRANT USAGE ON SCHEMA MICROCHIP_INTELLIGENCE.RAW TO ROLE <your_role>;

-- Grant privileges on semantic views
GRANT REFERENCES, SELECT ON SEMANTIC VIEW MICROCHIP_INTELLIGENCE.ANALYTICS.SV_DESIGN_ENGINEERING_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW MICROCHIP_INTELLIGENCE.ANALYTICS.SV_SALES_REVENUE_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW MICROCHIP_INTELLIGENCE.ANALYTICS.SV_CUSTOMER_SUPPORT_INTELLIGENCE TO ROLE <your_role>;

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE MICROCHIP_WH TO ROLE <your_role>;

-- Grant usage on Cortex Search services
GRANT USAGE ON CORTEX SEARCH SERVICE MICROCHIP_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE MICROCHIP_INTELLIGENCE.RAW.APPLICATION_NOTES_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE MICROCHIP_INTELLIGENCE.RAW.QUALITY_INVESTIGATION_REPORTS_SEARCH TO ROLE <your_role>;
```

---

## Step 3: Create Snowflake Intelligence Agent

### Step 3.1: Create the Agent

1. In Snowsight, click on **AI & ML** > **Agents**
2. Click on **Create Agent**
3. Select **Create this agent for Snowflake Intelligence**
4. Configure:
   - **Agent Object Name**: `MICROCHIP_INTELLIGENCE_AGENT`
   - **Display Name**: `Microchip Intelligence Agent`
5. Click **Create**

### Step 3.2: Add Description and Instructions

1. Click on **MICROCHIP_INTELLIGENCE_AGENT** to open the agent
2. Click **Edit** on the top right corner
3. In the **Description** section, add:
   ```
   This agent orchestrates between Microchip semiconductor business data for analyzing 
   structured metrics using Cortex Analyst (semantic views) and unstructured technical 
   content using Cortex Search services (support transcripts, application notes, quality reports).
   ```

### Step 3.3: Configure Response Instructions

1. Click on **Instructions** in the left pane
2. Enter the following **Response Instructions**:
   ```
   You are a specialized analytics assistant for Microchip Technology, a leading semiconductor 
   manufacturer. Your primary objectives are:

   For structured data queries (metrics, KPIs, design wins, revenue figures):
   - Use the Cortex Analyst semantic views for design engineering, sales revenue, and customer 
     support analysis
   - Provide direct, numerical answers with minimal explanation
   - Format responses clearly with relevant units and time periods
   - Only include essential context needed to understand the metric

   For unstructured technical content (support transcripts, application notes, quality reports):
   - Use Cortex Search services to find similar technical issues, implementation guidance, and 
     quality investigations
   - Extract relevant troubleshooting procedures, root causes, and solutions
   - Summarize technical findings in brief, focused responses
   - Maintain context from original technical documentation

   Operating guidelines:
   - Always identify whether you're using Cortex Analyst or Cortex Search for each response
   - Keep responses under 3-4 sentences when possible for metrics
   - Present numerical data in structured format
   - Don't speculate beyond available data
   - Highlight quality issues and design win conversion metrics prominently
   - For technical support queries, reference specific product families and issue types
   - Include relevant application note references when available
   ```

3. **Add Sample Questions** (click "Add a question" for each):
   - "Which products are winning the most designs in automotive?"
   - "What is our competitive win rate against STMicroelectronics?"
   - "Search support transcripts for I2C communication problems"

---

### Step 3.4: Add Cortex Analyst Tools (Semantic Views)

1. Click on **Tools** in the left pane
2. Find **Cortex Analyst** and click **+ Add**

**Add Semantic View 1: Design & Engineering Intelligence**

1. **Select semantic view**: `MICROCHIP_INTELLIGENCE.ANALYTICS.SV_DESIGN_ENGINEERING_INTELLIGENCE`
2. **Add a description**:
   ```
   This semantic view contains comprehensive data about customers, design engineers, products, 
   design wins, production orders, and certifications. Use this for queries about:
   - Design win analysis by industry, product family, or customer
   - Production ramp and conversion rates
   - Competitive displacement wins
   - Engineer certification impact
   - Product performance in design wins
   - Customer design activity
   ```
3. **Save**

**Add Semantic View 2: Sales & Revenue Intelligence**

1. Click **+ Add** again for another Cortex Analyst tool
2. **Select semantic view**: `MICROCHIP_INTELLIGENCE.ANALYTICS.SV_SALES_REVENUE_INTELLIGENCE`
3. **Add a description**:
   ```
   This semantic view contains order data, revenue metrics, distributor performance, and support 
   contracts. Use this for queries about:
   - Revenue trends by product family, region, or customer segment
   - Distributor performance and channel effectiveness
   - Order patterns and purchasing behavior
   - Support contract analysis
   - Direct sales versus distributor sales
   - Product portfolio revenue distribution
   ```
4. **Save**

**Add Semantic View 3: Customer Support Intelligence**

1. Click **+ Add** again for another Cortex Analyst tool
2. **Select semantic view**: `MICROCHIP_INTELLIGENCE.ANALYTICS.SV_CUSTOMER_SUPPORT_INTELLIGENCE`
3. **Add a description**:
   ```
   This semantic view contains support ticket data, support engineer performance, and customer 
   satisfaction metrics. Use this for queries about:
   - Support ticket volumes and resolution times
   - Customer satisfaction scores
   - Technical issue patterns by product family
   - Support engineer performance
   - Escalation rates
   - Issue type distribution
   ```
4. **Save**

---

### Step 3.5: Add Cortex Search Tools (Unstructured Data)

1. While still in **Tools**, find **Cortex Search** and click **+ Add**

**Add Cortex Search 1: Support Transcripts**

1. **Select Cortex Search Service**: `MICROCHIP_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH`
2. **Add a description**:
   ```
   Search 25,000 technical support interaction transcripts for troubleshooting procedures, 
   common issues, and successful resolutions. Use for queries about:
   - I2C, SPI, USB, CAN communication problems
   - Programming and debug tool issues
   - Peripheral configuration questions
   - Board layout and signal integrity issues
   - Power management and low-power modes
   - Specific error messages and diagnostic procedures
   ```
3. **Configure search settings**:
   - **ID Column**: `transcript_id`
   - **Title Column**: `ticket_id`
   - **Max Results**: 10
4. **Save**

**Add Cortex Search 2: Application Notes**

1. Click **+ Add** again for another Cortex Search
2. **Select Cortex Search Service**: `MICROCHIP_INTELLIGENCE.RAW.APPLICATION_NOTES_SEARCH`
3. **Add a description**:
   ```
   Search technical application notes and design guides for implementation procedures, 
   configuration guidance, and best practices. Use for queries about:
   - Core Independent Peripherals (CIP) implementation
   - Low power design techniques
   - Motor control and FOC implementation
   - ADC accuracy and precision design
   - USB device configuration
   - Wireless connectivity setup
   - FPGA timing and constraints
   ```
4. **Configure search settings**:
   - **ID Column**: `appnote_id`
   - **Title Column**: `title`
   - **Max Results**: 5
5. **Save**

**Add Cortex Search 3: Quality Investigation Reports**

1. Click **+ Add** again for another Cortex Search
2. **Select Cortex Search Service**: `MICROCHIP_INTELLIGENCE.RAW.QUALITY_INVESTIGATION_REPORTS_SEARCH`
3. **Add a description**:
   ```
   Search quality investigation reports for root cause analysis, corrective actions, and 
   lessons learned. Use for queries about:
   - Field failure investigations
   - Programming and flash retention issues
   - Package and assembly failures
   - Oscillator start-up problems
   - USB signal integrity issues
   - Moisture sensitivity and MSL handling
   - Process variation impacts
   ```
4. **Configure search settings**:
   - **ID Column**: `investigation_report_id`
   - **Title Column**: `quality_issue_id`
   - **Max Results**: 10
5. **Save**

---

## Step 4: Test the Agent

### Step 4.1: Test Structured Data Queries (Cortex Analyst)

1. In the agent interface, click **Chat**
2. Try these test questions:

**Test 1: Design Win Analysis**
```
Which product families are winning the most designs in the automotive industry vertical?
```
Expected: Uses SV_DESIGN_ENGINEERING_INTELLIGENCE, returns count by product_family filtered by industry_vertical = 'AUTOMOTIVE'

**Test 2: Competitive Intelligence**
```
Show me our competitive displacement wins. What is our win rate against STMicroelectronics?
```
Expected: Uses SV_DESIGN_ENGINEERING_INTELLIGENCE, filters by competitive_displacement = TRUE

**Test 3: Revenue Trends**
```
Analyze revenue trends over the past 12 months by product type
```
Expected: Uses SV_SALES_REVENUE_INTELLIGENCE, groups by product_type with time-series

**Test 4: Distributor Performance**
```
Which distributors are generating the most revenue by region?
```
Expected: Uses SV_SALES_REVENUE_INTELLIGENCE, aggregates by distributor and region

**Test 5: Support Efficiency**
```
What is the average support ticket resolution time by ticket category?
```
Expected: Uses SV_CUSTOMER_SUPPORT_INTELLIGENCE, calculates averages by ticket_category

### Step 4.2: Test Unstructured Data Queries (Cortex Search)

**Test 6: Technical Support Search**
```
Search support transcripts for I2C communication problems and common solutions
```
Expected: Uses SUPPORT_TRANSCRIPTS_SEARCH, returns relevant troubleshooting transcripts

**Test 7: Application Note Search**
```
What does our application note library say about low power design techniques for SAM D21?
```
Expected: Uses APPLICATION_NOTES_SEARCH, retrieves low power implementation guidance

**Test 8: Quality Investigation Search**
```
Find quality investigation reports about flash memory retention issues. What were the root causes?
```
Expected: Uses QUALITY_INVESTIGATION_REPORTS_SEARCH, returns relevant quality reports

**Test 9: Programming Troubleshooting**
```
Search for support tickets about MPLAB programming failures and recommended fixes
```
Expected: Uses SUPPORT_TRANSCRIPTS_SEARCH, finds programming issue resolutions

**Test 10: Design Guidance**
```
What guidance do our application notes provide about motor control FOC implementation?
```
Expected: Uses APPLICATION_NOTES_SEARCH, retrieves motor control procedures

### Step 4.3: Test Combined Queries (Structured + Unstructured)

**Test 11: Product Quality + Support Analysis**
```
Which products have the highest quality issue rates? Search support transcripts for common 
technical issues with those products.
```
Expected: Uses both SV_CUSTOMER_SUPPORT_INTELLIGENCE and SUPPORT_TRANSCRIPTS_SEARCH

**Test 12: Design Win + Technical Guidance**
```
What products are winning automotive designs? Search application notes for automotive-specific 
implementation guidance.
```
Expected: Uses SV_DESIGN_ENGINEERING_INTELLIGENCE and APPLICATION_NOTES_SEARCH

---

## Step 5: Advanced Configuration (Optional)

### 5.1: Add Guardrails

In the **Instructions** section, you can add specific guardrails:
```
Never disclose proprietary product roadmaps or unreleased features.
Always cite data sources (semantic view or Cortex Search service used).
For quality issues, maintain customer confidentiality.
```

### 5.2: Configure Response Formatting

Add formatting preferences to the instructions:
```
For numerical data, use tables or bullet points.
Include time periods for trend analysis.
Highlight critical issues (quality, security) in bold.
Always include relevant product families in responses.
```

---

## Verification Steps

### Verify Semantic Views
```sql
SHOW SEMANTIC VIEWS IN SCHEMA MICROCHIP_INTELLIGENCE.ANALYTICS;
-- Should show 3 semantic views
```

### Verify Cortex Search Services
```sql
SHOW CORTEX SEARCH SERVICES IN SCHEMA MICROCHIP_INTELLIGENCE.RAW;
-- Should show 3 search services
```

### Test Cortex Search Directly
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'MICROCHIP_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
      '{"query": "I2C communication problems", "limit":5}'
  )
)['results'] as results;
```

---

## Troubleshooting

### Agent Not Finding Data
1. Verify permissions on semantic views and search services
2. Check that warehouse is assigned and running
3. Ensure semantic views have data (check row counts)

### Cortex Search Not Working
1. Verify change tracking is enabled on tables
2. Check that search services are in READY state
3. Allow 5-10 minutes for initial indexing after creation

### Slow Response Times
1. Increase warehouse size for data generation
2. Verify Cortex Search indexes have built
3. Check query complexity in Cortex Analyst

---

## Next Steps

1. **Customize Questions**: Add industry-specific questions to the agent
2. **Integrate with Applications**: Use agent via API for custom applications
3. **Monitor Usage**: Track which queries are most common
4. **Expand Data**: Add more product families, customers, or time periods
5. **Enhance Search**: Add more unstructured content (emails, design reviews, etc.)

---

**Version:** 1.0  
**Created:** October 2025  
**Based on:** MedTrainer Intelligence Agent Template  
**Verified:** All syntax verified against Snowflake documentation

**Setup Time Estimate**: 30-45 minutes (including data generation)


