-- ============================================================================
-- Microchip Intelligence Agent - Synthetic Data Generation
-- ============================================================================
-- Purpose: Generate realistic sample data for Microchip business operations
-- Volume: ~25K customers, 250K engineers, 500K design wins, 1M orders
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE_VP;
USE SCHEMA RAW_VP;
USE WAREHOUSE MICROCHIP_WH_VP;

-- ============================================================================
-- Step 1: Generate Distributors
-- ============================================================================
INSERT INTO DISTRIBUTORS_VP VALUES
('DIST001', 'Arrow Electronics', 'AUTHORIZED', 'sales@arrow.com', '+1-303-824-4000', 'USA', 'NORTH_AMERICA', 'ACTIVE', 'PLATINUM', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST002', 'Avnet', 'AUTHORIZED', 'sales@avnet.com', '+1-480-643-2000', 'USA', 'NORTH_AMERICA', 'ACTIVE', 'PLATINUM', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST003', 'Digi-Key Electronics', 'AUTHORIZED', 'sales@digikey.com', '+1-800-344-4539', 'USA', 'NORTH_AMERICA', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST004', 'Mouser Electronics', 'AUTHORIZED', 'sales@mouser.com', '+1-817-804-3800', 'USA', 'NORTH_AMERICA', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST005', 'Future Electronics', 'AUTHORIZED', 'sales@futureelectronics.com', '+1-514-694-7710', 'CANADA', 'NORTH_AMERICA', 'ACTIVE', 'SILVER', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST006', 'RS Components', 'AUTHORIZED', 'sales@rs-components.com', '+44-1536-201201', 'UK', 'EMEA', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST007', 'Farnell', 'AUTHORIZED', 'sales@farnell.com', '+44-113-263-6311', 'UK', 'EMEA', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST008', 'WPG Holdings', 'AUTHORIZED', 'sales@wpgholdings.com', '+886-2-2788-5200', 'TAIWAN', 'APAC', 'ACTIVE', 'PLATINUM', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST009', 'Chip One Stop', 'AUTHORIZED', 'sales@chip1stop.com', '+81-45-470-8771', 'JAPAN', 'APAC', 'ACTIVE', 'SILVER', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('DIST010', 'Macnica', 'AUTHORIZED', 'sales@macnica.com', '+81-45-470-7555', 'JAPAN', 'APAC', 'ACTIVE', 'GOLD', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 2: Generate Product Catalog
-- ============================================================================
INSERT INTO PRODUCT_CATALOG_VP VALUES
-- PIC Family (8-bit MCUs)
('PROD001', 'PIC18F47Q10', 'PIC18F47Q10-I/P', 'PIC', 'MCU', 2.4500, 'DIP-40', '8-bit', 128, 3, '1.8V-5.5V', '-40°C to +85°C', 'High-performance 8-bit MCU with Core Independent Peripherals', 'ACTIVE', TRUE, '2018-03-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD002', 'PIC16F18877', 'PIC16F18877-I/P', 'PIC', 'MCU', 1.9800, 'DIP-40', '8-bit', 56, 4, '2.3V-5.5V', '-40°C to +125°C', 'Low-power 8-bit MCU with XLP technology', 'ACTIVE', TRUE, '2017-06-20', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD003', 'PIC18F57Q43', 'PIC18F57Q43-I/P', 'PIC', 'MCU', 2.7500, 'DIP-40', '8-bit', 128, 8, '1.8V-5.5V', '-40°C to +85°C', 'Advanced 8-bit MCU with enhanced peripherals', 'ACTIVE', TRUE, '2020-09-10', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- AVR Family (8-bit MCUs)
('PROD010', 'ATmega328P', 'ATMEGA328P-PU', 'AVR', 'MCU', 1.5500, 'DIP-28', '8-bit', 32, 2, '1.8V-5.5V', '-40°C to +85°C', 'Popular 8-bit AVR used in Arduino boards', 'ACTIVE', TRUE, '2008-05-12', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD011', 'ATtiny85', 'ATTINY85-20PU', 'AVR', 'MCU', 0.8800, 'DIP-8', '8-bit', 8, 0.512, '2.7V-5.5V', '-40°C to +85°C', 'Compact 8-bit AVR for space-constrained applications', 'ACTIVE', TRUE, '2006-11-30', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD012', 'AVR128DA48', 'AVR128DA48-I/PT', 'AVR', 'MCU', 2.1000, 'TQFP-48', '8-bit', 128, 16, '1.8V-5.5V', '-40°C to +125°C', 'Modern AVR with advanced analog features', 'ACTIVE', TRUE, '2020-02-18', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- SAM Family (32-bit ARM Cortex-M MCUs)
('PROD020', 'SAMD21G18', 'ATSAMD21G18A-AU', 'SAM', 'MCU', 2.8500, 'TQFP-48', 'ARM Cortex-M0+', 256, 32, '1.62V-3.63V', '-40°C to +85°C', '32-bit ARM Cortex-M0+ MCU with USB', 'ACTIVE', TRUE, '2013-10-22', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD021', 'SAME54P20', 'ATSAME54P20A-AU', 'SAM', 'MCU', 4.7500, 'TQFP-64', 'ARM Cortex-M4F', 1024, 256, '1.71V-3.63V', '-40°C to +125°C', '32-bit ARM Cortex-M4 with DSP and FPU', 'ACTIVE', TRUE, '2017-11-08', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD022', 'SAMV71Q21', 'ATSAMV71Q21B-AAB', 'SAM', 'MCU', 6.2500, 'LQFP-144', 'ARM Cortex-M7', 2048, 384, '2.7V-3.6V', '-40°C to +105°C', 'High-performance ARM Cortex-M7 MCU', 'ACTIVE', TRUE, '2015-05-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- SAMA5 Family (32-bit ARM Cortex-A MPUs)
('PROD030', 'SAMA5D27', 'ATSAMA5D27C-D1G-CU', 'SAMA5', 'MPU', 8.9500, 'BGA-289', 'ARM Cortex-A5', 0, 0, '3.0V-3.6V', '-40°C to +85°C', '500MHz ARM Cortex-A5 MPU with security features', 'ACTIVE', TRUE, '2016-08-30', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD031', 'SAMA5D36', 'ATSAMA5D36-CU', 'SAMA5', 'MPU', 12.5000, 'BGA-324', 'ARM Cortex-A5', 0, 0, '3.0V-3.6V', '-40°C to +85°C', 'Dual-core ARM Cortex-A5 MPU for industrial applications', 'ACTIVE', TRUE, '2013-04-18', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- dsPIC Family (16-bit DSC)
('PROD040', 'dsPIC33FJ128GP802', 'DSPIC33FJ128GP802-I/SP', 'dsPIC', 'MCU', 3.4500, 'SPDIP-28', '16-bit DSC', 128, 16, '3.0V-3.6V', '-40°C to +85°C', '16-bit Digital Signal Controller for motor control', 'ACTIVE', TRUE, '2007-09-25', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD041', 'dsPIC33CK256MP508', 'DSPIC33CK256MP508-I/PT', 'dsPIC', 'MCU', 4.8500, 'TQFP-64', '16-bit DSC', 256, 24, '3.0V-3.6V', '-40°C to +125°C', 'Advanced DSC with high-resolution PWM', 'ACTIVE', TRUE, '2018-07-12', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- PIC32 Family (32-bit MIPS MCUs)
('PROD050', 'PIC32MZ2048EFH144', 'PIC32MZ2048EFH144-I/PH', 'PIC32', 'MCU', 9.7500, 'TQFP-144', 'MIPS M-Class', 2048, 512, '2.3V-3.6V', '-40°C to +85°C', '32-bit MIPS MCU with graphics controller', 'ACTIVE', TRUE, '2014-01-20', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD051', 'PIC32MX470F512H', 'PIC32MX470F512H-120/PT', 'PIC32', 'MCU', 5.6500, 'TQFP-64', 'MIPS M4K', 512, 128, '2.3V-3.6V', '-40°C to +85°C', 'High-performance 32-bit MIPS MCU with USB', 'ACTIVE', TRUE, '2012-03-14', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- FPGA Products
('PROD060', 'PolarFire MPF300TS', 'MPF300TS-FCG1152I', 'PolarFire', 'FPGA', 45.7500, 'FCBGA-1152', 'FPGA', 0, 0, '1.0V-1.05V', '-40°C to +100°C', 'Mid-range PolarFire FPGA with security', 'ACTIVE', TRUE, '2017-11-30', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD061', 'SmartFusion2 M2S050', 'M2S050-FG484I', 'SmartFusion2', 'FPGA', 28.5000, 'FBGA-484', 'FPGA + MCU', 0, 64, '1.0V-1.05V', '-40°C to +100°C', 'FPGA with embedded ARM Cortex-M3', 'ACTIVE', TRUE, '2012-10-08', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Analog Products
('PROD070', 'MCP6001', 'MCP6001-I/P', 'ANALOG', 'ANALOG', 0.3500, 'DIP-8', 'Op-Amp', 0, 0, '2.7V-6.0V', '-40°C to +125°C', 'Single 1MHz rail-to-rail op-amp', 'ACTIVE', TRUE, '2002-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD071', 'MCP23017', 'MCP23017-E/SP', 'ANALOG', 'INTERFACE', 0.9800, 'DIP-28', 'I2C I/O Expander', 0, 0, '1.8V-5.5V', '-40°C to +125°C', '16-bit I2C GPIO expander', 'ACTIVE', TRUE, '2008-06-10', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD072', 'MCP73831', 'MCP73831T-2ACI/OT', 'ANALOG', 'POWER', 0.4200, 'SOT-23-5', 'Li-Ion Charger', 0, 0, '3.75V-6.0V', '-40°C to +85°C', 'Single-cell Li-Ion/Li-Po charge controller', 'ACTIVE', TRUE, '2005-03-22', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD073', 'MCP3008', 'MCP3008-I/P', 'ANALOG', 'ADC', 1.2500, 'DIP-16', '10-bit ADC', 0, 0, '2.7V-5.5V', '-40°C to +85°C', '8-channel 10-bit ADC with SPI', 'ACTIVE', TRUE, '2001-11-20', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Memory Products
('PROD080', 'SST26VF064B', 'SST26VF064B-104I/SM', 'MEMORY', 'FLASH', 2.8500, 'SOIC-8', 'Serial Flash', 0, 0, '2.7V-3.6V', '-40°C to +85°C', '64Mbit SPI Serial Flash memory', 'ACTIVE', TRUE, '2015-02-10', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD081', 'AT24C256', 'AT24C256C-SSHL-T', 'MEMORY', 'EEPROM', 0.5800, 'SOIC-8', 'Serial EEPROM', 0, 0, '1.7V-5.5V', '-40°C to +85°C', '256Kbit I2C EEPROM', 'ACTIVE', TRUE, '1998-07-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Wireless Products
('PROD090', 'RN4870', 'RN4870-V/RM', 'WIRELESS', 'BLUETOOTH', 4.7500, 'QFN-20', 'Bluetooth 4.2', 0, 0, '1.9V-3.6V', '-40°C to +85°C', 'Bluetooth 4.2 Low Energy module', 'ACTIVE', TRUE, '2016-04-12', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD091', 'ATWINC1500', 'ATWINC1500-MR210PA', 'WIRELESS', 'WIFI', 3.9500, 'QFN-28', 'Wi-Fi 802.11b/g/n', 0, 0, '3.0V-3.6V', '-40°C to +85°C', 'Low-power Wi-Fi network controller', 'ACTIVE', TRUE, '2014-09-25', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD092', 'WBZ451', 'WBZ451-E-AU', 'WIRELESS', 'BLUETOOTH', 5.2500, 'VQFN-40', 'Bluetooth 5.0', 0, 0, '1.8V-3.6V', '-40°C to +105°C', 'Bluetooth 5.0 with ARM Cortex-M4F', 'ACTIVE', TRUE, '2021-06-18', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 3: Generate Support Engineers
-- ============================================================================
INSERT INTO SUPPORT_ENGINEERS_VP
SELECT
    'SE' || LPAD(SEQ4(), 5, '0') AS support_engineer_id,
    ARRAY_CONSTRUCT('John Smith', 'Sarah Chen', 'Michael Johnson', 'Emily Rodriguez', 'David Kim',
                    'Jessica Martinez', 'Robert Lee', 'Amanda Patel', 'Christopher Brown', 'Lisa Anderson')[UNIFORM(0, 9, RANDOM())] 
        || ' ' || ARRAY_CONSTRUCT('Jr.', 'Sr.', '', '', '')[UNIFORM(0, 4, RANDOM())] AS engineer_name,
    'support' || SEQ4() || '@microchip.com' AS email,
    ARRAY_CONSTRUCT('MCU_SUPPORT', 'MPU_SUPPORT', 'FPGA_SUPPORT', 'ANALOG_SUPPORT', 'TOOLS_SUPPORT')[UNIFORM(0, 4, RANDOM())] AS department,
    ARRAY_CONSTRUCT('PIC Family', 'AVR Family', 'SAM Family', 'FPGA', 'Analog Design', 'Motor Control', 'Wireless', 'Development Tools')[UNIFORM(0, 7, RANDOM())] AS specialization,
    DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_DATE()) AS hire_date,
    (UNIFORM(38, 50, RANDOM()) / 10.0)::NUMBER(3,2) AS average_satisfaction_rating,
    UNIFORM(200, 8000, RANDOM()) AS total_tickets_resolved,
    'ACTIVE' AS engineer_status,
    DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 150));

-- ============================================================================
-- Step 4: Generate Customers
-- ============================================================================
INSERT INTO CUSTOMERS_VP
SELECT
    'CUST' || LPAD(SEQ4(), 10, '0') AS customer_id,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 
            ARRAY_CONSTRUCT('Automotive Systems', 'Industrial Controls', 'Consumer Electronics', 'Medical Devices', 'Aerospace Systems')[UNIFORM(0, 4, RANDOM())] || ' Inc.'
        WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN
            ARRAY_CONSTRUCT('Advanced', 'Precision', 'Global', 'Integrated', 'Smart', 'Digital')[UNIFORM(0, 5, RANDOM())] || ' ' ||
            ARRAY_CONSTRUCT('Technologies', 'Solutions', 'Manufacturing', 'Electronics', 'Automation', 'Systems')[UNIFORM(0, 5, RANDOM())]
        ELSE
            ARRAY_CONSTRUCT('Alpha', 'Beta', 'Delta', 'Omega', 'Nexus', 'Vertex', 'Zenith', 'Apex')[UNIFORM(0, 7, RANDOM())] || ' ' ||
            ARRAY_CONSTRUCT('Corp', 'Ltd', 'Industries', 'Group', 'International')[UNIFORM(0, 4, RANDOM())]
    END AS customer_name,
    'contact' || SEQ4() || '@' || ARRAY_CONSTRUCT('company', 'corp', 'tech', 'mfg', 'automation')[UNIFORM(0, 4, RANDOM())] || '.com' AS primary_contact_email,
    CONCAT('+1-', UNIFORM(200, 999, RANDOM()), '-', UNIFORM(100, 999, RANDOM()), '-', UNIFORM(1000, 9999, RANDOM())) AS primary_contact_phone,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 50 THEN 'USA'
         WHEN UNIFORM(0, 100, RANDOM()) < 25 THEN ARRAY_CONSTRUCT('GERMANY', 'UK', 'FRANCE', 'ITALY')[UNIFORM(0, 3, RANDOM())]
         ELSE ARRAY_CONSTRUCT('CHINA', 'JAPAN', 'TAIWAN', 'SOUTH_KOREA', 'INDIA')[UNIFORM(0, 4, RANDOM())]
    END AS country,
    ARRAY_CONSTRUCT('CA', 'TX', 'MA', 'NY', 'WA', 'OR', 'MI', 'OH', 'IL', 'NC', 'GA', 'AZ', 'CO')[UNIFORM(0, 12, RANDOM())] AS state,
    ARRAY_CONSTRUCT('San Jose', 'Austin', 'Boston', 'Seattle', 'Detroit', 'Phoenix', 'Denver', 'Portland', 'Atlanta')[UNIFORM(0, 8, RANDOM())] AS city,
    DATEADD('day', -1 * UNIFORM(30, 5475, RANDOM()), CURRENT_DATE()) AS onboarding_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 94 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 4 THEN 'INACTIVE'
         ELSE 'CHURNED' END AS customer_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN 'OEM'
         WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'CONTRACT_MANUFACTURER'
         ELSE 'DISTRIBUTOR' END AS customer_segment,
    (UNIFORM(50000, 5000000, RANDOM()) / 1.0)::NUMBER(12,2) AS lifetime_value,
    (UNIFORM(5, 45, RANDOM()) / 1.0)::NUMBER(5,2) AS credit_risk_score,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'AUTOMOTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 25 THEN 'INDUSTRIAL'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'IOT'
         WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 'AEROSPACE'
         WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 'MEDICAL'
         ELSE 'CONSUMER' END AS industry_vertical,
    (UNIFORM(1000000, 500000000, RANDOM()) / 1.0)::NUMBER(15,2) AS annual_revenue_usd,
    UNIFORM(50, 50000, RANDOM()) AS employee_count,
    UNIFORM(5, 500, RANDOM()) AS design_engineering_team_size,
    DATEADD('day', -1 * UNIFORM(30, 5475, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 25000));

-- ============================================================================
-- Step 5: Generate Design Engineers
-- ============================================================================
INSERT INTO DESIGN_ENGINEERS_VP
SELECT
    'ENG' || LPAD(SEQ4(), 10, '0') AS engineer_id,
    c.customer_id,
    ARRAY_CONSTRUCT('James', 'Jennifer', 'Michael', 'Michelle', 'David', 'Diana', 'Robert', 'Rachel', 'William', 'Wendy',
                    'Richard', 'Rebecca', 'Daniel', 'Danielle', 'Thomas', 'Tiffany', 'Charles', 'Christine')[UNIFORM(0, 17, RANDOM())]
        || ' ' ||
    ARRAY_CONSTRUCT('Smith', 'Johnson', 'Lee', 'Chen', 'Kim', 'Patel', 'Garcia', 'Martinez', 'Anderson', 'Wilson',
                    'Taylor', 'Brown', 'Jones', 'Miller', 'Davis')[UNIFORM(0, 14, RANDOM())] AS engineer_name,
    'engineer' || SEQ4() || '@' || LOWER(REPLACE(REPLACE(c.customer_name, ' ', ''), '.', '')) || '.com' AS email,
    ARRAY_CONSTRUCT('Hardware Engineer', 'Firmware Engineer', 'Software Engineer', 'Systems Engineer', 'Design Engineer',
                    'Senior Hardware Engineer', 'Principal Engineer', 'Lead Engineer', 'Embedded Systems Engineer', 'Application Engineer')[UNIFORM(0, 9, RANDOM())] AS job_title,
    ARRAY_CONSTRUCT('R&D', 'Engineering', 'Product Development', 'Hardware Design', 'Firmware Development', 'Systems Engineering')[UNIFORM(0, 5, RANDOM())] AS department,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 90 THEN 'ACTIVE' ELSE 'INACTIVE' END AS engineer_status,
    UNIFORM(2, 30, RANDOM()) AS years_of_experience,
    UNIFORM(0, 100, RANDOM()) < 25 AS microchip_certified,
    ARRAY_CONSTRUCT('PIC', 'AVR', 'SAM', 'dsPIC', 'PIC32', 'FPGA', 'ANALOG', 'WIRELESS', 'MIXED')[UNIFORM(0, 8, RANDOM())] AS primary_product_family,
    ARRAY_CONSTRUCT('EMAIL', 'PHONE', 'WEB_PORTAL', 'EMAIL')[UNIFORM(0, 3, RANDOM())] AS preferred_contact_method,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_DATE()) ELSE NULL END AS last_webinar_attended_date,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CUSTOMERS_VP c
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 10))
WHERE UNIFORM(0, 100, RANDOM()) < 100
LIMIT 250000;

-- ============================================================================
-- Step 6: Generate Marketing Campaigns
-- ============================================================================
INSERT INTO MARKETING_CAMPAIGNS_VP
SELECT
    'CAMP' || LPAD(SEQ4(), 5, '0') AS campaign_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 
        ARRAY_CONSTRUCT('PIC', 'AVR', 'SAM', 'PolarFire', 'dsPIC')[UNIFORM(0, 4, RANDOM())] || ' ' ||
        ARRAY_CONSTRUCT('Launch', 'Webinar Series', 'Training Program', 'Product Promotion')[UNIFORM(0, 3, RANDOM())]
    ELSE
        ARRAY_CONSTRUCT('Automotive Solutions', 'Industrial IoT', 'Motor Control', 'Security Solutions', 'Wireless Connectivity')[UNIFORM(0, 4, RANDOM())] || ' ' ||
        ARRAY_CONSTRUCT('Summit', 'Workshop', 'Conference', 'Roadshow')[UNIFORM(0, 3, RANDOM())]
    END AS campaign_name,
    ARRAY_CONSTRUCT('PRODUCT_LAUNCH', 'WEBINAR', 'CONFERENCE', 'EMAIL_CAMPAIGN', 'TRADE_SHOW', 'TRAINING')[UNIFORM(0, 5, RANDOM())] AS campaign_type,
    DATEADD('day', -1 * UNIFORM(1, 1825, RANDOM()), CURRENT_DATE()) AS start_date,
    DATEADD('day', UNIFORM(7, 90, RANDOM()), DATEADD('day', -1 * UNIFORM(1, 1825, RANDOM()), CURRENT_DATE())) AS end_date,
    ARRAY_CONSTRUCT('AUTOMOTIVE', 'INDUSTRIAL', 'IOT', 'AEROSPACE', 'MEDICAL', 'CONSUMER', 'ALL')[UNIFORM(0, 6, RANDOM())] AS target_audience,
    (UNIFORM(10000, 500000, RANDOM()) / 1.0)::NUMBER(12,2) AS budget,
    ARRAY_CONSTRUCT('EMAIL', 'WEBINAR', 'TRADE_SHOW', 'SOCIAL_MEDIA', 'DIRECT_MAIL', 'WEBSITE')[UNIFORM(0, 5, RANDOM())] AS channel,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 60 THEN 'COMPLETED'
         WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'ACTIVE'
         ELSE 'PLANNED' END AS campaign_status,
    DATEADD('day', -1 * UNIFORM(1, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 500));

-- ============================================================================
-- Step 7: Generate Support Contracts
-- ============================================================================
INSERT INTO SUPPORT_CONTRACTS_VP
SELECT
    'CONT' || LPAD(SEQ4(), 10, '0') AS contract_id,
    c.customer_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN 'BASIC_SUPPORT'
         WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'PREMIUM_SUPPORT'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'ENTERPRISE_SUPPORT'
         ELSE 'DESIGN_PARTNER' END AS contract_type,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 50 THEN 'BASIC'
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN 'PROFESSIONAL'
         ELSE 'ENTERPRISE' END AS service_tier,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()) AS start_date,
    DATEADD('year', 1, DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE())) AS end_date,
    ARRAY_CONSTRUCT('MONTHLY', 'QUARTERLY', 'ANNUAL')[UNIFORM(0, 2, RANDOM())] AS billing_cycle,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN (UNIFORM(500, 2000, RANDOM()) / 1.0)::NUMBER(10,2)
         WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN (UNIFORM(2000, 5000, RANDOM()) / 1.0)::NUMBER(10,2)
         ELSE (UNIFORM(5000, 15000, RANDOM()) / 1.0)::NUMBER(10,2) END AS monthly_fee,
    ARRAY_CONSTRUCT('BASIC', 'ADVANCED', 'FULL_SUITE')[UNIFORM(0, 2, RANDOM())] AS tool_license_access,
    UNIFORM(0, 100, RANDOM()) < 40 AS priority_support,
    UNIFORM(0, 100, RANDOM()) < 30 AS includes_nda,
    UNIFORM(0, 100, RANDOM()) < 15 AS includes_early_access,
    UNIFORM(0, 100, RANDOM()) < 20 AS dedicated_fae,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 85 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 'EXPIRED'
         ELSE 'CANCELLED' END AS contract_status,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CUSTOMERS_VP c
WHERE UNIFORM(0, 100, RANDOM()) < 60;

-- ============================================================================
-- Step 8: Generate Certifications
-- ============================================================================
INSERT INTO CERTIFICATIONS_VP
SELECT
    'CERT' || LPAD(SEQ4(), 10, '0') AS certification_id,
    e.engineer_id,
    e.customer_id,
    ARRAY_CONSTRUCT('MICROCHIP_ACADEMY', 'PRODUCT_SPECIALIST', 'DESIGN_EXPERT', 'ARM_CERTIFIED', 'FUNCTIONAL_SAFETY')[UNIFORM(0, 4, RANDOM())] AS certification_type,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 60 THEN
        ARRAY_CONSTRUCT('PIC', 'AVR', 'SAM', 'dsPIC', 'FPGA')[UNIFORM(0, 4, RANDOM())] || ' Certified Professional'
    ELSE
        ARRAY_CONSTRUCT('Motor Control Specialist', 'Wireless Design Expert', 'Security Solutions Expert', 'ARM Cortex-M Developer')[UNIFORM(0, 3, RANDOM())]
    END AS certification_name,
    ARRAY_CONSTRUCT('Microchip Academy', 'ARM', 'TUV SUD', 'Microchip University')[UNIFORM(0, 3, RANDOM())] AS issuing_organization,
    'CERT-' || LPAD(UNIFORM(100000, 999999, RANDOM()), 6, '0') AS certification_number,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()) AS issue_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN DATEADD('year', 3, DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()))
         ELSE NULL END AS expiration_date,
    'VERIFIED' AS verification_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 90 THEN 'ACTIVE' ELSE 'EXPIRED' END AS certification_status,
    UNIFORM(0, 100, RANDOM()) < 30 AS primary_certification,
    e.primary_product_family AS product_family_focus,
    ARRAY_CONSTRUCT('ASSOCIATE', 'PROFESSIONAL', 'EXPERT')[UNIFORM(0, 2, RANDOM())] AS certification_level,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM DESIGN_ENGINEERS_VP e
WHERE e.microchip_certified = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 100
LIMIT 40000;

-- ============================================================================
-- Step 9: Generate Design Wins
-- ============================================================================
INSERT INTO DESIGN_WINS_VP
SELECT
    'DW' || LPAD(SEQ4(), 12, '0') AS design_win_id,
    e.engineer_id,
    p.product_id,
    e.customer_id,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_DATE()) AS design_win_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'IN_PRODUCTION'
         WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN 'PROTOTYPE'
         ELSE 'IN_DESIGN' END AS design_status,
    DATEADD('day', UNIFORM(90, 730, RANDOM()), CURRENT_DATE()) AS estimated_production_date,
    ARRAY_CONSTRUCT('Smart Thermostat', 'Motor Controller', 'IoT Sensor Node', 'Industrial PLC', 'Automotive ECU',
                    'Medical Monitor', 'Home Automation Hub', 'Wearable Device', 'Security System', 'Battery Charger',
                    'LED Driver', 'Power Meter', 'HVAC Controller', 'Robotics Controller', 'Data Logger')[UNIFORM(0, 14, RANDOM())] AS end_product_name,
    c.industry_vertical AS target_industry,
    UNIFORM(1000, 500000, RANDOM()) AS estimated_annual_volume,
    d.distributor_id,
    UNIFORM(0, 100, RANDOM()) < 30 AS competitive_displacement,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 
         THEN ARRAY_CONSTRUCT('STMicroelectronics', 'NXP', 'Renesas', 'Infineon', 'Texas Instruments', 'Analog Devices')[UNIFORM(0, 5, RANDOM())]
         ELSE NULL END AS competitor_name,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM DESIGN_ENGINEERS_VP e
JOIN CUSTOMERS_VP c ON e.customer_id = c.customer_id
CROSS JOIN PRODUCT_CATALOG_VP p
CROSS JOIN DISTRIBUTORS_VP d
WHERE e.engineer_status = 'ACTIVE'
  AND p.is_active = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 1
LIMIT 500000;

-- ============================================================================
-- Step 10: Generate Production Orders
-- ============================================================================
INSERT INTO PRODUCTION_ORDERS_VP
SELECT
    'PO' || LPAD(SEQ4(), 12, '0') AS production_order_id,
    dw.design_win_id,
    dw.engineer_id,
    dw.product_id,
    dw.customer_id,
    DATEADD('day', UNIFORM(30, 180, RANDOM()), dw.design_win_date) AS production_start_date,
    UNIFORM(100, 100000, RANDOM()) AS order_quantity,
    p.unit_price * (1.0 - (UNIFORM(0, 30, RANDOM()) / 100.0)) AS unit_price,
    (UNIFORM(100, 100000, RANDOM()) * p.unit_price * (1.0 - (UNIFORM(0, 30, RANDOM()) / 100.0)))::NUMBER(15,2) AS total_order_value,
    DATEADD('day', UNIFORM(30, 180, RANDOM()), dw.design_win_date) AS order_date,
    DATEADD('day', UNIFORM(14, 90, RANDOM()), DATEADD('day', UNIFORM(30, 180, RANDOM()), dw.design_win_date)) AS ship_date,
    dw.distributor_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 80 THEN 'DELIVERED'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'SHIPPED'
         ELSE 'ORDERED' END AS production_status,
    DATEADD('day', UNIFORM(30, 180, RANDOM()), dw.design_win_date) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM DESIGN_WINS_VP dw
JOIN PRODUCT_CATALOG_VP p ON dw.product_id = p.product_id
WHERE dw.design_status = 'IN_PRODUCTION'
  AND UNIFORM(0, 100, RANDOM()) < 60
LIMIT 300000;

-- ============================================================================
-- Step 11: Generate Orders
-- ============================================================================
INSERT INTO ORDERS_VP
SELECT
    'ORD' || LPAD(SEQ4(), 12, '0') AS order_id,
    c.customer_id,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_TIMESTAMP()) AS order_date,
    ARRAY_CONSTRUCT('PRODUCT_ORDER', 'SAMPLE_REQUEST', 'EVALUATION_KIT', 'SUPPORT_RENEWAL')[UNIFORM(0, 3, RANDOM())] AS order_type,
    (p.unit_price * UNIFORM(100, 10000, RANDOM()))::NUMBER(12,2) AS order_amount,
    ARRAY_CONSTRUCT('NET_30', 'NET_60', 'NET_90', 'PREPAID', 'CREDIT_CARD')[UNIFORM(0, 4, RANDOM())] AS payment_terms,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 96 THEN 'COMPLETED'
         WHEN UNIFORM(0, 100, RANDOM()) < 3 THEN 'PENDING'
         ELSE 'CANCELLED' END AS payment_status,
    'USD' AS currency,
    p.product_id,
    UNIFORM(100, 10000, RANDOM()) AS quantity,
    p.unit_price AS unit_price,
    (p.unit_price * UNIFORM(100, 10000, RANDOM()) * UNIFORM(0, 20, RANDOM()) / 100.0)::NUMBER(10,2) AS discount_amount,
    (p.unit_price * UNIFORM(100, 10000, RANDOM()) * UNIFORM(6, 10, RANDOM()) / 100.0)::NUMBER(10,2) AS tax_amount,
    d.distributor_id,
    UNIFORM(0, 100, RANDOM()) < 40 AS direct_sale,
    ARRAY_CONSTRUCT('USA', 'CHINA', 'GERMANY', 'JAPAN', 'UK', 'FRANCE', 'TAIWAN', 'SOUTH_KOREA')[UNIFORM(0, 7, RANDOM())] AS ship_to_country,
    ARRAY_CONSTRUCT('DISTRIBUTOR', 'DIRECT', 'ONLINE', 'PARTNER')[UNIFORM(0, 3, RANDOM())] AS order_source,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CUSTOMERS_VP c
