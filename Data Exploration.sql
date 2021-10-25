-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From `portfolio-project-328010.covid.coviddeaths`
Where continent is not null 
order by 1,2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From `portfolio-project-328010.covid.coviddeaths`
Where location = "India"
and 
 continent is not null 
order by 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From `portfolio-project-328010.covid.coviddeaths`
--Where location = "India"
--and 
 --continent is not null 
order by 1,2

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From `portfolio-project-328010.covid.coviddeaths`
--Where location = "India"
--and 
 --continent is not null 
 group by location,population
order by PercentPopulationInfected desc 

-- Countries with Highest death Rate compared to Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount ,MAX(cast(Total_deaths as int)/population)*100 as TotalDeathpercent
From `portfolio-project-328010.covid.coviddeaths`
Where continent is not null 
 group by location
order by TotalDeathpercent desc 

  -- GLOBAL NUMBERS
  
SELECT
  SUM(new_cases) AS total_cases,
  SUM(CAST(new_deaths AS int)) AS total_deaths,
  SUM(CAST(new_deaths AS int))/SUM(New_Cases)*100 AS DeathPercentage
FROM
  `portfolio-project-328010.covid.coviddeaths`
WHERE
  continent IS NOT NULL
ORDER BY
 1,2
 
 --Countries with Highest smoker and old age Rate compared to Population
SELECT
  dea.location,
  diabetes_prevalence,
  vac.gdp_per_capita,
  aged_65_older,
  MAX(CAST(Total_deaths AS int)) AS TotalDeathCount,
  male_smokers,
  MAX(male_smokers +female_smokers)/2 AS total_smokers_population,
  MAX(total_cases/population)*100 AS PercentPopulationInfected,
  MAX(total_cases) AS PopulationInfected,
  (MAX(total_deaths)/MAX(total_cases) )*100 AS DeathPercentage,
FROM
  covid.coviddeaths dea
JOIN
  covid.covidvaccination vac
ON
  dea.location = vac.location
WHERE
  dea.continent IS NOT NULL
GROUP BY
  dea.location,
  aged_65_older,
  diabetes_prevalence,  male_smokers,
  vac.gdp_per_capita
ORDER BY
 DeathPercentage DESC
  
-- Further analysis 
SELECT
  dea.location,
  population,
  diabetes_prevalence,
  vac.gdp_per_capita,
  aged_65_older,
  Total_deaths,
  male_smokers,
  total_cases,
  SUM(CAST(icu_patients AS int)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS Rolling_icu_patients,
  SUM(CAST(hosp_patients AS int)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) AS Rolling_hosp_patients
FROM
  covid.coviddeaths dea
JOIN
  covid.covidvaccination vac
ON
  dea.location = vac.location
  AND  dea.date = vac.date
WHERE
  dea.continent IS NOT NULL
  
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 --Countries with Highest icu and hospitalisation Rate compared to Population
 
SELECT
  location,
  diabetes_prevalence,
  gdp_per_capita,
  aged_65_older,
  male_smokers,
  MAX(total_cases/Population)*100 AS PercentPopulationInfected,
  MAX(total_cases) AS PopulationInfected,
  (MAX(total_deaths)/MAX(total_cases) )*100 AS DeathPercentage,
  MAX(CAST(Total_deaths AS int)) AS TotalDeathCount,
  MAX(Rolling_icu_patients/Population)*100 AS PERCENT_icu_patients,
  MAX(Rolling_hosp_patients/Population)*100 AS PERCENT_HOSP_patients
FROM
  `portfolio-project-328010.covid.dummy`
GROUP BY
  location,
  diabetes_prevalence,
  aged_65_older,
  male_smokers,
  gdp_per_capita
ORDER BY
  PERCENT_HOSP_patients DESC 
 
  
  
