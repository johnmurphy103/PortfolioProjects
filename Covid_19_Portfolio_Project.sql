/*
Covid-19 Data Exploration

This data was taken 5/19/2021

*/


Select *
From Portfolio_Covid_Project..Covid_19_Deaths
Where continent is not null
order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From Portfolio_Covid_Project..Covid_19_Deaths
Where continent is not null
order by 1,2

-- Calculates the percent chance of dying in a country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From Portfolio_Covid_Project..Covid_19_Deaths
Where continent is not null
and location like '%states'
order by 1,2

-- Calculates what percentage of the population infected with Covid

Select location, date, total_cases, (total_cases/population) * 100 as PercentInfected
From Portfolio_Covid_Project..Covid_19_Deaths
Where continent is not null
-- and location like '%states'
order by 1,2

-- Calculates the Countries with the Highest Death Count per Population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Covid_Project..Covid_19_Deaths
Where continent is not null
-- and location like '%states'
Group by location
order by TotalDeathCount desc

-- calculating continents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Covid_Project..Covid_19_Deaths
Where continent is not null
-- and location like '%states'
Group by continent
order by TotalDeathCount desc

-- Calculating Global Death Percentage

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Portfolio_Covid_Project..Covid_19_Deaths
Where continent is not null
-- and location like '%states'
Group by date
order by 1,2

-- Calculates the Percentage of the population that has received at least one vaccine dosage per country

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From Portfolio_Covid_Project..Covid_19_Deaths dea
Join Portfolio_Covid_Project..Covid_19_Vaccinations vac
			on dea.location = vac.location
			and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- calculates the rolling number of people vaccinated via a CTE and partition from the last query

With PopulationVsVaccination (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio_Covid_Project..Covid_19_Deaths dea
Join Portfolio_Covid_Project..Covid_19_Vaccinations vac
			on dea.location = vac.location
			and dea.date = vac.date
Where dea.continent is not null
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/Population) * 100 as PercentRollingPeopleVaccinated
From PopulationVsVaccination


-- same calculation as last query but with a temp table

Drop Table if exists #PercentPopulationVaccinated
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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio_Covid_Project..Covid_19_Deaths dea
Join Portfolio_Covid_Project..Covid_19_Vaccinations vac
			on dea.location = vac.location
			and dea.date = vac.date
Where dea.continent is not null
-- order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as PercentRollingPeopleVaccinated
From #PercentPopulationVaccinated


-- Visualization for later

Create View RollingPercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Portfolio_Covid_Project..Covid_19_Deaths dea
Join Portfolio_Covid_Project..Covid_19_Vaccinations vac
			on dea.location = vac.location
			and dea.date = vac.date
Where dea.continent is not null




