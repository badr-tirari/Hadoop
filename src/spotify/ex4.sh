#!/bin/bash
# EX04 - II - Exercice 4 : nombre moyen de playlists Spotify par annee
set -e
cd /home/src/spotify
hdfs dfs -rm -r -f output/avg_playlists_year >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files ex4_mapper.py,reducer_avg.py \
  -mapper "python3 ex4_mapper.py" -reducer "python3 reducer_avg.py" \
  -input input/Spotify_Most_Streamed_Songs.csv -output output/avg_playlists_year 2>/tmp/ex4.log
echo "=== Moyenne playlists Spotify / annee (5 plus anciennes) ==="
hdfs dfs -cat output/avg_playlists_year/part-* | sort -n | head -5
echo "..."
echo "=== (5 plus recentes) ==="
hdfs dfs -cat output/avg_playlists_year/part-* | sort -n | tail -5
