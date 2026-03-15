
select * from [gold.fact_sales]

--Sales performance over time

select order_date, sales_amount from [gold.fact_sales]
where order_date is not null
and order_date <>''
order by order_date 

--- Aggregating the sales group amount

select order_date,sum(cast(sales_amount as float)) as total_sales from [gold.fact_sales]
where order_date is not null 
group by order_date
order by order_date

---Aggregating by year, number of customers increased/ decreased, quantit kpi:

select YEAR(order_date) as order_year, sum(cast(sales_amount as float )) as total_sales,
count (distinct customer_key) as total_customers,
sum(cast(quantity as int)) as total_quantity from [gold.fact_sales]
where order_date is not null
group by YEAR(order_date)
order by YEAR(order_date)

---Aggregating by month, number of customers increased/ decreased, quantit kpi:

select MONTH(order_date) as order_month,sum(cast(sales_amount as float)) as total_sales,
count(distinct customer_key) as total_customers,
sum(cast(quantity as int)) as total_quantity
from [gold.fact_sales]
where  order_date is not null
group by MONTH(order_date)
order by MONTH(order_date)


--- Aggregating by month & year both:

SELECT 
    CAST(DATETRUNC(month, order_date) AS DATE) AS order_month,
    SUM(CAST(sales_amount AS FLOAT)) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(CAST(quantity AS INT)) AS total_quantity
FROM [gold.fact_sales]
WHERE order_date IS NOT NULL
GROUP BY CAST(DATETRUNC(month, order_date) AS DATE)
ORDER BY order_month;



---  ***//// CUMULATIVE ANALYSIS


---- Calculate the total sales per month and the running total of sales over time using window function  ////*** ----

select order_date,total_Sales,
sum(total_sales) over ( order by order_date) as running_total_sales 
from
(
select cast(datetrunc(month, order_date) as date) as order_date , 
sum(cast(sales_amount as float)) as total_sales
from [gold.fact_sales]
where order_date is not null
group by CAST(DATETRUNC(month, order_date) AS DATE)

)t
ORDER BY order_date



---- ***/// CUMULATIVE ANALYSIS
---- Calculate the total sales by year and the running total of sales over time using window function  ///****------

select 
order_date, total_sales,
sum(total_sales ) over (order by order_date) as running_total_sales 
from
(
select cast(datetrunc(year,order_date) as date) as order_date,
sum(cast(sales_amount as float)) as total_sales
from [gold.fact_sales]
where order_date is not null
group by cast(datetrunc(year,order_date) as date )
)t
order by  order_date



--- Calculating the Moving Average Price:

select 
order_date, total_sales,
sum(total_sales ) over (order by order_date) as running_total_sales, 
avg(avg_price ) over (order by order_date) as moving_avg_price
from
(
select cast(datetrunc(year,order_date) as date) as order_date,
sum(cast(sales_amount as float)) as total_sales,
AVG(cast(price as int)) as avg_price
from [gold.fact_sales]
where order_date is not null
group by cast(datetrunc(year,order_date) as date )
)t
order by  order_date


------- ***/////  PERFORMANCE ANALYSIS -comapre the current value wih target value  //////*** -------

--- ***////  Yearly performance of products by comapring the sales to both the avg. current sales performance of the product 

--- and previous year sales   ****///// ----

with yearly_product_sales as(

select YEAR(f.order_date) order_year,p.product_name,sum(cast(f.sales_amount as float)) as current_sales  
from [gold.fact_sales] f
left join [gold.dim_products] p
on f.product_key = p.product_key
where order_date is not null 
group by YEAR(order_date),p.product_name
)

select order_year,product_name,current_sales,
avg(current_sales ) over (partition by product_name) as avg_sales,
current_sales - avg(current_sales) over (partition by product_name) as diff_avg,
case when current_sales - avg(current_sales) over (partition by product_name) > 0 then 'Above Avg.'
     when current_sales - avg(current_sales) over (partition by product_name) < 0 then 'Below Avg.'
	 else 'Avg'
	 end Avg_change
from yearly_product_sales
order by product_name,order_year


---- ***////  Comparing it to previous year sales 

with previous_yearly_sales as(

select YEAR(f.order_date) as order_year,p.product_name,

sum(cast(f.sales_amount as float)) as current_sales 
from [gold.fact_sales] f
left join [gold.dim_products] p
on f.product_key = p.product_key
where order_date is not null
group by YEAR(order_date),p.product_name
)
----Year over Year Analysis

