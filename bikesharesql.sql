CREATE TABLE Bikeshareproject
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

--Started with Data Exploration Checking each COLUMNS, with this query i checked for distinct rideable_types and got 3.
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

__ I created an extension so i can crosstab function and pass the query as string in it, so that casual and paid members can be pivoted as column on their own. 
--- with this query i compared the rides taken by casual and annual members
select *
from crosstab('select extract(hour from started_at) as time_of_rides,member_casual,count(rideable_type) as total_trips
from cyclistic
group by member_casual, time_of_rides
order by 1 desc',
         'values (''member''),(''casual'')')
as result (time_of_rides numeric, member varchar, casual varchar)
order by time_of_rides desc, member desc, casual desc

