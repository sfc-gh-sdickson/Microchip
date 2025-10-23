# 🚀 Quick Start: Get Inline Charts Working in Your Agent

**Goal:** Display charts directly in the agent chat interface (no separate windows)

**Time Required:** 5-10 minutes

---

## ✅ **Step-by-Step Instructions**

### **Step 1: Execute the Chart Functions SQL** (2 minutes)

In Snowflake Snowsight:

1. Open a new SQL worksheet
2. Paste and run this:
   ```sql
   @sql/tools/09_agent_inline_charts.sql
   ```
3. Wait for confirmation: "Inline chart functions created"

**What this does:** Creates 4 Python UDF functions that generate Vega-Lite chart specs

---

### **Step 2: Grant Permissions** (1 minute)

Still in your SQL worksheet, run:

```sql
USE ROLE ACCOUNTADMIN;

-- Replace <your_role> with your actual role (e.g., SYSADMIN, ANALYST_ROLE)
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_DONUT_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_BAR_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_LINE_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
GRANT USAGE ON FUNCTION MICROCHIP_INTELLIGENCE.ANALYTICS.GENERATE_AREA_CHART(VARCHAR, VARCHAR, VARCHAR, VARCHAR) TO ROLE <your_role>;
```

---

### **Step 3: Add Functions to Your Agent** (5 minutes)

1. In Snowsight, go to **AI & ML** → **Agents**
2. Click on your `MICROCHIP_INTELLIGENCE_AGENT`
3. Click **Tools** in the left sidebar
4. Click **+ Add** → Select **Function**

**Add Function 1:**
- Search for and select: `GENERATE_DONUT_CHART`
- Description:
  ```
  Enhanced donut pie chart generator. Use when users request pie charts or "3D pie charts".
  Creates donut-style visualization with gradient colors for depth perception.
  Renders inline in chat. Best for showing proportions and distributions.
  ```
- Click **Save**

**Add Function 2:**
- Click **+ Add** → **Function** again
- Select: `GENERATE_BAR_CHART`
- Description:
  ```
  Gradient bar chart generator. Use for comparing values across categories.
  Renders inline in chat.
  ```
- Click **Save**

**Add Function 3:**
- Click **+ Add** → **Function**
- Select: `GENERATE_LINE_CHART`
- Description:
  ```
  Line chart for trends. Use for time-series data and trend analysis.
  Renders inline in chat.
  ```
- Click **Save**

**Add Function 4:**
- Click **+ Add** → **Function**
- Select: `GENERATE_AREA_CHART`
- Description:
  ```
  Area chart for cumulative trends. Renders inline in chat.
  ```
- Click **Save**

---

### **Step 4: Update Agent Instructions** (2 minutes)

1. Still in your agent, click **Instructions** in the left sidebar
2. Find the **Response Instructions** section
3. Add this paragraph at the end:

```
CHART GENERATION:
When users request visualizations, use the chart generation functions:
- For pie/donut/"3D pie" requests → use GENERATE_DONUT_CHART()
- For bar charts → use GENERATE_BAR_CHART()
- For line/trend charts → use GENERATE_LINE_CHART()
- For area charts → use GENERATE_AREA_CHART()

Process:
1. Query data from semantic views
2. Format as JSON string
3. Call appropriate function with data_json, x_field, y_field, title
4. The chart will render inline automatically

Note: For "3D pie" requests, use donut charts (closest to 3D for inline display).
```

4. Click **Save**

---

## ✅ **Step 5: Test It!**

Ask your agent:

```
"Show me design wins by product family in a donut chart"
```

**You should see:**
- Agent queries the data
- Agent calls GENERATE_DONUT_CHART()
- **Chart displays INLINE in the chat** ✅
- Enhanced donut with gradient colors
- Interactive tooltips on hover

---

## 🎯 **Chart Request Examples**

Once configured, you can ask:

**Donut/Pie Charts:**
```
"Show me design wins by product family in a pie chart"
"Display revenue by customer segment as a donut chart"
"Create a pie chart of distributor market share"
```

**Bar Charts:**
```
"Show top 10 products by revenue as a bar chart"
"Display distributor performance in a bar chart"
"Compare design wins by industry as bars"
```

**Line Charts:**
```
"Show monthly revenue trends as a line chart"
"Display order volume over time"
"Create a line chart of design wins by month"
```

**Area Charts:**
```
"Show cumulative revenue as an area chart"
"Display production orders trend as area chart"
```

---

## ⚠️ **About "3D" Requests**

When you ask for "3D pie chart":
- Agent will use `GENERATE_DONUT_CHART()`
- Creates enhanced donut with visual depth effects
- **NOT actually rotatable 3D** (technical limitation)
- But provides best visual appearance **inline**

**Agent should explain:**
```
"Here's an enhanced donut chart (the closest to 3D that displays inline in our chat)..."
```

---

## 🔍 **Verification**

After setup, verify functions are available:

```sql
-- Check functions exist
SHOW FUNCTIONS LIKE 'GENERATE_%' IN SCHEMA MICROCHIP_INTELLIGENCE.ANALYTICS;

-- Should show:
-- GENERATE_DONUT_CHART
-- GENERATE_BAR_CHART
-- GENERATE_LINE_CHART
-- GENERATE_AREA_CHART
```

---

## 💡 **Tips for Best Results**

1. **Keep data sets reasonable** - 10-20 categories max for pie charts
2. **Use clear labels** - Short, descriptive category names
3. **Format numbers** - Round to appropriate precision
4. **Test with simple queries first** - Verify functions work before complex requests

---

## 📊 **What You Get**

### ✅ Advantages:
- Charts display **immediately** in agent conversation
- **No extra windows** or navigation
- **Context preserved** - chart stays with question/answer
- **Professional appearance** - Gradients, tooltips, styling
- **Mobile works** - Inline charts work anywhere agent works

### ⚠️ Trade-offs:
- Not true 3D rotation (Vega-Lite limitation)
- 2D visualizations only
- Donut style instead of true 3D pie

---

## 🎉 **You're Done!**

After these 5 steps, your agent will:
- ✅ Display enhanced donut charts inline
- ✅ Show gradient bar charts inline
- ✅ Render line and area charts inline
- ✅ Respond to chart requests immediately
- ✅ Keep everything in the conversation

**Just ask your agent for a chart and it will appear!**

---

**Setup time:** 5-10 minutes  
**Result:** Inline chart rendering in agent  
**Quality:** Enhanced Vega-Lite visualizations

🎨 **Charts now render directly in your agent chat!**


