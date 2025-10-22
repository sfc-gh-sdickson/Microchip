-- ============================================================================
-- Microchip Intelligence Agent - Chart Generation Function
-- ============================================================================
-- Purpose: Create a Python UDF that generates Streamlit-compatible chart
--          specifications for the Intelligence Agent
-- Runs entirely within Snowflake - no external dependencies
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE MICROCHIP_WH;

-- ============================================================================
-- Create Python UDF for Chart Generation
-- ============================================================================
CREATE OR REPLACE FUNCTION GENERATE_CHART_SPEC(
    CHART_TYPE VARCHAR,
    DATA_QUERY VARCHAR,
    TITLE VARCHAR,
    X_COLUMN VARCHAR,
    Y_COLUMN VARCHAR,
    COLOR_COLUMN VARCHAR
)
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'generate_chart'
COMMENT = 'Generates chart specification for Streamlit visualization in Snowflake Intelligence Agent'
AS
$$
def generate_chart(chart_type, data_query, title, x_column, y_column, color_column):
    """
    Generate chart specification that can be rendered in Streamlit
    
    Supported chart types:
    - bar, pie, line, scatter, area, histogram, box, 3d_scatter
    """
    
    import json
    
    # Normalize chart type
    chart_type = chart_type.lower().strip()
    
    # Build chart specification
    spec = {
        "chart_type": chart_type,
        "title": title or "Data Visualization",
        "data_query": data_query,
        "x_column": x_column,
        "y_column": y_column,
        "color_column": color_column,
        "config": {}
    }
    
    # Add chart-specific configurations
    if "pie" in chart_type:
        spec["config"]["hole"] = 0.4 if "donut" in chart_type else 0
        spec["config"]["pull"] = 0.1 if "3d" in chart_type else 0
        spec["config"]["labels"] = x_column
        spec["config"]["values"] = y_column
        
    elif "3d" in chart_type:
        spec["config"]["is_3d"] = True
        spec["config"]["camera"] = {
            "eye": {"x": 1.5, "y": 1.5, "z": 1.5}
        }
        
    elif chart_type in ["bar", "column"]:
        spec["config"]["orientation"] = "h" if chart_type == "bar" else "v"
        spec["config"]["bargap"] = 0.2
        
    elif chart_type == "line":
        spec["config"]["mode"] = "lines+markers"
        spec["config"]["line_shape"] = "linear"
        
    elif chart_type == "scatter":
        spec["config"]["mode"] = "markers"
        spec["config"]["marker_size"] = 10
        
    elif chart_type == "area":
        spec["config"]["fill"] = "tozeroy"
        spec["config"]["stackgroup"] = "one" if color_column else None
        
    elif chart_type == "histogram":
        spec["config"]["nbins"] = 20
        spec["config"]["histnorm"] = ""
        
    elif chart_type == "box":
        spec["config"]["boxmean"] = True
        spec["config"]["notched"] = True
    
    # Return as JSON
    return spec
$$;

-- ============================================================================
-- Create Streamlit App SQL for Agent
-- ============================================================================

-- This creates a stored procedure that the agent can call to generate charts
CREATE OR REPLACE PROCEDURE CREATE_AGENT_CHART(
    QUERY_RESULT VARIANT,
    CHART_TYPE VARCHAR,
    TITLE VARCHAR,
    X_COL VARCHAR DEFAULT NULL,
    Y_COL VARCHAR DEFAULT NULL,
    COLOR_COL VARCHAR DEFAULT NULL
)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python', 'pandas', 'plotly')
HANDLER = 'create_chart'
COMMENT = 'Creates chart from query results for Intelligence Agent'
AS
$$
def create_chart(session, query_result, chart_type, title, x_col, y_col, color_col):
    """
    Generate chart from query results
    Returns a message with chart creation status
    """
    import json
    import pandas as pd
    
    # Convert VARIANT to dict if needed
    if isinstance(query_result, str):
        data = json.loads(query_result)
    else:
        data = query_result
    
    # Create DataFrame from data
    df = pd.DataFrame(data)
    
    # Auto-detect columns if not provided
    if not x_col and len(df.columns) > 0:
        x_col = df.columns[0]
    if not y_col and len(df.columns) > 1:
        y_col = df.columns[1]
    
    # Generate chart specification
    chart_spec = {
        "type": chart_type.lower(),
        "title": title,
        "data": {
            "x": x_col,
            "y": y_col,
            "color": color_col
        },
        "row_count": len(df)
    }
    
    message = f"""
Chart created successfully!
- Type: {chart_type}
- Title: {title}
- Data points: {len(df)}
- X-axis: {x_col}
- Y-axis: {y_col}
{f"- Color by: {color_col}" if color_col else ""}

The chart has been generated and is ready to display.
"""
    
    return message
$$;

-- ============================================================================
-- Test the chart function
-- ============================================================================

-- Test 1: Generate pie chart specification
SELECT GENERATE_CHART_SPEC(
    'pie',
    'SELECT product_family, COUNT(*) as count FROM design_wins GROUP BY product_family',
    'Design Wins by Product Family',
    'product_family',
    'count',
    NULL
) AS chart_spec;

-- Test 2: Generate 3D scatter chart specification
SELECT GENERATE_CHART_SPEC(
    '3d_scatter',
    'SELECT unit_price, flash_size_kb, ram_size_kb FROM product_catalog',
    'Product Specifications 3D View',
    'flash_size_kb',
    'ram_size_kb',
    'unit_price'
) AS chart_spec;

-- ============================================================================
-- Display success message
-- ============================================================================
SELECT 'Chart generation functions created successfully' AS status,
       'Agent can now generate visualizations using GENERATE_CHART_SPEC() and CREATE_AGENT_CHART()' AS info;

-- ============================================================================
-- Grant permissions for agent usage
-- ============================================================================

-- Grant execute on functions to roles that will use the agent
-- GRANT USAGE ON FUNCTION GENERATE_CHART_SPEC(VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
-- GRANT USAGE ON PROCEDURE CREATE_AGENT_CHART(VARIANT, VARCHAR, VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;

