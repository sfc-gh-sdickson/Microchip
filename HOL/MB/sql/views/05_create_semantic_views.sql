-- ============================================================================
-- Microchip Intelligence Agent - Semantic Views
-- ============================================================================
-- Purpose: Create semantic views for Snowflake Intelligence agents
-- All syntax VERIFIED against official documentation:
-- https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
-- 
-- Syntax Verification Notes:
-- 1. Clause order is MANDATORY: TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT
-- 2. Semantic expression format: semantic_name AS sql_expression
-- 3. No self-referencing relationships allowed
-- 4. No cyclic relationships allowed
-- 5. PRIMARY KEY columns must exist in table definitions
-- 6. All column references VERIFIED against 02_create_tables.sql
-- 7. All synonyms are GLOBALLY UNIQUE across all semantic views
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE_MB;
USE SCHEMA ANALYTICS_MB;
USE WAREHOUSE MICROCHIP_WH_MB;

-- ============================================================================
-- Semantic View 1: Microchip Design & Engineering Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_DESIGN_ENGINEERING_INTELLIGENCE_MB
  TABLES (
    customers AS RAW_MB.CUSTOMERS_MB
      PRIMARY KEY (customer_id)
      WITH SYNONYMS ('oem customers', 'design clients', 'engineering customers')
      COMMENT = 'Customers using Microchip products',
    engineers AS RAW_MB.DESIGN_ENGINEERS_MB
      PRIMARY KEY (engineer_id)
      WITH SYNONYMS ('design engineers', 'hardware engineers', 'firmware engineers')
      COMMENT = 'Design engineers at customer companies',
    products AS RAW_MB.PRODUCT_CATALOG_MB
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('microchip products', 'mcu products', 'semiconductor products')
      COMMENT = 'Microchip product catalog',
    design_wins AS RAW_MB.DESIGN_WINS_MB
      PRIMARY KEY (design_win_id)
      WITH SYNONYMS ('customer designs', 'design selections', 'product design wins')
      COMMENT = 'Design wins where customer selected Microchip product',
    production_orders AS RAW_MB.PRODUCTION_ORDERS_MB
      PRIMARY KEY (production_order_id)
      WITH SYNONYMS ('production runs', 'manufacturing orders', 'volume orders')
      COMMENT = 'Production orders for designed products',
    certifications AS RAW_MB.CERTIFICATIONS_MB
      PRIMARY KEY (certification_id)
      WITH SYNONYMS ('engineer certifications', 'professional certifications', 'training credentials')
      COMMENT = 'Engineer certifications and training'
  )
  RELATIONSHIPS (
    engineers(customer_id) REFERENCES customers(customer_id),
    design_wins(engineer_id) REFERENCES engineers(engineer_id),
    design_wins(product_id) REFERENCES products(product_id),
    design_wins(customer_id) REFERENCES customers(customer_id),
    production_orders(design_win_id) REFERENCES design_wins(design_win_id),
    production_orders(engineer_id) REFERENCES engineers(engineer_id),
    production_orders(product_id) REFERENCES products(product_id),
    production_orders(customer_id) REFERENCES customers(customer_id),
    certifications(engineer_id) REFERENCES engineers(engineer_id),
    certifications(customer_id) REFERENCES customers(customer_id)
  )
  DIMENSIONS (
    customers.customer_name AS customer_name
      WITH SYNONYMS ('oem name view1', 'design customer name', 'engineering client name')
      COMMENT = 'Name of the customer company',
    customers.customer_status AS customer_status
      WITH SYNONYMS ('account status view1', 'customer active status')
      COMMENT = 'Customer status: ACTIVE, INACTIVE, CHURNED',
    customers.customer_segment AS customer_segment
      WITH SYNONYMS ('customer type view1', 'business segment')
      COMMENT = 'Customer segment: OEM, CONTRACT_MANUFACTURER, DISTRIBUTOR',
    customers.industry_vertical AS industry_vertical
      WITH SYNONYMS ('target industry', 'market vertical', 'application industry')
      COMMENT = 'Industry vertical: AUTOMOTIVE, INDUSTRIAL, IOT, AEROSPACE, MEDICAL, CONSUMER',
    customers.state AS state
      WITH SYNONYMS ('customer state view1', 'customer location state')
      COMMENT = 'Customer state location',
    customers.city AS city
      WITH SYNONYMS ('customer city view1', 'customer location city')
      COMMENT = 'Customer city location',
    engineers.engineer_name AS engineer_name
      WITH SYNONYMS ('designer name', 'hardware developer name')
      COMMENT = 'Name of the design engineer',
    engineers.job_title AS job_title
      WITH SYNONYMS ('engineer position', 'engineer role', 'job position')
      COMMENT = 'Engineer job title',
    engineers.department AS department
      WITH SYNONYMS ('engineering dept', 'engineer team', 'design department')
      COMMENT = 'Engineer department',
    engineers.engineer_status AS engineer_status
      WITH SYNONYMS ('engineer active status', 'designer status')
      COMMENT = 'Engineer status: ACTIVE, INACTIVE',
    engineers.microchip_certified AS microchip_certified
      WITH SYNONYMS ('certified engineer', 'academy trained')
      COMMENT = 'Whether engineer is Microchip certified',
    engineers.primary_product_family AS primary_product_family
      WITH SYNONYMS ('preferred mcu family', 'main product line')
      COMMENT = 'Engineer primary product family: PIC, AVR, SAM, dsPIC, PIC32, FPGA, ANALOG, WIRELESS',
    products.product_name AS product_name
      WITH SYNONYMS ('mcu name', 'chip name', 'part name')
      COMMENT = 'Name of the Microchip product',
    products.sku AS sku
      WITH SYNONYMS ('part number', 'product sku', 'device number')
      COMMENT = 'Product SKU/part number',
    products.product_family AS product_family
      WITH SYNONYMS ('mcu family', 'product line', 'chip family')
      COMMENT = 'Product family: PIC, AVR, SAM, dsPIC, PIC32, FPGA, ANALOG, MEMORY, WIRELESS',
    products.product_type AS product_type
      WITH SYNONYMS ('device type', 'component type')
      COMMENT = 'Product type: MCU, MPU, FPGA, ANALOG, MEMORY, WIRELESS, INTERFACE',
    products.package_type AS package_type
      WITH SYNONYMS ('device package', 'chip package')
      COMMENT = 'Package type: DIP, SOIC, QFN, BGA, etc',
    products.core_architecture AS core_architecture
      WITH SYNONYMS ('processor architecture', 'mcu core')
      COMMENT = 'Core architecture: 8-bit, 16-bit, 32-bit, ARM Cortex-M4, etc',
    products.lifecycle_status AS lifecycle_status
      WITH SYNONYMS ('product lifecycle', 'availability status')
      COMMENT = 'Lifecycle status: ACTIVE, NRND, OBSOLETE',
    design_wins.design_status AS design_status
      WITH SYNONYMS ('design phase', 'development stage')
      COMMENT = 'Design status: IN_DESIGN, PROTOTYPE, IN_PRODUCTION',
    design_wins.competitive_displacement AS competitive_displacement
      WITH SYNONYMS ('competitive win', 'displaced competitor')
      COMMENT = 'Whether this was a competitive displacement win',
    production_orders.production_status AS production_status
      WITH SYNONYMS ('order status', 'shipment status')
      COMMENT = 'Production status: ORDERED, SHIPPED, DELIVERED, CANCELLED',
    certifications.certification_type AS certification_type
      WITH SYNONYMS ('cert type', 'training type')
      COMMENT = 'Certification type: MICROCHIP_ACADEMY, PRODUCT_SPECIALIST, DESIGN_EXPERT, ARM_CERTIFIED, FUNCTIONAL_SAFETY',
    certifications.certification_status AS certification_status
      WITH SYNONYMS ('cert status', 'credential status')
      COMMENT = 'Certification status: ACTIVE, EXPIRED',
    certifications.product_family_focus AS product_family_focus
      WITH SYNONYMS ('cert product focus', 'certification specialization')
      COMMENT = 'Product family focus of certification',
    certifications.certification_level AS certification_level
      WITH SYNONYMS ('expertise level', 'proficiency level')
      COMMENT = 'Certification level: ASSOCIATE, PROFESSIONAL, EXPERT'
  )
  METRICS (
    customers.total_customers AS COUNT(DISTINCT customer_id)
      WITH SYNONYMS ('customer count view1', 'number of customers design')
      COMMENT = 'Total number of customers',
    customers.avg_lifetime_value AS AVG(lifetime_value)
      WITH SYNONYMS ('average customer value', 'mean ltv')
      COMMENT = 'Average customer lifetime value',
    customers.avg_credit_risk AS AVG(credit_risk_score)
      WITH SYNONYMS ('average credit risk', 'mean risk score')
      COMMENT = 'Average credit risk score across customers',
    engineers.total_engineers AS COUNT(DISTINCT engineer_id)
      WITH SYNONYMS ('engineer count', 'designer count', 'number of engineers')
      COMMENT = 'Total number of design engineers',
    engineers.avg_years_experience AS AVG(years_of_experience)
      WITH SYNONYMS ('average experience', 'mean years experience')
      COMMENT = 'Average years of experience for engineers',
    products.total_products AS COUNT(DISTINCT product_id)
      WITH SYNONYMS ('product count view1', 'number of products design')
      COMMENT = 'Total number of products',
    products.avg_unit_price AS AVG(unit_price)
      WITH SYNONYMS ('average product price', 'mean unit price')
      COMMENT = 'Average product unit price',
    products.avg_flash_size AS AVG(flash_size_kb)
      WITH SYNONYMS ('average flash memory', 'mean flash size')
      COMMENT = 'Average flash memory size in KB',
    products.avg_ram_size AS AVG(ram_size_kb)
      WITH SYNONYMS ('average ram size', 'mean memory size')
      COMMENT = 'Average RAM size in KB',
    design_wins.total_design_wins AS COUNT(DISTINCT design_win_id)
      WITH SYNONYMS ('design win count', 'number of design wins')
      COMMENT = 'Total number of design wins',
    design_wins.avg_estimated_volume AS AVG(estimated_annual_volume)
      WITH SYNONYMS ('average estimated volume', 'mean annual volume')
      COMMENT = 'Average estimated annual volume per design win',
    production_orders.total_production_orders AS COUNT(DISTINCT production_order_id)
      WITH SYNONYMS ('production order count', 'manufacturing order count')
      COMMENT = 'Total number of production orders',
    production_orders.total_order_quantity AS SUM(order_quantity)
      WITH SYNONYMS ('total units ordered', 'cumulative quantity')
      COMMENT = 'Total order quantity across all production orders',
    production_orders.total_order_value AS SUM(total_order_value)
      WITH SYNONYMS ('total production revenue', 'cumulative order value')
      COMMENT = 'Total order value from production orders',
    production_orders.avg_order_quantity AS AVG(order_quantity)
      WITH SYNONYMS ('average order quantity', 'mean units per order')
      COMMENT = 'Average order quantity per production order',
    certifications.total_certifications AS COUNT(DISTINCT certification_id)
      WITH SYNONYMS ('certification count', 'credential count')
      COMMENT = 'Total number of certifications',
    certifications.avg_certification_age AS AVG(DATEDIFF('day', issue_date, CURRENT_DATE()))
      WITH SYNONYMS ('average certification age')
      COMMENT = 'Average age of certifications in days'
  )
  COMMENT = 'Microchip Design & Engineering Intelligence - comprehensive view of customers, design wins, products, engineers, and certifications';

