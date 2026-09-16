#!/bin/bash
# TP Q2 : nombre d'articles par couple (ville, annee) - cle composite "ville#annee"
set -e
cd /home/src/spotify/tp
hdfs dfs -rm -r -f output/ventes_annee >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files mapper_ville_annee.py,reducer_ventes.py \
  -mapper "python3 mapper_ville_annee.py" -reducer "python3 reducer_ventes.py" \
  -input input/dataw_fro03.csv -output output/ventes_annee
echo "=== TOP 10 couples (ville, annee) par articles - FICHIER COMPLET ==="
hdfs dfs -cat output/ventes_annee/part-* | sort -t$'\t' -k2,2 -nr | head -10
echo "=== Nb couples (ville,annee) distincts ==="
hdfs dfs -cat output/ventes_annee/part-* | wc -l
