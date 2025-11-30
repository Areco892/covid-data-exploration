-- Preview of the Data
select *
from deaths
limit 10

select *
from vaccinations
limit 10

-- Deaths table: location, date, total_cases, new_cases, total_deaths, population
select location, date, total_cases, new_cases, total_deaths, population
from deaths
order by 1,2

-- Total cases vs Total deaths (Death Rate Percentage)
select location, date, total_cases, total_deaths, (total_deaths::float/total_cases::float)*100 as death_rate_percentage
from deaths
order by 1,2

-- Total cases vs Population (Percentage of the population who got infected in the United States)
select location, date, population, total_cases, (total_cases::float/population::float)* 100 as case_percentage
from deaths
where location ~* 'united states'
order by 1,2 

-- Highest infection rate countries (Rank Function)
select location, population, highest_infection_count, infection_rate,
Rank() over (order by infection_rate DESC) as rank
from(
    select location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases/population)*100) as infection_rate
    from deaths
    group by location, population
)
where infection_rate is not null

-- Highest death rate countries
select location, population, MAX(total_deaths) as heighest_death_count, MAX((total_deaths/population)*100) as death_rate
from deaths
group by location, population
order by death_rate DESC

-- Total deaths per continent
select continent, sum(total_deaths_count) as total_deaths_per_continent
from (  
    select location, continent, max(total_deaths) as total_deaths_count
    from deaths
    group by location, continent
)
group by continent

-- Global infection and death count per day
select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths 
from deaths
where continent is not null
group by date
order by 1,2

-- Vaccination percentage per date per location (JOIN)
select d.date, d.location, d.population, v.new_vaccinations
from deaths d
join vaccinations v 
on d.location = v.location and d.date = v.date
where d.continent is not null
order by 2, 1

-- Vaccination percentage per date per location with rolling vaccination count (Window Function)
select d.date, d.location, d.population, v.new_vaccinations, sum(v.new_vaccinations) over (partition by d.location order by d.date) as total_vaccinations
from deaths d
join vaccinations v 
on d.location = v.location and d.date = v.date
where d.continent is not null
order by 2, 1

-- Cumulative vaccination percentage per location (CTE Method)
with vaccinations_summary as (
    select d.date, d.location, d.population, v.new_vaccinations, sum(v.new_vaccinations) over (partition by d.location order by d.date) as total_vaccinations
    from deaths d
    join vaccinations v 
    on d.location = v.location and d.date = v.date
    where d.continent is not null
)
select s.location, s.population, MAX(s.total_vaccinations/s.population) * 100 as vaccination_percentage
from vaccinations_summary s
group by s.location, s.population
order by s.location

-- Cumulative vaccination percentage per location (Temp Table Method)
drop table if exists PercentPopulationVaccinated;
create table PercentPopulationVaccinated (
    continent text,
    location text,
    date date,
    population numeric,
    new_vaccinations numeric,
    rolling_people_vaccinated numeric 
)
insert into PercentPopulationVaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(v.new_vaccinations) over (partition by d.location order by d.date) as rolling_people_vaccinated
from deaths d
join vaccinations v 
on d.location = v.location and d.date = v.date
where d.continent is not null

select *, (rolling_people_vaccinated/population) * 100 as vaccination_percentage
from PercentPopulationVaccinated

-- Creating a View for Vaccination Percentage per Location
create view PercentagePopulationVaccinated as
with vaccinations_summary as (
    select d.date, d.location, d.population, v.new_vaccinations, sum(v.new_vaccinations) over (partition by d.location order by d.date) as total_vaccinations
    from deaths d
    join vaccinations v 
    on d.location = v.location and d.date = v.date
    where d.continent is not null
)
select s.location, s.population, MAX(s.total_vaccinations/s.population) * 100 as vaccination_percentage
from vaccinations_summary s
group by s.location, s.population
order by s.location

select * 
from PercentagePopulationVaccinated