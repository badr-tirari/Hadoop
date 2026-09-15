#!/bin/bash
# EX05 - Hive : CSV->TSV, chargement HDFS, table externe, requetes SQL (Parties I, II, III)
set -e
cd /home/src/spotify/hive
BEELINE="/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 --silent=true"

echo "===== 1) CSV -> TSV (script du cours 7-prepare-spotify-tsv.py) ====="
python3 /home/7-prepare-spotify-tsv.py /home/Spotify_Most_Streamed_Songs.csv /home/spotify-clean.tsv
echo "lignes TSV : $(wc -l < /home/spotify-clean.tsv)   (attendu 954)"

echo "===== 2) Chargement du TSV dans HDFS (/user/root/spotify/clean) ====="
hdfs dfs -mkdir -p /user/root/spotify/clean
hdfs dfs -put -f /home/spotify-clean.tsv /user/root/spotify/clean/
hdfs dfs -ls /user/root/spotify/clean

echo "===== 3) Base + table externe + controles (954 / 952 / 489458828542) ====="
$BEELINE -f 01_create_table.sql

echo "===== 4) Requetes d'analyse (Partie II & III) ====="
$BEELINE -f 02_queries.sql
echo "=== EX05 (I + II + III) termine ==="
