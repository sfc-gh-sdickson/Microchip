# ============================================================================
# Microchip Intelligence Agent - Streamlit Chart Generator
# ============================================================================
# Purpose: Streamlit app that generates charts from agent queries
# Runs entirely within Snowflake - no external dependencies
# Supports agent invocation with parameters
# ============================================================================

import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from snowflake.snowpark.context import get_active_session
import json

# Get Snowflake session
session = get_active_session()

# Check if invoked by agent with parameters
agent_params = st.experimental_get_query_params()

st.set_page_config(
    page_title="Microchip Intelligence Charts",
    page_icon="📊",
    layout="wide"
)

# Check if agent invoked with data
agent_mode = False
agent_data = None
agent_chart_type = None

if 'data' in agent_params and 'chart_type' in agent_params:
    agent_mode = True
    try:
        agent_data = json.loads(agent_params['data'][0])
        agent_chart_type = agent_params['chart_type'][0]
    except:
        agent_mode = False

if agent_mode and agent_data:
    # Agent-invoked mode - show chart immediately
    st.title(f"📊 {agent_chart_type.title()}")
    df = pd.DataFrame(agent_data)
    
    # Auto-detect columns
    cols = df.columns.tolist()
    x_col = cols[0] if len(cols) > 0 else None
    y_col = cols[1] if len(cols) > 1 else None
    z_col = cols[2] if len(cols) > 2 else None
    color_col = cols[2] if len(cols) > 2 and 'pie' not in agent_chart_type.lower() else None
    
    # Generate chart based on agent request
    chart_type_lower = agent_chart_type.lower()
    
    if '3d' in chart_type_lower and 'pie' in chart_type_lower:
        # 3D Pie Chart with pull effect
        fig = go.Figure(data=[go.Pie(
            labels=df[x_col],
            values=df[y_col],
            pull=[0.1] * len(df),
            hole=0.3,
            textposition='auto',
            textinfo='label+percent+value',
            marker=dict(line=dict(color='white', width=2))
        )])
        fig.update_layout(
            title=f"{x_col} Distribution",
            height=700,
            showlegend=True,
            scene=dict(
                camera=dict(eye=dict(x=1.5, y=1.5, z=1.5))
            )
        )
        
    elif '3d' in chart_type_lower and 'scatter' in chart_type_lower and len(cols) >= 3:
        # 3D Scatter Plot
        fig = px.scatter_3d(
            df, 
            x=x_col, 
            y=y_col, 
            z=z_col,
            color=color_col,
            title=f"3D Scatter: {x_col} vs {y_col} vs {z_col}",
            height=700
        )
        fig.update_traces(marker=dict(size=8))
        
    elif 'pie' in chart_type_lower:
        fig = px.pie(df, names=x_col, values=y_col, title=f"{x_col} Distribution", height=600)
        
    elif 'bar' in chart_type_lower or 'column' in chart_type_lower:
        fig = px.bar(df, x=x_col, y=y_col, color=color_col, title=f"{y_col} by {x_col}", height=600)
        
    elif 'line' in chart_type_lower:
        fig = px.line(df, x=x_col, y=y_col, color=color_col, title=f"{y_col} Trend", markers=True, height=600)
        
    elif 'scatter' in chart_type_lower:
        fig = px.scatter(df, x=x_col, y=y_col, color=color_col, size=y_col, title=f"{x_col} vs {y_col}", height=600)
        
    elif 'area' in chart_type_lower:
        fig = px.area(df, x=x_col, y=y_col, color=color_col, title=f"{y_col} Area", height=600)
        
    else:
        # Default to bar chart
        fig = px.bar(df, x=x_col, y=y_col, title="Data Visualization", height=600)
    
    # Display the chart
    st.plotly_chart(fig, use_container_width=True)
    
    # Show data table
    with st.expander("📋 View Source Data"):
        st.dataframe(df, use_container_width=True)
        
else:
    # Interactive mode - manual chart creation
    st.title("📊 Microchip Intelligence Agent - Chart Generator")
    st.markdown("Generate interactive charts from your data queries")

# Sidebar for chart configuration
with st.sidebar:
    st.header("Chart Configuration")
    
    chart_type = st.selectbox(
        "Chart Type",
        [
            "Bar Chart",
            "Pie Chart",
            "3D Pie Chart",
            "Line Chart",
            "Scatter Plot",
            "3D Scatter Plot",
            "Area Chart",
            "Histogram",
            "Box Plot",
            "Heatmap"
        ]
    )
    
    st.markdown("---")
    st.markdown("### Quick Start")
    st.markdown("""
    1. Enter a SQL query
    2. Select chart type
    3. Configure axes
    4. Click Generate Chart
    """)

# Main content area
col1, col2 = st.columns([2, 1])

with col1:
    st.subheader("SQL Query")
    default_query = """SELECT 
    product_family,
    COUNT(*) as design_wins
FROM MICROCHIP_INTELLIGENCE.RAW.DESIGN_WINS
GROUP BY product_family
ORDER BY design_wins DESC
LIMIT 10"""
    
    sql_query = st.text_area(
        "Enter your SQL query:",
        value=default_query,
        height=150
    )

