#!/bin/bash
# TD05 : nombre d'articles par ville (dataset dataw_fro03_mini_1000.csv)
# Test local (avant cluster) :
#   cat DATA/dataw_fro03_mini_1000.csv | python3 mapper_ventes.py | sort | python3 reducer.py
# Sur le cluster (apres hdfs dfs -put du CSV dans input/) :
set -e
cd /home/src/spotify/td/ventes
hdfs dfs -rm -r -f output/ventes >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files mapper_ventes.py,reducer.py \
  -mapper "python3 mapper_ventes.py" -reducer "python3 reducer.py" \
  -input input/dataw_fro03_mini_1000.csv -output output/ventes
echo "=== Top 5 villes par nombre d'articles ==="
hdfs dfs -cat output/ventes/part-* | sort -t$'\t' -k2,2 -nr | head -5
