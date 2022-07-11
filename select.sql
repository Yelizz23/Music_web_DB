--  название и год выхода альбомов, вышедших в 2018 году / name and release year of albums released in 2018;
SELECT *
FROM album
WHERE release_year = 2018;

--  название и продолжительность самого длительного трека / name and duration of the longest track;
SELECT name, track_duration
FROM track
WHERE track_duration = (SELECT MAX(track_duration) FROM track);

--  название треков, продолжительность которых не менее 3,5 минуты / name of tracks, which have a duration at least 3.5 minutes;
SELECT name, track_duration
FROM track
WHERE track_duration > '00:03:30';

--  названия сборников, вышедших в период с 2018 по 2020 год включительно / names of collections published between 2018 and 2020;
SELECT name, release_year
FROM collection
WHERE release_year
BETWEEN 2018 AND 2020;

--  исполнители, чье имя состоит из 1 слова / artists whose name consists of 1 word;
SELECT name
FROM artist
WHERE name
NOT LIKE '%% %%';

--  название треков, которые содержат слово "мой"/"my" / name of tracks that contain "my";
SELECT name
FROM track
WHERE name
ILIKE '%%мой%%' OR name ILIKE '%%my%%';


----------------------------------------------------------------------------------------------------------


--  количество исполнителей в каждом жанре / number of artists in each genre;
SELECT name, COUNT(artist_id)
FROM genre INNER JOIN genre_artist
ON genre.id = genre_artist.genre_id
GROUP BY name;

-- количество треков, вошедших в альбомы 2019-2020 годов / number of tracks included in albums of 2019-2020;
SELECT COUNT(*)
FROM track t
JOIN album a ON t.album_id = a.id
WHERE a.release_year BETWEEN 2019 AND 2020;

--  средняя продолжительность треков по каждому альбому / average length of tracks for each album;
SELECT a.name AS album_name, AVG(track_duration) AS avg_duration
FROM track INNER JOIN album a ON a.id = track.album_id
GROUP BY a.name;

-- все исполнители, которые не выпустили альбомы в 2020 году / artists who have not released albums in 2020;
SELECT DISTINCT ar.name FROM artist ar
JOIN artist_album aa ON ar.id = aa.artist_id
JOIN album al ON aa.album_id = al.id
WHERE ar.name NOT IN (
    SELECT DISTINCT ar.name FROM artist ar
    JOIN artist_album aa ON ar.id = aa.artist_id
    JOIN album al ON aa.album_id = al.id
    WHERE release_year IN (2020));

-- названия сборников, в которых присутствует конкретный исполнитель (выберите сами) / names of the collections in which selected artist is located (choose the artist yourself);
SELECT DISTINCT c.name
FROM artist AS a
INNER JOIN artist_album AS aa ON a.id = aa.artist_id
INNER JOIN track AS t ON aa.album_id = t.album_id
INNER JOIN track_collection AS tc ON t.id = tc.track_id
INNER JOIN collection AS c ON tc.collection_id = c.id
WHERE a.name = 'Metallica';

-- название альбомов, в которых присутствуют исполнители более 1 жанра / name of albums containing artists of more than 1 genre;
SELECT name
FROM genre_artist
LEFT JOIN  artist_album AS aal ON genre_artist.artist_id = aal.artist_id
LEFT JOIN album AS a ON a.id = aal.album_id
GROUP BY name
HAVING COUNT(genre_id) > 1;

-- наименование треков, которые не входят в сборники / name of tracks that are not included in the collections;
SELECT name
FROM track
LEFT JOIN track_collection tc ON track.id = tc.track_id
WHERE collection_id IS NULL;

-- исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько) / artist who wrote the shortest track (duration). Theoretically, there could be several tracks;
SELECT ar.name
FROM track AS t
LEFT JOIN album AS a ON t.album_id = a.id
LEFT JOIN artist_album aa ON a.id = aa.album_id
LEFT JOIN artist ar ON aa.artist_id = ar.id
WHERE t.track_duration = (SELECT MIN(track_duration) FROM track)
ORDER BY ar.name;

-- название альбомов, содержащих наименьшее количество треков / name of albums containing the least number of tracks;
SELECT album.name
FROM album
LEFT JOIN track AS t ON album.id = t.album_id
GROUP BY album.name
HAVING COUNT(t.id) = (
    SELECT MIN(amount)
    FROM (
        SELECT count(t.id) AS amount
        FROM album AS a
        LEFT JOIN track AS t ON a.id = t.album_id
        GROUP BY a.name
    ) as temp);