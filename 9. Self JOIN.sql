/* 1. How many stops are in the database */

SELECT COUNT(DISTINCT(id))
FROM stops


/* 2. Find the id value for the stop 'Craiglockhart' */

SELECT id
FROM stops
WHERE name = 'Craiglockhart'


/* 3. Give the id and the name for the stops on the '4' 'LRT' service. */

SELECT s.id, s.name
FROM stops s
JOIN route r
ON s.id = r.stop
WHERE r.num = '4' AND r.company = 'LRT'


/* 4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53).
Run the query and notice the two services that link these stops have a count of 2.
Add a HAVING clause to restrict the output to these two routes. */

SELECT company, num, COUNT(*)
FROM route
WHERE company = 'LRT'
AND (stop = 149 OR stop = 53)
GROUP BY company, num
HAVING COUNT(*) = 2


/* 5. Execute the self JOIN shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes.
Change the query so that it shows the services from Craiglockhart to London Road. */

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
	(a.company = b.company AND a.num = b.num)
WHERE a.stop = 53
AND b.stop = 149


/* 6. The query shown is similar to the previous one, however by JOINing two copies of the stops table we can refer to stops by name rather than by number.
Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
If you are tired of these places try 'Fairmilehead' against 'Tollcross' */

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a
JOIN route b ON
	(a.company = b.company AND a.num = b.num)
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop = stopb.id)
WHERE stopa.name = 'Craiglockhart'
AND stopb.name = 'London Road'


/* 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') */

SELECT DISTINCT(company), num
FROM (
	SELECT a.company, a.num, a.stop AS 'left', b.stop AS 'right'
	FROM route a
	JOIN route b ON
		(a.company = b.company AND a.num = b.num)
	WHERE a.stop = 115
	AND b.stop = 137
	) rr


/* 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' */

SELECT ra.company, ra.num
FROM route ra
JOIN route rb ON ra.num = rb.num
JOIN stops sa ON ra.stop = sa.id
JOIN stops sb ON rb.stop = sb.id
WHERE sa.name = 'Craiglockhart'
AND sb.name = 'Tollcross'


/* 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company.
Include the company and bus no. of the relevant services. */

SELECT s.name, r.company, r.num
FROM stops s
JOIN route r
ON s.id = r.stop
WHERE r.num IN (
	SELECT r.num
	FROM route r
	JOIN stops s
	ON r.stop = s.id
	WHERE s.name = 'Craiglockhart'
	AND company = 'LRT'
	)
AND r.company = 'LRT'
ORDER BY (
	CASE r.num
	WHEN 10 THEN 1
	WHEN 27 THEN 2
	WHEN 4 THEN 3
	WHEN 45 THEN 4
	ELSE 5
	END
	)

-- Wrong answer for sqlzoo


/* 10. Find the routes involving two buses that can go from Craiglockhart to Lochend. */

SELECT A.num, A.company, A.name, B.num, B.company
FROM (
	SELECT DISTINCT a.num, a.company, sb.name
	FROM route a
	JOIN route b
	ON (a.num = b.num AND a.company = b.company)
	JOIN stops sa ON sa.id = a.stop
	JOIN stops sb ON sb.id = b.stop
	WHERE sa.name = 'Craiglockhart' AND sb.name <> 'Craiglockhart') A
JOIN (
	SELECT x.num, x.company, sy.name
	FROM route x
	JOIN route y
	ON (x.num = y.num and x.company = y.company)
	JOIN stops sx ON sx.id = x.stop
	JOIN stops sy ON sy.id = y.stop
	WHERE sx.name = 'Lochend' AND sy.name <> 'Lochend') B
ON A.name = B.name
ORDER BY A.num, A.name, B.num
