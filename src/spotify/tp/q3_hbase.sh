#!/bin/bash
# TP Q3 (IV. HBase) : relancer Q1 avec un reducer qui ECRIT dans HBase (happybase).
# rowkey = ville, famille stat, colonne stat:total. Reducer distribue -> Thrift = hadoop-master.
set -e
cd /home/src/spotify/tp
echo "=== 1) Creation table HBase 'ventes' (une seule fois, AVANT le job, cote master) ==="
python3 - <<'PY'
import happybase
conn = happybase.Connection('hadoop-master', 9090)
try:
    conn.disable_table('ventes'); conn.delete_table('ventes')
except Exception:
    pass
conn.create_table('ventes', {'stat': dict()})
conn.close(); print("table 'ventes' creee")
PY
echo "=== 2) Job MapReduce : mapper_ville + reducer_hbase (ecrit dans HBase) ==="
hdfs dfs -rm -r -f output/ventes_hbase >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files mapper_ville.py,reducer_hbase.py \
  -mapper "python3 mapper_ville.py" -reducer "python3 reducer_hbase.py" \
  -input input/dataw_fro03.csv -output output/ventes_hbase
echo "=== 3) Verification par hbase (le put ne prouve rien) ==="
python3 - <<'PY'
import happybase
conn = happybase.Connection('hadoop-master', 9090)
t = conn.table('ventes')
print("count 'ventes'            =", sum(1 for _ in t.scan()), "villes")
print("get 'ventes','LE MANS'    =", t.row(b'LE MANS').get(b'stat:total'))
print("get 'ventes','CAEN'       =", t.row(b'CAEN').get(b'stat:total'))
conn.close()
PY
