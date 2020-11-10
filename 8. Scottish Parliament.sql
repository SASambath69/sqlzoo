/* 1. One MSP was kicked out of the Labour party and has no party.
Find him. */

SELECT name
FROM msp
WHERE party IS NULL


/* 2. Obtain a list of all parties and leaders. */

SELECT name, leader
FROM party


/* 3. Give the party and the leader for the parties which have leaders. */

SELECT name, leader
FROM party
WHERE leader IS NOT NULL


/* 4. Obtain a list of all parties which have at least one MSP. */

SELECT DISTINCT(p.name)
FROM party p
JOIN msp m
ON p.Code = m.Party
WHERE m.Name IS NOT NULL


/* 5. Obtain a list of all MSPs by name, give the name of the MSP and the name of the party where available.
Be sure that Canavan MSP, Dennis is in the list.
Use ORDER BY msp.name to sort your output by MSP. */

SELECT m.Name, p.Name
FROM msp m
LEFT JOIN party p
ON m.Party = p.Code
ORDER BY m.Name


/* 6. Obtain a list of parties which have MSPs, include the number of MSPs. */

SELECT p.Name, COUNT(m.Name)
FROM party p
JOIN msp m
ON p.Code = m.Party
GROUP BY p.Name


/* 7. A list of parties with the number of MSPs; include parties with no MSPs. */

SELECT p.Name, COUNT(m.Name)
FROM party p
LEFT JOIN msp m
ON p.Code = m.Party
GROUP BY p.Name
