/* 1. Find the title and artist who recorded the song 'Alison'. */

SELECT title, artist
FROM album a
JOIN track t
ON (a.asin = t.album)
WHERE song = 'Alison'


/* 2. Which artist recorded the song 'Exodus'? */

SELECT a.artist
FROM album a
JOIN track t
ON a.asin = t.album
WHERE t.song = 'Exodus'


/* 3. Show the song for each track on the album 'Blur' */

SELECT t.song
FROM track t
JOIN album a
ON t.album = a.asin
WHERE a.title = 'Blur'


/* 4. For each album show the title and the total number of track. */

SELECT title, COUNT(*)
FROM album a
JOIN track t
ON (a.asin = t.album)
GROUP BY title


/* 5. For each album show the title and the total number of tracks containing the word 'Heart' (albums with no such tracks need not be shown). */

SELECT a.title, COUNT(*)
FROM album a
JOIN track t
ON a.asin = t.album
WHERE song LIKE '%Heart%'
GROUP BY a.title


/* 6. A "title track" is where the song is the same as the title.
Find the title tracks. */

SELECT t.song
FROM track t
JOIN album a
ON t.album = a.asin
WHERE t.song = a.title


/* 7. An "eponymous" album is one where the title is the same as the artist (for example the album 'Blur' by the band 'Blur').
Show the eponymous albums. */

SELECT title
FROM album
WHERE title = artist


/* 8. Find the songs that appear on more than 2 albums.
Include a count of the number of times each shows up. */

SELECT t.song, COUNT(DISTINCT(a.title))
FROM track t
JOIN album a
ON t.album = a.asin
GROUP BY t.song
HAVING COUNT(DISTINCT(a.title)) > 2

-- Wrong answer for sqlzoo


/* 9. A "good value" album is one where the price per track is less than 50 pence.
Find the good value album - show the title, the price and the number of tracks. */

SELECT a.title, a.price, COUNT(t.song)
FROM album a
JOIN track t
ON a.asin = t.album
GROUP BY a.title, a.price
HAVING (a.price / COUNT(t.song)) < 0.50


/* 10. Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101 tracks.
List albums so that the album with the most tracks is first.
Show the title and the number of tracks
Where two or more albums have the same number of tracks you should order alphabetically */

SELECT a.title, COUNT(t.song)
FROM album a
JOIN track t
ON a.asin = t.album
GROUP BY a.title
ORDER BY COUNT(t.song) DESC, a.title ASC
