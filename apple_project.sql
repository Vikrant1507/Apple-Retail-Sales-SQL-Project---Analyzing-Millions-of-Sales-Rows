-- Apple Sales Project - 1M rows Sales dataset

select * from category;
select * from Products;
select* from stores;
select * from sales;
select * from warranty;


--EDA
select distinct repair_status from warranty;

select count(*) from sales;

-- Improving Query Performances

--execution time 64 ms
-- planning time 0.076 ms

---execution time after index 4.79 ms
-- planning time 1.72 ms
EXPLAIN ANALYZE
select * from sales 
WHERE product_id ='P-44'

CREATE INDEX sales_product_id on sales(product_id);


--execution time 123 ms
-- planning time 0.096 ms
---execution time after index 2.74 ms
-- planning time 1.77  ms
EXPLAIN ANALYZE
select * from sales 
WHERE store_id ='ST-31'

CREATE INDEX sales_store_id on sales(store_id);

-- 1.Find each country and number of stores
select country, count(store_id) as Total_Stores
from stores
Group by country
order by Total_Stores desc;

-- What is the total number of units sold by each store?
select 
st.store_id,
st.store_name,
sum(quantity) as total_units
from sales sl inner join stores st
on st.store_id = sl.store_id
Group by st.store_id,st.store_name
order by total_units Desc;
-- or group by 1,2
--order by 3

--How many sales occurred in December 2023?
select
count(sale_id) as total_sales
from sales
where TO_CHAR(sale_date,'MM-YYYY') = '12-2023';

select
*,
TO_CHAR(sale_date,'MM-YYYY')
from sales
where TO_CHAR(sale_date,'MM-YYYY') = '12-2023';

-- 4 How many stores have never had a warranty claim filed against any of their products?
 select * from stores
 where store_id NOT IN(
 						select 
 						distinct(store_id)
 						--store_id
 						from warranty w left join sales s
 						on w.sale_id = s.sale_id);-- recieved warranty claims stores

select count(*) as total_stores_not_claimed_warranty from stores
where store_id NOT IN(
 						select 
 						distinct(store_id)
 						--store_id
 						from warranty w left join sales s
 						on w.sale_id = s.sale_id);-- recieved warranty claims stores

-- 5. What percentage of warranty claims are marked as "Warranty Void"?
select 
ROUND
(count(claim_id)/
				(select count(*) from warranty):: numeric * 100,2)
as warranty_void_percentage
from warranty
where repair_status = 'Warranty Void';

-- 6. Which store had the highest total units sold in the last year?
select * from sales

select 
store_id,
sum(quantity) as Total_units_sold
from sales
where sale_date > (CURRENT_DATE - INTERVAL '1 Year')
Group By store_id
order By Total_units_sold desc
limit 1

-- 7. Count the number of unique products sold in the last year.
select * from sales;

select 
count(distinct(product_id)) as unique_products
from sales
where sale_date >= (Current_date - Interval '1 year');

--8. What is the average price of products in each category?

select
c.category_id,
c.category_name,
round(avg(price)) as average_price
from 
products p join category cs
on p.category_id = c.category_id
Group by c.category_id
order by average_price desc;

--How many warranty claims were filed in 2020?
select 
count(claim_id) as warranty_claims
from warranty
where extract(year from claim_date) = 2020; 

-- Identify each store and best selling day based on highest qty sold
select * 
from
(select
store_id,
to_char(sale_date,'Day') as day_name,
sum(quantity) as total_unit_sold,
RANK() over(partition by store_id order by sum(quantity)desc) as rank 
from sales
group by store_id,day_name
) as t1
where rank =1

--Identify least selling product of each country for each year based on total unit sold
WITH product_rank AS (
    SELECT
        st.country,
        p.product_name,
        EXTRACT(YEAR FROM sl.sale_date) AS year,
        SUM(sl.quantity) AS total_quantity_sold,
        RANK() OVER(PARTITION BY st.country, EXTRACT(YEAR FROM sl.sale_date) ORDER BY SUM(sl.quantity) DESC) AS rank
    FROM
        stores st
    JOIN
        sales sl ON st.store_id = sl.store_id
    JOIN
        products p ON p.product_id = sl.product_id
    GROUP BY
        st.country, p.product_name, EXTRACT(YEAR FROM sl.sale_date)
)
SELECT *
FROM product_rank
WHERE rank = 1;

-- 12. How many warranty claims were filed within 180 days of a product sale?

select
	w.*,
	s.sale_date,
	w.claim_date - s.sale_date as Claim_days
from warranty w 
left join 
sales s
on s.sale_id = w.sale_id
where 
	w.claim_date - s.sale_date <=180;


-- 13. How many warranty claims have been filed for products launched in the last two years?

select
	p.product_id,
	p.product_name,
	p.launch_date,
	count(w.claim_id) as claims
from warranty w
join 
sales s on
s.sale_id = w.sale_id
join products p on
p.product_id = s.product_id
where 
p.launch_date >= CURRENT_DATE - INTERVAL '2 YEARS'
group by 1,2;


