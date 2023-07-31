--Introducing data from first table, which consists of opioid overdose deaths in the United States from 1999 to 2014

Select *
From PortfolioProjectA..OpioidDeaths

--Opioid overdose death percentage for entirety of the United States between 1999 and 2014  
--Shows that the percentage of opioid overdose deaths tripled in a 15 year period 

Select Year, SUM(Deaths) AS TotalDeaths, SUM(Population) AS USPopulation, (SUM(Deaths)/SUM(Population))*100 AS DeathPercentageUS, [Prescriptions Dispensed by US Retailers in that year (millions)]
From PortfolioProjectA..OpioidDeaths
Group By Year, [Prescriptions Dispensed by US Retailers in that year (millions)]
Order By DeathPercentageUS DESC;

--The total amount of opioid overdose deaths in the United States between 1999 and 2014

Select SUM(Deaths) AS Total_Deaths_in_the_US_From_1999_to_2014
From PortfolioProjectA..OpioidDeaths

--BREAKING THINGS DOWN INTO 5 YEAR PERIODS 
--The total amount of opioid overdose deaths in the United States between 1999 and 2003

Select SUM(Deaths) AS Total_Deaths_in_the_US_From_1999_to_2003
From PortfolioProjectA..OpioidDeaths
Where Year IN (1999, 2000, 2001, 2002, 2003)

--The total amount of opioid overdose deaths in the United States between 2004 and 2009

Select SUM(Deaths) AS Total_Deaths_in_the_US_From_2004_to_2009
From PortfolioProjectA..OpioidDeaths
Where Year IN (2004, 2005, 2006, 2007, 2008, 2009)

--The total amount of opioid overdose deaths in the United States between 2010 and 2014

Select SUM(Deaths) AS Total_Deaths_in_the_US_From_2010_to_2014
From PortfolioProjectA..OpioidDeaths
Where Year IN (2010, 2011, 2012, 2013, 2014)

--BREAKING THINGS DOWN BY STATE

--Rolling death count by state 

Select State, Year, Deaths, Population, [Crude Rate], SUM(Deaths) OVER (Partition by State Order by State, Year) AS RollingDeathCount
FROM PortfolioProjectA..OpioidDeaths

--Sum of opioid overdose deaths per state between 1999-2014

Select State, SUM(Deaths) AS TotalDeaths
From PortfolioProjectA..OpioidDeaths
Group by State
Order by TotalDeaths DESC

--States with high death rate compared to population in 2014 

Select State, Year, Deaths, Population, (Deaths/Population)*100 AS DeathPercentage
From PortfolioProjectA..OpioidDeaths
Where Year=2014  
Order By DeathPercentage DESC

--Top 20 instances of the highest rate of opioid overdose deaths per 100,000 people between 1999 and 2014
--Shows states that have proven to be worse than others over time: West Virginia, Nevada, New Mexico, and Rhode Island 
Select Top 20
State, Year, MAX([Crude Rate]) AS HighestDeathRate
From PortfolioProjectA..OpioidDeaths
Group By State, Year
Order By HighestDeathRate DESC


--States with the highest to lowest rate of opioid overdose deaths per 100,000 people in 2014

Select Distinct State, Year, MAX([Crude Rate]) AS HighestDeathRate
From PortfolioProjectA..OpioidDeaths
WHERE Year = 2014
Group By State, Year
Order By HighestDeathRate DESC

--Introducing data from second table, which consists of opioid prescribers and prescriptions in the United States in 2014

Select *
From PortfolioProjectA..PrescriberInfo


--Total amount of opioid prescriptions in the United States in 2014

Select SUM(TotalPrescriptions) AS USTotalOpioidPrescriptions
FROM PortfolioProjectA..PrescriberInfo


--Prescriber Information of those who issued the highest amount of prescriptions in 2014

Select NPI, Gender, State, Credentials, Specialty, TotalPrescriptions 
FROM PortfolioProjectA..PrescriberInfo
WHERE TotalPrescriptions<>0
ORDER BY TotalPrescriptions DESC

--Showing the amount of providers and prescriptions in each state 

Select TOP 50
State, COUNT(NPI) AS ProvidersPerState, SUM(TotalPrescriptions) AS PrescriptionsPerState
FROM PortfolioProjectA..PrescriberInfo
GROUP BY State
ORDER BY PrescriptionsPerState DESC

--Showing the average amount of prescriptions per provider in each state 

WITH ProvidersVSPrescriptions AS (
Select TOP 51
State, COUNT(NPI) AS ProvidersPerState, SUM(TotalPrescriptions) AS PrescriptionsPerState
FROM PortfolioProjectA..PrescriberInfo
GROUP BY State 
ORDER BY PrescriptionsPerState DESC
)
Select State, ProvidersPerState, PrescriptionsPerState, (PrescriptionsPerState/ProvidersPerState)*100 AS PrescriptionsPerProvider
From ProvidersVSPrescriptions
Order By PrescriptionsPerProvider DESC


--Showing the rate of prescriptions in comparison to population 

WITH ProvidersVSPrescriptions AS (
Select TOP 51
State, COUNT(NPI) AS ProvidersPerState, SUM(TotalPrescriptions) AS PrescriptionsPerState
FROM PortfolioProjectA..PrescriberInfo
GROUP BY State 
ORDER BY PrescriptionsPerState DESC
)
Select p.State, p.ProvidersPerState, p.PrescriptionsPerState, o.Year, o.Population, (p.PrescriptionsPerState/o.Population)*100 AS PrescriptionToPopulationRatio
From ProvidersVSPrescriptions AS p JOIN PortfolioProjectA..OpioidDeaths AS o
ON p.State = o.State
Where o.Year=2014
Order By PrescriptionToPopulationRatio DESC





