/* 1. List each country name where the population is larger than that of 'Russia'. */

SELECT name
FROM world
WHERE population > (
	SELECT population
	FROM world
    WHERE name = 'Russia')


/* 2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'. */

SELECT name
FROM world
WHERE (gdp / population) > (
	SELECT (gdp / population) AS 'per capita gdp'
	FROM world
	WHERE name = 'United Kingdom')
AND continent = 'Europe'


/* 3. List the name and continent of countries in the continents containing either Argentina or Australia.
ORDER BY name of the country. */

SELECT name, continent
FROM world
WHERE continent IN (
	SELECT continent
	FROM world
	WHERE name IN ('Argentina','Australia'))
ORDER BY name


/* 4. Which country has a population that is more than Canada but less than Poland?
Show the name and the population. */

SELECT name, population
FROM world
WHERE population > (
	SELECT population
	FROM world
	WHERE name = 'Canada')
AND population < (
	SELECT population
	FROM world
	WHERE name = 'Poland')


/* 5. Germany (population 80 million) has the largest population of the countries in Europe.
Austria (population 8.5 million) has 11% of the population of Germany.
Show the name and the population of each country in Europe.
Show the population as a percentage of the population of Germany. */

SELECT name, concat(round((population / (SELECT population FROM world WHERE name = 'Germany') * 100),0),'%') as percentage
FROM world
WHERE continent = 'Europe'


/* 6. Which countries have a GDP greater than every country in Europe?
[Give the name only.] (Some countries may have NULL gdp values) */

SELECT name
FROM world
WHERE gdp >
  (SELECT max(gdp) FROM world WHERE continent = 'Europe')


/* 7. Find the largest country (by area) in each continent, show the continent, the name and the area */

SELECT continent, name, area 
FROM world
WHERE area IN (
	SELECT MAX(area) 
	FROM world 
	GROUP BY continent)


/* 8. List each continent and the name of the country that comes first alphabetically. */

SELECT continent, min(name) AS name
FROM world
GROUP BY continent
ORDER BY continent

-- ou aussi :

SELECT continent, name
FROM (SELECT continent, name, RANK() OVER(PARTITION BY continent ORDER BY name) AS position
      FROM world) AS world
WHERE position = 1


/* 9. Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents.
Show name, continent and population. */

SELECT name, continent, population
FROM world
WHERE continent IN (SELECT continent
		    FROM (SELECT DISTINCT(continent),
			  	CASE WHEN COUNT(continent) = SUM(ok) THEN 1
			  	ELSE 0 END AS correspond
			  FROM (SELECT continent, name,
					CASE WHEN population <= 25000000 THEN 1
					ELSE 0 END AS ok
				FROM world) AS w
			  GROUP BY continent) AS x
WHERE correspond = 1)


/* 10. Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents. */

SELECT name, continent
FROM world
WHERE population IN (SELECT max(population) AS population_max
		     FROM world
		     GROUP BY continent
		     HAVING continent IN (SELECT continent
					  FROM (SELECT w.continent, name, population, population_max,
							CASE WHEN population_max > 3 * population THEN 1
							ELSE 0 END as goal
						FROM world w
						JOIN (SELECT continent, MAX(population) AS population_max
						      FROM world
						      GROUP BY continent) AS x
						IN w.continent = x.continent) z
					  GROUP BY continent
					  HAVING (CASE WHEN COUNT(goal) = SUM(goal) + 1 THEN 1
						  ELSE 0 END) = 1))
