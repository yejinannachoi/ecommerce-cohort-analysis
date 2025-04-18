# Ecommerce Customer Cohort Analysis
![MySQL](https://img.shields.io/badge/MySQL-blue) ![Data Analysis](https://img.shields.io/badge/Data_Analysis-purple) ![MS Excel](https://img.shields.io/badge/MS_Excel-green) ![Data Visualization](https://img.shields.io/badge/Data_Visualization-red) ![Cohort Analysis](https://img.shields.io/badge/Cohort_Analysis-yellow)

## Objective

This project explores customer behavior by grouping ecommerce users into cohorts based on the month of their first purchase. The goal is to understand how long customers remain active after their first purchase, generate value over time, and how different factors (like coupons or marketing campaigns) may influence their behavior. The results of this analysis can help guide marketing investments and strategic decisions, particularly around customer retention.
## Dataset

The dataset `Onlinesales_info.csv` is from [Dacon's Ecommerce Customer Segmentation Analysis Competition](https://dacon.io/competitions/official/236222/data) and contains transaction records from an ecommerce platform.
- **customer_id** (`고객ID`): Unique identifier for each customer  
- **transaction_id** (`거래ID`): Unique identifier for each transaction  
- **transaction_date** (`거래날짜`): Date when the transaction occurred  
- **product_id** (`제품ID`): Unique identifier for each product  
- **product_category** (`제품카테고리`): Category to which the product belongs  
- **quantity** (`수량`): Number of items purchased in the transaction  
- **unit_price** (`평균금액`): Price per unit (in USD); may vary based on product options  
- **shipping_fee** (`배송료`): Delivery cost (in USD) associated with the transaction  
- **coupon_status** (`쿠폰상태`): Indicates whether a discount coupon was applied

## Key Outputs

- **User Retention Chart**: Rolling retention by first order month
- **Revenue by Cohort**: Monthly revenue contribution from each cohort
- **Revenue Retention**: Percentage of revenue retained over time
- **Average Order Value**: Tracked across cohorts and months
