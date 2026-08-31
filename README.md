# Olist E-Commerce Analytics — Sales, Retention & Delivery Dashboard

A six-page **Power BI business intelligence dashboard** analyzing 96,478 delivered orders from Olist, a Brazilian multi-seller marketplace.

This project goes beyond descriptive reporting by using a **validated MySQL analytical pipeline**, documented business rules, customer lifecycle analysis, fulfillment-aware metrics, and Power BI reporting. Core KPIs are designed to remain traceable to SQL-defined analytical views rather than relying only on report-layer calculations.

---

## Project Objective

Most e-commerce dashboards reduce performance to a single revenue number. This project deliberately separates **revenue realization, booked sales, and fulfillment outcomes** so that operational performance is not hidden inside a blended KPI.

The same metric-definition discipline is applied across customer segmentation, retention, delivery performance, seller analysis, geography, and customer experience.

The objective is to build an analytical layer that helps stakeholders understand:

- Where realized revenue comes from
- Whether growth is driven by order volume or order value
- Which customer groups create business value
- How repeat purchasing behaves within the observation window
- Which categories, products, states, and sellers contribute most
- Where delivery reliability is weakest
- Whether delivery performance is associated with customer satisfaction

---

## Key KPIs

| KPI | Value | Definition |
| --- | ---: | --- |
| **Realized Revenue** | **R$13.22M** | Revenue from realized/delivered orders |
| **Delivered Orders** | **96,478** | Orders classified as realized |
| **Unique Customers** | **93,358** | Distinct customers represented in the realized-order analysis |
| **Average Order Value** | **R$137.04** | Realized revenue ÷ delivered orders |
| **Repeat Customer Rate** | **3.00%** | Repeat customers within the observed dataset window |
| **Average Delivery Time** | **12.50 days** | Purchase → customer delivery |
| **Late Delivery Rate** | **6.77%** | Delivered orders past their estimated delivery date |
| **Average Review Score** | **4.09 / 5** | Average score from the deduplicated review layer |

> **Metric note:** The repeat-customer rate is intentionally treated as **window-scoped**, not as a lifetime retention claim. The dataset covers a finite observation period, so customers with only one observed order may not have had sufficient time to repeat.

---

## Dashboard Pages

### 1. Executive Overview

Provides the business-level snapshot of the marketplace.

**Includes:**

- Realized revenue
- Delivered orders
- Average order value
- Monthly revenue trend
- Revenue contribution by category
- Revenue contribution by state
- Core delivery and customer-experience indicators

This page is designed for fast executive interpretation before moving into diagnostic analysis.

---

### 2. Sales Performance

Examines whether business growth is coming from **more orders, larger orders, or changes in both**.

**Includes:**

- Monthly realized revenue
- Delivered order volume
- Average order value over time
- Month-over-month growth
- Sales performance trends

This separates **volume-driven growth** from **value-driven growth** rather than treating revenue movement as a single unexplained outcome.

---

### 3. Customer & Retention

Focuses on **customer lifecycle behavior, value segmentation, repeat purchasing, and retention**.

#### RFM Segmentation

RFM analysis is adapted to the actual shape of the dataset rather than applying a default segmentation template.

The analysis considers:

- **Recency** — how recently a customer purchased
- **Frequency** — how often a customer purchased
- **Monetary value** — how much realized revenue a customer generated

Because the observed customer base is heavily weighted toward one-time buyers, frequency scoring is handled according to the actual distribution rather than forcing a conventional quintile interpretation.

The resulting segments distinguish customer behavior and value, including one-time and repeat customer groups.

#### Cohort Retention

Cohort analysis tracks customer activity relative to the customer's first purchase month.

Retention is normalized by cohort size so that large cohorts do not dominate later-period comparisons simply because they contain more customers.

The analysis also recognizes **observation-window bias**: later cohorts have had less time to generate repeat purchases than earlier cohorts.

---

### 4. Product & Category Performance

Analyzes how product categories contribute to realized business value.

**Includes:**

- Revenue contribution by category
- Units sold by category
- Average selling price
- Product-level performance

The page is designed to distinguish **category concentration** from **customer-segment concentration** rather than treating either as the same business finding.

---

### 5. Seller Performance

Provides **seller-level performance diagnostics** rather than reducing sellers to a single composite score.

**Includes:**

