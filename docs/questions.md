<img src="..\Snowflake_Logo.svg" width="200">

# Microchip Intelligence Agent - Complex Questions

These 20 complex questions demonstrate the intelligence agent's ability to analyze Microchip's design wins, product performance, sales revenue, distributor effectiveness, support operations, and quality metrics across multiple dimensions.

---

## 1. Design Win Conversion and Production Ramp Analysis

**Question:** "Analyze design wins by status. Show me total design wins, breakdown by industry vertical (AUTOMOTIVE, INDUSTRIAL, IOT, AEROSPACE, MEDICAL, CONSUMER), conversion rate to production, average time from design win to production start, and which product families have highest conversion rates. Calculate potential revenue from design wins not yet in production."

**Why Complex:**
- Multi-table joins (DESIGN_WINS, CUSTOMERS, PRODUCT_CATALOG, PRODUCTION_ORDERS)
- Status progression analysis
- Time-to-production calculations
- Multi-dimensional breakdown (industry, product family)
- Revenue potential estimation

**Data Sources:** DESIGN_WINS, PRODUCTION_ORDERS, CUSTOMERS, PRODUCT_CATALOG

---

## 2. Competitive Displacement Win Analysis

**Question:** "Analyze competitive displacement wins. Show me total competitive wins by competitor (STMicro, NXP, Renesas, Infineon, TI), which product families are winning against which competitors, estimated revenue value of competitive wins, and which industries show highest competitive success. What is our win rate by product type?"

**Why Complex:**
- Competitive intelligence analysis
- Multi-dimensional segmentation
- Revenue impact calculation
- Win rate analysis by multiple factors
- Competitor-specific patterns

**Data Sources:** DESIGN_WINS, PRODUCT_CATALOG, CUSTOMERS, PRODUCTION_ORDERS

---

## 3. Distributor Performance and Channel Effectiveness

**Question:** "Analyze distributor performance. Show me total revenue by distributor, breakdown by region (NORTH_AMERICA, EMEA, APAC), revenue by product family through each distributor, number of unique customers per distributor, and compare direct sales versus distributor sales. Which distributors are underperforming their partnership tier?"

**Why Complex:**
- Multi-channel analysis
- Geographic segmentation
- Product mix analysis
- Performance benchmarking against tier
- Direct vs. channel comparison

**Data Sources:** DISTRIBUTORS, ORDERS, DESIGN_WINS, PRODUCTION_ORDERS, CUSTOMERS

---

## 4. Product Lifecycle and End-of-Life Planning

**Question:** "Identify products approaching end-of-life requiring migration planning. Show me products in NRND (Not Recommended for New Designs) status, products older than 10 years still generating significant revenue, active design wins using aging products, and recommended replacement products from current portfolio. Calculate migration impact by customer."

**Why Complex:**
- Lifecycle status analysis
- Time-based filtering
- Revenue dependency assessment
- Migration path identification
- Customer impact analysis

**Data Sources:** PRODUCT_CATALOG, DESIGN_WINS, ORDERS, CUSTOMERS

---

## 5. Engineer Certification Impact on Design Win Success

**Question:** "Analyze correlation between engineer certifications and design win success. Show me design win rates for certified versus non-certified engineers, breakdown by certification level (ASSOCIATE, PROFESSIONAL, EXPERT), product family alignment with certification focus, and average design win values. Do certified engineers drive higher-value design wins?"

**Why Complex:**
- Correlation analysis
- Certification level segmentation
- Success rate calculations
- Value analysis
- Multi-dimensional comparison

**Data Sources:** CERTIFICATIONS, DESIGN_ENGINEERS, DESIGN_WINS, PRODUCTION_ORDERS

---

## 6. Quality Issue Impact and Customer Satisfaction

**Question:** "Analyze quality issues and their impact on customer health. Show me total quality issues by severity, breakdown by product family, affected customer count, issue resolution times, customers with recurring quality problems, and correlation between quality issues and support ticket volumes. Which product families have highest quality issue rates?"

**Why Complex:**
- Multi-metric quality analysis
- Impact assessment
- Correlation analysis
- Time-based trending
- Customer health scoring

**Data Sources:** QUALITY_ISSUES, PRODUCT_CATALOG, CUSTOMERS, SUPPORT_TICKETS

---

## 7. Revenue Trend Analysis with Product Portfolio Performance

**Question:** "Analyze revenue trends over past 12 months by product type (MCU, MPU, FPGA, ANALOG, MEMORY, WIRELESS). Show me month-over-month growth rates, seasonal patterns, average order values, unit volume trends, and which product types show strongest growth. Compare revenue by customer segment (OEM, CONTRACT_MANUFACTURER)."

**Why Complex:**
- Time-series analysis (12 months)
- Growth rate calculations (MoM)
- Product portfolio analysis
- Seasonal pattern detection
- Customer segment comparison

