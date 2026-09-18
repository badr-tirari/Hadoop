#!/bin/bash
# TP V. Visualisation : lit HBase 'ventes' -> PDF top 10 + top10.txt
set -e
cd /home/src/spotify/tp
python3 graph_hbase.py | tee top10.txt
echo "=== livrables ==="
ls -la resultat.pdf top10.txt
