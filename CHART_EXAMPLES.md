# Microchip Intelligence Agent - Chart Request Examples

Quick reference for requesting visualizations from the agent. All charts run 100% in Snowflake with no external dependencies.

---

## 📊 Simple Chart Requests

### Pie Charts
```
"Show me design wins by product family in a pie chart"

"Display revenue by customer segment as a pie chart"

"Create a pie chart of distributor market share"
```

### 3D Pie Charts
```
"Show me this data in a 3D pie chart"

"Create a 3D pie chart of revenue by customer segment"

"Display design wins by industry vertical as a 3D pie chart"
```

### Bar Charts
```
"Show distributor performance as a bar chart"

"Display top 10 products by revenue in a bar chart"

"Create a bar chart comparing design win rates by product family"
```

### Line Charts
```
"Show monthly revenue trends as a line chart for the past 12 months"

"Display order volume trends in a line chart"

"Create a line chart showing design wins over time"
```

---

## 📈 Advanced Chart Requests

### Scatter Plots
```
"Show me a scatter plot of product price versus flash memory size"

"Create a scatter plot showing design win volume and production conversion rate"

"Display quality issues by affected quantity as a scatter plot"
```

### 3D Scatter Plots
```
"Create a 3D scatter plot showing product price, flash size, and RAM size"

"Display a 3D scatter of customer lifetime value, order count, and support tickets"

"Show me design wins in 3D: estimated volume, unit price, and production status"
```

### Area Charts
```
"Display cumulative revenue as an area chart by month"

"Show production order trends as a stacked area chart by product type"

"Create an area chart of support tickets over time by priority level"
```

### Box Plots
```
"Create a box plot of support ticket resolution times by category"

"Show me a box plot of order amounts by customer segment"

"Display quality issue resolution time distribution as a box plot"
```

### Histograms
```
"Show distribution of order amounts as a histogram"

"Create a histogram of design win estimated volumes"

"Display customer lifetime value distribution in a histogram"
```

### Heatmaps
```
"Create a heatmap showing orders by month and region"

"Display quality issues as a heatmap by product family and severity"

"Show design win conversion rates in a heatmap by industry and product type"
```

---

## 🎯 Combined Analysis + Chart Requests

### Analysis with Visualization
```
"What are the top 10 products by design wins? Show me in a bar chart."

"Analyze revenue by distributor and display as a 3D pie chart."

"Which customer segments have the highest lifetime value? Create a pie chart."

"Show me monthly order trends for automotive customers in a line chart."

"What are the most common quality issues by product family? Display in a bar chart."
```

### Comparative Analysis
```
"Compare direct sales versus distributor sales in a pie chart"

"Show certified versus non-certified engineer design win rates as a bar chart"

"Display competitive win rates by competitor in a bar chart"

"Compare support ticket resolution times by ticket type in a box plot"
```

### Trend Analysis
```
"Show me the trend of production orders over the past 6 months as a line chart"

"Display design win conversion rates by quarter in a line chart"

"Create an area chart showing cumulative revenue growth by product family"
```

---

## 💡 Pro Tips

### Get Better Charts

**Be Specific About Time Periods:**
```
✅ "Show revenue trends for the past 12 months in a line chart"
❌ "Show revenue in a chart"
```

**Specify Top N for Clarity:**
```
✅ "Display top 10 products by design wins in a bar chart"
❌ "Show all products in a chart"
```

**Name Your Metrics:**
```
✅ "Create a scatter plot of unit price vs flash size for MCU products"
❌ "Make a scatter plot"
```

**Combine Filters with Charts:**
```
✅ "Show design wins for automotive industry in a pie chart by product family"
❌ "Chart design wins"
```

---

## 🎨 Chart Type Selection Guide

| Want to Show | Best Chart Type | Example |
|--------------|----------------|---------|
| **Proportions** | Pie or 3D Pie | "Revenue share by segment in a 3D pie chart" |
| **Comparisons** | Bar Chart | "Compare distributors by revenue in a bar chart" |
| **Trends** | Line or Area | "Monthly order trends as a line chart" |
| **Relationships** | Scatter | "Plot price vs. memory as scatter chart" |
| **Distributions** | Histogram or Box | "Order amount distribution as histogram" |
| **3D Relationships** | 3D Scatter | "Show price, flash, RAM in 3D scatter plot" |
| **Patterns** | Heatmap | "Orders by region and month as heatmap" |
| **Rankings** | Bar Chart | "Top 10 customers by revenue in bar chart" |

---

## 🔍 Combining Search + Charts

### Support Analysis with Visualization
```
"How many I2C-related support tickets do we have? Show me the breakdown by product family in a pie chart."

"Find quality issues about flash memory. Display severity distribution as a bar chart."

"Search application notes about motor control. How many are there by product family? Chart it."
```

### Quality + Trends
```
"Show me quality issue trends over the past year as a line chart, broken down by severity."

"What products have the most RMAs? Display in a bar chart with affected quantities."
```

---

## ⚙️ Technical Details

### How It Works

1. **User Request**: "Show me design wins in a 3D pie chart"
2. **Agent Processes**:
   - Recognizes chart request
   - Queries appropriate semantic view
   - Extracts data needed for chart
3. **Chart Tool Invoked**:
   - Receives data from agent
   - Identifies chart type (3D pie)
   - Configures chart parameters
4. **Streamlit Renders**:
   - Generates Plotly visualization
   - Makes it interactive
   - Returns to user

### Data Flow
```
User Question
    ↓
Intelligence Agent
    ↓
Cortex Analyst (queries semantic views)
    ↓
Data Result
    ↓
Chart Tool Recognition
    ↓
Streamlit Chart App
    ↓
Interactive Plotly Chart
    ↓
User Sees Visualization
```

---

## 📝 Example Conversation

**User:** "Which products are winning the most automotive designs?"

**Agent:** "Based on SV_DESIGN_ENGINEERING_INTELLIGENCE, here are the top products:
- SAM D21: 4,523 design wins
- PIC18F47Q10: 3,891 design wins  
- dsPIC33CK: 2,765 design wins
- SAMA5D27: 2,234 design wins"

**User:** "Show me that in a 3D pie chart"

**Agent:** *[Calls Streamlit chart tool]*
*[Displays interactive 3D pie chart with the data]*

**User:** "Great! Now show me the revenue trends for these products over the past year."

**Agent:** *[Queries revenue data]*
*[Shows line chart with 4 series, one per product]*

---

## 🚀 Advanced Usage

### Custom Chart Titles
```
"Create a bar chart titled 'Q4 2025 Distributor Performance' showing revenue by distributor"
```

### Multi-Series Charts
```
"Show me a line chart with revenue trends for PIC, AVR, and SAM families over 12 months"
```

### Filtered Data
```
"Display design wins for customers with >$1M lifetime value in a scatter plot of volume vs. value"
```

### Comparative Analysis
```
"Create side-by-side bar charts comparing certified vs non-certified engineer performance"
```

---

## ✅ Verification

All chart functionality is:
- ✅ 100% Snowflake-native (Streamlit in Snowflake)
- ✅ No external API calls
- ✅ No 3rd party products
- ✅ Uses Snowpark Python (included in Snowflake)
- ✅ Uses Plotly (included in Snowflake Streamlit)
- ✅ Runs on Snowflake compute (your warehouse)
- ✅ Data never leaves Snowflake

---

**Created:** October 2025  
**Version:** 1.0  
**Requirement:** "All of it would need to run in Snowflake with no outside calls to 3rd party products" ✅


