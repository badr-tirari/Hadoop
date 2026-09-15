#!/bin/bash
# EX05 II.3 : table partitionnee + partition pruning (EXPLAIN)
set -e
cd /home/src/spotify/hive
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 --silent=true -f 03_partitions.sql
echo "=== 50 partitions attendues (1930->2023) ; le plan EXPLAIN ne lit que released_year=2022 ==="
