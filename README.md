<img src="Snowflake_Logo.svg" width="200">

# Microchip Intelligence Agent Solution

## About Microchip Technology

Microchip Technology Inc. is a leading provider of smart, connected, and secure embedded control solutions. Their comprehensive product portfolio includes microcontrollers, microprocessors, analog devices, FPGAs, memory, and wireless products serving industries such as automotive, industrial, aerospace, medical, consumer electronics, and IoT applications.

### Key Product Lines

- **Microcontrollers (MCU)**: PIC, AVR, SAM, dsPIC, PIC32 families - 8-bit, 16-bit, and 32-bit architectures
- **Microprocessors (MPU)**: SAMA5, SAM9 families - ARM-based processors for embedded Linux applications
- **FPGAs**: PolarFire, SmartFusion2, RTG4 - programmable logic with security features
- **Analog & Interface**: Op-amps, ADCs, DACs, interface ICs, power management
- **Memory Products**: Serial Flash, EEPROM, parallel flash
- **Wireless Solutions**: Bluetooth, WiFi, LoRa, Sub-GHz connectivity

### Market Position

- Leading provider of 8-bit and 16-bit microcontrollers
- Strong presence in automotive, industrial, and IoT markets
- Comprehensive development tools ecosystem (MPLAB X, XC compilers)
- Extensive technical support and training (Microchip Academy)

## Project Overview

This Snowflake Intelligence solution demonstrates how Microchip can leverage AI agents to analyze:

- **Design Win Intelligence**: Customer design selections, competitive wins, conversion to production
- **Product Performance**: Revenue by family, quality metrics, lifecycle management
- **Sales Analytics**: Revenue trends, distributor performance, geographic analysis
- **Customer Health**: Order patterns, support engagement, retention risk
- **Engineering Support**: Ticket resolution, technical issue patterns, documentation effectiveness
- **Quality Intelligence**: Field failures, RMA analysis, root cause investigations
- **Certification Impact**: Engineer training effectiveness on design win success
- **Unstructured Data Search**: Semantic search over support transcripts, application notes, and quality reports using Cortex Search

## Database Schema

The solution includes:

1. **RAW Schema**: Core business tables
   - CUSTOMERS: OEMs, manufacturers, and distributors
   - DESIGN_ENGINEERS: Engineers at customer companies designing products
   - PRODUCT_CATALOG: Complete Microchip product SKUs and specifications
   - DISTRIBUTORS: Authorized distribution partners (Arrow, Avnet, Digi-Key, etc.)
   - DESIGN_WINS: Customer design selections of Microchip products
   - PRODUCTION_ORDERS: Mass production orders from design wins
   - ORDERS: Product orders through distributors and direct
   - SUPPORT_CONTRACTS: Technical support and service agreements
   - CERTIFICATIONS: Engineer certifications (Microchip Academy, etc.)
   - CERTIFICATION_VERIFICATIONS: Verification records
   - SUPPORT_TICKETS: Customer support cases
   - SUPPORT_ENGINEERS: Microchip technical support staff
   - QUALITY_ISSUES: Field failures, RMAs, defect reports
   - MARKETING_CAMPAIGNS: Product launches, webinars, conferences
   - CUSTOMER_CAMPAIGN_INTERACTIONS: Marketing engagement tracking
   - SUPPORT_TRANSCRIPTS: Unstructured technical support interactions (25K transcripts)
   - APPLICATION_NOTES: Technical application notes and design guides (3 comprehensive notes)
   - QUALITY_INVESTIGATION_REPORTS: Detailed quality investigation documentation (15K reports)

2. **ANALYTICS Schema**: Curated views and semantic models
   - Customer 360 views
   - Design engineer analytics
   - Design win conversion metrics
   - Product performance tracking
   - Distributor effectiveness
   - Revenue analytics
   - Support efficiency metrics
   - Quality issue analysis
   - Certification impact views
   - Semantic views for AI agents

3. **Cortex Search Services**: Semantic search over unstructured data
   - SUPPORT_TRANSCRIPTS_SEARCH: Search 25K technical support interactions
   - APPLICATION_NOTES_SEARCH: Search technical documentation and design guides
   - QUALITY_INVESTIGATION_REPORTS_SEARCH: Search 15K quality investigations

## Files

