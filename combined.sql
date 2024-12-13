-- Customer Sales Insights
create database sales;
use sales;

create table orders (
order_id varchar(50) primary key,
order_date date,
customer_id varchar(50),
region varchar(50), 
product_id varchar(50),
sale float,
profit float,
discount float, 
quantity int, 
category varchar(50));

create table product (
product_id varchar(50) primary key,
product_name varchar(50),
category varchar(50),
sub_category varchar(50));

create table customer 
(
customer_id varchar(50) primary key,
customer_name varchar(50),
segment varchar(50)
);
-- 1. Total Sales by Category
select sum(sale) as total_sales , category 
from orders
group by category;-- 2. Count the Number of Orders for Each Customer
select count(order_id), customer_id
from orders
group by customer_id;
-- 3.Sales by Region with Rank

select 
region, sum(sale) as total_sales, rank() over (order by sum(sale) desc) as sales_rank

from orders

group by region ;
-- 4. Analyze Customer Profitability by Segment
select 
customer.customer_id, 
customer.segment, 
sum(profit) as total_profit
from 
customer
join 
orders on customer.customer_id= orders.customer_id
group by 
customer_id, segment
order by 
total_profit desc
limit 5;

-- 5. Rank Products by Sales within Each Category
select 
orders.category,
product_name,
sum(sale) as total_sales,
rank() over( partition by category order by sum(sale) desc) as sale_rank

from 
orders
join 
product on orders.product_id = product.product_id

group by category, product_name
order by 
category , sale_rank;

-- 6. Total Sales per Customer by Product Category (sale>500)

select 
customer.customer_id,
customer.customer_name,
orders.category,
sum(sale) as total_sales
from orders
join
 customer on orders.customer_id = customer.customer_id
 join 
 product on orders.product_id = product.product_id
 where 
 order_date between '2024-01-01' and '2024-12-31'
 group by 
 customer_id, customer_name, category
 having 
 sum(sale)>500
 order by total_sales desc
 limit 5;