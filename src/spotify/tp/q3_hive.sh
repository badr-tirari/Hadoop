#!/bin/bash
# TP Q3 : validation croisee Hive sur le fichier complet
set -e
cd /home/src/spotify/tp
echo "=== 1) Preparation du TSV (4 colonnes : ville, annee, libobj, qte) ==="
python3 prepare_ventes_tsv.py /home/dataw_fro03.csv /home/ventes-clean.tsv
echo "=== 2) Depot dans HDFS ==="
hdfs dfs -mkdir -p /user/root/ventes/clean
hdfs dfs -rm -f /user/root/ventes/clean/* >/dev/null 2>&1 || true
hdfs dfs -put -f /home/ventes-clean.tsv /user/root/ventes/clean/
echo "=== 3) Creation table externe ==="
beeline -u jdbc:hive2://localhost:10000 -n root --silent=true -f hive/create_ventes.sql
echo "=== 4) Requetes de validation croisee ==="
beeline -u jdbc:hive2://localhost:10000 -n root --silent=true -f hive/queries_ventes.sql
