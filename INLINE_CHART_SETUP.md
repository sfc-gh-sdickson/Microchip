# Setting Up Inline Charts in Your Intelligence Agent

## Quick Setup Guide

Follow these steps to enable inline chart rendering in your Microchip Intelligence Agent.

---

## Step 1: Execute the Chart Functions

Run this SQL file in Snowflake:

```sql
-- Execute this file
@sql/tools/09_agent_inline_charts.sql
```

This creates 4 chart generation functions:
- `GENERATE_DONUT_CHART()` - Enhanced donut/pie charts
- `GENERATE_BAR_CHART()` - Gradient bar charts
- `GENERATE_LINE_CHART()` - Trend line charts
- `GENERATE_AREA_CHART()` - Area charts

**Execution time:** < 5 seconds

---

## Step 2: Grant Permissions

```sql
USE ROLE ACCOUNTADMIN;

GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_DONUT_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_BAR_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_LINE_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_AREA_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
```

Replace `<your_role>` with your actual role name.

---

## Step 3: Add Functions as Agent Tools

### Option A: Via Snowsight UI

1. Open your Intelligence Agent in Snowsight
2. Go to **Tools** section
3. Click **+ Add** → Select **Function**
4. Add each function:

**Function 1: GENERATE_DONUT_CHART**
- Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_DONUT_CHART`
- Description:
  ```
  Creates enhanced donut pie charts for inline display. Use when users request:
  - Pie charts
  - Donut charts  
  - "3D pie charts" (donut style is closest to 3D for inline rendering)
  
  Parameters:
  - data_json: JSON string of data array
  - label_field: Column name for categories/labels
  - value_field: Column name for values
  - chart_title: Title for the chart
  
  Returns Vega-Lite spec that renders inline in chat.
  ```

**Function 2: GENERATE_BAR_CHART**
- Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_BAR_CHART`
- Description:
  ```
  Creates gradient bar charts for comparisons. Use for comparing categories.
  Returns Vega-Lite spec for inline rendering.
  ```

**Function 3: GENERATE_LINE_CHART**
- Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_LINE_CHART`
- Description:
  ```
  Creates line charts for trends over time. Returns Vega-Lite spec for inline rendering.
  ```

**Function 4: GENERATE_AREA_CHART**
- Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_AREA_CHART`
- Description:
  ```
  Creates area charts for cumulative trends. Returns Vega-Lite spec for inline rendering.
  ```

---

## Step 4: Test Inline Charts

Ask your agent these questions:

### Test 1: Donut Chart
```
"Show me design wins by product family in a pie chart"
```

**Expected:** Agent queries data and displays an enhanced donut chart **inline**

### Test 2: Bar Chart
```
"Display top 10 distributors by revenue as a bar chart"
```

**Expected:** Agent shows gradient bar chart **inline**

### Test 3: Line Chart
```
"Show me monthly revenue trends for the past year as a line chart"
```

**Expected:** Agent displays line chart with markers **inline**

### Test 4: "3D" Request
```
"Show me design wins in a 3D pie chart"
```

**Expected:** Agent uses `GENERATE_DONUT_CHART()` and explains:
```
"Here's an enhanced donut chart showing design wins by product family 
(donut style provides the closest to 3D appearance for inline display)..."

[Displays donut chart inline with gradient colors and center hole]
```

---

## How It Works

### User Request Flow:

```
User: "Show me design wins in a 3D pie chart"
    ↓
Agent: Queries SV_DESIGN_ENGINEERING_INTELLIGENCE
    ↓
Agent: Gets data (product_family, count)
    ↓
Agent: Converts to JSON format
    ↓
Agent: Calls GENERATE_DONUT_CHART(json, 'product_family', 'design_wins', 'Title')
    ↓
Agent: Receives Vega-Lite specification
    ↓
Agent: Displays chart INLINE in chat ✅
    ↓
User: Sees enhanced donut chart immediately!
```

---

## What Charts Look Like Inline

### Enhanced Donut Chart (Pseudo-3D)
```
     ╔════════════════════════╗
     ║  Design Wins by Family ║
     ╠════════════════════════╣
     ║                        ║
     ║     ┌─────────┐       ║
     ║    ╱   PIC    ╲       ║
     ║   │  35% Blue  │      ║
     ║   │  ┌─────┐  │      ║
     ║  AVR│ Donut│SAM      ║
     ║  28%│ Hole │22%      ║
     ║   │  └─────┘  │      ║
     ║   │ dsPIC 15% │      ║
     ║    ╲───────────╱       ║
     ║                        ║
     ║  Interactive tooltips  ║
     ║  Gradient colors       ║
     ╚════════════════════════╝
```

- Center donut hole creates depth perception
- Gradient colors enhance visual appeal
- White borders separate slices
- Interactive hover tooltips
- **Displays immediately in agent chat**

---

## Advantages of Inline Charts

✅ **Immediate display** - No separate windows  
✅ **Context preserved** - Chart stays with conversation  
✅ **Simple UX** - Just ask, chart appears  
✅ **Mobile friendly** - Works in agent on any device  
✅ **Fast** - No additional loading time

---

## Limitations to Understand

❌ **Not true 3D** - Can't rotate with mouse  
❌ **No z-axis** - Limited to 2D plane  
❌ **Vega-Lite only** - Platform constraint

**But:** You get professional-looking charts **inline** which is what you requested!

---

## Troubleshooting

### Charts Not Appearing

**Check:**
1. Did you execute `09_agent_inline_charts.sql`?
2. Did you grant permissions to your role?
3. Did you add functions as tools in agent?
4. Is agent calling the functions (check tool usage)?

### Wrong Chart Type Showing

**Fix:**
- Make sure agent description mentions which function for which chart type
- Update agent instructions to map requests to correct functions

---

## Ready to Use!

Once you complete Steps 1-3 above, your agent will be able to:

✅ Display donut charts inline when you ask for "pie" or "3D pie"  
✅ Show bar charts inline for comparisons  
✅ Render line charts inline for trends  
✅ Display area charts inline for cumulative data

**All rendering directly in the agent chat interface!**

---

**Created:** October 22, 2025  
**Status:** Ready for deployment  
**Approach:** Enhanced Vega-Lite for best inline appearance