CROSS JOIN PRODUCT_CATALOG_VP p
CROSS JOIN DISTRIBUTORS_VP d
WHERE UNIFORM(0, 100, RANDOM()) < 2
  AND p.is_active = TRUE
LIMIT 1000000;

-- ============================================================================
-- Step 12: Generate Customer Campaign Interactions
-- ============================================================================
INSERT INTO CUSTOMER_CAMPAIGN_INTERACTIONS_VP
SELECT
    'INT' || LPAD(SEQ4(), 10, '0') AS interaction_id,
    c.customer_id,
    mc.campaign_id,
    DATEADD('day', UNIFORM(0, 60, RANDOM()), mc.start_date) AS interaction_date,
    ARRAY_CONSTRUCT('EMAIL_OPEN', 'CLICK', 'WEBINAR_ATTEND', 'DEMO_REQUEST', 'DOWNLOAD', 'REGISTRATION', 'BOOTH_VISIT', 'PURCHASE')[UNIFORM(0, 7, RANDOM())] AS interaction_type,
    UNIFORM(0, 100, RANDOM()) < 15 AS conversion_flag,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN (UNIFORM(5000, 200000, RANDOM()) / 1.0)::NUMBER(12,2) ELSE 0.00 END AS revenue_generated,
    DATEADD('day', UNIFORM(0, 60, RANDOM()), mc.start_date) AS created_at
