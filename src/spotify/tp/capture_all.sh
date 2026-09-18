#!/bin/bash
# Capture de tous les livrables du TP (sections II a VI) dans outputs/.
JAR='/opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar'
BEE='beeline -u jdbc:hive2://localhost:10000 -n root --silent=true'
cd /home/src/spotify/tp
OUT=/home/src/spotify/tp/outputs
mkdir -p "$OUT"

echo "########## II. PREPARATION ##########"
hdfs dfs -test -e input/dataw_fro03.csv 2>/dev/null || { hdfs dfs -mkdir -p input; hdfs dfs -put -f /home/dataw_fro03.csv input/dataw_fro03.csv; }
{
  echo "=== Fichier present dans HDFS ==="
  hdfs dfs -ls -h input/dataw_fro03.csv
  echo; echo "=== 5 PREMIERES lignes (lues depuis HDFS) ==="
  hdfs dfs -cat input/dataw_fro03.csv 2>/dev/null | head -5
  echo; echo "=== 5 DERNIERES lignes (lues depuis HDFS) ==="
  hdfs dfs -cat input/dataw_fro03.csv 2>/dev/null | tail -5
} > "$OUT/II_preparation_hdfs.txt"
echo "  -> II_preparation_hdfs.txt"

echo "########## III. Q1 - articles par ville ##########"
hdfs dfs -rm -r -f output/ventes_full >/dev/null 2>&1
hadoop jar $JAR -files mapper_ville.py,reducer_ventes.py \
  -mapper "python3 mapper_ville.py" -reducer "python3 reducer_ventes.py" \
  -input input/dataw_fro03.csv -output output/ventes_full 2> "$OUT/Q1_job.log"
{
  echo "=== Parts generes ==="; hdfs dfs -ls output/ventes_full
  echo; echo "=== part-00000 : 5 premieres lignes ==="; hdfs dfs -cat output/ventes_full/part-00000 2>/dev/null | head -5
  echo; echo "=== TOP 5 villes (par total d'articles) ==="; hdfs dfs -cat output/ventes_full/part-* 2>/dev/null | sort -t$'\t' -k2,2 -nr | head -5
  echo; echo "=== Nb villes distinctes ==="; hdfs dfs -cat output/ventes_full/part-* 2>/dev/null | wc -l
} > "$OUT/Q1_villes.txt"
hdfs dfs -cat output/ventes_full/part-00000 > "$OUT/Q1_part-00000.txt" 2>/dev/null
echo "  -> Q1_villes.txt, Q1_part-00000.txt"

echo "########## III. Q2 - articles par ville#annee ##########"
hdfs dfs -rm -r -f output/ventes_annee >/dev/null 2>&1
hadoop jar $JAR -files mapper_ville_annee.py,reducer_ventes.py \
  -mapper "python3 mapper_ville_annee.py" -reducer "python3 reducer_ventes.py" \
  -input input/dataw_fro03.csv -output output/ventes_annee 2> "$OUT/Q2_job.log"
{
  echo "=== Parts generes ==="; hdfs dfs -ls output/ventes_annee
  echo; echo "=== part-00000 : 5 premieres lignes ==="; hdfs dfs -cat output/ventes_annee/part-00000 2>/dev/null | head -5
  echo; echo "=== TOP 5 couples (ville#annee) ==="; hdfs dfs -cat output/ventes_annee/part-* 2>/dev/null | sort -t$'\t' -k2,2 -nr | head -5
  echo; echo "=== Nb couples distincts ==="; hdfs dfs -cat output/ventes_annee/part-* 2>/dev/null | wc -l
} > "$OUT/Q2_ville_annee.txt"
hdfs dfs -cat output/ventes_annee/part-00000 > "$OUT/Q2_part-00000.txt" 2>/dev/null
echo "  -> Q2_ville_annee.txt, Q2_part-00000.txt"

echo "########## IV. Q3 - HBase (reducer happybase distribue) ##########"
python3 - <<'PY' 2>/dev/null
import happybase
c=happybase.Connection('hadoop-master',9090)
try:
    c.disable_table('ventes'); c.delete_table('ventes')
except Exception: pass
c.create_table('ventes', {'stat': dict()}); c.close()
PY
hdfs dfs -rm -r -f output/ventes_hbase >/dev/null 2>&1
if hadoop jar $JAR -files mapper_ville.py,reducer_hbase.py \
     -mapper "python3 mapper_ville.py" -reducer "python3 reducer_hbase.py" \
     -input input/dataw_fro03.csv -output output/ventes_hbase 2> "$OUT/Q3_job.log"; then
  MODE="reducer happybase distribue (conforme au sujet)"
else
  MODE="FALLBACK chargeur cote master (reducer distribue en echec, voir Q3_job.log)"
  python3 load_hbase_from_hdfs.py 2>>"$OUT/Q3_job.log"
fi
{
  echo "=== Mode de chargement : $MODE ==="
  python3 - <<'PY' 2>/dev/null
import happybase
c=happybase.Connection('hadoop-master',9090); t=c.table('ventes')
print("count 'ventes'         =", sum(1 for _ in t.scan()), "villes")
print("get 'ventes','LE MANS' =", t.row(b'LE MANS').get(b'stat:total'))
print("get 'ventes','CAEN'    =", t.row(b'CAEN').get(b'stat:total'))
print("get 'ventes','FLERS'   =", t.row(b'FLERS').get(b'stat:total'))
c.close()
PY
} > "$OUT/Q3_hbase.txt"
echo "  -> Q3_hbase.txt (mode: $MODE)"

echo "########## V. Visualisation ##########"
python3 graph_hbase.py > "$OUT/top10.txt" 2>/dev/null
cp -f resultat.pdf "$OUT/resultat.pdf" 2>/dev/null
echo "  -> top10.txt, resultat.pdf"

echo "########## VI. Q4 - Hive (validation croisee) ##########"
python3 prepare_ventes_tsv.py /home/dataw_fro03.csv /home/ventes-clean.tsv 2> "$OUT/Q4_prepare.log"
hdfs dfs -mkdir -p /user/root/ventes/clean
hdfs dfs -rm -f /user/root/ventes/clean/* >/dev/null 2>&1
hdfs dfs -put -f /home/ventes-clean.tsv /user/root/ventes/clean/
$BEE -f hive/create_ventes.sql   > "$OUT/Q4_hive.txt" 2>/dev/null
$BEE -f hive/queries_ventes.sql >> "$OUT/Q4_hive.txt" 2>/dev/null
$BEE -e "EXPLAIN SELECT villecli, SUM(qte) AS total FROM ventes GROUP BY villecli ORDER BY total DESC LIMIT 5;" > "$OUT/Q4_explain.txt" 2>/dev/null
echo "  -> Q4_hive.txt, Q4_explain.txt, Q4_prepare.log"

echo "########## FIN — recap outputs ##########"
ls -la "$OUT"
