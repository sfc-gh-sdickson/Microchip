-- ============================================================================
-- Microchip Intelligence Agent - Inline Chart Rendering
-- ============================================================================
-- Purpose: Create functions that return Vega-Lite specifications for
--          INLINE rendering in Snowflake Intelligence Agent chat interface
-- Note: Agents support Vega-Lite only (not true 3D Plotly)
--       We use visual effects (donut, gradients, shadows) for depth
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE MICROCHIP_WH;

-- ============================================================================
-- Function 1: Enhanced Donut Chart (Pseudo-3D Pie Chart)
-- ============================================================================
CREATE OR REPLACE FUNCTION GENERATE_DONUT_CHART(
    DATA_JSON VARCHAR,
    LABEL_FIELD VARCHAR,
    VALUE_FIELD VARCHAR,
    CHART_TITLE VARCHAR
)
RETURNS OBJECT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'generate_donut'
COMMENT = 'Generates enhanced donut chart with 3D-like appearance for inline agent rendering'
AS
$$
def generate_donut(data_json, label_field, value_field, chart_title):
    """
    Creates Vega-Lite donut chart specification with enhanced visual depth.
    This is the closest to 3D pie chart that can render inline in agent.
    """
    import json
    
    # Parse data
    data = json.loads(data_json) if isinstance(data_json, str) else data_json
    
    spec = {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "description": "Enhanced donut chart with 3D-like visual effects",
        "title": {
            "text": chart_title,
            "fontSize": 20,
            "fontWeight": "bold",
            "anchor": "middle",
            "color": "#333"
        },
        "data": {"values": data},
        "width": 500,
        "height": 500,
        "mark": {
            "type": "arc",
            "innerRadius": 100,
            "outerRadius": 180,
            "stroke": "white",
            "strokeWidth": 3,
            "tooltip": True,
            "cursor": "pointer"
        },
        "encoding": {
            "theta": {
                "field": value_field,
                "type": "quantitative",
                "stack": True
            },
            "color": {
                "field": label_field,
                "type": "nominal",
                "scale": {
                    "scheme": "tableau20"
                },
                "legend": {
                    "title": label_field,
                    "titleFontSize": 14,
                    "labelFontSize": 12,
                    "orient": "right",
                    "offset": 10
                }
            },
            "opacity": {
                "value": 0.95
            },
            "tooltip": [
                {"field": label_field, "type": "nominal", "title": "Category"},
                {"field": value_field, "type": "quantitative", "title": "Value", "format": ","},
                {"field": value_field, "type": "quantitative", "title": "Percentage", "format": ".1%", 
                 "aggregate": "sum", "stack": "normalize"}
            ]
        },
        "config": {
            "view": {"stroke": "transparent"},
            "arc": {"cornerRadius": 3}
        }
    }
    
    return spec
$$;

-- ============================================================================
-- Function 2: Enhanced Bar Chart with Gradient (Depth Effect)
-- ============================================================================
CREATE OR REPLACE FUNCTION GENERATE_BAR_CHART(
    DATA_JSON VARCHAR,
    X_FIELD VARCHAR,
    Y_FIELD VARCHAR,
    CHART_TITLE VARCHAR
)
RETURNS OBJECT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'generate_bar'
AS
$$
def generate_bar(data_json, x_field, y_field, chart_title):
    import json
    data = json.loads(data_json) if isinstance(data_json, str) else data_json
    
    return {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "title": {"text": chart_title, "fontSize": 18, "fontWeight": "bold"},
        "data": {"values": data},
        "width": "container",
        "height": 400,
        "mark": {
            "type": "bar",
            "tooltip": True,
            "cornerRadiusEnd": 5,
            "opacity": 0.9
        },
        "encoding": {
            "x": {
                "field": x_field,
                "type": "nominal",
                "axis": {"labelAngle": -45, "labelFontSize": 11}
            },
            "y": {
                "field": y_field,
                "type": "quantitative",
                "axis": {"grid": True}
            },
            "color": {
                "field": y_field,
                "type": "quantitative",
                "scale": {"scheme": "blues", "reverse": False},
                "legend": None
            },
            "tooltip": [
                {"field": x_field, "type": "nominal"},
                {"field": y_field, "type": "quantitative", "format": ","}
            ]
        }
    }
$$;

-- ============================================================================
-- Function 3: Line Chart for Trends
-- ============================================================================
CREATE OR REPLACE FUNCTION GENERATE_LINE_CHART(
    DATA_JSON VARCHAR,
    X_FIELD VARCHAR,
    Y_FIELD VARCHAR,
    CHART_TITLE VARCHAR
)
RETURNS OBJECT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'generate_line'
AS
$$
def generate_line(data_json, x_field, y_field, chart_title):
    import json
    data = json.loads(data_json) if isinstance(data_json, str) else data_json
    
    return {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "title": {"text": chart_title, "fontSize": 18},
        "data": {"values": data},
        "width": "container",
        "height": 400,
        "mark": {
            "type": "line",
            "point": {"filled": True, "size": 80},
            "tooltip": True,
            "strokeWidth": 3
        },
        "encoding": {
            "x": {"field": x_field, "type": "temporal"},
            "y": {"field": y_field, "type": "quantitative"},
            "color": {"value": "#1f77b4"},
            "tooltip": [
                {"field": x_field, "title": "Date"},
                {"field": y_field, "format": ","}
            ]
        }
    }
$$;

-- ============================================================================
-- Function 4: Enhanced Area Chart (Gradient Fill)
-- ============================================================================
CREATE OR REPLACE FUNCTION GENERATE_AREA_CHART(
    DATA_JSON VARCHAR,
    X_FIELD VARCHAR,
    Y_FIELD VARCHAR,
    CHART_TITLE VARCHAR
)
RETURNS OBJECT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'generate_area'
AS
$$
def generate_area(data_json, x_field, y_field, chart_title):
    import json
    data = json.loads(data_json) if isinstance(data_json, str) else data_json
    
    return {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "title": {"text": chart_title, "fontSize": 18},
        "data": {"values": data},
        "width": "container",
        "height": 400,
        "mark": {
            "type": "area",
            "line": {"strokeWidth": 2},
            "point": True,
            "tooltip": True,
            "opacity": 0.7
        },
        "encoding": {
            "x": {"field": x_field, "type": "ordinal"},
            "y": {"field": y_field, "type": "quantitative"},
            "color": {
                "value": "#ff7f0e"
            },
            "tooltip": [
                {"field": x_field},
                {"field": y_field, "format": ","}
            ]
        }
    }
$$;

-- ============================================================================
-- Grant permissions
-- ============================================================================
-- Execute these as ACCOUNTADMIN after creating functions:
-- GRANT USAGE ON FUNCTION GENERATE_DONUT_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
-- GRANT USAGE ON FUNCTION GENERATE_BAR_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
-- GRANT USAGE ON FUNCTION GENERATE_LINE_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
-- GRANT USAGE ON FUNCTION GENERATE_AREA_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;

SELECT 'Inline chart functions created - ready for agent use' AS status;

