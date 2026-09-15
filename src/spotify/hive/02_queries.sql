USE spotify_db;

-- II.1 Top 10 artistes par total de streams (= MapReduce Ex1, convention duo = 1 cle)
SELECT artist_name, SUM(streams) AS total
FROM spotify
GROUP BY artist_name
ORDER BY total DESC
LIMIT 10;

-- Validation croisee : total streams par annee (= MapReduce Ex3) - controle 1975/1984/2023
SELECT released_year, SUM(streams) AS total
FROM spotify
WHERE released_year IN (1975, 1984, 2023)
GROUP BY released_year
ORDER BY released_year;

-- II.2 Moyenne de danceability par annee (valeurs entre 0 et 100)
SELECT released_year, ROUND(AVG(danceability_pct), 2) AS dance_moyenne
FROM spotify
GROUP BY released_year
ORDER BY released_year;

-- III.1 Top 5 artistes par nombre de titres (une ligne = un titre)
SELECT artist_name, COUNT(*) AS nombre_de_titres
FROM spotify
GROUP BY artist_name
ORDER BY nombre_de_titres DESC
LIMIT 5;

-- III.2 Streams moyens par annee de sortie (= MapReduce Ex2)
SELECT released_year, ROUND(AVG(streams), 2) AS moyenne_streams
FROM spotify
GROUP BY released_year
ORDER BY released_year;
