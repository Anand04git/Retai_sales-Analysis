--SQL RETAIL SALES ANALYSIS--


DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
		(
			transactions_id INT PRIMARY KEY,	
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantity INT,
			price_per_unit FLOAT,
			cogs FLOAT,
			total_sale FLOAT
		);

SELECT * FROM retail_sales;


--DATA CLEANING

SELECT * FROM retail_Sales
WHERE transactions_id is NULL;

SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

select COUNT(*) FROM retail_sales;

--DATA EXPLORATION
--how manyb sales we have
SELECT COUNT(*)
FROM retail_sales;

--How many unique customer we have
SELECT COUNT(DISTINCT customer_id) as total_sale 
from retail_sales;


--how many ctaegory we have
select distinct category from retail_sales;

-- DATA ANALYSIS && BUSSINESS KEY PROBLEM

--Q1:-- Write  a sql query to retrieve the total sales made on '2022-11-05'
Select * 
from retail_sales
where sale_date='2022-11-05';

-- Q2:- Write a sql query to retrieve all the transactions where the category is "clothing" and the quantity sold is more than 10 in the month of Nov-2022
Select * from retail_sales
where category='Clothing' and quantity>=4
and TO_CHAR(sale_date, 'YYYY-mm')='2022-11';

--Q3:- Writea sql query to retrieve total sales from all the category
select category, 
sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by category;

--Q4:- write a sql query to find the average age of customers who purchased items from the "beauty" category
select round(avg(age),2) as avg_age
from retail_Sales
where category='Beauty';

--Q5:- write a sql query to find all the transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale > 1000;

--Q6:- write a sql query to find the total number of transactions(transaction_id) made by each gender in each category
select category, gender, count(transactions_id)
from retail_sales
group by gender, category
order by 2;

--Q7:- write a sql query to calculate the average sale for each month. find the best selling month in each year.

select * from
(
select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
group by 1,2
) as t1
where rank=1;

--Q8:- write a sql query to find the top 5 customer based on the highest total_sale

select 
customer_id,
sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

--Q9:- write a sql query to find the number of unique customer who purchased items from each category
select  
category,
count(distinct customer_id) as unique_customers
from retail_sales
group by 1;

--Q10:- write a sql query to create each shifts and number of order (Example Morning<12, Afternoon between 12 &17, Evening>17)
with hourly_sales
as
(
select *,
	case
		when extract(hour from sale_time)<12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sales
group by shift;

