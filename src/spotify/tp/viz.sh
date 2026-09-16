#!/bin/bash
# TP visualisation : lit HBase 'ventes' -> PDF top 10 villes
set -e
cd /home/src/spotify/tp
python3 graph_hbase.py
echo "=== PDF genere : /home/src/spotify/tp/resultat.pdf ==="
ls -la resultat.pdf