- `MAPPING_DOCUMENT.md`: Entity mapping from MedTrainer template to Microchip
- `README.md`: This comprehensive solution documentation
- `sql/setup/01_database_and_schema.sql`: Database and schema creation
- `sql/setup/02_create_tables.sql`: Table definitions with proper constraints
- `sql/data/03_generate_synthetic_data.sql`: Realistic semiconductor sample data
- `sql/views/04_create_views.sql`: Analytical views
- `sql/views/05_create_semantic_views.sql`: Semantic views for AI agents (verified syntax)
- `sql/search/06_create_cortex_search.sql`: Unstructured data tables and Cortex Search services
- `docs/questions.md`: 20 complex questions the agent can answer
- `docs/AGENT_SETUP.md`: Complete agent configuration instructions

## Setup Instructions

1. Execute SQL files in order (01 through 06)
   - 01: Database and schema setup
   - 02: Create tables
   - 03: Generate synthetic data (10-20 min)
   - 04: Create analytical views
   - 05: Create semantic views
   - 06: Create Cortex Search services (5-10 min)
2. Follow AGENT_SETUP.md for agent configuration
3. Test with questions from questions.md

## Data Model Highlights

### Structured Data
- Realistic semiconductor business scenarios
- 25K customers across OEM, contract manufacturer, and distributor segments
- 250K design engineers with Microchip certifications
- 30 product SKUs across PIC, AVR, SAM, dsPIC, FPGA, Analog, Memory, Wireless families
- 500K design wins with competitive displacement tracking
- 300K production orders showing design-to-production conversion
- 1M orders through distributors and direct sales channels
- 75K support tickets covering design support, debugging, tools, ordering, RMA
- 25K quality issues with RMA tracking and root cause analysis
- 40K engineer certifications (Microchip Academy, product specialist, design expert)
- 10 major distributors (Arrow, Avnet, Digi-Key, Mouser, etc.)

### Unstructured Data
- 25,000 technical support transcripts with realistic embedded systems troubleshooting
- 3 comprehensive application notes (CIPs, low power, motor control)
- 15,000 quality investigation reports with root cause analysis
- Semantic search powered by Snowflake Cortex Search
- RAG (Retrieval Augmented Generation) ready for AI agents

## Key Features

✅ **Hybrid Data Architecture**: Combines structured tables with unstructured technical content  
✅ **Semantic Search**: Find similar technical issues and solutions by meaning, not keywords  
✅ **RAG-Ready**: Agent can retrieve context from support transcripts and application notes  
✅ **Production-Ready Syntax**: All SQL verified against Snowflake documentation  
✅ **Comprehensive Demo**: 1M+ orders, 500K design wins, 25K support transcripts  
✅ **Verified Syntax**: CREATE SEMANTIC VIEW and CREATE CORTEX SEARCH SERVICE syntax verified against official Snowflake documentation  
✅ **No Duplicate Synonyms**: All semantic view synonyms globally unique across all three views

## Complex Questions Examples

The agent can answer sophisticated questions like:

### Structured Data Analysis (Semantic Views)
1. **Design Win Analysis**: Conversion rates by industry vertical and product family
2. **Competitive Intelligence**: Displacement wins by competitor and revenue impact
3. **Distributor Performance**: Revenue by region, product mix, partnership tier effectiveness
4. **Product Lifecycle**: End-of-life planning and migration impact
5. **Certification Impact**: Correlation between engineer training and design win success
6. **Quality Metrics**: Issue rates by product family, resolution times, customer impact
7. **Revenue Trends**: Month-over-month growth, seasonal patterns, customer segmentation
8. **Cross-Sell Opportunities**: Gap analysis for product upgrades and expansions
9. **Support Efficiency**: Resolution times, escalation rates, product documentation needs
10. **Customer Health**: Retention risk scoring based on order trends, support, quality

### Unstructured Data Search (Cortex Search)
11. **I2C Communication**: Common issues, troubleshooting procedures, successful fixes
12. **Programming Failures**: Error patterns, signal integrity impacts, board layout recommendations
13. **FOC Implementation**: Motor control configuration guidance from application notes
14. **USB Enumeration**: Troubleshooting procedures and design best practices
15. **Flash Retention**: Quality investigation root causes and corrective actions
16. **Low Power Design**: Comprehensive power optimization techniques from app notes
17. **Oscillator Issues**: Multi-source analysis of start-up failures and prevention
18. **ADC Accuracy**: Layout guidance, noise management, reference voltage handling
19. **CAN Bus Errors**: Diagnostic procedures, termination issues, electrical troubleshooting
20. **Package Handling**: MSL procedures, moisture prevention, bake-out recommendations

## Semantic Views

The solution includes three verified semantic views:

