select * from  project.dbo.data1;
 select * from  project.dbo.data2;
 

---No of Rows from both tables
select count(*) from project.dbo.data1;
select count(*) as RES1 from project..data1;
select count(*) as Res2 from project..data2;

--Distinct select statement
Select Distinct State  from project..data1;
Select Distinct State  from project..data2;

Select Distinct State  from project..data3;

----clauses
select * from project..data2
where Area_km2 > 4041

select * from project..data2
where state = 'Rajasthan';

select * from project..data2
where District = 'churu';

select * from project..data2 order by District desc;
select * from project..data2 where state = 'Rajasthan'order by Population desc;
select * from project..data2 order by Population desc,State desc ;

select * from project..data1 where state = 'Rajasthan' and Literacy < 70;
select * from project..data1 where state = 'kerala' and Literacy > 95;

select * from project..data1 where state = 'Haryana' and (sex_ratio >900 or Literacy > 95);
select * from project..data1 where state = 'Haryana' and (sex_ratio >900 and Literacy > 55);
select * from project..data1 where state = 'Haryana' and (sex_ratio >900 or state like 'Raj%%');

select * from project..data1 where not state = 'Kerala' and Literacy > 90;

insert into project..data1 (District,State,Growth,Sex_Ratio,Literacy) values ('Sikar', 'Raj', 0.55,789,98.98);

delete from project..data1 where state = 'Raj';

select top 5 * from project..data1 where state = 'Rajasthan';
select top 2 * from project..data1;
select top 2 * from project..data2 where state = 'Rajasthan';

select MIN(Population) as MINPOP from project..data2 where state = 'Rajasthan';
select Min(Population) as MINPOP from project..data2 Group by Area_km2;
select Min(Population) as MINPOP from project..data2;

select * from project..data2 where state in ('Rajasthan', 'Haryana');

---Joins
select data1.growth, data1.literacy, data2.Population
from project..data1 inner join project..data2 on project..data1.District = project..data2.District;

select data1.growth, data1.literacy, data2.Population
from project..data1 left join project..data2 on project..data1.District = project..data2.District;

select data1.growth, data1.literacy, data2.Population
from project..data1 right join project..data2 on project..data1.District = project..data2.District;

select data1.growth, data1.literacy, data2.Population
from project..data1 full outer join project..data2 on project..data1.District = project..data2.District;

--union
select state from project..data1
union
select state from project..data2
order by state;

select state from project..data1  where exists (SELECT state FROM project..data1  WHERE project..data1 .District = project..data1 .District);

select state,
CASE
    when state = 'Rajasthan' then 'Known for Kings, Palaces and forts'
    when state = 'Haryana' then 'Known for Sports'
    when state = 'West Bengal' then 'Literature'
    else 'Never mind'
END AS 'States that they are known for'
from project..data2;

-- dataset for jharkhand and bihar

select * from project..data1 where state in ('Jharkhand' ,'Bihar')

-- population of India

select sum(population) as Population from project..data2

-- avg growth 

select state,avg(growth)*100 avg_growth from project..data1 group by state;

-- avg sex ratio

select state,round(avg(sex_ratio),0) avg_sex_ratio from project..data1 group by state order by avg_sex_ratio desc;

- avg literacy rate
 
select state,round(avg(literacy),0) avg_literacy_ratio from project..data1 
group by state having round(avg(literacy),0)>90 order by avg_literacy_ratio desc ;

-- top 3 state showing highest growth ratio


select top 3 state,avg(growth)*100 avg_growth from project..data1 group by state order by avg_growth desc;


--bottom 3 state showing lowest sex ratio

select top 3 state,round(avg(sex_ratio),0) avg_sex_ratio from project..data1 group by state order by avg_sex_ratio asc;

-- top and bottom 3 states in literacy state

drop table if exists #topstates;
create table #topstates
( state nvarchar(255),
  topstate float

  )

insert into #topstates
select state,round(avg(literacy),0) avg_literacy_ratio from project..data1 
group by state order by avg_literacy_ratio desc;

select top 3 * from #topstates order by #topstates.topstate desc;

drop table if exists #bottomstates;
create table #bottomstates
( state nvarchar(255),
  bottomstate float

  )

insert into #bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from project..data1 
group by state order by avg_literacy_ratio desc;

select top 3 * from #bottomstates order by #bottomstates.bottomstate asc;

--union opertor

select * from (
select top 3 * from project..data2 order by Population desc) a

union

select * from (
select top 3 * from project..data2 order by population asc) b;

-- states starting with letter a

select distinct state from project..data1 where lower(state) like 'a%' or lower(state) like 'b%'

select distinct state from project..data1 where lower(state) like 'a%' and lower(state) like '%m'

-- joining both table

--total males and females

select d.state,sum(d.males) total_males,sum(d.females) total_females from
(select c.district,c.state state,round(c.population/(c.sex_ratio+1),0) males, round((c.population*c.sex_ratio)/(c.sex_ratio+1),0) females from
(select a.district,a.state,a.sex_ratio/1000 sex_ratio,b.population from project..data1 a inner join project..data2 b on a.district=b.district ) c) d
group by d.state;

-- total literacy rate

select c.state,sum(literate_people) total_literate_pop,sum(illiterate_people) total_lliterate_pop from 
(select d.district,d.state,round(d.literacy_ratio*d.population,0) literate_people,
round((1-d.literacy_ratio)* d.population,0) illiterate_people from
(select a.district,a.state,a.literacy/100 literacy_ratio,b.population from project..data1 a 
inner join project..data2 b on a.district=b.district) d) c
group by c.state

-- population in previous census

select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from project..data1 a inner join project..data2 b on a.district=b.district) d) e
group by e.state)m

-- population vs area

select (g.total_area/g.previous_census_population)  as previous_census_population_vs_area, (g.total_area/g.current_census_population) as 
current_census_population_vs_area from
(select q.*,r.total_area from (

select '1' as keyy,n.* from
(select sum(m.previous_census_population) previous_census_population,sum(m.current_census_population) current_census_population from(
select e.state,sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
(select d.district,d.state,round(d.population/(1+d.growth),0) previous_census_population,d.population current_census_population from
(select a.district,a.state,a.growth growth,b.population from project..data1 a inner join project..data2 b on a.district=b.district) d) e
group by e.state)m) n) q inner join (

select '1' as keyy,z.* from (
select sum(area_km2) total_area from project..data2)z) r on q.keyy=r.keyy)g

--window

select a.* from
(select district,state,literacy,rank() over(partition by state order by literacy desc) rnk from project..data1) a

where a.rnk in (1,2,3) order by state