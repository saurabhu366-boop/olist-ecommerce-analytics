# Olist E-Commerce Analytics — Sales, Retention & Delivery Dashboard

A six-page **Power BI business intelligence project** analyzing e-commerce sales, customer lifecycle behavior, product and category performance, seller contribution, fulfillment reliability, geographic delivery risk, and customer experience.

The project follows a **validation-first analytics workflow**: raw data is profiled, business rules are applied through MySQL analytical views, KPI outputs are reconciled, and the validated analytical layer is consumed by Power BI.

---

## 📌 Project Overview

Instead of treating revenue as a single headline metric, this project separates:

- Realized revenue
- Order activity
- Customer behavior
- Product and category contribution
- Seller performance
- Delivery reliability
- Customer experience

The objective is to create an analytical solution where metrics are **traceable, validated, and connected to business questions**.

---

## 🎯 Business Objectives

The analysis is designed to answer:

- How is realized revenue changing over time?
- Is revenue growth driven by order volume or order value?
- Which categories and products contribute the most realized revenue?
- Which sellers contribute the most commercial value?
- How strong is repeat purchasing?
- Which customers represent higher value?
- How does retention vary across acquisition cohorts?
- Where are delivery delays concentrated?
- How does fulfillment performance relate to customer reviews?

---

# 📊 Key KPIs

| KPI | Value |
|---|---:|
| **Realized Revenue** | **₹13.22M** |
| **Delivered Orders** | **96,478** |
| **Unique Customers** | **93,358** |
| **Average Order Value** | **₹137.04** |
| **Repeat Customer Rate** | **3.00%** |
| **Average Delivery Time** | **12.50 days** |
| **Late Delivery Rate** | **6.77%** |
| **Average Review Score** | **4.09 / 5** |

> **Metric definition:** Repeat-customer analysis is window-scoped because the dataset represents a finite historical observation period. A customer appearing once in the dataset is not necessarily a customer who would never purchase again outside the observed period.

---

# 📊 Dashboard

The Power BI solution contains six analytical pages.

## 01 — Executive Overview

**Business question:**  
> What is the overall health of the business?

Provides a high-level view of realized revenue, delivered orders, AOV, category contribution, geography, customer behavior, delivery performance, and reviews.

![Executive Overview](Screenshots/01-executive-overview.png)

---

## 02 — Sales Analysis

**Business question:**  
> How are revenue and order performance evolving over time?

Analyzes:

- Revenue trends
- Order volume
- Average order value
- Monthly performance
- Revenue contribution
- Volume versus value movement

![Sales Analysis](Screenshots/02-sales-analysis.png)

---

## 03 — Customer & Retention Analysis

**Business question:**  
> Who are the customers, how valuable are they, and how well are they retained?

Analyzes:

- New versus repeat customers
- Repeat purchase behavior
- RFM segmentation
- Customer value
- Cohort retention
- Customer lifecycle patterns

![Customer & Retention](Screenshots/03-customer-retention.png)

---

## 04 — Product & Category Analysis

**Business question:**  
> Which categories and products drive realized business value?

Analyzes:

- Category revenue
- Product contribution
- Delivered items
- Average item price
- Category-level performance
- Product-level contribution

![Product & Category](Screenshots/04-product-category-analysis.png)

---

## 05 — Seller Performance

**Business question:**  
> Which sellers contribute most to marketplace performance?

Analyzes:

- Seller revenue
- Seller order volume
- Delivered items
- Revenue per order
- Seller contribution
- Commercial performance distribution

![Seller Performance](Screenshots/05-seller-performance.png)

---

## 06 — Delivery & Review Analysis

**Business question:**  
> Where does fulfillment performance intersect with customer experience?

Analyzes:

- Average delivery time
- Late delivery rate
- Delivery delays
- Geographic delivery patterns
- Review scores
- Customer experience indicators

![Delivery & Review](Screenshots/06-delivery-review-analysis.png)

---

# 💡 Key Business Insights

The dashboard is designed to surface several business signals.

### Customer retention is a growth opportunity

The observed repeat-customer rate is **3.00%**, highlighting second-purchase conversion as an important customer-lifecycle opportunity.

### Revenue should be evaluated with fulfillment context

The project distinguishes **realized revenue** from broader booked or unrealized commercial value, reducing the risk of treating demand that did not become completed business as revenue.

### Customer value is multidimensional

RFM segmentation evaluates customers using:

- Recency
- Frequency
- Monetary value

This provides a more informative customer-value perspective than revenue alone.

### Seller contribution is not one-dimensional