- Top sellers by realized revenue
- Seller order volume
- Items delivered by seller
- Revenue per order
- Seller-level delivery/review performance where applicable

Seller and product identifiers are shortened in visual labels for readability while the underlying identifiers remain available for detailed inspection.

Keeping seller metrics separate avoids mixing commercial performance with operational outcomes into an arbitrary blended ranking.

---

### 6. Delivery & Customer Experience

Examines **operational reliability and customer experience** together.

**Includes:**

- Average delivery time
- Late-delivery rate
- Delivery status split
- Customer review distribution
- Average review score
- Geographic late-delivery patterns
- Delivery/review relationship analysis

The analysis is intended to distinguish a genuine operational pattern from a simple correlation between two headline cards.

---

## Data Pipeline

```text
Source CSVs
    ↓
Raw MySQL Layer
    ↓
Data-Quality Validation
    ↓
Cleaned / Staging Layer
    ↓
Analytical SQL Views
    ↓
RFM & Retention Layer
    ↓
Power BI Data Model
    ↓
Six-Page Dashboard
```

The pipeline follows a **validation-first analytics** approach:

- Raw data is preserved separately from analytical transformations.
- Data quality is assessed before reporting.
- Business rules are implemented in the SQL analytical layer.
- KPIs are traceable to documented SQL definitions.
- Power BI is used primarily as the analytical presentation and exploration layer.

---

## Data Model & Analytical Layer

The project uses a structured analytical model built around transactional, customer, product, seller, delivery, and review data.

Key analytical views include:

- `vw_sales_summary`
- `vw_order_summary`
- `vw_customer_repeat_purchase_summary`
- `vw_customer_rfm`
- `vw_customer_rfm_final`
- `vw_customer_rfm_segments`
- `vw_cohort_retention`
- `vw_category_performance`
- `vw_seller_performance`
- `vw_monthly_sales_trend`
- `vw_customer_geo_distribution`

This separation creates clearer **data lineage** between source data, business rules, analytical metrics, and dashboard visuals.

---

## Analytical Techniques

### Revenue Realization

Revenue is treated as a **fulfillment-aware metric**.

The project distinguishes realized revenue from other commercial values so that cancelled, unavailable, or otherwise unrealized demand is not accidentally presented as completed revenue.

### Customer Lifecycle Segmentation

RFM is used to identify differences in customer recency, purchasing frequency, and realized monetary value.

The methodology is adapted to the actual customer distribution rather than blindly applying a standard template.

### Repeat Purchase Analysis

Repeat behavior is measured within the available observation window.

This avoids presenting a finite historical dataset as if it represented customers' complete lifetime purchasing behavior.

### Cohort Retention

Customers are grouped by first-purchase month and tracked across subsequent months.

Retention is evaluated as a proportion of the original cohort, allowing cohorts of different sizes to be compared more fairly.

### Delivery Reliability

Delivery duration and estimated-vs-actual delivery dates are used to identify operational delay patterns.

Geographic analysis helps surface **delivery-risk areas** that may require operational investigation.

### Seller Performance Diagnostics

Seller performance is evaluated through multiple independent measures rather than an arbitrary composite score.

This allows commercial contribution and operational reliability to be interpreted separately.

### Customer Experience Analysis

Review scores are analyzed alongside delivery performance to investigate whether operational delays are associated with weaker customer feedback.

---

## Business Questions Supported

- How are realized revenue and order volume trending?
- Is revenue growth driven by more orders or higher order value?
- Which categories and products contribute most to realized revenue?
- Which states contribute most to marketplace revenue?
- Which sellers generate the greatest realized revenue and order volume?
- What does the customer lifecycle actually look like within the observed window?
- Which customer segments represent higher monetary value?
- How strong is repeat purchasing within the available observation period?
- How does retention change across customer cohorts?
- Where are late deliveries concentrated geographically?
- Does delivery lateness appear alongside lower customer review scores?

---

## Notable Technical Decisions

### 1. Metric Definition Discipline

Realized revenue is explicitly separated from broader booked item value and fulfillment outcomes.

This prevents a report from displaying a gross commercial figure under a misleading **Revenue** label.

### 2. Validation-First Analytics

The analytical layer was validated before being used as the basis for Power BI reporting.

This makes KPI construction more auditable and reduces the risk of visual-layer calculations hiding data-quality problems.