**Data Sources:** ORDERS, PRODUCT_CATALOG, CUSTOMERS

---

## 8. Cross-Sell and Up-Sell Opportunity Identification

**Question:** "Identify sales opportunities. Show me customers using only 8-bit MCUs (potential for 32-bit upgrade), customers with FPGA designs but no development tool licenses, OEMs in AUTOMOTIVE vertical without our automotive-qualified products, and customers with high support contract values but low product purchases. Calculate potential revenue for each opportunity type."

**Why Complex:**
- Gap analysis across product portfolio
- Upgrade opportunity identification
- Industry-specific opportunity detection
- Revenue opportunity calculation
- Prioritization by potential value

**Data Sources:** CUSTOMERS, ORDERS, PRODUCT_CATALOG, SUPPORT_CONTRACTS, DESIGN_WINS

---

## 9. Technical Support Efficiency and Product Quality Correlation

**Question:** "Analyze support ticket patterns by product family. Show me average resolution times, ticket volumes by product type, correlation between quality issues and support tickets, products generating highest support load relative to sales volume, and ticket escalation rates. Which products need improved documentation or training?"

**Why Complex:**
- Support efficiency analysis
- Product-level correlation
- Volume-normalized comparison
- Root cause identification
- Resource allocation insights

**Data Sources:** SUPPORT_TICKETS, PRODUCT_CATALOG, QUALITY_ISSUES, ORDERS, APPLICATION_NOTES

---

## 10. Customer Health Score and Retention Risk Assessment

**Question:** "Calculate customer health scores and identify at-risk customers. Show me customers with declining order patterns (3+ month trend), customers with high support ticket to order ratio, customers with unresolved high-severity quality issues, support contract expirations in next 60 days, and customers with no new design wins in 18+ months. Prioritize by lifetime value and calculate potential churn revenue impact."

**Why Complex:**
- Multi-factor health scoring
- Trend analysis (order patterns)
- Risk factor aggregation
- Time-based filtering (expirations, gaps)
- Revenue impact prioritization

**Data Sources:** CUSTOMERS, ORDERS, SUPPORT_TICKETS, QUALITY_ISSUES, SUPPORT_CONTRACTS, DESIGN_WINS

---

## Cortex Search Questions (Unstructured Data)

These questions test the agent's ability to search and retrieve insights from unstructured data using Cortex Search services.

### 11. Common Technical Support Issues - I2C Communication

**Question:** "Search support transcripts for I2C communication problems. What are the most common root causes? What troubleshooting steps do our engineers recommend? What are the successful resolution patterns?"

**Why Complex:**
- Semantic search over technical support text
- Root cause pattern extraction
- Procedure identification
- Success factor analysis

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 12. Programming and Debug Tool Issues

**Question:** "Find support transcripts about MPLAB programming failures. What error messages are most common? What are the recommended solutions? How do signal integrity and board layout affect programming reliability?"

**Why Complex:**
- Technical issue pattern recognition
- Error message correlation
- Solution procedure extraction
- Hardware design impact analysis

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 13. Motor Control Implementation Guidance

**Question:** "What does our application note library say about Field Oriented Control (FOC) implementation on dsPIC33? Provide details on PWM configuration, current sampling, and PI controller tuning."

**Why Complex:**
- Technical procedure retrieval
- Multi-topic synthesis (PWM, ADC, control theory)
- Configuration guidance extraction
- Best practices identification

**Data Source:** APPLICATION_NOTES_SEARCH

---

### 14. USB Communication Troubleshooting

**Question:** "Search support transcripts for USB enumeration failures. What are the common causes? How do engineers troubleshoot signal integrity issues? What board design recommendations are most effective?"

**Why Complex:**
- Failure mode analysis
- Troubleshooting procedure extraction
- Design recommendation synthesis
- Success pattern identification

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 15. Flash Memory Retention Quality Analysis

**Question:** "Find quality investigation reports about flash memory retention issues. What were the root causes? What process controls were implemented? How were affected customers supported?"

**Why Complex:**
- Quality pattern analysis
- Root cause identification
- Corrective action extraction
- Customer support procedure review

**Data Source:** QUALITY_INVESTIGATION_REPORTS_SEARCH

---

### 16. Low Power Design Techniques

**Question:** "What low power techniques are recommended in our application notes for SAM D21? Provide specific guidance on standby modes, peripheral configuration, and event system usage to minimize power consumption."

**Why Complex:**
- Multi-technique synthesis
- Configuration procedure extraction
- Power optimization strategy assembly
- Detailed implementation guidance

**Data Source:** APPLICATION_NOTES_SEARCH

---

### 17. Crystal Oscillator Start-up Problems

**Question:** "Search quality investigation reports and support transcripts for crystal oscillator start-up failures. What are the root causes? What crystal specifications should be recommended? What board layout practices prevent start-up issues?"