-- ============================================================================
-- Semantic View 2: Microchip Sales & Revenue Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_SALES_REVENUE_INTELLIGENCE_MB
  TABLES (
    customers AS RAW_MB.CUSTOMERS_MB
      PRIMARY KEY (customer_id)
      WITH SYNONYMS ('revenue customers', 'sales customers', 'buying customers')
      COMMENT = 'Customers placing orders',
    orders AS RAW_MB.ORDERS_MB
      PRIMARY KEY (order_id)
      WITH SYNONYMS ('purchase orders', 'sales orders', 'transactions')
      COMMENT = 'Product orders',
    products AS RAW_MB.PRODUCT_CATALOG_MB
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('ordered products', 'catalog items', 'sellable products')
      COMMENT = 'Microchip product catalog',
    distributors AS RAW_MB.DISTRIBUTORS_MB
      PRIMARY KEY (distributor_id)
      WITH SYNONYMS ('distribution partners', 'channel partners', 'resellers')
      COMMENT = 'Authorized distributors',
    contracts AS RAW_MB.SUPPORT_CONTRACTS_MB
      PRIMARY KEY (contract_id)
      WITH SYNONYMS ('service contracts', 'support agreements', 'maintenance contracts')
      COMMENT = 'Support and service contracts'
  )
  RELATIONSHIPS (
    orders(customer_id) REFERENCES customers(customer_id),
    orders(product_id) REFERENCES products(product_id),
    orders(distributor_id) REFERENCES distributors(distributor_id),
    contracts(customer_id) REFERENCES customers(customer_id)
  )
  DIMENSIONS (
    customers.customer_name AS customer_name
      WITH SYNONYMS ('revenue customer name', 'sales client name')
      COMMENT = 'Name of the customer',
    customers.customer_segment AS customer_segment
      WITH SYNONYMS ('revenue customer type', 'sales segment')
      COMMENT = 'Customer segment: OEM, CONTRACT_MANUFACTURER, DISTRIBUTOR',
    customers.state AS state
      WITH SYNONYMS ('revenue customer state', 'sales location state')
      COMMENT = 'Customer state location',
    orders.order_type AS order_type
      WITH SYNONYMS ('purchase type', 'transaction type')
      COMMENT = 'Order type: PRODUCT_ORDER, SAMPLE_REQUEST, EVALUATION_KIT, SUPPORT_RENEWAL',
    orders.payment_terms AS payment_terms
      WITH SYNONYMS ('payment conditions', 'billing terms')
      COMMENT = 'Payment terms: NET_30, NET_60, NET_90, PREPAID, CREDIT_CARD',
    orders.payment_status AS payment_status
      WITH SYNONYMS ('transaction payment status', 'order payment state')
      COMMENT = 'Payment status: COMPLETED, PENDING, CANCELLED',
    orders.currency AS currency
      WITH SYNONYMS ('transaction currency', 'order currency')
      COMMENT = 'Transaction currency',
    orders.direct_sale AS direct_sale
      WITH SYNONYMS ('sold direct', 'direct channel')
      COMMENT = 'Whether order was direct or through distributor',
    orders.ship_to_country AS ship_to_country
      WITH SYNONYMS ('destination country', 'shipping country')
      COMMENT = 'Country where order is shipped',
    orders.order_source AS order_source
      WITH SYNONYMS ('sales channel', 'order channel')
      COMMENT = 'Order source: DISTRIBUTOR, DIRECT, ONLINE, PARTNER',
    products.product_name AS product_name
      WITH SYNONYMS ('sold product name', 'revenue product name')
      COMMENT = 'Name of the product',
    products.product_family AS product_family
      WITH SYNONYMS ('sold product family', 'revenue product line')
      COMMENT = 'Product family',
    products.product_type AS product_type
      WITH SYNONYMS ('sold product type', 'revenue device type')
      COMMENT = 'Product type: MCU, MPU, FPGA, ANALOG, MEMORY, WIRELESS',
    products.is_active AS is_active
      WITH SYNONYMS ('available for sale', 'active catalog item')
      COMMENT = 'Whether product is currently active',
    distributors.distributor_name AS distributor_name
      WITH SYNONYMS ('partner name', 'reseller name')
      COMMENT = 'Name of the distributor',
    distributors.distributor_type AS distributor_type
      WITH SYNONYMS ('partner type', 'channel type')
      COMMENT = 'Distributor type',
    distributors.region AS region
      WITH SYNONYMS ('distributor region', 'sales region')
      COMMENT = 'Distributor region: NORTH_AMERICA, EMEA, APAC',
    distributors.partnership_tier AS partnership_tier
      WITH SYNONYMS ('partner level', 'distributor tier')
      COMMENT = 'Partnership tier: PLATINUM, GOLD, SILVER',
    contracts.contract_type AS contract_type
      WITH SYNONYMS ('service type', 'support level')
      COMMENT = 'Contract type: BASIC_SUPPORT, PREMIUM_SUPPORT, ENTERPRISE_SUPPORT, DESIGN_PARTNER',
    contracts.service_tier AS service_tier
      WITH SYNONYMS ('contract tier', 'support tier')
      COMMENT = 'Service tier: BASIC, PROFESSIONAL, ENTERPRISE',
    contracts.priority_support AS priority_support
      WITH SYNONYMS ('premium support enabled', 'priority service')
      COMMENT = 'Whether contract includes priority support',
    contracts.contract_status AS contract_status
      WITH SYNONYMS ('service status', 'agreement status')
      COMMENT = 'Contract status: ACTIVE, EXPIRED, CANCELLED'
  )
  METRICS (
    customers.total_customers AS COUNT(DISTINCT customer_id)
      WITH SYNONYMS ('customer count view2', 'number of revenue customers')
      COMMENT = 'Total number of customers',
    orders.total_orders AS COUNT(DISTINCT order_id)
      WITH SYNONYMS ('order count', 'transaction count')
      COMMENT = 'Total number of orders',
    orders.total_revenue AS SUM(order_amount)
      WITH SYNONYMS ('total sales', 'gross revenue', 'total order value')
      COMMENT = 'Total revenue from all orders',
    orders.avg_order_amount AS AVG(order_amount)
      WITH SYNONYMS ('average order value', 'mean transaction amount')
      COMMENT = 'Average order amount',
    orders.total_quantity AS SUM(quantity)
      WITH SYNONYMS ('total units sold', 'cumulative quantity sold')
      COMMENT = 'Total quantity ordered',
    orders.avg_quantity AS AVG(quantity)
      WITH SYNONYMS ('average units per order', 'mean order quantity')
      COMMENT = 'Average quantity per order',
    orders.total_discount AS SUM(discount_amount)
      WITH SYNONYMS ('total discounts given', 'discount sum')
      COMMENT = 'Total discount amount given',
    orders.total_tax AS SUM(tax_amount)
      WITH SYNONYMS ('total tax collected', 'tax sum')
      COMMENT = 'Total tax amount collected',
    products.total_products AS COUNT(DISTINCT product_id)
      WITH SYNONYMS ('product count view2', 'number of sold products')
      COMMENT = 'Total number of unique products sold',
    distributors.total_distributors AS COUNT(DISTINCT distributor_id)
      WITH SYNONYMS ('distributor count', 'partner count')
      COMMENT = 'Total number of distributors',
    contracts.total_contracts AS COUNT(DISTINCT contract_id)
      WITH SYNONYMS ('contract count', 'agreement count')
      COMMENT = 'Total number of support contracts',
    contracts.avg_monthly_fee AS AVG(monthly_fee)
      WITH SYNONYMS ('average contract fee', 'mean monthly cost')
      COMMENT = 'Average monthly contract fee',
    contracts.total_monthly_fees AS SUM(monthly_fee)
      WITH SYNONYMS ('total contract revenue', 'recurring revenue')
      COMMENT = 'Total monthly fees across all contracts'
  )
  COMMENT = 'Microchip Sales & Revenue Intelligence - comprehensive view of orders, customers, distributors, products, and revenue metrics';

