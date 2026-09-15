#!/bin/bash
# EX04 - II - Exercice 1 : total des streams par artiste
set -e
cd /home/src/spotify
hdfs dfs -rm -r -f output/artists >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files ex1_mapper.py,reducer_sum.py \
  -mapper "python3 ex1_mapper.py" -reducer "python3 reducer_sum.py" \
  -input input/Spotify_Most_Streamed_Songs.csv -output output/artists 2>/tmp/ex1.log
echo "=== TOP 6 artistes (par total de streams) ==="
hdfs dfs -cat output/artists/part-* | sort -t$'\t' -k2,2 -nr | head -6
echo "=== Nombre total d'artistes ==="
hdfs dfs -cat output/artists/part-* | wc -l
