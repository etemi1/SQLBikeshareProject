# SQLBikeshareProject

# Case Study: How Does a Bike-Share Navigate Speedy Success?
Introduction
Welcome to the Cyclistic bike-share analysis case study! In this case study, you will perform many real-world tasks of a junior data analyst. You will work for a fictional company, Cyclistic, and meet different characters and team members. In order to answer the key business questions, you will follow the steps of the data analysis process: ask, prepare, process, analyze, share, and act. Along the way, the Case Study Roadmap tables — including guiding questions and key tasks — will help you stay on the right path.
By the end of this lesson, you will have a portfolio-ready case study. Download the packet and reference the details of this case study anytime. Then, when you begin your job hunt, your case study will be a tangible way to demonstrate your knowledge and skills to potential employers.
 
# Scenario
You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.
Characters and teams
● Cyclistic: A bike-share program that features more than 5,800 bicycles and 600 docking stations. Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike. The majority of riders opt for traditional bikes; about 8% of riders use the assistive options. Cyclistic users are more likely to ride for leisure, but about 30% use them to commute to work each day.
● Lily Moreno: The director of marketing and your manager. Moreno is responsible for the development of campaigns and initiatives to promote the bike-share program. These may include email, social media, and other channels.
● Cyclistic marketing analytics team: A team of data analysts who are responsible for collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy. You joined this team six months ago and have been busy learning about Cyclistic’s mission and business goals — as well as how you, as a junior data analyst, can help Cyclistic achieve them.
● Cyclistic executive team: The notoriously detail-oriented executive team will decide whether to approve the recommended marketing program.

# About the company
In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geotracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.
Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good chance to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.
Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Moreno and her team are interested in analyzing the Cyclistic historical bike trip data to identify trends.
## Ask
Three questions will guide the future marketing program:
1. How do annual members and casual riders use Cyclistic bikes differently?
2. Why would casual riders buy Cyclistic annual memberships?
3. How can Cyclistic use digital media to influence casual riders to become members?

#### Moreno has assigned you the first question to answer: How do annual members and casual riders use Cyclistic bikes differently?
You will produce a report with the following deliverables:
1. A clear statement of the business task
2. A description of all data sources used
3. Documentation of any cleaning or manipulation of data
4. A summary of your analysis
5. Supporting visualizations and key findings
6. Your top three recommendations based on your analysis
Use the following Case Study Roadmap as a guide. Note: Completing this case study within a week is a good goal.

#### It's Worthy to Note that i have already solved this project with Power BI , so this is me also solving it with SQL but data from a different data source KAGGLE

	-- CREATE TABLE Bikeshareproject
(
    ride_id varchar,
    rideable_type varchar,
    started_at timestamp,
    ended_at timestamp,
    start_station_name varchar,
    start_station_id   int,
    end_station_name varchar,
    end_station_id int,
    start_lat float,
    start_lng  float,
    end_lat  float,
    end_lng float,
    member_casual  varchar)
	
	-- forgot to add end_lng column 
	ALTER TABLE bikeshareproject
ADD COLUMN end_lng fLoat

		--- I removed unecessary columns from each table
ALTER TABLE feb
 DROP COLUMN ride_id,
 drop column start_station_id,
 drop column end_station_id
 
 
 -- I changed one of the table names 
 ALTER TABLE bikeshareproject 
RENAME TO April 

-- I created  A new table and merged all the data into that new TABLE
CREATE TABLE cyclistic AS
select * from april
union all
select * from may
union all
select * from june
union all
select * from july
union all
select * from august
union all
select * from sept
union all
select * from oct
union all
select * from nov
union all
select * from dec
union all
select * from jan
union all
select * from feb
union all
select * from mar

--Started with Data Exploration Checking each COLUMNS, with this query i checked for distinct rideable_types 
Select rideable_type from cyclistic
select count(distinct(rideable_type))
from cyclistic