/* select
	p.product_id,
	p.product_name,
	p.launch_date,
	w.claim_date,
	p.launch_date - w.claim_date as claim_days
from warranty w
join 
sales s on
s.sale_id = w.sale_id
join products p on
p.product_id = s.product_id
where 
p.launch_date >= CURRENT_DATE - INTERVAL '2 YEARS' */


-- 14 List the months in the last three years where sales exceeded 5,000 units in the USA.
SELECT 
	TO_CHAR(sale_date,'MM-YYYY') as month,
	SUM(s.quantity) as Total_sales
FROM sales as s
JOIN
stores as st
on s.store_id = st.store_id
WHERE
	st.country ='USA'
	AND
	s.sale_date >= CURRENT_DATE - INTERVAL '3 year'
GROUP BY month
HAVING SUM(s.quantity)> 5000

-- Q.15 Identify the product category with the most warranty claims filed in the last two years.
SELECT
	c.category_name,
	Count(w.claim_id) as total_claims	
FROM warranty as w
LEFT JOIN Sales s
on w.sale_id = s.sale_id
JOIN products as p
on s.product_id = p.product_id
JOIN category as c
on p.category_id = c.category_id
WHERE 
	w.claim_date >= CURRENT_DATE - INTERVAL '2 year'
GROUP BY 1

-- Complex Problems
-- Q.16 Determine the percentage chance of receiving warranty claims after each purchase for each country!
select
	country,
	total_sales,
	total_claims,
	ROUND(coalesce(total_claims::numeric/total_sales::numeric * 100,0),2) as percentage_warranty_claims
FROM
(SELECT 
	st.country,
	sum(s.quantity) as total_sales,
	count(w.claim_id) as total_claims
from sales as s
join
stores as st
on s.store_id = st.store_id
left join
warranty as w
on s.sale_id = w.sale_id
group by st.country) t1
order by 4 desc

-- Q.17 Analyze the year-by-year growth ratio for each store.
WITH yearly_sales
AS
(
select 
	st.store_id,
	st.store_name,
	extract(year from s.sale_date) as year,
	sum(p.price * s.quantity ) as total_sale
from sales as s
join
products as p
on s.product_id = p.product_id
join stores st
on s.store_id = st.store_id
group by 1,2,3
order by 1,2,3 
),
Growth_Ratio
AS
(
 Select
	store_name,
	year,
	LAG(total_sale,1) OVER(partition by store_name order by year) as last_year_sale,
	total_sale as current_year_sale
from yearly_sales
)

SELECT 
	store_name,
	year,
	last_year_sale,
	current_year_sale,
	ROUND(
			(current_year_sale - last_year_sale)::numeric/
							last_year_sale::numeric * 100,3) as growth_ratio
FROM growth_ratio
where
	last_year_sale is NOT NULL
	AND
	year<>EXTRACT(YEAR FROM CURRENT_DATE);

-- Q.18 Calculate the correlation between product price and warranty claims for 
-- products sold in the last five years, segmented by price range.

SELECT
	CASE
		when p.price < 500 then 'LESS EXPENSIVE PRODUCT'
		when p.price between 500 and 1000 then'MID RANGE PRODUCT'
		else 'EXPENSIVE PRODUCT'
	END as price_Segment,
	count(w.claim_id) as Total_claims
FROM warranty as w
left join sales as s
on w.sale_id = s.sale_id
join products as p
on p.product_id =s.product_id
where claim_date >= CURRENT_DATE - INTERVAL '5 year'
group by 1


-- Q.19 Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed

WITH paid_repair
AS
(select 
	s.store_id,
	count(w.claim_id) as paid_repaired
from sales as s
Right join warranty as w
on s.sale_id = w.sale_id
where w.repair_status = 'Paid Repaired'
Group by 1
),

total_repaired
AS
(select 
	s.store_id,
	count(w.claim_id) as total_repaired
from sales as s
Right join warranty as w
on s.sale_id = w.sale_id
Group by 1
)

select
	tr.store_id,
	st.store_name,
	pr.paid_repaired,
	tr.total_repaired,
	ROUND(pr.paid_repaired::numeric /tr.total_repaired::numeric *100,2) as percentage_paid_repaired
from paid_repair as pr
JOIN
total_repaired as tr
on pr.store_id = tr.store_id
JOIN stores as st
on st.store_id = tr.store_id
ORDER BY percentage_paid_repaired DESC

-- -- Q.20 Write a query to calculate the monthly running total of sales for each store
-- over the past four years and compare trends during this period.

WITH monthly_sales
AS
(
select
	s.store_id,
	EXTRACT(YEAR from s.sale_date) as year,
	EXTRACT(MONTH from s.sale_date) as month,
	SUM(p.price * s.quantity) as total_revenue
from sales as s
join products as p
on p.product_id = s.product_id
GROUP BY s.store_id,year,month
ORDER BY s.store_id,year,month
)
SELECT 
	store_id,
	month,
	year,
	total_revenue,
	SUM(total_revenue) OVER(PARTITION BY store_id ORDER BY year, month) as running_total
FROM monthly_sales

























