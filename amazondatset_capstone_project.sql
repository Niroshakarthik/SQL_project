create database capstone_amazon ----Creating database to analyse the sale of amazon
use capstone_amazon

----Data wrangling--
-----Creating the table and inserting the data
-----NOT NULL is used to avoid the null values in the table

CREATE table amazons(
invoice_id VARCHAR(30) NOT NULL,
branch VARCHAR(5) NOT NULL, 
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL, 
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity int NOT NULL,
VAT float NOT NULL,
total decimal(10,2) NOT NULL,
date date NOT NULL,
time time NOT NULL,
payment VARCHAR(50) NOT NULL,
cogs decimal(10,2) NOT NULL,
gross_margin_percentage float NOT NULL,
gross_income decimal(10,2) NOT NULL,
rating float NOT NULL
);
select * from amazons
---Feature Engineering: This will help us generate some new columns from existing ones.
----2.1  Add a new column named timeofday to give insight of sales in the Morning, Afternoon and EveningALTER table amazons
ADD COLUMN time_of_day. 
----This will help answer the question on which part of the day most sales are made.

SELECT * FROM amazons

ALTER TABLE amazons
ADD  time_of_day varchar(20);

UPDATE amazons
SET time_of_day=
CASE 
WHEN HOUR(amazons.time)>=0 AND HOUR(amazons.time)<12 THEN "Morning"
WHEN HOUR(amazons.time)>=12 AND HOUR(amazons.time)<18 THEN "Afternoon"
ELSE "Evening" 
END

SELECT time_of_day from amazons

---2.2 Add a new column named dayname that contains the extracted days of the week on
--- which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer
 ---the question on which week of the day each branch is busiest.
 
--- Creating the column day_name int the existing tabe
 ALTER table amazons
 add day_name VARCHAR(30)amazons
 
 UPDATE amazons
 SET day_name=DATE_FORMAT(amazons.date, '%a');

SELECT day_name from amazons

----2.3 Add a new column named monthname that contains the extracted months of the year on 
----which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year 
----- the most sales and profit.
alter table amazons
add column month_name varchar(20)
update amazons
set month_name = monthname(date);

SELECT month_name FROM amazons

----Questions To Answer:
---1.What is the count of distinct cities in the dataset?
SELECT COUNT(DISTINCT city) AS distinct_city_count FROM amazons

---2.For each branch, what is the corresponding city?
SELECT DISTINCT branch, city FROM amazons

---3.What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT product_line) as count_of_product_line FROM amazons
----4.Which payment method occurs most frequently?
SELECT * FROM amazons
SELECT product_line, count(payment) as payment_method  FROM amazons
GROUP BY product_line
ORDER BY payment_method DESC
LIMIT 1
---5.Which product line has the highest sales?
SELECT product_line, sum(total) AS total_sale FROM amazons
GROUP BY product_line
ORDER BY total_sale DESC



---6.How much revenue is generated each month?
SELECT month_name, SUM(total) as revenue FROM amazons
GROUP BY month_name
----7.In which month did the cost of goods sold reach its peak?
SELECT month_name, sum(cogs) as total_cogs FROM amazons
GROUP BY month_name
ORDER BY total_cogs DESC
LIMIT 1
---8.Which product line generated the highest revenue?
SELECT product_line, SUM(total) as revenue FROM amazons
GROUP BY product_line
ORDER BY revenue DESC
LIMIT 1
----9.In which city was the highest revenue recorded?
SELECT city, SUM(total) AS revenue FROM amazons
GROUP BY city
ORDER BY revenue DESC
LIMIT 1
-----10.Which product line incurred the highest Value Added Tax?
SELECT product_line, SUM(VAT) value_added_tax FROM amazons
GROUP BY product_line
ORDER BY value_added_tax DESC
LIMIT 1

----11.For each product line, add a column indicating "Good" 
---if its sales are above average, otherwise "Bad."
SELECT product_line, 
CASE 
WHEN gross_income> (SELECT avg(gross_income) FROM amazons) THEN "good"
ELSE "bad"
END AS sale
FROM amazons
---12.Identify the branch that exceeded the average number of products sold.
SELECT 
	branch, sum(quantity) AS total_quantity
FROM 
	amazons
