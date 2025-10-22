# Microchip Intelligence Agent - Chart Generation Tool

## Overview

This chart generation tool allows users to request visualizations directly from the Snowflake Intelligence Agent using natural language like:
- "Show me this data in a 3D pie chart"
- "Create a bar chart of design wins by product family"
- "Display revenue trends as a line chart"

**100% Snowflake-native** - No external services or 3rd party products required!

---

## Components

### 1. SQL Functions (`sql/tools/07_create_chart_function.sql`)

Two Python UDFs that run entirely within Snowflake:

**`GENERATE_CHART_SPEC()`**
- Generates chart configuration specifications
- Supports 10+ chart types
- Returns JSON specification for rendering

**`CREATE_AGENT_CHART()`**
- Processes query results into charts
- Handles data formatting
- Returns status messages

### 2. Streamlit App (`streamlit/chart_app.py`)

Interactive chart generator running in Snowflake:
- Executes SQL queries
- Configures chart parameters
- Generates interactive visualizations using Plotly
- Provides data download capabilities

---

## Supported Chart Types

| Chart Type | Use Case | Example Request |
|------------|----------|-----------------|
| **Bar Chart** | Compare categories | "Show distributor revenue as a bar chart" |
| **Pie Chart** | Show proportions | "Display design wins by product family in a pie chart" |
| **3D Pie Chart** | Enhanced proportions | "Create a 3D pie chart of customer segments" |
| **Line Chart** | Trends over time | "Show monthly revenue trends in a line chart" |
| **Scatter Plot** | Relationships | "Plot price vs. flash size as a scatter chart" |
| **3D Scatter Plot** | 3-variable relationships | "Show 3D scatter of price, flash, and RAM" |
| **Area Chart** | Cumulative trends | "Display cumulative orders as an area chart" |
| **Histogram** | Distribution | "Show order amount distribution as histogram" |
| **Box Plot** | Statistical summary | "Create box plot of ticket resolution times" |
| **Heatmap** | Pattern analysis | "Show heatmap of orders by month and region" |

---

## Installation Steps

### Step 1: Execute SQL Script
```sql
-- Run in Snowflake
@sql/tools/07_create_chart_function.sql
```

### Step 2: Deploy Streamlit App

1. In Snowsight, go to **Streamlit** → **+ Streamlit App**
2. Configure:
   - Name: `MICROCHIP_CHART_GENERATOR`
   - Database: `MICROCHIP_INTELLIGENCE`
   - Schema: `ANALYTICS`
   - Warehouse: `MICROCHIP_WH`
3. Copy contents of `streamlit/chart_app.py` into the editor
4. Click **Run**

### Step 3: Add to Intelligence Agent

1. Open your Intelligence Agent
2. Go to **Tools** → **Streamlit** → **+ Add**
3. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.MICROCHIP_CHART_GENERATOR`
4. Add description (see AGENT_SETUP.md Step 4.3)
5. Save

### Step 4: Grant Permissions
```sql
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_CHART_SPEC(...) TO ROLE <your_role>;
GRANT USAGE ON PROCEDURE MICROCHIP_INTELLIGENCE.ANALYTICS.CREATE_AGENT_CHART(...) TO ROLE <your_role>;
GRANT USAGE ON STREAMLIT MICROCHIP_INTELLIGENCE.ANALYTICS.MICROCHIP_CHART_GENERATOR TO ROLE <your_role>;
```

---

## Usage Examples

### Example 1: Simple Pie Chart
**User Request:**
```
Show me design wins by product family in a pie chart
```

**What Happens:**
1. Agent queries `SV_DESIGN_ENGINEERING_INTELLIGENCE` for design wins by product family
2. Agent calls Streamlit chart tool with:
   - Chart type: "pie"
   - Data: Product family and counts
3. Streamlit generates interactive pie chart
4. User sees visualization in the agent interface

### Example 2: 3D Pie Chart with Revenue
**User Request:**
```
Create a 3D pie chart showing revenue by customer segment
```

**What Happens:**
1. Agent queries `SV_SALES_REVENUE_INTELLIGENCE` for revenue by segment
2. Chart tool creates 3D pie with pull effects
3. Interactive chart displays with percentages and labels

### Example 3: Trend Line Chart
**User Request:**
```
Show me monthly order trends for the past year as a line chart
```

**What Happens:**
1. Agent queries orders data grouped by month
2. Line chart displays with markers showing trend
3. User can hover for exact values

### Example 4: 3D Scatter Plot
**User Request:**
```
Display a 3D scatter plot of product price, flash memory, and RAM size
```

**What Happens:**
1. Agent queries product catalog
2. 3D scatter plot shows three dimensions
3. Interactive rotation and zoom available

---

## Technical Architecture

```
User Request
    ↓
Intelligence Agent
    ↓
├─→ Cortex Analyst (queries data from semantic views)
    ↓