with col2:
    st.subheader("Chart Settings")
    chart_title = st.text_input("Chart Title", "Data Visualization")
    
    if st.button("🔄 Preview Data", use_container_width=True):
        try:
            df = session.sql(sql_query).to_pandas()
            st.dataframe(df.head(), use_container_width=True)
            st.success(f"✅ Query returned {len(df)} rows")
        except Exception as e:
            st.error(f"Query Error: {str(e)}")

# Generate chart button
if st.button("📊 Generate Chart", type="primary", use_container_width=True):
    try:
        # Execute query
        with st.spinner("Executing query..."):
            df = session.sql(sql_query).to_pandas()
        
        if df.empty:
            st.warning("Query returned no data")
        else:
            st.success(f"✅ Retrieved {len(df)} rows")
            
            # Column selection
            st.subheader("Configure Chart Axes")
            cols = df.columns.tolist()
            
            col_a, col_b, col_c = st.columns(3)
            
            with col_a:
                x_col = st.selectbox("X-axis", cols, index=0)
            
            with col_b:
                y_col = st.selectbox("Y-axis", cols, index=min(1, len(cols)-1))
            
            with col_c:
                color_col = st.selectbox("Color by (optional)", ["None"] + cols)
                color_col = None if color_col == "None" else color_col
            
            # Generate chart based on type
            st.subheader(chart_title)
            
            try:
                if chart_type == "Bar Chart":
                    fig = px.bar(df, x=x_col, y=y_col, color=color_col, title=chart_title)
                    
                elif chart_type == "Pie Chart":
                    fig = px.pie(df, names=x_col, values=y_col, title=chart_title)
                    
                elif chart_type == "3D Pie Chart":
                    # Create 3D-style pie chart with pull effect
                    fig = go.Figure(data=[go.Pie(
                        labels=df[x_col],
                        values=df[y_col],
                        pull=[0.1] * len(df),  # Pull all slices slightly
                        hole=0.3,  # Donut style
                        textposition='inside',
                        textinfo='label+percent'
                    )])
                    fig.update_layout(title=chart_title)
                    
                elif chart_type == "Line Chart":
                    fig = px.line(df, x=x_col, y=y_col, color=color_col, 
                                 title=chart_title, markers=True)
                    
                elif chart_type == "Scatter Plot":
                    fig = px.scatter(df, x=x_col, y=y_col, color=color_col,
                                    title=chart_title, size=y_col if y_col else None)
                    
                elif chart_type == "3D Scatter Plot":
                    if len(cols) >= 3:
                        z_col = st.selectbox("Z-axis", cols, index=min(2, len(cols)-1))
                        fig = px.scatter_3d(df, x=x_col, y=y_col, z=z_col, 
                                           color=color_col, title=chart_title)
                    else:
                        st.error("3D Scatter requires at least 3 columns")
                        fig = None
                    
                elif chart_type == "Area Chart":
                    fig = px.area(df, x=x_col, y=y_col, color=color_col, title=chart_title)
                    
                elif chart_type == "Histogram":
                    fig = px.histogram(df, x=x_col, color=color_col, title=chart_title)
                    
                elif chart_type == "Box Plot":
                    fig = px.box(df, x=x_col, y=y_col, color=color_col, title=chart_title)
                    
                elif chart_type == "Heatmap":
                    # For heatmap, try to create a pivot table
                    if len(cols) >= 3:
                        pivot_col = st.selectbox("Pivot by", cols, index=min(2, len(cols)-1))
                        pivot_df = df.pivot_table(values=y_col, index=x_col, 
                                                   columns=pivot_col, aggfunc='sum')
                        fig = px.imshow(pivot_df, title=chart_title, aspect="auto")
                    else:
                        st.error("Heatmap requires at least 3 columns")
                        fig = None
                
                # Display chart
                if fig:
                    fig.update_layout(
                        height=600,
                        showlegend=True,
                        hovermode='closest'
                    )
                    st.plotly_chart(fig, use_container_width=True)
                    
                    # Show data table below chart
                    with st.expander("📋 View Data Table"):
                        st.dataframe(df, use_container_width=True)
                        
                        # Download options
                        csv = df.to_csv(index=False)
                        st.download_button(
                            label="⬇️ Download Data as CSV",
                            data=csv,
                            file_name="chart_data.csv",
                            mime="text/csv"
                        )
                        
            except Exception as chart_error:
                st.error(f"Chart Generation Error: {str(chart_error)}")
                st.info("Please check your column selections and data types")
            
    except Exception as e:
        st.error(f"Error: {str(e)}")
        st.info("Please check your SQL query syntax")

# Footer
st.markdown("---")
st.markdown("""
### 💡 Tips for Great Charts
- **Pie Charts**: Use for showing proportions (limited categories work best)
- **Bar Charts**: Great for comparing categories
- **Line Charts**: Perfect for trends over time
- **Scatter Plots**: Show relationships between variables
- **3D Charts**: Visualize three dimensions of data

For best results, ensure your query returns appropriate data types for the selected chart.
""")

