-- EX05 II.3 : partitions logiques + elagage de partitions (partition pruning)
USE spotify_db;

CREATE TABLE IF NOT EXISTS spotify_part (
  track_name STRING,
  artist_name STRING,
  streams BIGINT
)
PARTITIONED BY (released_year INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

-- On exclut l'en-tete (released_year NULL) pour avoir exactement 50 partitions
INSERT OVERWRITE TABLE spotify_part PARTITION (released_year)
SELECT track_name, artist_name, streams, released_year
FROM spotify
WHERE released_year IS NOT NULL;

SHOW PARTITIONS spotify_part;
SELECT 'NB_PARTITIONS' AS x, COUNT(*) AS c FROM (SELECT DISTINCT released_year FROM spotify_part) t;

-- Le plan ne doit lire QUE la partition 2022
EXPLAIN SELECT COUNT(*) FROM spotify_part WHERE released_year = 2022;
