#!/bin/bash

echo "[INFO] Starting HiveServer2 (Derby metastore embarqué)..."

# Le metastore Derby se crée dans /home/metastore_db au premier lancement.
# Une seule session à la fois (verrou Derby) : cf. README.
mkdir -p /home/metastore_db 2>/dev/null

$HIVE_HOME/bin/hive --service hiveserver2 > /home/hiveserver2.log 2>&1 &

# Attendre que le port JDBC réponde (jusqu'à ~60 s)
for i in $(seq 1 30); do
    if nc -z localhost 10000 2>/dev/null; then
        echo "[INFO] HiveServer2 is up (jdbc:hive2://localhost:10000)."
        echo "[INFO] Se connecter avec : beeline -u jdbc:hive2://localhost:10000"
        exit 0
    fi
    sleep 2
done

echo "[WARN] HiveServer2 ne répond pas encore sur le port 10000."
echo "[INFO] Logs : /home/hiveserver2.log"
exit 0
