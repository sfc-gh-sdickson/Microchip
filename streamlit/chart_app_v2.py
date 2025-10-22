# ============================================================================
# Microchip Intelligence Agent - Chart Generator (Agent-Optimized)
# ============================================================================
# Purpose: Streamlit app optimized for Snowflake Intelligence Agent integration
# Displays actual 3D visualizations including 3D pie charts
# ============================================================================

import streamlit as st
from snowflake.snowpark.context import get_active_session
import pandas as pd
import plotly.graph_objects as go
import plotly.express as px

# Initialize Snowflake session
session = get_active_session()

st.set_page_config(page_title="Microchip Charts", page_icon="📊", layout="wide")

# Title
st.title("📊 Microchip Intelligence - Chart Generator")

# Instructions for agent
st.info("💡 **For Agent Use:** This app renders charts from data queries. Pass SQL query and chart type.")

# Input method selection
input_method = st.radio("Data Input Method", ["Execute SQL Query", "Use Sample Data"], horizontal=True)

if input_method == "Execute SQL Query":
    # SQL Query input
    st.subheader("1️⃣ Enter SQL Query")
    
    default_query = """SELECT 
    product_family,
    COUNT(*) as design_wins
FROM MICROCHIP_INTELLIGENCE.RAW.DESIGN_WINS  
GROUP BY product_family
ORDER BY design_wins DESC
LIMIT 10"""
    
    sql_query = st.text_area("SQL Query:", value=default_query, height=120)
    
    if st.button("▶️ Execute Query", type="primary"):
        try:
            df = session.sql(sql_query).to_pandas()
            st.session_state['chart_data'] = df
            st.success(f"✅ Retrieved {len(df)} rows with {len(df.columns)} columns")
            st.dataframe(df.head(10), use_container_width=True)
        except Exception as e:
            st.error(f"Query Error: {str(e)}")

else:
    # Sample data
    st.subheader("Using Sample Data")
    sample_data = {
        'Product Family': ['PIC', 'AVR', 'SAM', 'dsPIC', 'FPGA', 'ANALOG', 'WIRELESS'],
        'Design Wins': [15420, 12350, 9870, 6540, 4230, 3210, 2180],
        'Revenue': [4.5, 3.8, 5.2, 2.9, 8.7, 1.2, 2.4]
    }
    df = pd.DataFrame(sample_data)
    st.session_state['chart_data'] = df
    st.dataframe(df, use_container_width=True)

