#!/bin/bash
# TP Q4 (cluster) : charge le total/ville dans HBase depuis la sortie MapReduce,
# puis verifie par relecture (le put ne prouve rien).
set -e
cd /home/src/spotify/tp
echo "=== 1) Chargement HBase depuis output/ventes_full (cote master) ==="
python3 load_hbase_from_hdfs.py
echo "=== 2) Verification : relecture depuis la table HBase ==="
python3 - <<'PY'
import happybase
conn = happybase.Connection('127.0.0.1', 9090)
t = conn.table('ventes')
print("count 'ventes'                 =", sum(1 for _ in t.scan()), "villes")
print("get 'ventes','LE MANS' total   =", t.row(b'LE MANS').get(b'stat:total'))
print("get 'ventes','CAEN'    total   =", t.row(b'CAEN').get(b'stat:total'))
print("get 'ventes','FLERS'   total   =", t.row(b'FLERS').get(b'stat:total'))
conn.close()
PY
