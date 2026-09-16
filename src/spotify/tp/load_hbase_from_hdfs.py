#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# TP final Q4 (variante cluster multi-noeuds) : charge le total d'articles PAR
# VILLE dans HBase, en lisant la sortie MapReduce deja calculee (output/ventes_full).
#
# POURQUOI un chargeur cote master et pas le reducer happybase (script 11) ?
#   Sur un cluster reel, les REDUCERS tournent sur les SLAVES (NodeManagers).
#   Le Thrift HBase n'ecoute que sur le MASTER (127.0.0.1:9090 cote master).
#   Un reducer distribue qui fait happybase.Connection('127.0.0.1', 9090) vise
#   donc le vide cote slave -> code 1. La bonne architecture (celle de l'EX06)
#   garde l'I/O HBase sur le master : MapReduce agrege -> un script master charge.
#
# ROWKEY = ville ; famille 'stat' ; colonne stat:total.

import subprocess
import sys
import happybase

TABLE = 'ventes'
conn = happybase.Connection('127.0.0.1', 9090)

# table recreee proprement (une seule fois, cote master)
try:
    conn.disable_table(TABLE); conn.delete_table(TABLE)
except Exception:
    pass
conn.create_table(TABLE, {'stat': dict()})
table = conn.table(TABLE)

# lecture de la sortie MapReduce (HDFS fait lui-meme l'expansion du glob part-*)
proc = subprocess.run(
    ['hdfs', 'dfs', '-cat', 'output/ventes_full/part-*'],
    capture_output=True, text=True
)
if proc.returncode != 0:
    sys.stderr.write(proc.stderr)
    sys.exit("Impossible de lire output/ventes_full - lancer d'abord run_ventes_full.sh")

n = 0
with table.batch(batch_size=500) as batch:
    for line in proc.stdout.splitlines():
        parts = line.split('\t', 1)
        if len(parts) < 2:
            continue
        ville, total = parts[0], parts[1]
        try:
            int(total)
        except ValueError:
            continue
        batch.put(ville.encode(), {b'stat:total': total.encode()})
        n += 1

conn.close()
print("%d villes inserees dans '%s'" % (n, TABLE), file=sys.stderr)