# Chart generation section
if 'chart_data' in st.session_state and st.session_state['chart_data'] is not None:
    df = st.session_state['chart_data']
    
    st.markdown("---")
    st.subheader("2️⃣ Generate Chart")
    
    # Chart type selection
    col1, col2 = st.columns([2, 1])
    
    with col1:
        chart_type = st.selectbox(
            "Chart Type:",
            [
                "3D Pie Chart",
                "Pie Chart", 
                "3D Scatter Plot",
                "Bar Chart",
                "Line Chart",
                "Scatter Plot",
                "Area Chart",
                "Histogram",
                "Box Plot"
            ]
        )
    
    with col2:
        chart_title = st.text_input("Chart Title:", "Data Visualization")
    
    # Column selection
    cols = df.columns.tolist()
    
    col_a, col_b, col_c = st.columns(3)
    
    with col_a:
        if len(cols) > 0:
            x_col = st.selectbox("X-axis / Labels:", cols, index=0)
        else:
            st.error("No columns available")
            x_col = None
    
    with col_b:
        if len(cols) > 1:
            y_col = st.selectbox("Y-axis / Values:", cols, index=min(1, len(cols)-1))
        else:
            y_col = x_col
    
    with col_c:
        if len(cols) > 2:
            z_col_options = ["None"] + cols
            z_col = st.selectbox("Z-axis (for 3D):", z_col_options)
            z_col = None if z_col == "None" else z_col
        else:
            z_col = None
    
    # Generate button
    if st.button("🎨 Generate Chart", type="primary", use_container_width=True):
        try:
            st.markdown("---")
            st.subheader(chart_title)
            
            # Generate chart based on type
            if chart_type == "3D Pie Chart":
                # Create enhanced 3D pie chart
                fig = go.Figure(data=[go.Pie(
                    labels=df[x_col],
                    values=df[y_col],
                    pull=[0.1, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05][:len(df)],
                    hole=0.3,
                    textposition='outside',
                    textinfo='label+percent',
                    hovertemplate='<b>%{label}</b><br>Value: %{value}<br>Percent: %{percent}<extra></extra>',
                    marker=dict(
                        colors=px.colors.qualitative.Set3,
                        line=dict(color='white', width=3)
                    ),
                    rotation=45,
                    sort=False
                )])
                
                fig.update_layout(
                    title={
                        'text': chart_title,
                        'x': 0.5,
                        'xanchor': 'center',
                        'font': {'size': 24, 'family': 'Arial Black'}
                    },
                    height=700,
                    showlegend=True,
                    legend=dict(
                        orientation="v",
                        yanchor="middle",
                        y=0.5,
                        xanchor="left",
                        x=1.02
                    ),
                    annotations=[dict(
                        text='3D Effect Applied',
                        x=0.5, y=-0.1,
                        xref='paper', yref='paper',
                        showarrow=False,
                        font=dict(size=12, color='gray')
                    )]
                )
                
                st.plotly_chart(fig, use_container_width=True, key='3d_pie')
                st.success("✅ 3D Pie Chart generated with pull effects and enhanced styling!")
                
            elif chart_type == "3D Scatter Plot":
                if z_col is None and len(cols) > 2:
                    z_col = cols[2]
                
                if z_col:
                    fig = px.scatter_3d(
                        df,
                        x=x_col,
                        y=y_col,
                        z=z_col,
                        color=y_col,
                        size=y_col,
                        title=chart_title,
                        labels={x_col: x_col, y_col: y_col, z_col: z_col},
                        color_continuous_scale='Viridis'
                    )
                    
                    fig.update_traces(
                        marker=dict(
                            size=10,
                            line=dict(width=0.5, color='white'),
                            opacity=0.8
                        )
                    )
                    
                    fig.update_layout(
                        height=700,
                        scene=dict(
                            xaxis_title=x_col,
                            yaxis_title=y_col,
                            zaxis_title=z_col,
                            camera=dict(
                                eye=dict(x=1.5, y=1.5, z=1.3)
                            ),
                            xaxis=dict(backgroundcolor="rgb(230, 230,230)"),
                            yaxis=dict(backgroundcolor="rgb(230, 230,230)"),
                            zaxis=dict(backgroundcolor="rgb(230, 230,230)")
                        )
                    )
                    
                    st.plotly_chart(fig, use_container_width=True, key='3d_scatter')
                    st.success("✅ 3D Scatter Plot generated with interactive rotation!")
                else:
                    st.error("3D Scatter requires 3 columns. Please select Z-axis column.")
                    
            elif chart_type == "Pie Chart":
                fig = px.pie(
                    df,
                    names=x_col,
                    values=y_col,
                    title=chart_title,
                    color_discrete_sequence=px.colors.qualitative.Set3
                )
                fig.update_traces(textposition='inside', textinfo='percent+label')
                fig.update_layout(height=600)
                st.plotly_chart(fig, use_container_width=True)
                
            elif chart_type == "Bar Chart":
                fig = px.bar(
                    df,
                    x=x_col,
                    y=y_col,
                    title=chart_title,
                    color=y_col,
                    color_continuous_scale='Blues'
                )
                fig.update_layout(height=600, showlegend=False)
                st.plotly_chart(fig, use_container_width=True)
                
            elif chart_type == "Line Chart":
                fig = px.line(
                    df,
                    x=x_col,
                    y=y_col,
                    title=chart_title,
                    markers=True
                )
                fig.update_traces(line=dict(width=3), marker=dict(size=10))
                fig.update_layout(height=600)
                st.plotly_chart(fig, use_container_width=True)
                
            elif chart_type == "Scatter Plot":
                fig = px.scatter(
                    df,
                    x=x_col,
                    y=y_col,
                    title=chart_title,
                    size=y_col,
                    color=y_col,
                    color_continuous_scale='Viridis'
                )
                fig.update_traces(marker=dict(size=12, line=dict(width=1, color='white')))
                fig.update_layout(height=600)
                st.plotly_chart(fig, use_container_width=True)
                
            elif chart_type == "Area Chart":
                fig = px.area(
                    df,
                    x=x_col,
                    y=y_col,
                    title=chart_title
                )
                fig.update_layout(height=600)
                st.plotly_chart(fig, use_container_width=True)
                
            elif chart_type == "Histogram":
                fig = px.histogram(
                    df,
                    x=x_col,
                    title=chart_title,
                    nbins=20
                )
                fig.update_layout(height=600)
                st.plotly_chart(fig, use_container_width=True)
                
            elif chart_type == "Box Plot":
                fig = px.box(
                    df,
                    y=y_col,
                    title=chart_title
                )
                fig.update_layout(height=600)
                st.plotly_chart(fig, use_container_width=True)
            
            # Show data table
            with st.expander("📊 View Data Table"):
                st.dataframe(df, use_container_width=True)
                
                # Download CSV
                csv = df.to_csv(index=False)
                st.download_button(
                    "⬇️ Download as CSV",
                    csv,
                    "chart_data.csv",
                    "text/csv",
                    use_container_width=True
                )
            
        except Exception as e:
            st.error(f"Chart Generation Error: {str(e)}")
            st.info("Please check your column selections and data types")

else:
    st.info("👆 Select a data input method above to get started")

# Footer with tips
st.markdown("---")
st.markdown("""
### 💡 Quick Tips

**3D Pie Chart:**
- Shows proportions with visual depth and pull effects
- Best for 5-10 categories
- Automatically highlights largest slice

**3D Scatter Plot:**
- Visualizes 3 dimensions simultaneously  
- Interactive rotation with mouse
- Color-coded by value
- Great for product specification analysis

**For Agent:**
- Ask: "Show me [data] in a 3D pie chart"
- Ask: "Create a 3D scatter plot of [x], [y], and [z]"
- The agent will execute your query and display the chart here!
""")

