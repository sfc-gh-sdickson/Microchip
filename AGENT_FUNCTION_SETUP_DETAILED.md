# Step-by-Step: Adding Chart Functions to Your Intelligence Agent

## Complete UI Click-by-Click Instructions

**Time required:** 10 minutes  
**Prerequisite:** You've executed `sql/tools/09_agent_inline_charts.sql` and granted permissions

---

## Step 1: Navigate to Your Agent

1. Open Snowflake Snowsight in your browser
2. In the left navigation menu, click **AI & ML**
3. Click **Agents**
4. Find and click on **MICROCHIP_INTELLIGENCE_AGENT**
   - The agent editor will open

---

## Step 2: Add Chart Functions as Tools

### Function 1: GENERATE_DONUT_CHART

1. In the agent editor, click **Tools** in the left sidebar
2. Click the blue **+ Add** button (top right of Tools section)
3. A modal window opens: "Add tool"
4. Click on **Function** tile
5. In the "Select a function" dropdown:
   - Start typing: `GENERATE_DONUT`
   - Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_DONUT_CHART`
6. The function details appear below
7. Click in the **Description** box
8. Paste this description:
   ```
   Creates enhanced donut pie charts for inline display in chat. Use when users request pie charts, donut charts, or "3D pie charts".
   
   The donut style (hollow center) provides visual depth perception - this is the closest to 3D appearance that can display inline in the agent interface.
   
   Parameters:
   - data_json: JSON string array of your data
   - label_field: Column name for slice labels (e.g., 'product_family')
   - value_field: Column name for values (e.g., 'design_wins')
   - chart_title: Title for the chart
   
   Returns: Vega-Lite specification that renders immediately inline
   
   Use for: Proportions, distributions, market share, category breakdowns
   ```
9. Click **Add** button at bottom right
10. Confirm the function appears in your Tools list

### Function 2: GENERATE_BAR_CHART

1. Click **+ Add** button again
2. Click **Function** tile
3. In dropdown, select: `MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_BAR_CHART`
4. In **Description** box, paste:
   ```
   Creates gradient bar charts for comparing values across categories. Renders inline in chat.
   
   Uses color gradients to show value intensity - higher values appear darker blue.
   
   Parameters:
   - data_json: JSON string array of your data
   - x_field: Column for categories (x-axis)
   - y_field: Column for values (y-axis)
   - chart_title: Title for the chart
   
   Returns: Vega-Lite specification for inline rendering
   
   Use for: Comparisons, rankings, category analysis
   ```
5. Click **Add**
6. Confirm it appears in Tools list

### Function 3: GENERATE_LINE_CHART

1. Click **+ Add** button again
2. Click **Function**
3. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_LINE_CHART`
4. Description:
   ```
   Creates line charts for visualizing trends over time. Renders inline in chat.
   
   Displays trend lines with point markers and interactive tooltips.
   
   Parameters:
   - data_json: JSON string array of your data
   - x_field: Column for time/sequence (x-axis)
   - y_field: Column for values (y-axis)
   - chart_title: Title for the chart
   
   Returns: Vega-Lite specification for inline rendering
   
   Use for: Time series, trends, sequential data
   ```
5. Click **Add**

### Function 4: GENERATE_AREA_CHART

1. Click **+ Add** button again
2. Click **Function**
3. Select: `MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_AREA_CHART`
4. Description:
   ```
   Creates area charts for cumulative trends. Renders inline in chat.
   
   Displays filled area under trend line with gradient shading.
   
   Parameters:
   - data_json: JSON string array of your data
   - x_field: Column for x-axis
   - y_field: Column for values (y-axis)
   - chart_title: Title for the chart
   
   Returns: Vega-Lite specification for inline rendering
   
   Use for: Cumulative data, stacked trends, volume analysis
   ```
5. Click **Add**

### Verify All Functions Added

You should now see **4 functions** in your Tools list:
- ✅ GENERATE_DONUT_CHART
- ✅ GENERATE_BAR_CHART
- ✅ GENERATE_LINE_CHART
- ✅ GENERATE_AREA_CHART

---

## Step 3: Update Agent Instructions

1. Still in the agent editor, click **Instructions** in the left sidebar
2. Scroll down to find the **Response Instructions** text box
3. Click in the text box to edit
4. Scroll to the end of existing instructions
5. Add a new paragraph:

```

CHART GENERATION FOR INLINE DISPLAY:

When users request visualizations, use the chart generation functions to create charts that display inline in this conversation:

For pie/donut chart requests (including "3D pie"):
- Use GENERATE_DONUT_CHART(data_json, label_column, value_column, title)
- Explain: "Here's an enhanced donut chart..." (donut = closest to 3D for inline)

For bar chart requests:
- Use GENERATE_BAR_CHART(data_json, x_column, y_column, title)

For line/trend chart requests:
- Use GENERATE_LINE_CHART(data_json, x_column, y_column, title)

For area chart requests:
- Use GENERATE_AREA_CHART(data_json, x_column, y_column, title)

Process for all chart requests:
1. Query data from appropriate semantic view
2. Convert query results to JSON array format
3. Call the appropriate chart function
4. The chart will render inline automatically in this chat

Important: These functions return Vega-Lite specifications that display inline. For "3D pie" requests, donut charts provide the best visual depth appearance possible for inline rendering.
```

6. Click **Save** button (top right)

---

## Step 4: Test the Chart Functions

1. Click on **Chat** tab in the agent interface
2. Ask your agent:

### Test 1: Basic Donut Chart
```
Show me design wins by product family in a donut chart
```

**What should happen:**
- Agent queries `SV_DESIGN_ENGINEERING_INTELLIGENCE`
- Agent calls `GENERATE_DONUT_CHART()`
- **Chart displays INLINE in the conversation** ✅
- You see an enhanced donut chart with gradient colors

