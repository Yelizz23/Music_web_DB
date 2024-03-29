CREATE TABLE IF NOT EXISTS genre (
	id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT NULL
);

CREATE TABLE IF NOT EXISTS artist (
	id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS genre_artist (
	id SERIAL PRIMARY KEY,
	artist_id INTEGER NOT NULL REFERENCES artist(id),
	genre_id INTEGER NOT NULL REFERENCES genre(id)
);

CREATE TABLE IF NOT EXISTS album (
	id SERIAL PRIMARY KEY,
	name VARCHAR(90) NOT NULL,
	release_year INTEGER NOT NULL
);

CREATE TABLE artist_album (
	id SERIAL PRIMARY KEY,
	artist_id INTEGER NOT NULL REFERENCES artist(id),
	album_id INTEGER NOT NULL REFERENCES album(id)
);

CREATE TABLE IF NOT EXISTS track (
	id SERIAL PRIMARY KEY,
	album_id INTEGER NOT NULL REFERENCES album(id),
	name VARCHAR(100) NOT NULL,
	track_duration INTERVAL MINUTE TO SECOND NOT NULL
);

CREATE TABLE IF NOT EXISTS collection (
	id SERIAL PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	release_year INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS track_collection (
	id SERIAL PRIMARY KEY,
	track_id INTEGER NOT NULL REFERENCES track(id),
	collection_id INTEGER NOT NULL REFERENCES collection(id)
);