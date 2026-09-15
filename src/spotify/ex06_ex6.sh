#!/bin/bash
# EX06 IV / EX04 Ex6 : streams par annee -> table HBase streams_year
set -e
cd /home/src/spotify
hdfs dfs -rm -r -f output/streams_year_hb >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files mapper_year_streams.py,reducer_sum.py \
  -mapper "python3 mapper_year_streams.py" -reducer "python3 reducer_sum.py" \
  -input input/Spotify_Most_Streamed_Songs.csv -output output/streams_year_hb 2>/tmp/ex6.log
echo "=== Insertion des agregats dans HBase (table streams_year) ==="
hdfs dfs -cat output/streams_year_hb/part-* | python3 hbase/put_year_hbase.py
echo "=== Verif cote HBase : scan 'streams_year' (5 lignes) + count ==="
printf "scan 'streams_year', {LIMIT => 5}\ncount 'streams_year'\n" | hbase shell -n 2>/dev/null
