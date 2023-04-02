--SElecting All Fields from databas to Explore the Dataset
SELECT *
FROM membership; 
--The data contains 7,275 recods and 19 Fields

--Demographic information for memberships
SELECT last_name, marital_status,gender,industry, zip_code
FROM membership; 

--Maximum and minimun earners in the dataset
SELECT last_name, annual_income
FROM membership
ORDER BY annual_income ASC;
--Max earn is $119,996 and the lowest is $35,002 

--Top oldest members by the age they joined at 
SELECT last_name, age_at_issue
FROM membership
ORDER BY age_at_issue DESC
LIMIT 10;
--The oldest members are either 78 or 77 years old

--Showing only members who have cancelled their membership
SELECT *
FROM membership 
WHERE status = 'CANCELLED';
--There are 2,810 members who cancelled thier membership, which present 38.6% from the total members

--Showing total number of memberships who have cancelled
SELECT COUNT(id) AS total_cancelled
FROM membership
WHERE status = 'CANCELLED';
--There are 2,810 member who cancelled thier membership (38.6% of total members)

--Showing members who earn more than $50,000 a year
SELECT id, annual_income
FROM membership
WHERE annual_income > 50000;
--There are 5,961 members that presents 81.9% from the total members

--Showing members age 40 or younger
SELECT id, age_at_issue
FROM membership
WHERE age_at_issue <= 40;
--There are 3,108 members age less than 40, which present 42.7% from the total members

--Joining year
SELECT DISTINCT(start_year) AS starting_year
FROM membership
ORDER BY starting_year;
--The data starts from 2006 to 2013

--Showing ALL members who joined between 2006 and 2011
SELECT id, start_year AS starting_year
FROM membership
WHERE start_year BETWEEN '2006' and '2013';

--Showing members who both earn above $75,000 a year, and have a Gold Membership 
SELECT id, annual_income, member_type
FROM membership
WHERE annual_income > 75000 
  AND member_type = 'Gold';
--There are 941 members who has a Gold membership and earns more than $75,000 per year 
  
--Number of mebers based on matirial_status
SELECT marital_status, COUNT (id) AS member_id
FROM membership 
GROUP BY marital_status
ORDER BY member_id DESC;
--most of members are married, and few of them are divorced. (Married=82.4%, Single=15.4%, Widowed=1.6%, Divorced=0.6%)

--Number of mebers based on matirial_status who cancelled membership
SELECT marital_status, COUNT (id) AS member_id
FROM membership 
WHERE status ILIKE ('c%')
GROUP BY marital_status
ORDER BY member_id DESC;
--most of members who canceled membership are married, and few of them are divorced (Married=31.2%, Single=6.7%, Widowed=0.5%, Divorced=0.2%)

--Showing members who make annual or semi-annual membership payments
SELECT payment, COUNT(id) AS member_id
FROM membership
WHERE payment ILIKE ('%nnual')
GROUP BY payment;
--There are 4,449 member pays annualy, and 1079 member pays semi_annual

--Counting number of members based on job industry 
SELECT industry, COUNT(id) AS member_id
FROM membership
GROUP BY industry
ORDER BY member_id DESC;
--Most of members work in Consumer Consumer Discretionary, and few of them work in Consumer Staples industry

--Counting number of members based on job industry who cancelled membership
SELECT industry, COUNT(id) AS member_id
FROM membership
WHERE status ILIKE ('c%')
GROUP BY industry
ORDER BY member_id DESC;
--Most of members who cancelled thier membership work in Consumer Discretionary and Real Estate industries

--Showing the SUM of  annual fees for members who have cancelled
SELECT SUM(annual_fee) AS avg_fee
FROM membership
WHERE status = 'CANCELLED';
--Sum of annual fees for cancelled members is $2,516,2000

--Showing the average annual income of cancelled members 
SELECT AVG(annual_income)
FROM membership
WHERE status ILIKE ('c%')
--AVG annual fees for cancelled members is $77,844