**Why Complex:**
- Multi-source search (quality + support)
- Technical failure analysis
- Design specification synthesis
- Prevention strategy identification

**Data Sources:** QUALITY_INVESTIGATION_REPORTS_SEARCH, SUPPORT_TRANSCRIPTS_SEARCH

---

### 18. ADC Design Best Practices

**Question:** "What guidance do our application notes provide about achieving high ADC accuracy? What are the board layout recommendations? How do we recommend handling reference voltage and power supply noise?"

**Why Complex:**
- Multi-topic technical guidance
- Layout best practices extraction
- Noise management techniques
- Comprehensive design procedure

**Data Source:** APPLICATION_NOTES_SEARCH

---

### 19. CAN Bus Communication Issues

**Question:** "Find support transcripts about CAN bus off errors and communication failures. What are the common causes (termination, bit timing, electrical)? What diagnostic procedures do engineers use? What are the successful fixes?"

**Why Complex:**
- Multi-cause analysis
- Diagnostic procedure extraction
- Electrical troubleshooting synthesis
- Solution effectiveness evaluation

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 20. Package Moisture Sensitivity Handling

**Question:** "Search quality reports for moisture-induced package failures. What MSL (Moisture Sensitivity Level) handling procedures prevent failures? What bake-out procedures are recommended? What customer training is provided?"

**Why Complex:**
- Quality issue pattern analysis
- Procedure extraction (handling, bake-out)
- Prevention strategy identification
- Customer education synthesis

**Data Source:** QUALITY_INVESTIGATION_REPORTS_SEARCH

---

## Question Complexity Summary

These questions test the agent's ability to:

1. **Multi-table joins** - connecting customers, engineers, products, design wins, orders, support, quality
2. **Temporal analysis** - revenue trends, time-to-production, lifecycle tracking
3. **Segmentation & classification** - industry verticals, product families, customer segments
4. **Derived metrics** - conversion rates, win rates, growth calculations, health scores
5. **Competitive intelligence** - displacement analysis, win rate by competitor
6. **Performance benchmarking** - distributor performance, product quality metrics
7. **Correlation analysis** - certifications vs. success, quality vs. support, order trends
8. **Opportunity identification** - cross-sell, up-sell, migration needs
9. **Risk assessment** - customer churn, quality impact, contract expiration
10. **Quality metrics** - issue resolution, satisfaction ratings, defect rates
11. **Semantic search** - technical problem pattern recognition in unstructured data
12. **Technical synthesis** - combining design guidance, troubleshooting procedures, best practices
13. **Root cause analysis** - quality investigations, support escalations
14. **Design guidance extraction** - application notes, reference designs, configuration procedures

These questions reflect realistic business intelligence needs for Microchip's semiconductor design, sales, support, and quality operations.

---

---

## ML Prediction Questions (If ML Models Added)

These questions require the optional ML procedures (PREDICT_REVENUE, PREDICT_CUSTOMER_CHURN, PREDICT_DESIGN_WIN_CONVERSION).

### 21. Revenue Forecasting

**Question:** "Forecast revenue for the next 6 months using the revenue predictor model"

**Why Complex:**
- Calls ML model from Model Registry
- Time-series forecasting with regression
- Returns future predictions

**Tool Used:** PREDICT_REVENUE procedure

---

### 22. Customer Churn Prediction

**Question:** "Which customers are predicted to churn according to the churn prediction model? Focus on OEM customers."

**Why Complex:**
- ML classification model
- Multi-factor churn analysis
- Segment-specific filtering

**Tool Used:** PREDICT_CUSTOMER_CHURN procedure

---

### 23. Design Win Conversion Prediction

**Question:** "Use the conversion predictor to identify which PIC family design wins are most likely to go to production"

**Why Complex:**
- ML probability prediction
- Product family filtering
- Conversion likelihood ranking

**Tool Used:** PREDICT_DESIGN_WIN_CONVERSION procedure

---

### 24. Combined ML and Analytics

**Question:** "Forecast revenue for next quarter, then identify which customers are at churn risk and analyze if there's correlation with design win activity"

**Why Complex:**
- Multiple ML model calls
- Correlation analysis
- Cross-functional insights

**Tools Used:** PREDICT_REVENUE + PREDICT_CUSTOMER_CHURN + SV_DESIGN_ENGINEERING_INTELLIGENCE

---

### 25. ML Prediction with Visualization

**Question:** "Forecast revenue for the next 12 months and show the agent's built-in visualization"

**Why Complex:**
- ML forecasting
- Data visualization request
- Time-series chart display

**Tools Used:** PREDICT_REVENUE + agent's built-in data_to_chart

---

**Version:** 1.0  
**Created:** October 2025  
**Updated:** Added ML prediction questions (optional)  
**Based on:** MedTrainer Intelligence Template  
**Target Use Case:** Microchip Technology semiconductor business intelligence