1. **SV_DESIGN_ENGINEERING_INTELLIGENCE**: Comprehensive view of customers, engineers, products, design wins, production orders, and certifications
2. **SV_SALES_REVENUE_INTELLIGENCE**: Revenue, orders, distributors, products, and support contracts
3. **SV_CUSTOMER_SUPPORT_INTELLIGENCE**: Support tickets, engineers, customers, products, and satisfaction

All semantic views follow the verified syntax structure:
- TABLES clause with PRIMARY KEY definitions
- RELATIONSHIPS clause defining foreign keys
- DIMENSIONS clause with synonyms and comments
- METRICS clause with aggregations and calculations
- Proper clause ordering (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT)
- **NO DUPLICATE SYNONYMS** - All synonyms globally unique

## Cortex Search Services

Three Cortex Search services enable semantic search over unstructured data:

1. **SUPPORT_TRANSCRIPTS_SEARCH**: Search 25,000 technical support interactions
   - Find similar technical issues by description
   - Retrieve troubleshooting procedures from successful resolutions
   - Analyze support patterns and best practices
   - Searchable attributes: customer_id, support_engineer_id, interaction_type, product_family, issue_category

2. **APPLICATION_NOTES_SEARCH**: Search technical documentation and design guides
   - Retrieve implementation procedures for features (FOC, CIPs, low power)
   - Find configuration guidance and best practices
   - Access technical specifications and design recommendations
   - Searchable attributes: product_family, application_category, title, document_number

3. **QUALITY_INVESTIGATION_REPORTS_SEARCH**: Search 15,000 quality investigations
   - Find similar quality issues and root causes
   - Identify effective corrective actions
   - Retrieve investigation procedures and learnings
   - Searchable attributes: customer_id, product_id, investigation_type, investigation_status

All Cortex Search services use verified syntax:
- ON clause specifying search column
- ATTRIBUTES clause for filterable columns
- WAREHOUSE assignment
- TARGET_LAG for refresh frequency
- AS clause with source query

## Syntax Verification

All SQL syntax has been verified against official Snowflake documentation:

- **CREATE SEMANTIC VIEW**: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
- **CREATE CORTEX SEARCH SERVICE**: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
- **Cortex Search Overview**: https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-overview

Key verification points:
- ✅ Clause order is mandatory (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS)
- ✅ PRIMARY KEY columns verified to exist in source tables
- ✅ No self-referencing or cyclic relationships
- ✅ Semantic expression format: `name AS expression`
- ✅ Change tracking enabled for Cortex Search tables
- ✅ Correct ATTRIBUTES syntax for filterable columns
- ✅ All column references verified against table definitions
- ✅ No duplicate synonyms across all three semantic views

## Getting Started

### Prerequisites
- Snowflake account with Cortex Intelligence enabled
- ACCOUNTADMIN or equivalent privileges
- X-SMALL or larger warehouse

### Quick Start
```sql
-- 1. Create database and schemas
@sql/setup/01_database_and_schema.sql

-- 2. Create tables
@sql/setup/02_create_tables.sql

-- 3. Generate sample data (10-20 minutes)
@sql/data/03_generate_synthetic_data.sql

-- 4. Create analytical views
@sql/views/04_create_views.sql

-- 5. Create semantic views
@sql/views/05_create_semantic_views.sql

-- 6. Create Cortex Search services (5-10 minutes)
@sql/search/06_create_cortex_search.sql
```

### Configure Agent
Follow the detailed instructions in `docs/AGENT_SETUP.md` to:
1. Create the Snowflake Intelligence Agent
2. Add semantic views as data sources (Cortex Analyst)
3. Configure Cortex Search services
4. Set up system prompts and instructions
5. Test with sample questions

## Testing

### Verify Installation
```sql
-- Check semantic views
SHOW SEMANTIC VIEWS IN SCHEMA MICROCHIP_INTELLIGENCE.ANALYTICS;

-- Check Cortex Search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA MICROCHIP_INTELLIGENCE.RAW;

-- Test Cortex Search
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'MICROCHIP_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
      '{"query": "I2C communication problems", "limit":5}'
  )
)['results'] as results;
```

### Sample Test Questions
1. "Which products are winning the most designs in automotive?"
2. "What is our competitive win rate against STMicroelectronics?"
3. "Show me customers at risk of churn based on declining order patterns."
4. "Search support transcripts for USB enumeration failures and recommended solutions."

## Data Volumes

