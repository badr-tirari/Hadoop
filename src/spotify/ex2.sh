#!/bin/bash
# EX04 - II - Exercice 2 : moyenne des streams par annee de sortie
set -e
cd /home/src/spotify
hdfs dfs -rm -r -f output/avg_streams_year >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files mapper_year_streams.py,reducer_avg.py \
  -mapper "python3 mapper_year_streams.py" -reducer "python3 reducer_avg.py" \
  -input input/Spotify_Most_Streamed_Songs.csv -output output/avg_streams_year 2>/tmp/ex2.log
echo "=== Moyenne streams / annee (5 plus anciennes) ==="
hdfs dfs -cat output/avg_streams_year/part-* | sort -n | head -5
echo "..."
echo "=== (5 plus recentes) ==="
hdfs dfs -cat output/avg_streams_year/part-* | sort -n | tail -5
echo "=== Nombre d'annees ==="
hdfs dfs -cat output/avg_streams_year/part-* | wc -l
