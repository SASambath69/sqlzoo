/* 1. List the films where the yr is 1962 [Show id, title] */

SELECT id, title
FROM movie
WHERE yr = 1962


/* 2. Give year of 'Citizen Kane'. */

SELECT yr
FROM movie
WHERE title = 'Citizen Kane'


/* 3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title).
Order results by year. */

SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr


/* 4. What id number does the actor 'Glenn Close' have? */

SELECT id
FROM actor
WHERE name = 'Glenn Close'


/* 5. What is the id of the film 'Casablanca' */

SELECT id
FROM movie
WHERE title = 'Casablanca'


/* 6. Obtain the cast list for 'Casablanca'.
Use movieid=11768, (or whatever value you got from the previous question) */

SELECT a.name
FROM actor a
JOIN casting c
ON a.id = c.actorid
WHERE movieid = 11768


/* 7. Obtain the cast list for the film 'Alien' */

SELECT a.name
FROM actor a
JOIN casting c
ON a.id = c.actorid
WHERE movieid = (
	SELECT DISTINCT(movieid)
	FROM casting c
	JOIN movie m
	ON c.movieid = m.id
	WHERE m.title = 'Alien')


/* 8. List the films in which 'Harrison Ford' has appeared */

SELECT m.title
FROM movie m
JOIN casting c
ON m.id = c.movieid
WHERE c.actorid = (
	SELECT DISTINCT(actorid)
	FROM casting
	JOIN actor
	ON casting.actorid = actor.id
	WHERE name = 'Harrison Ford')


/* 9. List the films where 'Harrison Ford' has appeared - but not in the starring role.
[Note: the ord field of casting gives the position of the actor.
If ord=1 then this actor is in the starring role] */

SELECT m.title
FROM movie m
JOIN casting c
ON m.id = c.movieid
WHERE c.actorid = (
	SELECT DISTINCT(actorid)
	FROM casting
	JOIN actor
	ON casting.actorid = actor.id
	WHERE name = 'Harrison Ford')
AND ord != 1


/* 10. List the films together with the leading star for all 1962 films. */

SELECT title, name
FROM (
	SELECT m.title, c.actorid, c.ord
	FROM movie m
	JOIN casting c
	ON m.id = c.movieid
	WHERE yr = 1962) mc
JOIN actor a
ON mc.actorid = a.id
WHERE mc.ord = 1


/* 11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies. */

SELECT yr, COUNT(title)
FROM movie
JOIN casting ON movie.id = movieid
JOIN actor ON actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2


/* 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in. */

SELECT m.title, ca.name
FROM (
	SELECT movieid, name
	FROM casting c
	JOIN actor a
	ON c.actorid = a.id
	WHERE movieid IN (
		SELECT movieid
		FROM casting
		WHERE actorid IN (
			SELECT id
			FROM actor
			WHERE name = 'Julie Andrews'))
	AND ord = 1) ca
JOIN movie m
ON ca.movieid = m.id


/* 13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles. */

SELECT name
FROM (
	SELECT a.name, COUNT(a.name) qty
	FROM actor a
	JOIN casting c
	ON a.id = c.actorid
	WHERE c.ord = 1
	GROUP BY a.name) ac
WHERE qty >= 15


/* 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title. */

SELECT m.title, COUNT(c.actorid)
FROM movie m
JOIN casting c
ON m.id = c.movieid
WHERE m.yr = 1978
GROUP BY m.title
ORDER BY COUNT(c.actorid) DESC, m.title ASC


/* 15. List all the people who have worked with 'Art Garfunkel'. */

SELECT a.name
FROM actor a
JOIN casting c
ON a.id = c.actorid
WHERE c.movieid IN (
	SELECT c.movieid
	FROM actor a
	JOIN casting c
	ON a.id = c.actorid
	WHERE name = 'Art Garfunkel')
AND a.name != 'Art Garfunkel'
