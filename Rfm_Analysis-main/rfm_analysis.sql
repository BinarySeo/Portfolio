-- checking data
SELECT * FROM sales;

-- changing data type and format for column orderdate
set sql_safe_updates = 0;

update sales
set orderdate = str_to_date(orderdate,"%m/%d/%y%H:%i:%s");

select max(orderdate) from sales;


-- 6 status of order
select distinct status from sales;
-- 2003, 2004, 2005
select distinct year_id from sales;
-- 7 different product lines
select distinct productline from sales;
-- 19 different countries
select count(distinct country) from sales;
-- 3 different dealsize
select distinct dealsize from sales;
-- 4 different territory
select distinct territory from sales;


-- Analsis
-- Group by productline sory by sum of sales for each product line
select productline, sum(sales) from sales group by productline order by 2 desc;

-- group by year, to find out best year
select year_id, sum(sales) from sales
group by year_id order by 2 desc;
-- 2003, 2004 full operation but 2005 it had done by may.
select year_id,count( distinct month_id) from sales group by year_id order by 1 desc;
-- Dealsize comaprison.
select dealsize, sum(sales) from sales group by dealsize order by 2 desc;

 # best territory
select 
territory, avg(sales) as total_sales,count(orderdate) as total_order_quantity 
from sales group by territory order by 3 desc;


# Create temporary table for rfm

-- RFM analysis

-- determine the best customer

#creating temp table called rfm_temp to store query result as a table.
drop table if exists rfm_temp;



Create temporary table rfm_temp(
Customername char(50),
Monetary double,
Average_Monetary double,
Frequency int,
last_order_date date,
last_date date,
recency int,
rfm_recency int,
rfm_frequency int,
rfm_Monetary int,
Rfm_Cell int,
rfm_count_string char(10)

)
with rfm as (
	select customername,
		sum(sales) as Monetary,
		avg(sales) as Average_Monetary,
		count(orderdate) as Frequency,
		max(ORDERDATE) as last_order_date,
		(select max(orderdate) from sales) as last_date,
		datediff((select max(orderdate) from sales),max(ORDERDATE)) as recency
    from sales group by customername
),
rfm_calc as(
select r.*,
ntile(4) over (order by recency desc) as rfm_recency,
ntile(4) over (order by Frequency) as rfm_frequency,
ntile(4) over (order by Monetary) as rfm_Monetary
from rfm r
)
select 
	c.*, (rfm_recency + rfm_frequency +rfm_Monetary) as Rfm_Cell,
	concat(rfm_recency,rfm_frequency,rfm_Monetary) as Rfm_cell_string

from rfm_calc c;

#checking data in temporary table rfm_temp.
select * from rfm_temp;

#Define customer status by rfm analysis.
# Break down to customer -> scale from 1 to 4. 4 is the highest score.
# My target of customers are fairly new customer who 
# 
select customername, rfm_recency,rfm_frequency,rfm_Monetary,
	case
		when rfm_cell_string in (111,112,121,122,123,131,132,211,212,114,141) then "Inactive"
        when rfm_cell_string in (133,134,143,144,222,231,221,241,232,244) then "Possible inactive"
		when rfm_cell_string in (311,411,331,421,412) then "New"
        when rfm_cell_string in (312,313,314,223,323,322) then "Target"
        when rfm_cell_string in (234,233,333,341,431,441,321,422,332,432,433,434,443,444,334,343,344) then "Loyal "
	end  as customer_type
 from rfm_temp;
 