Seller performance is evaluated using separate measures such as:

- Realized revenue
- Orders
- Delivered items
- Revenue per order

This avoids creating an arbitrary composite seller score.

### Delivery performance has geographic variation

The overall late-delivery rate is **6.77%**. State-level analysis provides a way to identify areas that may require deeper operational investigation.

### Customer experience provides an additional signal

The overall review score is **4.09 / 5**, allowing customer feedback to be evaluated alongside fulfillment performance.

> These observations are presented as analytical signals rather than unsupported causal claims.

---

# 🔍 Analytical Framework

## Revenue Realization

Revenue is treated as a **fulfillment-aware metric**.

Realized revenue is separated from broader item-level commercial value so that cancelled, unavailable, or otherwise unrealized demand is not incorrectly presented as completed revenue.

---

## Customer Lifecycle Analysis

Customer behavior is evaluated through:

- First purchase
- Repeat purchasing
- Customer frequency
- Customer monetary value
- RFM segmentation
- Cohort retention

---

## RFM Segmentation

RFM analysis combines:

**Recency**  
How recently the customer purchased.

**Frequency**  
How often the customer purchased.

**Monetary**  
How much realized revenue the customer generated.

The scoring approach is adapted to the observed purchase-frequency distribution rather than blindly applying a conventional segmentation template.

Segments include:

- Champions
- Loyal Customers
- New / Promising
- At Risk
- Cannot Lose Them
- Other

---

## Cohort Retention

Customers are grouped according to their first realized purchase month and evaluated across subsequent activity months.

The analysis also considers **observation-window bias**: later cohorts have had less time to generate repeat purchases than earlier cohorts.

---

## Delivery Reliability

Delivery performance is evaluated using:

- Purchase timestamp
- Delivery timestamp
- Estimated delivery date
- Actual delivery date
- Delivery duration
- Delivery delay

Geographic analysis is used to identify potential delivery-risk areas.

---

## Seller Performance

Seller performance is evaluated using independent commercial measures rather than a single composite score.

This allows revenue contribution, order volume, and operational measures to be interpreted separately.

---

## Customer Experience

Review scores are analyzed alongside delivery performance to investigate potential relationships between fulfillment outcomes and customer feedback.

---

# 🧩 Data Pipeline

```text
Source CSVs
     ↓
Raw MySQL Layer
     ↓
Data Quality Validation
     ↓
Cleaned / Staging Layer
     ↓
Analytical SQL Views
     ↓
RFM & Cohort Retention Layer
     ↓
Power BI Data Model
     ↓
Six-Page Dashboard
```

### Workflow

1. Preserve raw source data.
2. Profile and validate the data.
3. Apply documented business rules.
4. Build reusable analytical SQL views.
5. Validate and reconcile KPI outputs.
6. Connect the analytical layer to Power BI.
7. Build interactive dashboards.
8. Translate analytical outputs into business insights.

---

# 🗄️ Analytical SQL Layer

The project uses reusable MySQL views to create a structured analytical layer for Power BI.

Key views include:

```text
vw_sales_summary
vw_order_summary
vw_monthly_sales_trend
vw_category_performance
vw_seller_performance
vw_order_reviews_latest
vw_dim_customer
vw_customer_first_purchase
vw_customer_repeat_purchase_summary
vw_customer_geo_distribution
vw_customer_rfm
vw_customer_rfm_segments
vw_cohort_retention
```

This creates clearer **data lineage** between source tables, business rules, metrics, and dashboard visuals.

---

# 🧠 Technical Decisions

## Validation-First Analytics

Dashboard KPIs were validated through SQL before being used for reporting.

The final baseline reconciliation confirmed:

| Metric | Expected | Actual |
|---|---:|---:|
| Realized Revenue | ₹13,221,498.11 | ₹13,221,498.11 |
| Delivered Orders | 96,478 | 96,478 |

This confirms that the core Power BI analytical layer reconciles with the validated SQL baseline.

---

## Data-Shape-Aware RFM

The dataset contains a large proportion of customers with limited purchase frequency.

Therefore, RFM scoring was designed with the actual customer purchase distribution in mind rather than assuming a perfectly balanced frequency distribution.

---

## Observation-Window Awareness

Repeat purchase and retention metrics are interpreted within the available historical dataset.

This prevents the analysis from treating the dataset as a complete lifetime history for every customer.

---

## Independent Seller Metrics

Seller revenue, order volume, delivered items, and revenue-per-order metrics remain separate.

This makes the dashboard more transparent than an arbitrary weighted seller score.

---