-- Next i use this query to find out the count for each rideable_type
select rideable_type, count((rideable_type)) as ride_types
from cyclistic
group by rideable_type
order by ride_types desc


-- I add a new column for ride_length
ALTER TABLE cyclistic
ADD COLUMN ride_length

 
 -- I inserted the difference between end and start time in minute into ride_length COLUMNS
 UPDATE cyclistic
 SET ride_length = EXTRACT (month from ended_at-started_at)
 
 -- i added two more columns for quarter and start_day
 alter table cyclistic
add column start_day  varchar,
add column quarter numeric
add column start_month numeric
---  updated start_day so that sun =1 and sat  7
update cyclistic 
set start_day = extract(dow from started_at)  + 1


-- i updated start_month 
update cyclistic
set start_month = extract (month from started_at)


--- I deleted rows in ride_length where ride_length was negative
delete from cyclistic
where ride_length <= 0


-- Data Analysis
-- Monthly trend
select start_month,count(ride_length) as total_ride_length
from cyclistic
group by start_month
order by total_ride_length desc

-- total rides for members per rideable types
select rideable_type,member_casual, count(rideable_type) as total_ride
from cyclistic
where member_casual = 'member'
group by rideable_type,member_casual
order by total_ride desc

--- total rides for casual riders per rideable type
select rideable_type,member_casual, count(rideable_type) as total_ride
from cyclistic
where member_casual = 'member'
group by rideable_type,member_casual
order by total_ride desc

-- Percentage of casual riders to members 
with cte as 
    (select cast(count(rideable_type) as float) as total_rides
    from cyclistic)
    select member_casual,
    case when member_casual = 'member' then ROUND(CAST((count(*)/total_rides)*100 as numeric),2)
    when member_casual = 'casual' then ROUND(CAST((count(*)/total_rides) * 100 AS numeric),2)
    end AS percentage_of_riders
    from cyclistic, cte
    group by member_casual, cte.total_rides
	
	--- Rideable_type percentage per member_type
with cte as 
(select cast(count(*)as float) as total_rides
 from cyclistic) 
select member_casual, rideable_type, 
 case when rideable_type ='docked_bike' then round(cast((count(*)/total_rides) * 100 as numeric),2)
 when rideable_type ='electric_bike' then round(cast((count(*)/total_rides) * 100 as numeric),2)  
 when rideable_type ='classic_bike' then round(cast((count(*)/total_rides) * 100 as numeric),2) 
 end as percentage_of_bike_type
 from cyclistic, cte
 group by rideable_type,member_casual,cte.total_rides
 order by percentage_of_bike_type desc


--- average ride duration per MEMBER
select member_casual,
case when member_casual = 'member' then round(avg(ride_length),2)
    when member_casual ='casual' then round(avg(ride_length),2)
end as average_ride_time
from cyclistic
group by member_casual


-- SUMMARY STATISTICS
-- maximum ride_length
select  max(ride_length)
from cyclistic

-- Minimum Ride_length
select  min(ride_length)
from cyclistic

-- average ride_length
select  avg(ride_length)
from cyclistic


--- TOP STATION names for casual members
select start_station_name, count(rideable_type) as total_ride
from cyclistic
where member_casual = 'casual'
group by start_station_name 
order by total_ride desc

-- TOP station name for members
select start_station_name, count(rideable_type) as total_ride
from cyclistic
where member_casual = 'member'
group by start_station_name 
order by total_ride desc

--- Busiest days and busiest stations
select start_station_name,start_day,count(rideable_type) as total_ride
from cyclistic
where member_casual = 'member' 
group by start_station_name , start_day
order by total_ride desc

-- with this query we check what rideable types are used per station and on what days
select start_station_name,start_day,rideable_type,count(rideable_type) as total_ride
from cyclistic
where member_casual = 'casual' 
group by start_station_name , start_day,rideable_type
order by total_ride desc
