#Created Database using alter and import fuction of MySql 
# where i created the Nesseccary Table names and used import fuction to import data from Excel csv file 

#Feature Engineering:
   # Create 3 new columns which can better help us answer and run some Queries

#1) to create column time of the day
alter table amazon
add column time_of_day VARCHAR(50);

UPDATE AMAZON
SET time_of_day = case 
when HOUR(amazon.Time) > 0 AND  HOUR(amazon.Time) < 12  then 'Morning'
when HOUR(amazon.Time) > 12 and  HOUR(amazon.Time) < 18 then 'Afternoon'
else 'Night'  END;

#2) to create column  day name
alter table amazon
add column DAYNAME VARCHAR(50);

UPDATE AMAZON
SET DAYNAME = DATE_FORMAT(Date,'%a');

#3) to create column  month name

alter table amazon
add column monthname VARCHAR(50);

UPDATE AMAZON
SET monthname = DATE_FORMAT(Date,'%b');



##########################################################################################
#Exploratory Data Analysis (EDA): 

#1) What is the count of distinct cities in the dataset?
select count(distinct City) from amazon;

#2) For each branch, what is the corresponding city?
select distinct Branch,City from amazon ;


# 3) What is the count of distinct product lines in the dataset?
select count(distinct `Product line`) from amazon ;

# 4) Which payment method occurs most frequently?
select max(Payment ) from amazon ;

# 5) Which product line has the highest sales?
select  `Product line`,sum(`gross income`) as Sales  from amazon GROUP BY `Product line` order by Sales desc;

# 6)  How much revenue is generated each month?
select 	monthname,sum(Total) as revenue from amazon group by monthname order by revenue; 

# 7) In which month did the cost of goods sold reach its peak?
select 	monthname,MAX(cogs) as cogs_sale from amazon group by monthname order by cogs_sale desc limit 1;

#8) Which product line generated the highest revenue?
SELECT `Product line`, sum(Total) as Revenue from amazon group by `Product line` order by Revenue DESC limit 1;

#9) In which city was the highest revenue recorded?
SELECT City, sum(Total) as Revenue from amazon group by City order by Revenue DESC limit 1;

#10) Which product line incurred the highest Value Added Tax?
SELECT `Product line`, sum(`VAT Tax 5%`) as vat from amazon group by `Product line` order by vat DESC limit 1;

#11) For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT `Product line`, sum(Total) as revenue ,case when sum(Total) >AVG(Total) then 'Good'else 'Bad' end as sales_agenda from amazon group by `Product line` ;

#12) Identify the branch that exceeded the average number of products sold.
select  AVG(Quantity) from amazon;
select distinct Branch FROM amazon where Quantity >( select  AVG(Quantity) from amazon) ;


#13)Which product line is most frequently associated with each gender?
WITH  ranked as(
select `Product line` ,Gender , count(*) as product_line_count, 
rank() over (PARTITION BY Gender order by count(*) desc) as rank_p from amazon
group by Gender , `Product line`)
SELECT `Product line`, Gender , product_line_count from ranked where rank_p =1;

#14) Calculate the average rating for each product line.
SELECT `Product line`, AVG(Rating) as RATING  from amazon group by `Product line` ;

# 15) Count the sales occurrences for each time of day on every weekday.

WITH new as(select time_of_day, total,DAYNAME FROM amazon where DAYNAME !='Sat' and DAYNAME !='Sun')
select DISTINCT DAYNAME,time_of_day,count(Total) from new group by DAYNAME,time_of_day;

# 16) Identify the customer type contributing the highest revenue.
select `Customer type`, sum(Total) as revenue from amazon group by `Customer type` order by sum(Total) desc ;

#17)Determine the city with the highest VAT percentage
 select City , COALESCE(sum(`VAT Tax 5%`)/ nullif(sum(Total),0)*100,null) as vat_per from amazon group by City order by vat_per desc;

#18)Identify the customer type with the highest VAT payments.
 select `Customer type` , sum(`VAT Tax 5%`) as max_vat from amazon group by `Customer type` order by max_vat desc;
 
#19) What is the count of distinct customer types in the dataset?
 select count( distinct `Customer type`) from amazon ;
 
#20) What is the count of distinct payment methods in the dataset?
  select count( distinct Payment) from amazon ;
  
#21) Which customer type occurs most frequently?
select `Customer type` , count(`Invoice ID`) as frequency from amazon group by `Customer type`
order by frequency desc;

 #22) Determine the predominant gender among customers.
select Gender , count(`Invoice ID`) as frequency from amazon group by Gender
order by frequency desc;

#23) Examine the distribution of genders within each branch.
select Gender , Branch ,count(`Invoice ID`) as frequency from amazon group by Gender,Branch
order by Branch, frequency desc;

# Product Analysis
#  FOOD AND BEVERAGES revenue is highest and doing good. Whereas Health and beauty need to increase its sales.


