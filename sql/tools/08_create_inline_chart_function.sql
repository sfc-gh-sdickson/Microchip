-- ============================================================================
-- Microchip Intelligence Agent - Inline Chart Generation Function
-- ============================================================================
-- Purpose: Create a Python UDF that returns Vega-Lite chart specifications
--          that can be rendered INLINE in the Intelligence Agent chat
-- Returns Vega-Lite format (not Plotly) for agent compatibility
-- ============================================================================

USE DATABASE MICROCHIP_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE MICROCHIP_WH;

-- ============================================================================
-- Create Python UDF for Vega-Lite Chart Generation (Inline in Agent)
-- ============================================================================
CREATE OR REPLACE FUNCTION CREATE_INLINE_CHART(
    DATA_ARRAY ARRAY,
    CHART_TYPE VARCHAR,
    TITLE VARCHAR,
    X_FIELD VARCHAR,
    Y_FIELD VARCHAR
)
RETURNS VARIANT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'create_vega_chart'
COMMENT = 'Generates Vega-Lite chart specification for inline rendering in Snowflake Intelligence Agent'
AS
$$
def create_vega_chart(data_array, chart_type, title, x_field, y_field):
    """
    Generate Vega-Lite chart specification that Intelligence Agent can render inline
    
    Supported types: pie, bar, line, scatter, area
    Note: True 3D charts not supported in Vega-Lite, but we use visual effects for depth
    """
    
    chart_type = chart_type.lower().strip()
    
    # Base Vega-Lite specification
    spec = {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "title": {
            "text": title,
            "fontSize": 18,
            "font": "Arial",
            "fontWeight": "bold"
        },
        "data": {
            "values": data_array
        },
        "width": 600,
        "height": 400
    }
    
    if 'pie' in chart_type or 'donut' in chart_type:
        # Enhanced pie chart with shadow and gradient for 3D appearance
        spec.update({
            "mark": {
                "type": "arc",
                "innerRadius": 80 if 'donut' in chart_type or '3d' in chart_type else 0,
                "outerRadius": 150,
                "stroke": "white",
                "strokeWidth": 3,
                "tooltip": True
            },
            "encoding": {
                "theta": {
                    "field": y_field,
                    "type": "quantitative",
                    "stack": True
                },
                "color": {
                    "field": x_field,
                    "type": "nominal",
                    "scale": {
                        "scheme": "category20"
                    },
                    "legend": {
                        "title": x_field,
                        "orient": "right",
                        "titleFontSize": 12,
                        "labelFontSize": 11
                    }
                },
                "opacity": {
                    "value": 0.9
                },
                "tooltip": [
                    {"field": x_field, "type": "nominal", "title": "Category"},
                    {"field": y_field, "type": "quantitative", "title": "Value", "format": ","}
                ]
            },
            "view": {"stroke": None}
        })
        
    elif 'bar' in chart_type or 'column' in chart_type:
        # Enhanced bar chart with gradient fill for depth
        spec.update({
            "mark": {
                "type": "bar",
                "tooltip": True,
                "cornerRadiusEnd": 4,
                "opacity": 0.85
            },
            "encoding": {
                "x": {
                    "field": x_field,
                    "type": "nominal",
                    "axis": {
                        "labelAngle": -45,
                        "title": x_field,
                        "titleFontSize": 12,
                        "labelFontSize": 10
                    }
                },
                "y": {
                    "field": y_field,
                    "type": "quantitative",
                    "axis": {
                        "title": y_field,
                        "titleFontSize": 12,
                        "grid": True
                    }
                },
                "color": {
                    "field": y_field,
                    "type": "quantitative",
                    "scale": {
                        "scheme": "blues"
                    },
                    "legend": None
                },
                "tooltip": [
                    {"field": x_field, "type": "nominal"},
                    {"field": y_field, "type": "quantitative", "format": ","}
                ]
            }
        })
        
    elif 'line' in chart_type:
        # Line chart with area fill for visual depth
        spec.update({
            "mark": {
                "type": "line",
                "point": {
                    "filled": True,
                    "size": 100
                },
                "tooltip": True,
                "strokeWidth": 3,
                "opacity": 0.8
            },
            "encoding": {
                "x": {
                    "field": x_field,
                    "type": "ordinal",
                    "axis": {"title": x_field, "titleFontSize": 12}
                },
                "y": {
                    "field": y_field,
                    "type": "quantitative",
                    "axis": {"title": y_field, "titleFontSize": 12, "grid": True}
                },
                "color": {"value": "#1f77b4"},
                "tooltip": [
                    {"field": x_field},
                    {"field": y_field, "type": "quantitative", "format": ","}
                ]
            }
        })
        
    elif 'scatter' in chart_type:
        # Scatter plot with size encoding for depth perception
        spec.update({
            "mark": {
                "type": "point",
                "filled": True,
                "tooltip": True,
                "opacity": 0.7
            },
            "encoding": {
                "x": {
                    "field": x_field,
                    "type": "quantitative",
                    "axis": {"title": x_field, "titleFontSize": 12, "grid": True}
                },
                "y": {
                    "field": y_field,
                    "type": "quantitative",
                    "axis": {"title": y_field, "titleFontSize": 12, "grid": True}
                },
                "size": {
                    "field": y_field,
                    "type": "quantitative",
                    "scale": {"range": [100, 1000]},
                    "legend": None
                },
                "color": {
                    "field": y_field,
                    "type": "quantitative",
                    "scale": {"scheme": "viridis"}
                },
                "tooltip": [
                    {"field": x_field, "type": "quantitative"},
                    {"field": y_field, "type": "quantitative", "format": ","}
                ]
            }
        })
        
    elif 'area' in chart_type:
        # Stacked area chart
        spec.update({
            "mark": {
                "type": "area",
                "line": True,
                "point": True,
                "tooltip": True,
                "opacity": 0.7
            },
            "encoding": {
                "x": {
                    "field": x_field,
                    "type": "ordinal",
                    "axis": {"title": x_field, "titleFontSize": 12}
                },
                "y": {
                    "field": y_field,
                    "type": "quantitative",
                    "axis": {"title": y_field, "titleFontSize": 12, "grid": True}
                },
                "color": {"value": "#ff7f0e"},
                "tooltip": [
                    {"field": x_field},
                    {"field": y_field, "type": "quantitative", "format": ","}
                ]
            }
        })
    
    else:
        # Default to enhanced bar chart
        spec.update({
            "mark": {"type": "bar", "tooltip": True, "opacity": 0.8},
            "encoding": {
                "x": {"field": x_field, "type": "nominal", "axis": {"labelAngle": -45}},
                "y": {"field": y_field, "type": "quantitative"},
                "color": {"field": y_field, "type": "quantitative", "scale": {"scheme": "blues"}},
                "tooltip": [{"field": x_field}, {"field": y_field, "format": ","}]
            }
        })
    
    return spec