--Showing number of Male members who have cancelled their memberships 
SELECT COUNT(id)
FROM membership
WHERE gender LIKE ('M')
  AND status ILIKE ('c%'); 
--there are 2,195 Male member cancelled thier membership (78%)

--Showing the youngest member 
SELECT MIN(age_at_issue)
FROM membership
--Youngest member is 18 years old;

--Showing number of cancelled members based on thier age
SELECT age_at_issue, count(id) as cancelled_member_no
FROM membership
WHERE status ILIKE ('c%')
GROUP BY age_at_issue
ORDER BY cancelled_member_no DESC;
--most cancelled member are 36 years old 

--Showing the most additional members a member can have 
SELECT MAX(add_members)
FROM membership;
--A member can add max 3 of his Children to become a member

--Showing the membership type with the most and lowest cancellations with their average annual income
SELECT member_type, COUNT(id) AS member_count, AVG(annual_income) AS avg_income
FROM membership
WHERE status ILIKE ('c%')
GROUP BY member_type
ORDER BY member_count DESC;
--Most cancelled members are Gold members with average income of $77,140. On the other hand, the lowest cencelled members are Platinum members with avgerage income of 78,967 
--It means that there is a negative linear relationship between avergae annual income anf cancellation. lower average income, increase cancellation. 

--Showing the average income, the sum of annual fees, and the count of members across industries for cancelled members
SELECT industry,
  avg(annual_income) AS avg_income, 
  sum(annual_fee) AS sum_fee, 
  count(id) AS member_count
FROM membership
WHERE status ILIKE 'C%'
GROUP BY industry
ORDER BY member_count DESC;
--max avergae income for members who work in healthcare industry, and the min in communication services.Most cancceled member are working in Concumer Discretionary.

--Showing the total of annual fees for people who have held membership for longer than a year, by start month,
SELECT start_month, sum(annual_fee) AS sum_annual_fee
FROM membership
WHERE (end_year - start_year) > 1 
GROUP BY start_month
HAVING sum(annual_fee) > 100000 
ORDER BY sum_annual_fee DESC;
--December is the most profitable month

--Showing number of members who had membership for more than one year
SELECT COUNT(id)
FROM membership
WHERE (end_year - start_year)> 1; 
--There are 636 members who had membership for more than one year

--Showing the average annual income of members who earn more than $50,000 who left after 2012 by marital status
SELECT marital_status, ROUND(avg(annual_income),2) AS avg_annual_income
FROM membership 
WHERE end_year > 2011
GROUP BY marital_status
HAVING avg(annual_income) > 50000
ORDER BY avg_annual_income DESC;
--Widoed have max avgerage annual income with more than 50000, and left after 2012

--Showing the count of id by zip_code
SELECT DISTINCT(zip_code)AS zip, COUNT(id)
FROM membership
GROUP BY zip;

--Showing if unmarried with children affect cancellation rates
SELECT member_type, status, count(id) AS counted_member
FROM membership 
WHERE (marital_status NOT ILIKE 'M%') AND (status ILIKE ('c%'))
GROUP BY member_type, status
HAVING count(add_members) >= 1
ORDER BY counted_member DESC;
--There are 542 unmarried members with children who cancelled thier membership

--Showing if age at joining affect cancellations
SELECT status, round(avg(age_at_issue),2)
FROM membership
GROUP BY status;
--Age at joining doesnt affect cancellation 

SELECT zip_code, 
  count(id) AS member_count, 
  round(avg(annual_fee),2) AS avg_fee, 
  round(avg(annual_income),2) AS avg_income, 
  round (avg(add_members),2) AS avg_additional
FROM membership
WHERE status = 'CANCELLED'
GROUP BY zip_code,member_type,gender,industry
ORDER BY 2 DESC
--Most cancelled member are located in 80237 zip_code
