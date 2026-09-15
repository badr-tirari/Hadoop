#!/bin/bash
# EX04 - II - Exercice 3 : nombre total de streams par annee de sortie
set -e
cd /home/src/spotify
hdfs dfs -rm -r -f output/streams_year >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files mapper_year_streams.py,reducer_sum.py \
  -mapper "python3 mapper_year_streams.py" -reducer "python3 reducer_sum.py" \
  -input input/Spotify_Most_Streamed_Songs.csv -output output/streams_year 2>/tmp/ex3.log
echo "=== Total streams par annee (annee croissante) ==="
hdfs dfs -cat output/streams_year/part-* | sort -n
echo "=== Controle 1975 / 1984 / 2023 ==="
hdfs dfs -cat output/streams_year/part-* | grep -E '^(1975|1984|2023)\b'