### 3. Data-Shape-Aware RFM

Frequency scoring is adapted to the actual purchase-frequency distribution.

A default quintile model can create misleading distinctions when most customers have only one observed order.

### 4. Observation-Window Awareness

Repeat purchase and cohort retention are interpreted within the dataset's historical window.

Later cohorts naturally have less opportunity to repeat, so raw cohort comparisons can otherwise introduce misleading conclusions.

### 5. Independent Seller Metrics

Seller rankings use separate measures for revenue, orders, and operational indicators instead of creating a single arbitrary performance score.

### 6. Readability Without Losing Traceability

Long product and seller identifiers are shortened in dashboard labels, while the underlying identifiers remain available for detailed inspection.

---

## Data Quality & Validation

The project includes explicit data-quality checks before dashboard reporting.

Validation covers areas such as:

- Duplicate and unique customer checks
- RFM customer coverage
- Cohort month and offset validity
- Revenue reconciliation
- Delivery-date validity
- Review deduplication
- Analytical-view row counts
- Metric reconciliation between SQL and Power BI

This makes the dashboard a **validated analytical product**, rather than a collection of disconnected visuals.

---

## Tools & Technologies

| Area | Technology |
| --- | --- |
| Database | **MySQL 8.0** |
| BI & Visualization | **Power BI Desktop** |
| Data Transformation | **Power Query** |
| Calculations | **DAX** |
| Custom Visualization | **Deneb / Vega-Lite** |
| Data Modeling | **Star schema / analytical views** |
| Analysis | **RFM, cohort retention, KPI analysis** |
| Quality | **SQL validation & reconciliation** |

---

## Dashboard Design

The dashboard uses a consistent business-oriented visual system.

| Purpose | Colour |
| --- | --- |
| Primary / Revenue | `#2563EB` |
| Positive / Early Delivery | `#10B981` |
| Warning / Late Delivery | `#F59E0B` |
| Negative Metric | `#EF4444` |
| Primary Text | `#1F2937` |
| Secondary Text | `#64748B` |
| Gridlines | `#E5E7EB` |
| Page Background | `#F5F7FA` |

The visual language uses semantic colors where appropriate: positive delivery outcomes use green, late/warning conditions use amber, and negative conditions use red.

Deneb/Vega-Lite is used for selected custom visuals where standard Power BI charts do not provide the desired analytical presentation.

---

## Project Structure

```text
Olist-Ecommerce-Analytics/
│
├── README.md
│
├── sql/
│   ├── data_quality/
│   ├── analytical_views/
│   ├── customer_rfm/
│   ├── cohort_retention/
│   └── validation/
│
├── powerbi/
│   └── Olist_Ecommerce_Analytics.pbix
│
├── documentation/
│   └── business_rules.md
│
└── screenshots/
    ├── page_1_executive_overview.png
    ├── page_2_sales_performance.png
    ├── page_3_customer_retention.png
    ├── page_4_product_category.png
    ├── page_5_seller_performance.png
    └── page_6_delivery_customer_experience.png
```

---

## Skills Demonstrated

**Power BI · DAX · Power Query · MySQL · SQL · Data Modeling · Star Schema Design · Analytical SQL Views · KPI Development · RFM Segmentation · Cohort Analysis · Customer Lifecycle Analysis · Revenue Realization · Data Quality Auditing · Metric Validation · Data Lineage · Business-Rule Documentation · Business Intelligence · Data Visualization · Deneb / Vega-Lite**

---

## Resume-Ready Project Description

> **Olist E-Commerce Analytics — Power BI**  
> Built a six-page business intelligence dashboard analyzing **R$13.22M in realized revenue across 96K delivered orders and 93K unique customers**, using MySQL analytical views, Power Query, DAX, RFM segmentation, cohort retention analysis, seller diagnostics, and fulfillment-aware delivery metrics. Implemented validation-first KPI definitions and a structured analytical layer to connect sales, customer lifecycle, product, seller, delivery, and review performance.

---

## Project Focus

This project demonstrates an end-to-end analytics workflow:

**Raw Data → Validation → Business Rules → Analytical SQL → Data Model → Analysis → Dashboard → Business Interpretation**

The emphasis is not only on making the numbers visible, but on making the **numbers defensible, traceable, and useful for business decisions**.
