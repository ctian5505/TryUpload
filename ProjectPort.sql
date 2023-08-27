

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid



-- Countries with Highest Infection Rate compared to Population



-- Countries with Highest Death Count per Population




-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population




-- GLOBAL NUMBERS

SELECT Date, SUM(new_cases) AS Global_Daily_Cases, SUM(CAST(new_deaths AS INT)) AS Ggobal_Daily_Deaths,
			(SUM(CAST(new_deaths AS INT))/SUM(new_cases))*100 AS Global_Death_percentage
FROM PortfolioProject..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date

EXEC TEST










-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine



SELECT Death.continent, Death.location, Death.date, Death.population, Vac.new_vaccinations,
SUM(CAST(Vac.new_vaccinations AS INT)) OVER (PARTITION BY Death.location ORDER BY Death.location, Death.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ AS Death
JOIN PortfolioProject..CovidVaccinations$ AS Vac
ON Death.location = Vac.location
AND Death.date = Vac.date
WHERE Death.continent IS NOT NULL
ORDER BY 2,3




WITH PopVsVac (continent, location,date, population,new_vaccinations,RollingPeopleVaccinated) AS
(
SELECT Death.continent, Death.location, Death.date, Death.population, Vac.new_vaccinations,
SUM(CAST(Vac.new_vaccinations AS INT)) OVER (PARTITION BY Death.location ORDER BY Death.location, Death.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ AS Death
JOIN PortfolioProject..CovidVaccinations$ AS Vac
ON Death.location = Vac.location
AND Death.date = Vac.date
WHERE Death.continent IS NOT NULL
--ORDER BY 2,3
)

SELECT *,(RollingPeopleVaccinated/population)*100
FROM PopVsVac


CREATE TABLE #PopVsVac (
continent VARCHAR(100), 
location VARCHAR(100),
date DATETIME, 
population INT,
new_vaccinations INT,
RollingPeopleVaccinated INT
)

INSERT INTO #PopVsVac
SELECT Death.continent, Death.location, Death.date, Death.population, Vac.new_vaccinations,
SUM(CAST(Vac.new_vaccinations AS INT)) OVER (PARTITION BY Death.location ORDER BY Death.location, Death.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ AS Death
JOIN PortfolioProject..CovidVaccinations$ AS Vac
ON Death.location = Vac.location
AND Death.date = Vac.date
WHERE Death.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)
FROM #PopVsVac










-- Using CTE to perform Calculation on Partition By in previous query







-- Using Temp Table to perform Calculation on Partition By in previous query






-- Creating View to store data for later visualizations