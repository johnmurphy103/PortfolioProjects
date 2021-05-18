-- 1st visualization 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases) * 100 as DeathPercentage
From Covid_Data.. CovidDeaths
Where continent is not null
order by 1,2

-- 2nd visualization

Select location, Sum(cast(new_deaths as int)) as TotalDeathCount
From Covid_Data.. CovidDeaths
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- 3rd visualization 

Select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population)) * 100 as PercentPopulationInfected
From Covid_Data.. CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

-- 4th visualization 

Select location, population, date, MAX(total_cases) as HighestInfectedCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected
From Covid_Data.. CovidDeaths
Group by location, Population, date 
order by PercentPopulationInfected desc

