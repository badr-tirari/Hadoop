-- EX05 Partie I : base de travail + table externe (DDL validee du cours)
CREATE DATABASE IF NOT EXISTS spotify_db;
USE spotify_db;

DROP TABLE IF EXISTS spotify;
CREATE EXTERNAL TABLE spotify (
  track_name STRING,
  artist_name STRING,
  artist_count INT,
  released_year INT,
  released_month INT,
  released_day INT,
  in_spotify_playlists INT,
  in_spotify_charts INT,
  streams BIGINT,                 -- certaines valeurs depassent INT
  in_apple_playlists INT,
  in_apple_charts INT,
  in_deezer_playlists STRING,     -- contient "1,003" -> STRING sinon NULL silencieux
  in_deezer_charts INT,
  in_shazam_charts STRING,
  bpm INT,
  `key` STRING,                   -- key = mot reserve -> backticks obligatoires
  mode STRING,
  danceability_pct DOUBLE,
  valence_pct DOUBLE,
  energy_pct DOUBLE,
  acousticness_pct DOUBLE,
  instrumentalness_pct DOUBLE,
  liveness_pct DOUBLE,
  speechiness_pct DOUBLE,
  cover_url STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/user/root/spotify/clean';

-- Controles I.5 : 954 (en-tete lu comme donnee) / 952 (streams non NULL) / 489458828542
SELECT 'COUNT_STAR'     AS mesure, COUNT(*)       AS valeur FROM spotify;
SELECT 'COUNT_STREAMS'  AS mesure, COUNT(streams) AS valeur FROM spotify;
SELECT 'SUM_TOTAL'      AS mesure, SUM(streams)   AS valeur FROM spotify;
