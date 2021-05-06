SELECT *
FROM Portfolio_Project..CovidDeaths
Where continent is not null
order by 3,4

--SELECT *
--FROM Portfolio_Project..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project..CovidDeaths
Where continent is not null
Order By 1,2

-- Looking at total cases vs total deaths
-- Shows the likelihood of dying from Covid-19
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS MortalityRate
FROM Portfolio_Project..CovidDeaths
WHERE location like '%states%'
and continent is not null
Order By 1,2


-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid

SELECT location, date, population, total_cases, (total_cases/population) * 100 AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths
WHERE location like '%states%'
Order By 1,2

-- Looking at countries with Highest Infection Rate compared to population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population)) * 100 AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths
-- WHERE location like '%states%'
Group by Location, population
Order By PercentPopulationInfected desc

-- Breakdown by continent 

SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM Portfolio_Project..CovidDeaths
-- WHERE location like '%states%'
Where continent is null
Group by location
Order By TotalDeathCount desc

-- Showing countries with highest death count per population

SELECT location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM Portfolio_Project..CovidDeaths
-- WHERE location like '%states%'
Where continent is not null
Group by Location
Order By TotalDeathCount desc


-- Showing continents with highest death count per population

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM Portfolio_Project..CovidDeaths
-- WHERE location like '%states%'
Where continent is not null
Group by continent
Order By TotalDeathCount desc

-- Global Numbers

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases) * 100 AS MortalityRate
FROM Portfolio_Project..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY date
Order By 1,2

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases) * 100 AS MortalityRate
FROM Portfolio_Project..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
--GROUP BY date
Order By 1,2

-- Total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- USE CTE

WITH PopulationvsVacinnation (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population) * 100 AS PercentVaccinated
From PopulationvsVacinnation
Order by 2,3

-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population) * 100 AS PercentVaccinated
From #PercentPopulationVaccinated
Order by 2,3


-- Creating View to store later for visualizations

Create View PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
FROM Portfolio_Project..CovidDeaths dea
JOIN Portfolio_Project..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

Select * 
From PercentPopulationVaccinated
Order by 2,3