### Test 2: Request "3D Pie"
```
Show me design wins in a 3D pie chart
```

**What should happen:**
- Agent recognizes "3D pie" request
- Agent uses `GENERATE_DONUT_CHART()` (best option for inline)
- Agent explains: "Here's an enhanced donut chart (closest to 3D for inline display)..."
- **Chart displays INLINE** ✅

### Test 3: Bar Chart
```
Display top 10 products by revenue as a bar chart
```

**What should happen:**
- Agent queries data
- Agent calls `GENERATE_BAR_CHART()`
- **Gradient bar chart displays INLINE** ✅

### Test 4: Line Chart
```
Show me monthly order trends as a line chart
```

**What should happen:**
- Agent queries orders by month
- Agent calls `GENERATE_LINE_CHART()`
- **Line chart with markers displays INLINE** ✅

---

## Step 5: Verify Function Calls

After asking for a chart, look for:

1. **Tool Call Indicator** - Agent should show it's calling a function
2. **Function Name** - Should show "GENERATE_DONUT_CHART" (or other chart function)
3. **Chart Display** - Vega-Lite chart renders inline in the conversation
4. **Interactive Elements** - You can hover over chart elements for tooltips

---

## Troubleshooting

### Issue: "Function not found"

**Fix:**
1. Verify you executed `09_agent_inline_charts.sql`
2. Run this to check:
   ```sql
   SHOW FUNCTIONS LIKE 'GENERATE_%' IN SCHEMA MICROCHIP_INTELLIGENCE.ANALYTICS;
   ```
3. Should show 4 functions

### Issue: "Permission denied"

**Fix:**
1. Re-run the GRANT statements in Step 2
2. Make sure you replaced `<your_role>` with your actual role
3. Verify grants:
   ```sql
   SHOW GRANTS ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_DONUT_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR);
   ```

### Issue: "Agent doesn't call the functions"

**Fix:**
1. Make sure functions are added in **Tools** section
2. Check that descriptions mention when to use each function
3. Verify instructions include chart generation guidance
4. Try asking more explicitly: "Use GENERATE_DONUT_CHART to show me..."

### Issue: "Chart doesn't display"

**Fix:**
1. Check that agent actually called the function (look for tool call)
2. Verify function returned a result (not an error)
3. Check that data format is correct (JSON string)
4. Try with simpler data first (fewer rows)

---

## Complete UI Navigation Summary

```
Snowsight Home
  ↓
Click: AI & ML (left sidebar)
  ↓
Click: Agents
  ↓
Click: MICROCHIP_INTELLIGENCE_AGENT
  ↓
Click: Tools (left sidebar in agent editor)
  ↓
Click: + Add (blue button top right)
  ↓
Click: Function (in modal)
  ↓
Select: MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_DONUT_CHART
  ↓
Paste: Description (see above)
  ↓
Click: Add (bottom right of modal)
  ↓
Repeat for 3 more functions
  ↓
Click: Instructions (left sidebar)
  ↓
Scroll to end of Response Instructions
  ↓
Add: Chart generation paragraph (see Step 3)
  ↓
Click: Save (top right)
  ↓
Click: Chat (to test)
  ↓
Ask: "Show me design wins in a donut chart"
  ↓
RESULT: Chart displays inline! ✅
```

---

## Expected Results

### When Working Correctly:

**Your Question:**
```
Show me design wins by product family in a donut chart
```

**Agent Response:**
```
Based on SV_DESIGN_ENGINEERING_INTELLIGENCE, here are design wins by product family:

[INLINE DONUT CHART DISPLAYS HERE]
- Enhanced donut visualization
- Gradient color scheme
- Interactive tooltips
- Percentage labels
- Center donut hole for depth

Total design wins analyzed: 500,000 across all product families.
```

**You See:**
- The text response
- An actual rendered donut chart inline
- Can hover for tooltips
- Professional gradient styling

---

## Screenshot Guide (What to Look For)

### In Tools Section:
```
Tools (4)
├─ Cortex Analyst (3)
│  ├─ SV_DESIGN_ENGINEERING_INTELLIGENCE
│  ├─ SV_SALES_REVENUE_INTELLIGENCE
│  └─ SV_CUSTOMER_SUPPORT_INTELLIGENCE
├─ Cortex Search (3)
│  ├─ SUPPORT_TRANSCRIPTS_SEARCH
│  ├─ APPLICATION_NOTES_SEARCH
│  └─ QUALITY_INVESTIGATION_REPORTS_SEARCH
└─ Functions (4)  ← YOU SHOULD SEE THIS
   ├─ GENERATE_DONUT_CHART
   ├─ GENERATE_BAR_CHART
   ├─ GENERATE_LINE_CHART
   └─ GENERATE_AREA_CHART
```

---

## Quick Reference Card

| User Says | Agent Uses | Result |
|-----------|------------|--------|
| "pie chart" | GENERATE_DONUT_CHART() | Donut inline |
| "3D pie chart" | GENERATE_DONUT_CHART() | Enhanced donut inline |
| "bar chart" | GENERATE_BAR_CHART() | Gradient bars inline |
| "line chart" | GENERATE_LINE_CHART() | Line with markers inline |
| "trend chart" | GENERATE_LINE_CHART() | Line chart inline |
| "area chart" | GENERATE_AREA_CHART() | Filled area inline |

---

**Need help?** Check `INLINE_CHART_REALITY.md` for technical details or `QUICK_START_INLINE_CHARTS.md` for condensed steps.

**Status:** Complete step-by-step UI instructions  
**Location:** This file (AGENT_FUNCTION_SETUP_DETAILED.md)