$$;

-- ============================================================================
-- Create simpler function for direct chart data return
-- ============================================================================
CREATE OR REPLACE FUNCTION CHART_DATA_TO_VEGALITE(
    QUERY_RESULT ARRAY,
    CHART_TYPE VARCHAR,
    X_COL VARCHAR,
    Y_COL VARCHAR,
    TITLE VARCHAR
)
RETURNS OBJECT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.9'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'to_vegalite'
COMMENT = 'Converts query results to Vega-Lite spec for agent inline rendering'
AS
$$
def to_vegalite(query_result, chart_type, x_col, y_col, title):
    """
    Convert query results to Vega-Lite specification
    Returns format that Intelligence Agent can render inline
    """
    
    chart_type = (chart_type or 'bar').lower()
    
    # Build Vega-Lite spec
    spec = {
        "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
        "description": f"{chart_type.title()} chart of {y_col} by {x_col}",
        "title": title or "Data Visualization",
        "data": {"values": query_result},
        "width": "container",
        "height": 400
    }
    
    # Configure based on chart type
    if 'pie' in chart_type:
        # Pie/Donut chart (3D effect via donut hole and gradients)
        spec["mark"] = {
            "type": "arc",
            "innerRadius": 70,  # Creates donut = pseudo-3D
            "stroke": "white",
            "strokeWidth": 2,
            "tooltip": True
        }
        spec["encoding"] = {
            "theta": {"field": y_col, "type": "quantitative"},
            "color": {
                "field": x_col,
                "type": "nominal",
                "scale": {"scheme": "tableau20"},
                "legend": {"orient": "right", "titleFontSize": 14}
            },
            "tooltip": [
                {"field": x_col, "type": "nominal", "title": "Category"},
                {"field": y_col, "type": "quantitative", "title": "Value", "format": ","}
            ]
        }
    
    elif 'bar' in chart_type:
        spec["mark"] = {"type": "bar", "tooltip": True, "cornerRadiusEnd": 3}
        spec["encoding"] = {
            "x": {"field": x_col, "type": "nominal", "axis": {"labelAngle": 0}},
            "y": {"field": y_col, "type": "quantitative", "axis": {"grid": True}},
            "color": {"field": y_col, "type": "quantitative", "scale": {"scheme": "blues"}},
            "tooltip": [{"field": x_col}, {"field": y_col, "format": ","}]
        }
    
    elif 'line' in chart_type:
        spec["mark"] = {"type": "line", "point": True, "tooltip": True, "strokeWidth": 2}
        spec["encoding"] = {
            "x": {"field": x_col, "type": "ordinal"},
            "y": {"field": y_col, "type": "quantitative"},
            "tooltip": [{"field": x_col}, {"field": y_col, "format": ","}]
        }
    
    else:
        # Default bar
        spec["mark"] = "bar"
        spec["encoding"] = {
            "x": {"field": x_col, "type": "nominal"},
            "y": {"field": y_col, "type": "quantitative"}
        }
    
    return spec
$$;

-- ============================================================================
-- Test the inline chart function
-- ============================================================================

-- Test with sample data
SELECT CREATE_INLINE_CHART(
    ARRAY_CONSTRUCT(
        OBJECT_CONSTRUCT('product_family', 'PIC', 'design_wins', 15420),
        OBJECT_CONSTRUCT('product_family', 'AVR', 'design_wins', 12350),
        OBJECT_CONSTRUCT('product_family', 'SAM', 'design_wins', 9870),
        OBJECT_CONSTRUCT('product_family', 'dsPIC', 'design_wins', 6540),
        OBJECT_CONSTRUCT('product_family', 'FPGA', 'design_wins', 4230)
    ),
    'pie',
    'Design Wins by Product Family',
    'product_family',
    'design_wins'
) AS vega_spec;

-- ============================================================================
-- Display success message
-- ============================================================================
SELECT 'Inline chart generation function created successfully' AS status,
       'Agent can now render charts directly in chat using Vega-Lite format' AS info;

