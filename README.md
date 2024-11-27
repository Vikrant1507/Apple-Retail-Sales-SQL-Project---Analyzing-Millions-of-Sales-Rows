# Apple-Retail-Sales-SQL-Project---Analyzing-Millions-of-Sales-Rows

Link for the Dataset: https://drive.google.com/drive/folders/10z46zcJEH7G3D-uqCbRkD5yB48TAgYFA?usp=sharing

Project Overview
This project is designed to showcase advanced SQL querying techniques through the analysis of over 1 million rows of Apple retail sales data. The dataset includes information about products, stores, sales transactions, and warranty claims across various Apple retail locations globally. By tackling a variety of questions, from basic to complex, you'll demonstrate your ability to write sophisticated SQL queries that extract valuable insights from large datasets.

The project is ideal for data analysts looking to enhance their SQL skills by working with a large-scale dataset and solving real-world business questions.

Database Schema
The project uses five main tables:

stores: Contains information about Apple retail stores.

store_id: Unique identifier for each store.
store_name: Name of the store.
city: City where the store is located.
country: Country of the store.
category: Holds product category information.

category_id: Unique identifier for each product category.
category_name: Name of the category.
products: Details about Apple products.

product_id: Unique identifier for each product.
product_name: Name of the product.
category_id: References the category table.
launch_date: Date when the product was launched.
price: Price of the product.
sales: Stores sales transactions.

sale_id: Unique identifier for each sale.
sale_date: Date of the sale.
store_id: References the store table.
product_id: References the product table.
quantity: Number of units sold.
warranty: Contains information about warranty claims.

claim_id: Unique identifier for each warranty claim.
claim_date: Date the claim was made.
sale_id: References the sales table.
repair_status: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).
Objectives
The project is split into three tiers of questions to test SQL skills of increasing complexity:

Easy to Medium (10 Questions)
1: Find the number of stores in each country.
2: Calculate the total number of units sold by each store.
3: Identify how many sales occurred in December 2023.
4: Determine how many stores have never had a warranty claim filed.
5: Calculate t6:he percentage of warranty claims marked as "Warranty Void".
7: Identify which store had the highest total units sold in the last year.
8: Count the number of unique products sold in the last year.
9: Find the average price of products in each category.
10: How many warranty claims were filed in 2020?
For each store, identify the best-selling day based on the highest quantity sold.

Medium to Hard (5 Questions)
11: Identify the least selling product in each country for each year based on total units sold.
12; Calculate how many warranty claims were filed within 180 days of a product sale.
13: Determine how many warranty claims were filed for products launched in the last two years.
14: List the months in the last three years where sales exceeded 5,000 units in the USA.
15 : Identify the product category with the most warranty claims filed in the last two years.

Complex (5 Questions)
16:Determine the percentage chance of receiving warranty claims after each purchase for each country.
17: Analyze the year-by-year growth ratio for each store.
18: Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
19: Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed.
20: Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.
