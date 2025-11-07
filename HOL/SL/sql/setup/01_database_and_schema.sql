-- ============================================================================
-- Microchip Intelligence Agent - Database and Schema Setup
-- ============================================================================
-- Purpose: Initialize the database, schema, and warehouse for the Microchip
--          Intelligence Agent solution
-- ============================================================================

-- Create the database
CREATE DATABASE IF NOT EXISTS MICROCHIP_INTELLIGENCE_SL;

-- Use the database
USE DATABASE MICROCHIP_INTELLIGENCE_SL;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS RAW_SL;
CREATE SCHEMA IF NOT EXISTS ANALYTICS_SL;

-- Create a virtual warehouse for query processing
CREATE OR REPLACE WAREHOUSE MICROCHIP_WH_SL WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Microchip Intelligence Agent queries';

-- Set the warehouse as active
USE WAREHOUSE MICROCHIP_WH_SL;

-- Display confirmation
SELECT 'Database, schema, and warehouse setup completed successfully' AS STATUS;