├─→ Chart Tool Detection (recognizes "chart", "plot", "graph")
    ↓
└─→ Streamlit App Call
        ↓
    ┌───────────────────┐
    │  Streamlit App    │
    │  (Snowflake)      │
    │                   │
    │  1. Execute SQL   │
    │  2. Process data  │
    │  3. Generate chart│
    │  4. Return visual │
    └───────────────────┘
        ↓
    User sees interactive chart
```

---

## Features

### Interactive Charts
- ✅ Zoom and pan
- ✅ Hover for details
- ✅ Click to filter
- ✅ Download as image

### Data Export
- ✅ Download as CSV
- ✅ View raw data table
- ✅ Copy to clipboard

### Customization
- ✅ Custom titles
- ✅ Axis labels
- ✅ Color schemes
- ✅ Multiple series

---

## Best Practices

### 1. Query Optimization
- Limit data to relevant time periods
- Use aggregations for large datasets
- Include appropriate filters

### 2. Chart Selection
- **Pie charts**: Best with < 10 categories
- **Line charts**: Perfect for time series
- **Scatter plots**: Show correlations
- **Bar charts**: Great for comparisons

### 3. Data Preparation
- Ensure proper column names
- Use meaningful labels
- Format numbers appropriately
- Handle NULL values

---

## Troubleshooting

### Chart Not Appearing
**Problem**: User requests chart but nothing displays

**Solutions:**
1. Verify Streamlit app is deployed and running
2. Check permissions on the Streamlit app
3. Confirm agent has Streamlit tool configured
4. Check warehouse is active

### Data Type Errors
**Problem**: "Cannot create chart with this data"

**Solutions:**
1. Ensure numeric columns for Y-axis
2. Verify column names match query results
3. Check for NULL or invalid values

### Performance Issues
**Problem**: Chart takes long time to generate

**Solutions:**
1. Limit result set size (use LIMIT clause)
2. Use appropriate warehouse size
3. Optimize underlying queries
4. Consider data aggregation

---

## Example Queries

### Design Win Analysis
```sql
-- Query the agent might generate
SELECT 
    product_family,
    COUNT(*) as design_wins
FROM MICROCHIP_INTELLIGENCE.RAW.DESIGN_WINS
WHERE design_status = 'IN_PRODUCTION'
GROUP BY product_family
ORDER BY design_wins DESC
LIMIT 10
```

### Revenue Trends
```sql
-- Monthly revenue trend
SELECT 
    DATE_TRUNC('month', order_date) as month,
    SUM(order_amount) as revenue
FROM MICROCHIP_INTELLIGENCE.RAW.ORDERS
WHERE order_date >= DATEADD('month', -12, CURRENT_DATE())
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month
```

### Product Specifications 3D
```sql
-- 3D scatter data
SELECT 
    product_name,
    unit_price,
    flash_size_kb,
    ram_size_kb
FROM MICROCHIP_INTELLIGENCE.RAW.PRODUCT_CATALOG
WHERE is_active = TRUE
AND product_type = 'MCU'
LIMIT 50
```

---

## Extending the Tool

### Add New Chart Types

Edit `streamlit/chart_app.py`:

```python
elif chart_type == "Your New Chart":
    fig = px.your_chart_function(df, x=x_col, y=y_col, 
                                  color=color_col, title=chart_title)
```

### Customize Appearance

Update Plotly figure layout:

```python
fig.update_layout(
    font_family="Arial",
    font_color="blue",
    title_font_size=24,
    plot_bgcolor="white"
)
```

### Add Data Transformations

Pre-process data before charting:

```python
# Add calculated columns
df['profit_margin'] = (df['revenue'] - df['cost']) / df['revenue'] * 100

# Filter data
df = df[df['region'] == 'NORTH_AMERICA']
```

---

## Security Considerations

### Data Access
- Charts only show data user has permission to query
- Semantic views enforce row-level security
- Streamlit app uses user's session credentials

### Permissions
- Users need SELECT on semantic views
- Users need USAGE on Streamlit app
- Users need USAGE on warehouse

### Compliance
- All data stays within Snowflake
- No external API calls
- Audit logs track all queries

---

## Performance Tips

1. **Use aggregations**: Don't chart raw data, aggregate first
2. **Limit results**: Use TOP/LIMIT for large datasets
3. **Cache queries**: Streamlit caches results automatically
4. **Right-size warehouse**: X-SMALL is fine for most charts
5. **Index columns**: Ensure queried columns are indexed

---

## Support

For issues or questions:
1. Check Streamlit app logs in Snowflake
2. Verify SQL query syntax
3. Review agent tool configuration
4. Check warehouse status
5. Validate data types

---

**Version**: 1.0  
**Created**: October 2025  
**Requires**: Snowflake account with Cortex Intelligence and Streamlit enabled

**100% Snowflake-Native - Zero External Dependencies!** ✅