FROM CUSTOMERS_VP c
CROSS JOIN MARKETING_CAMPAIGNS_VP mc
WHERE UNIFORM(0, 100, RANDOM()) < 5
LIMIT 50000;

-- ============================================================================
-- Step 13: Generate Support Tickets
-- ============================================================================
INSERT INTO SUPPORT_TICKETS_VP
SELECT
    'TIX' || LPAD(SEQ4(), 10, '0') AS ticket_id,
    c.customer_id,
    e.engineer_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN
        ARRAY_CONSTRUCT('Code compilation error', 'Debugger not connecting', 'Programming issue', 'Tool installation problem')[UNIFORM(0, 3, RANDOM())]
    WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN
        p.product_name || ' - ' || ARRAY_CONSTRUCT('Not responding', 'Unexpected behavior', 'Peripheral configuration', 'Clock setup question')[UNIFORM(0, 3, RANDOM())]
    ELSE
        ARRAY_CONSTRUCT('Order status inquiry', 'Sample request', 'Documentation request', 'Technical specification question', 'Lead time inquiry')[UNIFORM(0, 4, RANDOM())]
    END AS subject,
    'Detailed description of the technical issue or question' AS description,
    ARRAY_CONSTRUCT('TECHNICAL', 'ORDERING', 'ACCOUNT', 'DOCUMENTATION')[UNIFORM(0, 3, RANDOM())] AS ticket_category,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'URGENT')[UNIFORM(0, 3, RANDOM())] AS priority,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 78 THEN 'CLOSED'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'IN_PROGRESS'
         ELSE 'OPEN' END AS ticket_status,
    ARRAY_CONSTRUCT('PHONE', 'EMAIL', 'WEB_PORTAL', 'CHAT')[UNIFORM(0, 3, RANDOM())] AS channel,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_date,
    DATEADD('hour', UNIFORM(1, 6, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS first_response_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 78 
         THEN DATEADD('hour', UNIFORM(6, 72, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()))
         ELSE NULL END AS resolution_date,
    'SE' || LPAD(UNIFORM(1, 150, RANDOM()), 5, '0') AS assigned_engineer_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 78 THEN UNIFORM(1, 5, RANDOM()) ELSE NULL END AS customer_satisfaction_score,
    p.product_id,
    ARRAY_CONSTRUCT('DESIGN_SUPPORT', 'DEBUGGING', 'TOOLS', 'ORDERING', 'RMA', 'DOCUMENTATION')[UNIFORM(0, 5, RANDOM())] AS ticket_type,
    UNIFORM(0, 100, RANDOM()) < 8 AS escalated,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CUSTOMERS_VP c
JOIN DESIGN_ENGINEERS_VP e ON c.customer_id = e.customer_id
CROSS JOIN PRODUCT_CATALOG_VP p
WHERE UNIFORM(0, 100, RANDOM()) < 1
  AND e.engineer_status = 'ACTIVE'
LIMIT 75000;

-- ============================================================================
-- Step 14: Generate Quality Issues
-- ============================================================================
INSERT INTO QUALITY_ISSUES_VP
SELECT
    'QI' || LPAD(SEQ4(), 10, '0') AS quality_issue_id,
    c.customer_id,
    p.product_id,
    e.engineer_id AS reported_by_engineer_id,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS reported_date,
    ARRAY_CONSTRUCT('FIELD_FAILURE', 'MANUFACTURING_DEFECT', 'SPECIFICATION_DEVIATION', 'PACKAGING_ISSUE', 'DOCUMENTATION_ERROR')[UNIFORM(0, 4, RANDOM())] AS issue_type,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')[UNIFORM(0, 3, RANDOM())] AS severity,
    'Detailed description of the quality issue encountered in production or field' AS description,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN 'CLOSED'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'INVESTIGATING'
         ELSE 'OPEN' END AS investigation_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN
        ARRAY_CONSTRUCT('Process variation', 'Component contamination', 'Handling damage', 'Design sensitivity', 'Test escapes')[UNIFORM(0, 4, RANDOM())]
         ELSE NULL END AS root_cause,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN
        'Corrective action implemented: process controls tightened, additional testing added'
         ELSE NULL END AS corrective_action,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN
        'Preventive action: update manufacturing procedures, enhance supplier quality requirements'
         ELSE NULL END AS preventive_action,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 
         THEN DATEADD('day', UNIFORM(7, 90, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()))
         ELSE NULL END AS closure_date,
    'LOT' || LPAD(UNIFORM(100000, 999999, RANDOM()), 8, '0') AS lot_number,
    'RMA' || LPAD(UNIFORM(10000, 99999, RANDOM()), 6, '0') AS rma_number,
    UNIFORM(1, 10000, RANDOM()) AS affected_quantity,
    ARRAY_CONSTRUCT('ELECTRICAL', 'MECHANICAL', 'SOFTWARE', 'DOCUMENTATION', 'PACKAGING')[UNIFORM(0, 4, RANDOM())] AS issue_category,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CUSTOMERS_VP c
JOIN DESIGN_ENGINEERS_VP e ON c.customer_id = e.customer_id
CROSS JOIN PRODUCT_CATALOG_VP p
WHERE UNIFORM(0, 100, RANDOM()) < 0.5
  AND e.engineer_status = 'ACTIVE'
LIMIT 25000;

-- ============================================================================
-- Step 15: Generate Certification Verifications
-- ============================================================================
INSERT INTO CERTIFICATION_VERIFICATIONS_VP
SELECT
    'VER' || LPAD(SEQ4(), 10, '0') AS verification_id,
    cert.certification_id,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS verification_date,
    ARRAY_CONSTRUCT('ONLINE_VERIFICATION', 'DOCUMENT_REVIEW', 'THIRD_PARTY')[UNIFORM(0, 2, RANDOM())] AS verification_method,
    'VERIFIED' AS verification_status,
    'Microchip Certification Team' AS verified_by,
    ARRAY_CONSTRUCT('Microchip Academy Database', 'ARM Certification Portal', 'Training Provider')[UNIFORM(0, 2, RANDOM())] AS verification_source,
    'Certification verified and active' AS notes,
    DATEADD('year', 1, DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP())) AS next_verification_date,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM CERTIFICATIONS_VP cert
WHERE UNIFORM(0, 100, RANDOM()) < 85
LIMIT 60000;

-- ============================================================================
-- Display completion
-- ============================================================================
SELECT 'All synthetic data generated successfully' AS status;

