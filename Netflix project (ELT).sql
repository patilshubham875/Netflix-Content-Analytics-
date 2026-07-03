use netflix;
SELECT * FROM netflix.netflix_raw;
-- Creating raw table for importing data in sql database  
CREATE TABLE netflix_raw (
  show_id varchar(20),
  type varchar(20),
  title nvarchar(150),
  director nvarchar(250),
  cast nvarchar(800),
  country nvarchar(150),
  date_added varchar(20),
  release_year int,
  rating nvarchar(20),
  duration nvarchar(20),
  listed_in nvarchar(100),
  description nvarchar(300)
);
-- Handling foreign characters 
   #like different languages present in title column
   
-- Removing duplicates

Select * from netflix_raw where concat(title, type) in (
Select concat(title, type)
from netflix_raw group by title, type
having count(*)> 1) order by concat(title, type); #This query finds duplicate values
 
with cte as (
 Select *, rank() over(partition by title, type order by show_id) as rnk from netflix_raw)
 select * from cte where rnk =1;
 
-- Create New tables for Directors, country, listed in & cast for performing normalization
  
-- Tables for directors
create table netflix_directors  ( 
SELECT
    n.show_id,
    TRIM(jt.director) AS director
FROM netflix_raw n
CROSS JOIN 
JSON_TABLE(
    CONCAT( '["',  REPLACE(REPLACE(n.director, '"', '\\"'),', ','","'),  '"]' ),   '$[*]' COLUMNS (director VARCHAR(255) PATH '$')
) AS jt
WHERE n.director IS NOT NULL
AND n.director <> '');

-- Tables for country
create table netflix_country ( 
Select n.show_id , trim(jt.country) as country
from  netflix_raw n 
cross join 
json_table (
concat( '["',replace(replace(n.country,'"','\\"'),', ','","'), '"]'), '$[*]' columns (country nvarchar(150) path '$')
) as jt
where n. country is not null and n.country <> ''); 

-- Tables for listed insert
create table listed_in ( 
Select n.show_id , trim(jt.listed_in) as listed_in
from  netflix_raw n 
cross join 
json_table (
concat( '["',replace(replace(n.listed_in,'"','\\"'),', ','","'), '"]'), '$[*]' columns (listed_in nvarchar(150) path '$')
) as jt
where n. listed_in is not null and n.listed_in <> ''); 

-- Tables for Cast 
create table cast ( 
Select n.show_id , trim(jt.cast) as cast
from  netflix_raw n 
cross join 
json_table (
concat( '["',replace(replace(n.cast,'"','\\"'),', ','","'), '"]'), '$[*]' columns (cast nvarchar(800) path '$')
) as jt
where n. cast is not null and n.cast <> ''); 
 
-- Populate missing values in duration column 

Select * from netflix_raw where duration is null;

-- Creating final table for analysis
Create table Netflix_data as 
 with cte as (
 Select *, rank() over(partition by title, type order by show_id) as rnk from netflix_raw
 )
 select show_id, type, title,  str_to_date(date_added, '%M %d, %Y')  date_added, release_year, rating, 
 (case when duration is null then rating else duration end) as duration, description
 from cte where rnk =1;                                                                       #This is the final table
 
 Select * from netflix_data;
 
 
                                                   -- Netflix Data analysis -- 
 
 -- 1. For each director Count of number of movies and TV shows created by them in seperate column 
       -- for directors who have created movies & TV shows both
       
       -- Using Join and Subquery  
Select m.director, m.Movie_count, t.TV_show_count  from (
Select d.director, count(distinct d.show_id) as Movie_count from netflix_directors d inner join netflix_data n
on d.show_id=n.show_id where n.type = 'movie' group by director) m 
join 
(Select d.director, count(distinct d.show_id) as TV_show_count from netflix_directors d inner join netflix_data n
on d.show_id=n.show_id where n.type = 'TV Show' group by director) t on m.director = t.director;

-- Using Case statement & join 
Select d.director,
count(distinct case when n.type ='Movie' then n.show_id end) as Movie_count,
count(distinct case when n.type ='TV Show' then n.show_id end) as TV_show_count from netflix_data n
join netflix_directors d on n.show_id = d.show_id group by d. director
having count(distinct n.type)>1;

-- 2. Which country has highest no of comedy movie
Select c.Country, count(l.show_id) as no_of_comedy_movies 
from  listed_in l 
join netflix_country c 
on l.show_id = c.show_id 
join netflix_data n
on c.show_id = n.show_id 
where type = 'Movie' and listed_in like '%comed%' 
group by c.country 
order by no_of_comedy_movies desc;
 
 -- 3.  For each year (as per date added to netflix) which director has highest no of movies released
 
With cte as (
Select year(date_added) as date_added, d.director, count(n.show_id) as no_of_movies 
from netflix_data n 
join netflix_directors d 
on n.show_id = d.show_id
where n.type = 'Movie'
group by year(date_added),director)
Select *, row_number() over(partition by date_added order by no_of_movies desc) as rnk
from cte order by no_of_movies desc;


-- 4. What is the Average duration of movies in each genre

Select listed_in, avg(duration_int) as Average_duration from (
Select n.Show_id, l.listed_in, Cast(replace(duration,' min','')as signed) as duration_int 
from netflix_data n join listed_in l
on n.show_id = l.show_id where type = 'Movie') as x group by listed_in order by Average_duration desc;

-- 5. Find list of directors who have created horror and comedy movies both.
      -- Display director name along with number of comedy and horror movies directed by them
      
Select d. director, 
Count( distinct case when l.listed_in = 'comedies' then d.show_id end) as no_of_comedies,
Count(distinct case when l.listed_in = 'horror movies' then d.show_id end) as no_of_horror from netflix_data n 
join listed_in l  on n.show_id = l.show_id 
join netflix_directors d on n.show_id = d.show_id
where n.type = 'Movie' and l.listed_in in ('comedies','horror movies')
group by d. director
having count(distinct l.listed_in) = 2;
 