select order_year,product_name,current_sales,
avg(current_sales) over (partition by product_name) as avg_sales,
current_sales - avg(current_sales) over(partition by product_name) as diff_avg,
case when current_sales - avg(current_sales) over(partition by product_name) > 0 then 'Above Avg.'
     when current_sales - avg(current_sales) over(partition by product_name) < 0 then 'Below Avg.'
	 else 'Average'
	 end Avg_change,
	 LAG(current_sales)over(partition by product_name order by order_year) py_sales,
	 current_sales - 	 LAG(current_sales)over(partition by product_name order by order_year) as diff_sales,
	 case when current_sales -LAG(current_sales)over(partition by product_name order by order_year) > 0 then 'Increase'
          when current_sales - LAG(current_sales)over(partition by product_name order by order_year) < 0 then 'Decrease'
	      else 'No_Change'
		  end py_change
from previous_yearly_sales
order by product_name,order_year




---- ///*** Part - to - Whole Analysis -------  ****/////


-----  Which categories contribute the most to overall sales 

with category_sales as(

select category, sum(cast(sales_amount as float)) as total_sales 

from [gold.fact_sales] f
left join [gold.dim_products] p
on f.product_key = p.product_key
group by category
)

select category,total_sales,
sum(total_sales)over () overall_sales,
concat(ROUND((cast(total_sales as float) /sum(total_sales)over())* 100, 2), '%')as percentage_of_total
from category_sales
order by total_sales


------****////   ADVANCED ANALYTICS  //////*****

----  Data Segmentation

---- Segment products into cost ranges and count how many products fll into each segment 

with products_segment as (
select product_name,product_key,cost,

case when cost < 100 then 'Below 100'
     when cost between 100 and 500 then '100-500'
	 when cost between 500 and 1000 then '500-1000'
	 else 'Above 1000'
	 end cost_range
from [gold.dim_products])

select 
cost_range, count(product_key) as total_products 
from products_segment
group by cost_range
order by total_products desc



----- ///// **** Group customers into 3 segments based on their spending behaviour:

---  * 1. VIP: at least 12 months of history and spending more than 5000.
---  * 2. Regular: at least 12 months of history but spending 5000 or less
---  * 3. New: lifespan less than 12 months

----  And find the total numbers of customers by each group 

with customer_spending as (

select c.customer_key, sum(cast(f.sales_amount as float)) as total_spending ,f.order_date,
MIN(order_date) as first_order,
MAX(Order_date) as last_order,
datediff(month,min(order_date),max(order_date)) as lifespan

from [gold.fact_sales] f

left join [gold.dim_customers] c
on f.customer_key=c.customer_key
group by c.customer_key,f.sales_amount,f.order_date
)

select customer_key,
total_spending,lifespan,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
	 ELSE  'New'
	 END customer_segment 

from customer_spending




with customer_spending as (

select c.customer_key, sum(cast(f.sales_amount as float)) as total_spending ,f.order_date,
MIN(order_date) as first_order,
MAX(Order_date) as last_order,
datediff(month,min(order_date),max(order_date)) as lifespan

from [gold.fact_sales] f

left join [gold.dim_customers] c
on f.customer_key=c.customer_key
group by c.customer_key,f.sales_amount,f.order_date
)

select customer_segment,
count(customer_key )as total_customers
FROM(
Select customer_key,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
	 ELSE  'New'
	 END customer_segment 

from customer_spending) t
group by customer_segment
order by total_customers DESC


---- ////// *****   Segmenting on the basis of only total_spending ***///// 


with customer_spending as (

select c.customer_key, sum(cast(f.sales_amount as float)) as total_spending ,f.order_date,
MIN(order_date) as first_order,
MAX(Order_date) as last_order
from [gold.fact_sales] f

left join [gold.dim_customers] c
on f.customer_key=c.customer_key
group by c.customer_key,f.sales_amount,f.order_date
)

select customer_key,
total_spending,
CASE WHEN  total_spending > 5000 THEN 'VIP'
     WHEN  total_spending <= 5000 THEN 'Regular'
	 ELSE  'New'
	 END customer_segment 

from customer_spending








