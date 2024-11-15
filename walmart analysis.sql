 select * 
from [dbo].[sales]

---data reconstruction---

--time of day--
        
select time ,
        case 
		     when time between '00:00:00' and  '12:00:00' then 'morning'
            when time between '12:01:00' and  '16:00:00' then 'afternoon'
			   else 'evening'
			 end as time_of_day

			   from sales

			   alter table sales
			   add time_of_day varchar(20)
update sales
set time_of_day = (
        case 
		     when time between '00:00:00' and  '12:00:00' then 'morning'
            when time between '12:01:00' and  '16:00:00' then 'afternoon'
			   else 'evening'
			 end 
)
---day_name---

select format(date,'ddd ') as day_week
from sales

alter table sales
add day_of_week varchar(20)

update sales
set day_of_week = (format(date,'ddd ')
)

--month name--

alter table sales
add month_name varchar(20)

select format(date,'MMM ') as day_week
from sales

update sales
set month_name = (format(date,'MMM ')
)

--EDA-- 
SELECT DISTINCT city
from sales

SELECT DISTINCT branch
from sales

select distinct city,branch
from sales

--most common payment method--

select *
from sales

select distinct payment
from sales


select 
payment,
     count(payment) as amount_of_payments
	 from sales 
	 group by payment
	 order by amount_of_payments desc

--what is the most selling product line--

select * 
from sales

select 
product_line,
     count(product_line) as Orderd_product_line
	 from sales 
	 group by product_line
	 order by Orderd_product_line desc

--what is the total revenue by month--


select month_name as month
from sales

select month_name as month,
    sum(total) as total_revenue
	from sales
	group by month_name
	order by total_revenue desc

--what month had the largest COGS--


SELECT month_name as months,
sum(cogs) as cogs
from sales
group by month_name
order by cogs desc


--what product line had the largest revenue--

select product_line,
sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc

--what is the citi with the largest revenue--


select branch,city,
sum(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc


--what product line had the largest vat--


select product_line,
       AVG(tax_5) as avg_tax
	   from sales
	   group by product_line
	   order by avg_tax desc

--which branch sold more products than avarage products sold--
                         --COME BACK TO FIX--


select branch,
sum(quantity) as qty
from sales 
group by branch
having sum(quantity) > (select avg(quantity) from sales)

--what is the most common product line by gender--


select gender, product_line,
       count(gender)as total_cnt
	   from sales
	   group by gender, product_line 
	   order by total_cnt desc

-- what is the avarage rating of each product--

select 
  round (avg(rating), 2) as avg_rating,
	product_line
from sales
group by product_line
order by avg_rating desc

---------------------------------------------------------------------------------
--------------------sales---------------------------------------------------


--number of sales made in each time of the day per week--

select time_of_day,
       count(*) as total_sales
	   from sales 
	   where day_of_week = 'mon'
	   group by time_of_day 
	   order by total_sales desc


--which of the customer types bring in the most revenue--


SELECT customer_type, 
       sum (total)as total_rev
	   from sales
	   group by customer_type
	   order by total_rev desc

-- which city has the largest tax percent / vat (value added tax)?--


select city,
       avg(tax_5) as vat
	   from sales
	   group by city
	   order by vat desc


--What customer type pays the most in VAT?--

select customer_type,
       avg(tax_5) as customer_vat
	   from sales
	   group by customer_type
	   order by customer_vat desc

-------------------------------------------------------------------------------
------------------customer imfo-----------------------------------------------

--how many unique customer type does the data have--

select 
        distinct customer_type
from sales

--how many unique payment methods does the data have?--

select distinct payment
from sales

--what is the most common customer type?--

select customer_type, payment,
       count(customer_type) as customer_count,
	   count(payment) as payment_count
	   from sales 
	   group by customer_type,payment
	   order by customer_count desc

--which customer type buys the most--

select *
from sales

select customer_type,
       count(*) as cstm_count
	   from sales
group by customer_type
order by cstm_count desc

--what is the gender of most of the customers?--

select *
from sales

select gender,
       count(*) as gender_cnt
	   from sales
group by gender
order by gender_cnt desc

--what is the gender distribution per branch?--

select gender,
       count(*) as gender_cnt
	   from sales
	   where branch = 'A'
group by gender
order by gender_cnt desc