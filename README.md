# Local Bike - Analytics Engineering Case Study

## Project Structure

* **Staging Layer**: Raw data cleaning and standardization (9 models)
  - Cleans and validates source data from BigQuery
  - Each table includes a source_id column for data lineage
  
* **Intermediate Layer**: Business logic and complex transformations (2 models)
  - int_order_items_enriched: Order items with product details and discounts
  - int_stocks_enriched: Inventory data enriched with location info
  
* **Marts Layer**: Dimensional star schema optimized for Power BI analytics (6 models)
  - fact_sales: Sales transactions grain (1 item per row, 4,722 rows)
  - dim_customers, dim_products, dim_stores, dim_categories, dim_date
  
* **Data Quality**: Complete test coverage with native dbt tests
  - Unique constraints (primary keys)
  - Not null validations (required fields)
  - Referential integrity (foreign keys)
  - Business rule validations

## Running this project
```bash
dbt run
dbt test
dbt docs generate
```
## Power BI Report

### Overview
- **File**: `localbike_report_databird_loicoliere.pbix`
- **Pages**: 5 (Cover + Executive Overview + 3 Analysis pages)
- **Data Source**: BigQuery (`raw_localbike`)
- **Refresh Frequency**: Manual (ad-hoc)

### Key Metrics
- Total Revenue: $8,578,244
- Orders: 1,615 (Completion Rate: 89.5%)
- Rejected Orders: 45 (2.8% loss)
- DAX Measures: 17+ (DISTINCTCOUNT, CALCULATE, IF, VAR)


### Pages Structure

#### Page 0: Cover
Introduction and project context

#### Page 1: Executive Overview
KPI Dashboard with key metrics:
- Total Revenue: $8.5M
- Revenue by Store: Baldwin 67.9%, Santa Cruz 20.9%, Rowlett 11.2%
- Quarterly Trends: 2016-2018

#### Page 2: Product Portfolio & Revenue Analysis
Analysis of revenue by product category and price segment

#### Page 3: Discount Impact Analysis
Impact assessment of discount strategies by category and store

#### Page 4: Order Status & Conversion Pipeline
Order completion pipeline and rejection analysis

### DAX Measures
- **17+ measures**: DISTINCTCOUNT, CALCULATE, IF, VAR
- See Power BI Model for complete measure definitions

### Slicers & Filters
- Store Filter (Baldwin, Santa Cruz, Rowlett)
- Date Range Filter (2016-2018)
- Year Selector (Executive Overview)

### Relationships
All relationships validated in Model view:
- fact_sales ↔ orders ↔ dim_products ↔ dim_categories ↔ dim_brands
- fact_sales ↔ dim_stores

### Usage Guide
1. Open localbike_report_databird_loicoliere.pbix in Power BI Desktop
2. Select filters to explore data by store and date
3. Navigate through 5 pages for different analyses
