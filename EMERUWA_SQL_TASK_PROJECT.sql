Select *
from SQL_TAASK_PROJECT..CovidDeaths
where continent is not null
order by 3,4

--Select *
--from SQL_TAASK_PROJECT..CovidVaccinations
--order by 3,4
--select the data to be used
select Location, date, total_cases, new_cases, total_deaths, population
from SQL_TAASK_PROJECT..CovidDeaths
where continent is not null
order by 1,2


--looking at the total_cases vs total_deaths
--shows the likeslihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from SQL_TAASK_PROJECT..CovidDeaths
where location like '%states%' 
order by 1,2

--looking at Total cases vs population 
--shows percentage of population got covid
select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from SQL_TAASK_PROJECT..CovidDeaths
	1where continent is not null
order by 1,2

--looking at countries with highest infection Rate compared to population
select Location, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/population)*100 as PercentagePopulationInfected
from SQL_TAASK_PROJECT..CovidDeaths
--where location like '%States%' 
Group by Location, population 
order by PercentagePopulationInfected desc

--showing countries with highest Death Count per Population
select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from SQL_TAASK_PROJECT..CovidDeaths
where continent is not null
Group by Location
order by TotalDeathcount desc

--let's break the data down by continent
select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from SQL_TAASK_PROJECT..CovidDeaths
where continent is not null
Group by continent 
order by TotalDeathcount desc

--showing the contient with highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from SQL_TAASK_PROJECT..CovidDeaths
where continent is null
Group by location 
order by TotalDeathcount desc



--global numbers
create view global_covid19_numbers as
select date, SUM(NEW_cases) as total_cases, SUM(cast(new_deaths as int)) as Total_death, SUM(cast(new_deaths as int))/SUM
(new_cases)*100 as DeathPercentage
from SQL_TAASK_PROJECT..CovidDeaths
where continent is not null
group by date 
--order by 1,2


--looking atTtotal population vs vaccinations 
select*
from SQL_TAASK_PROJECT..CovidDeaths dea 
join SQL_TAASK_PROJECT..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccination/population)*100
From SQL_TAASK_PROJECT..CovidDeaths dea 
join SQL_TAASK_PROJECT..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE
With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from SQL_TAASK_PROJECT..CovidDeaths dea 
join SQL_TAASK_PROJECT..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac



--TEMP TABLE


--create Table #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)



--Insert into #PercentPopulationVaccinated
--select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
--dea.Date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
--from SQL_TAASK_PROJECT..CovidDeaths dea 
--join SQL_TAASK_PROJECT..CovidVaccinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

--select *, (RollingPeopleVaccinated/Population)*100
--from #PercentPopulationVaccinated


--showing the contient with highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from SQL_TAASK_PROJECT..CovidDeaths
where continent is null
Group by location 
order by TotalDeathcount desc


--creating view to store data for later visualization (done in powerbi)

create view PercentPeopleVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from SQL_TAASK_PROJECT..CovidDeaths dea 
join SQL_TAASK_PROJECT..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PercentPeopleVaccinated


create view PopvsVac as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
--(RollingPeopleVaccination/population)*100
From SQL_TAASK_PROJECT..CovidDeaths dea 
join SQL_TAASK_PROJECT..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From PopvsVac



--view for the contient with highest death count per population

create view coviddeathcount as 
select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from SQL_TAASK_PROJECT..CovidDeaths
where continent is null
Group by location 
--order by TotalDeathcount desc

create view casesvsdeath as
--looking at the total_cases vs total_deaths
--shows the likeslihood of dying if you contract covid in your country
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from SQL_TAASK_PROJECT..CovidDeaths
--where location like '%states%' 
--order by 1,2





