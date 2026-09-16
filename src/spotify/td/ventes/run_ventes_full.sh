#!/bin/bash
# TD05 Q2 : nombre d'articles par ville sur le FICHIER COMPLET (dataw_fro03.csv, ~135 000 lignes)
# Prerequis : le CSV complet a ete copie dans HDFS -> input/dataw_fro03.csv
set -e
cd /home/src/spotify/td/ventes
hdfs dfs -rm -r -f output/ventes_full >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files mapper_ventes.py,reducer.py \
  -mapper "python3 mapper_ventes.py" -reducer "python3 reducer.py" \
  -input input/dataw_fro03.csv -output output/ventes_full
echo "=== Top 5 villes par nombre d'articles (FICHIER COMPLET) ==="
hdfs dfs -cat output/ventes_full/part-* | sort -t$'\t' -k2,2 -nr | head -5
echo "=== Nombre de villes distinctes ==="
hdfs dfs -cat output/ventes_full/part-* | wc -l
