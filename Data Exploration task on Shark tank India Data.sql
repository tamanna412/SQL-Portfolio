select * from Project2..sharktank;

--total no of episodes
select count(distinct [Ep# No#]) from Project2..sharktank;
select max([Ep# No#]) from Project2..sharktank;

--NO OF BRANDS
select count(distinct Brand) from Project2..sharktank;

--pitches converted
		 SELECT 
    CAST(SUM(b.converted_not_converted) AS FLOAT) / CAST(COUNT(*) AS FLOAT)
FROM 
    (SELECT [Amount Invested lakhs], 
            CASE 
                WHEN [Amount Invested lakhs] > 0 THEN 1 
                ELSE 0 
            END AS converted_not_converted
     FROM project2..sharktank) b;

-- total male

select sum(male) from project2..sharktank

-- total female

select sum(female) total_female from project2..sharktank 

--gender ratio

select sum(female)/sum(male)*100 from project2..sharktank
 or
SELECT 
    CASE 
        WHEN SUM(male) = 0 THEN 0 
        ELSE SUM(female) / SUM(male) 
    END AS female_to_male_ratio
FROM project2..sharktank;

-- total invested amount

select sum([Amount Invested lakhs]) from project2..sharktank

-- avg equity taken

select avg(c.[Equity Taken %]) 
      from
                (select * from project2..sharktank where [Equity Taken %]>0) c;

--highest deal taken

select max([Amount Invested lakhs]) from project2..sharktank 

--higheest equity taken

select max([Equity Taken %]) from project2..sharktank 

-- startups having at least women

SELECT SUM(d.female_count) AS total_startups_with_female
FROM (
    SELECT [female],
           CASE 
               WHEN female > 0 THEN 1 
               ELSE 0 
           END AS female_count
    FROM project2..sharktank
) d
WHERE d.female_count > 0;

-- pitches converted having atleast one women

select * from project2..sharktank


select sum(b.female_count) from(

select case when a.female>0 then 1 else 0 end as female_count ,a.*from (
(select * from project2..sharktank where deal!='No Deal')) a)b

-- avg team members

select avg([Team Members]) from project2..sharktank

-- amount invested per deal

select avg(a.[Amount Invested lakhs]) amount_invested_per_deal from
(select * from project2..sharktank where deal!='No Deal') a

-- avg age group of contestants

select [Avg age],count([Avg age]) cnt from project2..sharktank group by [Avg age] order by cnt desc

-- location group of contestants 

select location,count(location) cnt from project2..sharktank group by location order by cnt desc

-- sector group of contestants

select [Sector],count([sector]) cnt from project2..sharktank group by [sector] order by cnt desc

--partner deals

select Partners,count(Partners) cnt from project2..sharktank  where partners!='-' group by partners order by cnt desc

-- making the matrix


select * from project2..sharktank

SELECT 
    'Ashneer' AS keyy,
    SUM(C.[Ashneer Amount Invested]) AS total_invested,
    AVG(C.[Ashneer Equity Taken %]) AS avg_equity_taken
FROM 
    (SELECT * 
     FROM PROJECT2..sharktank  
     WHERE [Ashneer Equity Taken %] != 0 
       AND [Ashneer Equity Taken %] IS NOT NULL) C;

--for Namita

SELECT 
    'Namita' AS keyy,
    SUM(C.[Namita Amount Invested]) AS total_invested,
    AVG(C.[Namita Equity Taken %]) AS avg_equity_taken
FROM 
    (SELECT * 
     FROM PROJECT2..sharktank  
     WHERE [Namita Equity Taken %] != 0 
       AND [Namita Equity Taken %] IS NOT NULL) C;

SELECT 
    m.keyy,
    m.total_deals_present,
    m.total_deals,
    n.total_amount_invested,
    n.avg_equity_taken
FROM 
    (
        SELECT 
            'Ashneer' AS keyy,
            COUNT([Ashneer Amount Invested]) AS total_deals_present,
            COUNT(*) AS total_deals
        FROM project2..sharktank 
        WHERE [Ashneer Amount Invested] IS NOT NULL
    ) m
JOIN 
    (
        SELECT 
            'Ashneer' AS keyy,
            SUM([Ashneer Amount Invested]) AS total_amount_invested,
            AVG([Ashneer Equity Taken %]) AS avg_equity_taken
        FROM project2..sharktank 
        WHERE [Ashneer Equity Taken %] IS NOT NULL 
          AND [Ashneer Equity Taken %] != 0
    ) n
ON m.keyy = n.keyy;

-- which is the startup in which the highest amount has been invested in each domain/sector

select c.* from 
(select [brand],[sector],[Amount Invested lakhs],rank() over(partition by sector order by [Amount Invested lakhs] desc) rnk 

from project2..sharktank) c

where c.rnk=1 and [Amount Invested lakhs]>0