SELECT *
FROM Covid_Deaths
where continent is not null
ORDER BY 3,4

SELECT *
FROM Covid_Vaccinations
ORDER BY 3,4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Covid_Deaths
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS Death_rate
FROM Covid_Deaths
--WHERE location like '%bangladesh%'
ORDER BY 1,2

--Looking at Total Cases vs Population

SELECT location, date, population, total_deaths,(total_deaths/population)*100 AS Death_rate
FROM Covid_Deaths
--WHERE location like '%bangladesh%'
ORDER BY 1,2


--Looking at Countries with Highest Infection Rate vs Population

SELECT location, population, MAX(total_cases) AS highest_infection, MAX((total_cases/population))*100 AS infection_rate
FROM Covid_Deaths
--WHERE location like '%bangladesh%'
GROUP BY location, population
ORDER BY infection_rate DESC


--Looking at Countries with Highest Death

SELECT location, MAX(CAST(total_deaths AS INT)) AS highest_death
FROM Covid_Deaths
--WHERE location like '%bangladesh%'
where continent is not null
GROUP BY location
ORDER BY highest_death DESC


SELECT location, MAX(CAST(total_deaths AS INT)) AS highest_death
FROM Covid_Deaths
--WHERE location like '%bangladesh%'
where continent is null
GROUP BY location
ORDER BY highest_death DESC


--Continent with Highest Death

SELECT continent, MAX(CAST(total_deaths AS INT)) AS highest_death
FROM Covid_Deaths
where continent is not null
GROUP BY continent
ORDER BY highest_death DESC

--Death Rate per Date

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Death_rate
FROM Covid_Deaths
where continent is not null
GROUP BY date
ORDER BY 1,2


--Global Number

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS Death_rate
FROM Covid_Deaths
where continent is not null
ORDER BY 1,2


--Total People vs Vaccination


select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.date) as rollingpeoplevaccicnated
from Covid_Deaths d
join Covid_Vaccinations v
on d.location = v.location
and d.date = v.date
WHERE d.continent is not null
order by 2,3



--Using Common Table Expression (CTE)

with populationVSvaccination(continent, location, date, population, new_vaccinations, rollingpeoplevaccicnated)
as(
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.date) as rollingpeoplevaccicnated
from Covid_Deaths d
join Covid_Vaccinations v
on d.location = v.location
and d.date = v.date
WHERE d.continent is not null
--order by 2,3
)
select * , (rollingpeoplevaccicnated/population)*100
from populationVSvaccination



--TEMP Table

DROP TABLE if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date nvarchar(255),
population numeric,
new_vacccinations numeric,
rollingpeoplevaccicnated numeric
)
insert into #percentpopulationvaccinated
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.date) as rollingpeoplevaccicnated
from Covid_Deaths d
join Covid_Vaccinations v
on d.location = v.location
and d.date = v.date
--WHERE d.continent is not null
--order by 2,3

select * , (rollingpeoplevaccicnated/population)*100 AS rollingpeoplevaccinated_rate
from #percentpopulationvaccinated




--Creating View for Visualisation

create view percentpopulationvaccinated as
select d.continent, d.location, d.date, d.population, v.new_vaccinations, sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.date) as rollingpeoplevaccicnated
from Covid_Deaths d
join Covid_Vaccinations v
on d.location = v.location
and d.date = v.date
WHERE d.continent is not null
--order by 2,3

select *
from percentpopulationvaccinated