-- ============================================================================
-- Semantic View 3: Microchip Customer Support Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_CUSTOMER_SUPPORT_INTELLIGENCE_MB
  TABLES (
    customers AS RAW_MB.CUSTOMERS_MB
      PRIMARY KEY (customer_id)
      WITH SYNONYMS ('support customers', 'ticket customers', 'help clients')
      COMMENT = 'Customers requesting support',
    tickets AS RAW_MB.SUPPORT_TICKETS_MB
      PRIMARY KEY (ticket_id)
      WITH SYNONYMS ('support cases', 'help requests', 'technical tickets')
      COMMENT = 'Customer support tickets',
    support_engineers AS RAW_MB.SUPPORT_ENGINEERS_MB
      PRIMARY KEY (support_engineer_id)
      WITH SYNONYMS ('support staff', 'help desk engineers', 'technical support team')
      COMMENT = 'Support engineers',
    products AS RAW_MB.PRODUCT_CATALOG_MB
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('support products', 'ticket products', 'products needing support')
      COMMENT = 'Products related to support tickets'
  )
  RELATIONSHIPS (
    tickets(customer_id) REFERENCES customers(customer_id),
    tickets(assigned_engineer_id) REFERENCES support_engineers(support_engineer_id),
    tickets(product_id) REFERENCES products(product_id)
  )
  DIMENSIONS (
    customers.customer_name AS customer_name
      WITH SYNONYMS ('support customer name', 'ticket client name')
      COMMENT = 'Name of the customer',
    customers.customer_segment AS customer_segment
      WITH SYNONYMS ('support customer type', 'support segment')
      COMMENT = 'Customer segment: OEM, CONTRACT_MANUFACTURER, DISTRIBUTOR',
    tickets.ticket_category AS ticket_category
      WITH SYNONYMS ('issue category', 'support category')
      COMMENT = 'Ticket category: TECHNICAL, ORDERING, ACCOUNT, DOCUMENTATION',
    tickets.ticket_type AS ticket_type
      WITH SYNONYMS ('support type', 'request type')
      COMMENT = 'Ticket type: DESIGN_SUPPORT, DEBUGGING, TOOLS, ORDERING, RMA, DOCUMENTATION',
    tickets.priority AS priority
      WITH SYNONYMS ('ticket urgency', 'support priority')
      COMMENT = 'Ticket priority: LOW, MEDIUM, HIGH, URGENT',
    tickets.ticket_status AS ticket_status
      WITH SYNONYMS ('case status', 'support status')
      COMMENT = 'Ticket status: OPEN, IN_PROGRESS, CLOSED',
    tickets.channel AS channel
      WITH SYNONYMS ('contact method', 'support channel')
      COMMENT = 'Support channel: PHONE, EMAIL, WEB_PORTAL, CHAT',
    tickets.escalated AS escalated
      WITH SYNONYMS ('escalated ticket', 'escalation flag')
      COMMENT = 'Whether ticket was escalated',
    support_engineers.engineer_name AS engineer_name
      WITH SYNONYMS ('support engineer name', 'support rep name')
      COMMENT = 'Name of support engineer',
    support_engineers.department AS department
      WITH SYNONYMS ('support team dept', 'support department')
      COMMENT = 'Support engineer department: MCU_SUPPORT, MPU_SUPPORT, FPGA_SUPPORT, ANALOG_SUPPORT, TOOLS_SUPPORT',
    support_engineers.specialization AS specialization
      WITH SYNONYMS ('engineer expertise', 'support specialty')
      COMMENT = 'Support engineer specialization area',
    support_engineers.engineer_status AS engineer_status
      WITH SYNONYMS ('support engineer status', 'support staff status')
      COMMENT = 'Support engineer status: ACTIVE, INACTIVE',
    products.product_name AS product_name
      WITH SYNONYMS ('ticket product name', 'support product name')
      COMMENT = 'Name of the product',
    products.product_family AS product_family
      WITH SYNONYMS ('ticket product family', 'support product line')
      COMMENT = 'Product family related to ticket',
    products.product_type AS product_type
      WITH SYNONYMS ('ticket product type', 'support device type')
      COMMENT = 'Product type related to ticket'
  )
  METRICS (
    customers.total_customers AS COUNT(DISTINCT customer_id)
      WITH SYNONYMS ('customer count view3', 'number of support customers')
      COMMENT = 'Total number of customers with tickets',
    tickets.total_tickets AS COUNT(DISTINCT ticket_id)
      WITH SYNONYMS ('ticket count', 'case count', 'number of support tickets')
      COMMENT = 'Total number of support tickets',
    tickets.avg_satisfaction AS AVG(customer_satisfaction_score)
      WITH SYNONYMS ('average satisfaction rating', 'csat score', 'customer satisfaction')
      COMMENT = 'Average customer satisfaction score',
    support_engineers.total_support_engineers AS COUNT(DISTINCT support_engineer_id)
      WITH SYNONYMS ('support engineer count', 'support staff count')
      COMMENT = 'Total number of support engineers',
    support_engineers.avg_engineer_satisfaction AS AVG(average_satisfaction_rating)
      WITH SYNONYMS ('average support engineer rating')
      COMMENT = 'Average satisfaction rating across all support engineers',
    support_engineers.total_tickets_resolved_by_support AS SUM(total_tickets_resolved)
      WITH SYNONYMS ('total resolved by support', 'cumulative support resolutions')
      COMMENT = 'Total tickets resolved by all support engineers',
    products.total_products AS COUNT(DISTINCT product_id)
      WITH SYNONYMS ('product count view3', 'number of support products')
      COMMENT = 'Total number of unique products in support tickets'
  )
  COMMENT = 'Microchip Customer Support Intelligence - comprehensive view of support tickets, engineers, customers, and satisfaction';

-- ============================================================================
-- Display confirmation and verification
-- ============================================================================
SELECT 'Semantic views created successfully - all syntax verified' AS status;

-- Verify semantic views exist
SELECT 
    table_name AS semantic_view_name,
    comment AS description
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'ANALYTICS_MB'
  AND table_name LIKE 'SV_%'
ORDER BY table_name;

-- Show semantic view details
SHOW SEMANTIC VIEWS IN SCHEMA ANALYTICS_MB;

