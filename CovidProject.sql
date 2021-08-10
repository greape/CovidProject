select*
from [Sql Project]..CovidDeath
order by 3,4

select*
from [Sql Project]..CovidVaccination
order by 3,4

select location, date, total_cases, new_cases, total_deaths,population
from [Sql Project]..CovidDeath
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from [Sql Project]..CovidDeath
order by 1,2

select location, date, total_cases, population, (total_cases/population)*100 as Covid_Percentage
from [Sql Project]..CovidDeath
where location like'%indonesia%'
order by 1,2

select location,  population, MAX(total_cases) as Highest_Infection, MAX((total_cases/population))*100 as Highest_Covid_Percentage
from [Sql Project]..CovidDeath
group by location,population
order by Highest_Covid_Percentage desc

select location,   MAX(CAST(total_deaths as int)) as Total_Death
from [Sql Project]..CovidDeath
where continent is not null
group by location
order by Total_Death desc

select location,   MAX(CAST(total_deaths as int)) as Total_Death
from [Sql Project]..CovidDeath
where continent is null
group by location
order by Total_Death desc

select continent,   MAX(CAST(total_deaths as int)) as Total_Death
from [Sql Project]..CovidDeath
where continent is not null
group by continent
order by Total_Death desc

select  date, sum(new_cases) as global_Case, sum(cast(new_deaths as int)) as global_deaths, (sum(cast(new_deaths as int))/sum(new_cases)) as global_death_percentage
from [Sql Project]..CovidDeath
where continent is not null 
group by date
order by 1,2

with PopsVac (Continent, Location, Data, Population, new_vaccinations, total_vaccination)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(int, vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.date) as total_vaccination
from [Sql Project]..CovidDeath dea
join [Sql Project]..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
select *, (total_vaccination/Population)*100
From PopsVac
order by 2,3



Create Table #PopulationVaccinatedPercentage
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
total_vaccination numeric,
)

Insert into #PopulationVaccinatedPercentage
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(int, vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.date) as total_vaccination
from [Sql Project]..CovidDeath dea
join [Sql Project]..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select *, (total_vaccination/Population)*100
From #PopulationVaccinatedPercentage


select location, date, population, (total_vaccination/Population)*100
from #PopulationVaccinatedPercentage
order by 1,2,3


Create view PopulationVaccinatedPercentage as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(int, vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.date) as total_vaccination
from [Sql Project]..CovidDeath dea
join [Sql Project]..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
