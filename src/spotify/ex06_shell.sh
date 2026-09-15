#!/bin/bash
# EX06 I & III (shell) : exercice bibliotheque dans le shell HBase
set -e
echo "=== Exercice bibliotheque (create/put/scan/get/update/delete/filter/deleteall) ==="
# hbase shell <fichier> execute le script ; stderr = logs SLF4J -> /dev/null
hbase shell /home/src/spotify/hbase/biblio.hb 2>/dev/null
