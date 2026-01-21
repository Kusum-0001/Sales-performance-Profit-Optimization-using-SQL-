create database sales ;
use sales;
show tables ;


select * from samplesuperstore ;
select count(*) from samplesuperstore;

-- CHECK NULL VALUES OR ABNORMAL VALUES

Select count(*) as total_rows,
	sum(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    sum(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS null_profit,
    sum(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END ) AS null_discount
    from samplesuperstore;
-- overall business KPIs
Select sum(Sales) As total_revenue , 
sum(Profit) As total_profit,
Round(sum(profit) / sum(sales) * 100,2) As profit_margin_percentage,
Count(*) As total_orders 
from  samplesuperstore; 


-- Region Wise Sales & Profit Performance

Select 
Region, 
sum(Sales) As total_revenue , 
sum(Profit) As total_profit,
Round(sum(profit) / sum(sales) * 100,2) As profit_margin 
from samplesuperstore
group by Region
order by profit_margin ASC;


-- Category - Wise Performance

Select Category,
sum(Sales) As revenue , 
sum(Profit) As profit
from  samplesuperstore
group by category
order by profit ASC; 


-- Sub-Category Profit Leakage

Select sub_category,
sum(Sales) As revenue , 
sum(Profit) As profit
from  samplesuperstore
group by sub_category
Having  sum(Profit)< 0 
order by profit ASC; 


-- TOP & BOTTOM SUB-CATEGORIES BY PROFIT
-- Top10  loss 
Select sub_category,
sum(Sales) As revenue , 
sum(Profit) As profit
from  samplesuperstore
group by sub_category
order by profit ASC
Limit 10;

-- Top10 profit
Select sub_category,
sum(Sales) As revenue , 
sum(Profit) As profit
from  samplesuperstore
group by sub_category
order by profit DESC
Limit 10;


-- DISCOUNT VS PROFIT ANALYSIS

Select 
Discount ,
count(*) order_count,
sum(sales) AS revenue,
sum(profit) AS Profit
from samplesuperstore
group by discount 
order by discount;
 

-- DISCOUNT BUCKET ANALYSIS

Select 
CASE 
	when discount <= 0.10 THEN '0-10%' 
    when discount <= 0.20 THEN '10-20%'
    when discount <= 0.30 THEN '20-30%'
    ELSE '30%+'
    END AS discount_bucket,
    sum(sales) AS revenue,
    sum(profit) AS Profit
    FROM samplesuperstore
    group by discount_bucket 
    order by discount_bucket;
    
    
    
-- HIGH DISCOUNT LOSS IDENTIFICATION

Select 
Category ,
sub_category,
AVG(Discount) AS avg_discount,
SUM(Profit) AS total_profit
from samplesuperstore
group by Category, sub_category
Having AVG(Discount) > 0.30 and SUM(Profit) < 0
Order by total_profit;



 -- SEGMENT-WISE  PROFITABILITY
 
 select segment,
 SUM(Sales) AS revenue,
 SUM(Profit) AS profit,
 ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS profit_margin
 from samplesuperstore
 group by segment
  order by profit;
  
  
--  PROFIT LEAKAGE SCORE 

select 
sub_category ,
SUM(
	CASE 
		WHEN profit < 0 THEN Sales*Discount
        ELSE 0
	END) AS profit_leakage_score
  FROM samplesuperstore 
  GROUP BY sub_category
  ORDER BY profit_leakage_score DESC;