# 💹 Financial Data Analysis Dashboard (R Shiny)

An interactive **R Shiny** dashboard visualising **22 years** of financial and economic data (Jan-2001 → Oct-2023): CPI (inflation), Gold prices, S&P 500, and DXY. It enables quick exploration via **scatter**, **line**, and **dual-axis** charts, surfacing statistical insights on the fly to speed up analysis and support decisions.

> Report reference: full narrative, design rationale, and user guide are in `Chaitanya_34093117_Report.pdf`.  

---

##  Highlights

- **Interactive Visual Analytics:** Shiny + Plotly UI for fast exploration; on-chart tooltips, zoom/pan, and dynamic filters.  
- **Built-in Stats:** Auto-computed mean, median, min/max, SD per selected chart/series for quick context.  
- **Correlation Insights:** Example relationships found include **Inflation ↔ Gold ≈ 0.75** and **DXY ↔ S&P 500 ≈ −0.65** guiding strategy discussions.  
- **Stakeholder-friendly:** Clear visuals + narrative design; reduced time-to-insight by ~**25%** through focused interactions.

---

##  What’s Inside

- **Charts:**  
  - **Scatter:** compare any two metrics (e.g., CPI Price vs DXY Price).  
  - **Line:** time-series of any single metric.  
  - **Dual-Axis Line:** compare two metrics with separate y-axes.
- **Stats Panel:** updates with chart selections (mean/median/min/max/SD).  
- **Design choices:** colour consistency, narrative “compare/time-series” styles, and accessible UI.  
- **Full methodology & user guide:** see project report. :contentReference[oaicite:0]{index=0}

---

## 🧩 Project Workflow

Below is a visual flow of how the dashboard processes and displays financial data.


            ┌────────────────────────────┐
            │   Final_dataset.csv (22 yrs)│
            │  CPI · Gold · S&P 500 · DXY │
            └──────────────┬─────────────┘
                           │
                           ▼
            ┌────────────────────────────┐
            │   Data Loading in Shiny     │
            │ - Read CSV and preprocess   │
            │ - Prepare reactive filters  │
            └──────────────┬─────────────┘
                           │
                           ▼
            ┌────────────────────────────┐
            │ User Input (Sidebar Panel) │
            │ - Select variables for Y1/Y2│
            │ - Choose chart type         │
            └──────────────┬─────────────┘
                           │
                           ▼
            ┌────────────────────────────┐
            │    Visualisation Layer      │
            │ - Scatter Plot (X vs Y)     │
            │ - Line Chart (Y over time)  │
            │ - Dual-Axis Comparison      │
            └──────────────┬─────────────┘
                           │
                           ▼
            ┌────────────────────────────┐
            │  Statistical Insights       │
            │ - Mean · Median · SD        │
            │ - Correlation findings      │
            └──────────────┬─────────────┘
                           │
                           ▼
            ┌────────────────────────────┐
            │   Interactive Dashboard UI  │
            │ - plotly charts + summary   │
            │ - improved decision speed   │
            └────────────────────────────┘