- **Customers**: 25,000
- **Design Engineers**: 250,000
- **Product Catalog**: 30 SKUs with detailed specifications
- **Distributors**: 10 major partners
- **Design Wins**: 500,000
- **Production Orders**: 300,000
- **Orders**: 1,000,000
- **Support Contracts**: 15,000
- **Certifications**: 40,000
- **Support Tickets**: 75,000
- **Quality Issues**: 25,000
- **Support Transcripts**: 25,000 (unstructured)
- **Application Notes**: 3 comprehensive guides
- **Quality Investigation Reports**: 15,000 (unstructured)

## Architecture

<svg width="800" height="600" xmlns="http://www.w3.org/2000/svg">
  <!-- Gradient Definitions -->
  <defs>
    <linearGradient id="agentGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#29B5E8;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#1E88C7;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="analystGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#56C596;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#3EA876;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="searchGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#FF9F40;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#E88330;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="dataGrad" x1="0%" y1="0%" x2="0%" y2="100%">
      <stop offset="0%" style="stop-color:#9D7EC0;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#7D5FA0;stop-opacity:1" />
    </linearGradient>
  </defs>
  
  <!-- Title -->
  <text x="400" y="30" font-family="Arial, sans-serif" font-size="20" font-weight="bold" text-anchor="middle" fill="#333">
    Microchip Intelligence Agent Architecture
  </text>
  
  <!-- Agent Container -->
  <rect x="50" y="60" width="700" height="280" rx="10" fill="url(#agentGrad)" stroke="#1E88C7" stroke-width="3" opacity="0.95"/>
  <text x="400" y="90" font-family="Arial, sans-serif" font-size="18" font-weight="bold" text-anchor="middle" fill="white">
    Snowflake Intelligence Agent
  </text>
  
  <!-- Cortex Analyst Box -->
  <rect x="70" y="110" width="320" height="210" rx="8" fill="url(#analystGrad)" stroke="#3EA876" stroke-width="2"/>
  <text x="230" y="135" font-family="Arial, sans-serif" font-size="14" font-weight="bold" text-anchor="middle" fill="white">
    Cortex Analyst (Semantic Views)
  </text>
  <text x="80" y="160" font-family="Arial, sans-serif" font-size="11" fill="white">
    • SV_DESIGN_ENGINEERING_INTELLIGENCE
  </text>
  <text x="100" y="177" font-family="Arial, sans-serif" font-size="10" fill="#E8F5E9">
    Design wins, products, engineers
  </text>
  <text x="80" y="200" font-family="Arial, sans-serif" font-size="11" fill="white">
    • SV_SALES_REVENUE_INTELLIGENCE
  </text>
  <text x="100" y="217" font-family="Arial, sans-serif" font-size="10" fill="#E8F5E9">
    Orders, revenue, distributors
  </text>
  <text x="80" y="240" font-family="Arial, sans-serif" font-size="11" fill="white">
    • SV_CUSTOMER_SUPPORT_INTELLIGENCE
  </text>
  <text x="100" y="257" font-family="Arial, sans-serif" font-size="10" fill="#E8F5E9">
    Tickets, satisfaction, engineers
  </text>
  <circle cx="230" y="300" r="6" fill="#4CAF50"/>
  <text x="240" y="305" font-family="Arial, sans-serif" font-size="10" fill="white" font-weight="bold">
    Structured Data
  </text>
  
  <!-- Cortex Search Box -->
  <rect x="410" y="110" width="320" height="210" rx="8" fill="url(#searchGrad)" stroke="#E88330" stroke-width="2"/>
  <text x="570" y="135" font-family="Arial, sans-serif" font-size="14" font-weight="bold" text-anchor="middle" fill="white">
    Cortex Search (Unstructured)
  </text>
  <text x="420" y="160" font-family="Arial, sans-serif" font-size="11" fill="white">
    • SUPPORT_TRANSCRIPTS_SEARCH
  </text>
  <text x="440" y="177" font-family="Arial, sans-serif" font-size="10" fill="#FFF3E0">
    25K technical support interactions
  </text>
  <text x="420" y="200" font-family="Arial, sans-serif" font-size="11" fill="white">
    • APPLICATION_NOTES_SEARCH
  </text>
  <text x="440" y="217" font-family="Arial, sans-serif" font-size="10" fill="#FFF3E0">
    Technical design guides
  </text>
  <text x="420" y="240" font-family="Arial, sans-serif" font-size="11" fill="white">
    • QUALITY_INVESTIGATION_REPORTS_SEARCH
  </text>
  <text x="440" y="257" font-family="Arial, sans-serif" font-size="10" fill="#FFF3E0">
    15K quality investigations
  </text>
  <circle cx="570" y="300" r="6" fill="#FF9800"/>
  <text x="580" y="305" font-family="Arial, sans-serif" font-size="10" fill="white" font-weight="bold">
    Semantic Search
  </text>
  
  <!-- Arrows -->
  <path d="M 230 340 L 230 380" stroke="#666" stroke-width="3" fill="none" marker-end="url(#arrowhead)"/>
  <path d="M 570 340 L 570 380" stroke="#666" stroke-width="3" fill="none" marker-end="url(#arrowhead)"/>
  
  <!-- Arrow marker -->
  <defs>
    <marker id="arrowhead" markerWidth="10" markerHeight="10" refX="5" refY="3" orient="auto">
      <polygon points="0 0, 10 3, 0 6" fill="#666"/>
    </marker>
  </defs>
  
  <!-- Data Layer -->
  <rect x="50" y="390" width="700" height="180" rx="10" fill="url(#dataGrad)" stroke="#7D5FA0" stroke-width="3" opacity="0.95"/>
  <text x="400" y="420" font-family="Arial, sans-serif" font-size="18" font-weight="bold" text-anchor="middle" fill="white">
    RAW Schema (Source Data)
  </text>
  
  <!-- Data - Left Column -->
  <text x="70" y="450" font-family="Arial, sans-serif" font-size="11" fill="white">
    📊 Structured Tables:
  </text>
  <text x="80" y="470" font-family="Arial, sans-serif" font-size="10" fill="#E1BEE7">
    • 25K Customers (OEMs, manufacturers)
  </text>
  <text x="80" y="487" font-family="Arial, sans-serif" font-size="10" fill="#E1BEE7">
    • 250K Design Engineers
  </text>
  <text x="80" y="504" font-family="Arial, sans-serif" font-size="10" fill="#E1BEE7">
    • 30 Products (PIC, AVR, SAM, FPGA...)
  </text>
  <text x="80" y="521" font-family="Arial, sans-serif" font-size="10" fill="#E1BEE7">
    • 500K Design Wins
  </text>
  <text x="80" y="538" font-family="Arial, sans-serif" font-size="10" fill="#E1BEE7">
    • 1M Orders, 75K Support Tickets
  </text>
  
  <!-- Data - Right Column -->
  <text x="420" y="450" font-family="Arial, sans-serif" font-size="11" fill="white">
    📄 Unstructured Documents:
  </text>
  <text x="430" y="470" font-family="Arial, sans-serif" font-size="10" fill="#E1BEE7">
    • 25K Support Transcripts
  </text>
  <text x="430" y="487" font-family="Arial, sans-serif" font-size="10" fill="#E1BEE7">
    • 3 Application Notes
  </text>
  <text x="430" y="504" font-family="Arial, sans-serif" font-size="10" fill="#E1BEE7">
    • 15K Quality Investigation Reports
  </text>
  <text x="430" y="530" font-family="Arial, sans-serif" font-size="10" fill="white" font-weight="bold">
    Total: ~2.5M records + 40K documents
  </text>
  
  <!-- Footer Badge -->
  <rect x="280" y="575" width="240" height="20" rx="4" fill="#4CAF50"/>
  <text x="400" y="589" font-family="Arial, sans-serif" font-size="11" font-weight="bold" text-anchor="middle" fill="white">
    ✓ 100% Snowflake-Native Solution
  </text>
</svg>

## Support

For questions or issues:
- Review `docs/AGENT_SETUP.md` for detailed setup instructions
- Check `docs/questions.md` for example questions
- Consult `MAPPING_DOCUMENT.md` for entity mapping details
- Refer to Snowflake documentation for syntax verification
- Contact your Snowflake account team for assistance

## Version History

- **v1.0** (October 2025): Initial release
  - Verified semantic view syntax
  - Verified Cortex Search syntax
  - 25K customers, 250K engineers, 500K design wins, 1M orders
  - 25K support transcripts with semantic search
  - 3 application notes with technical guidance
  - 15K quality investigation reports
  - 20 complex test questions (10 structured + 10 unstructured)
  - Comprehensive documentation

## License

This solution is provided as a template for building Snowflake Intelligence agents. Adapt as needed for your specific use case.

---

**Created**: October 2025  
**Template Based On**: MedTrainer Intelligence Demo  
**Snowflake Documentation**: Syntax verified against official documentation  
**Target Use Case**: Microchip Technology semiconductor business intelligence

**NO GUESSING - ALL SYNTAX VERIFIED** ✅  
**NO DUPLICATE SYNONYMS - ALL GLOBALLY UNIQUE** ✅