GROUP BY branch
HAVING sum(quantity)>(SELECT avg(quantity) FROM amazons);
---13.Which product line is most frequently associated with each gender?
SELECT product_line, count(product_line) AS no_of_products,gender FROM amazons WHERE gender='male'
GROUP BY PRODUCT_LINE
ORDER BY no_of_products DESC
LIMIT 1
 
SELECT product_line, count(product_line) AS no_of_products,gender FROM amazons WHERE gender='female'
GROUP BY PRODUCT_LINE
ORDER BY no_of_products DESC
LIMIT 1
---14.Calculate the average rating for each product line.
SELECT product_line, AVG(rating) AS avg_rating FROM amazons
GROUP BY product_line
---15.Count the sales occurrences for each time of day on every weekday.
select day_name from amazons
SELECT day_name, time_of_day, COUNT(invoice_id) as sale FROM amazons
WHERE day_name NOT IN ('sat', 'sun')
GROUP BY day_name,time_of_day
ORDER BY day_name

---16 Identify the customer type contributing the highest revenue.
SELECT 
	customer_type, sum(total) as revenue 
FROM 
	amazons
GROUP BY customer_type
ORDER BY revenue DESC
LIMIT 1


----17 Determine the city with the highest VAT percentage.
SELECT 
	city, VAT 
FROM 
	amazons
ORDER BY VAT DESC
LIMIT 1

----18. Identify the customer type with the highest VAT payments.

SELECT 
	customer_type, VAT 
FROM 
	amazons
ORDER BY VAT DESC
LIMIT 1

----19.What is the count of distinct customer types in the dataset?
SELECT 
	count(DISTINCT customer_type) AS distinct_custom 
FROM 
	amazons

-----20.What is the count of distinct payment methods in the dataset?
SELECT 
	COUNT(DISTINCT payment) AS distinct_payment_method 
FROM 
	amazons

----21.Which customer type occurs most frequently?
SELECT 
	customer_type, COUNT(customer_type) as customer_type_count  
FROM 
	amazons
GROUP BY 
	customer_type
ORDER BY customer_type_count DESC
LIMIT 1

----22.Identify the customer type with the highest purchase frequency.
SELECT 
	customer_type, COUNT(invoice_id) AS purchase_frequency 
FROM 
	amazons
GROUP BY 
	customer_type
ORDER BY purchase_frequency DESC
LIMIT 1

----23.Determine the predominant gender among customers.
SELECT 
	Max(GENDER) AS predominant_customer 
FROM 
	amazons

----24.Examine the distribution of genders within each branch.
SELECT branch, gender, COUNT(*) AS gender_count 
FROM amazons
GROUP BY branch, gender 
ORDER BY branch, gender_count DESC

-----25.Identify the time of day when customers provide the most ratings.
SELECT time_of_day,COUNT(RATING) AS MAX_RATING FROM amazons
GROUP BY time_of_day
ORDER BY max_rating DESC
LIMIT 1

-----26.Determine the time of day with the highest customer ratings for each branch.
SELECT time_of_day, COUNT(*) AS max_rating from amazons
GROUP BY time_of_day
ORDER BY max_rating DESC
LIMIT 1
-----27.Identify the day of the week with the highest average ratings.
SELECT day_name, COUNT(*) AS max_rating FROM amazons
GROUP BY day_name
ORDER BY max_rating DESC

-----28.Determine the day of the week with the highest average ratings for each branch.
SELECT day_name,branch, COUNT(*) 	AS max_rating FROM amazons
GROUP BY day_name,branch
ORDER BY max_rating DESC

----Analysis List
Product Analysis
----1.Conduct analysis on the data to understand the different product lines,
---the products lines performing best and the product lines that need to be improved.
---- In product analyis it is found that food and beverages is performing best and Health and beauty is required to be improved.
----2.Sales Analysis:
---This analysis aims to answer the question of the sales trends of product. 
---The result of this can help us measure the effectiveness of each sales strategy the business 
----applies and what modifications are needed to gain more sales.
In sale analyis it is found that the customers who are members provided more revenue 
than the normal customers to increase, it is required to improve the sale by normal members.
---Customer Analysis
---This analysis aims to uncover the different customer segments, purchase trends and the profitability of each customer segment.
---In the customer analysis it is found that male customers are predominant than the female and t
---the productline which is more associated with male are 'Health and beauty' and the productline which is more
----associated with female are 'Fashion accessories'.
















 






