## Readability Without Losing Traceability

Long seller and product identifiers are shortened where necessary for dashboard readability while preserving the underlying identifiers for detailed analysis.

---

# 🧪 Data Quality & Validation

The SQL layer includes checks for:

- Raw versus cleaned row counts
- Null values
- Order completeness
- Order-item quality
- Review-score validity
- Customer coverage
- RFM population
- Cohort validity
- Delivery-date validity
- Revenue reconciliation
- Category reconciliation
- Seller reconciliation
- Geographic reconciliation
- Review deduplication
- KPI reconciliation

The validation layer helps maintain **metric consistency and KPI traceability** throughout the analytical workflow.

---

# 🛠️ Tools & Technologies

| Area | Technology |
|---|---|
| Database | **MySQL 8.0** |
| BI & Visualization | **Power BI Desktop** |
| Data Transformation | **Power Query** |
| Calculations | **DAX** |
| Custom Visualization | **Deneb / Vega-Lite** |
| Data Modeling | **Analytical SQL Views** |
| Customer Analysis | **RFM & Cohort Retention** |
| Data Quality | **SQL Validation & Reconciliation** |

---

# 🎨 Dashboard Design

The dashboard uses a consistent business-oriented visual system.

| Purpose | Colour |
|---|---|
| Primary / Revenue | `#2563EB` |
| Positive / Early | `#10B981` |
| Warning / Late | `#F59E0B` |
| Negative | `#EF4444` |
| Primary Text | `#1F2937` |
| Secondary Text | `#64748B` |
| Gridlines | `#E5E7EB` |
| Background | `#F5F7FA` |

The design maintains:

- Consistent typography
- Clear KPI hierarchy
- Semantic colors
- Consistent spacing
- Business-focused visual hierarchy

Selected visuals use **Deneb / Vega-Lite** where standard Power BI visuals were not sufficient for the intended analytical presentation.

---

# 📁 Repository Structure

```text
olist-ecommerce-analytics/
│
├── README.md
│
├── Screenshots/
│   ├── 01-executive-overview.png
│   ├── 02-sales-analysis.png
│   ├── 03-customer-retention.png
│   ├── 04-product-category-analysis.png
│   ├── 05-seller-performance.png
│   └── 06-delivery-review-analysis.png
│
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_analytical_views.sql
│   ├── 03_customer_rfm.sql
│   ├── 04_cohort_retention.sql
│   └── 05_validation.sql
│
├── documentation/
│   └── business_rules.md
│
└── powerbi/
    └── Olist_Ecommerce_Analytics.pbix
```

---

# 💼 Business Questions Supported

The dashboard can be used to investigate:

- How is realized revenue changing?
- What is driving revenue movement?
- Which categories generate the most realized value?
- Which products contribute most to revenue?
- Which sellers contribute most to marketplace performance?
- How many customers are repeat purchasers?
- Which customers have higher RFM value?
- How does retention differ between cohorts?
- Which geographic areas show delivery risk?
- How long does fulfillment take?
- How frequently are orders delivered late?
- What is the customer review experience?
- How can commercial and operational performance be evaluated together?

---

# 🎯 Project Outcome

This project demonstrates an end-to-end business intelligence workflow:

```text
Raw Data
   ↓
Data Validation
   ↓
Business Rules
   ↓
Analytical SQL
   ↓
KPI Reconciliation
   ↓
Power BI Data Model
   ↓
Interactive Dashboard
   ↓
Business Insights
```

The focus is on building a **traceable analytical product**, rather than simply creating a collection of charts.

---

# 👨‍💻 Skills Demonstrated

**SQL · MySQL · Power BI · DAX · Power Query · Data Modeling · Analytical SQL Views · KPI Development · RFM Segmentation · Cohort Analysis · Customer Lifecycle Analysis · Revenue Realization · Fulfillment Analytics · Seller Performance Diagnostics · Data Quality Auditing · Metric Validation · Data Lineage · Business-Rule Documentation · Business Intelligence · Data Visualization · Deneb / Vega-Lite**

---

# 📄 Resume-Ready Project Description

> **Olist E-Commerce Analytics — Power BI**  
> Built a six-page business intelligence dashboard analyzing **₹13.22M in realized revenue across 96K delivered orders and 93K unique customers**, using MySQL analytical views, Power Query, DAX, RFM segmentation, cohort retention analysis, seller diagnostics, and fulfillment-aware delivery metrics. Implemented validation-first KPI definitions and a structured analytical layer connecting sales, customer lifecycle, product, seller, delivery, and review performance.
