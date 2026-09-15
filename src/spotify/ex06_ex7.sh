#!/bin/bash
# EX06 IV / EX04 Ex7 : streams par artiste -> HBase streams_artist -> PDF (lecture HBase)
set -e
cd /home/src/spotify
hdfs dfs -rm -r -f output/streams_artist_hb >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files ex1_mapper.py,reducer_sum.py \
  -mapper "python3 ex1_mapper.py" -reducer "python3 reducer_sum.py" \
  -input input/Spotify_Most_Streamed_Songs.csv -output output/streams_artist_hb 2>/tmp/ex7.log
echo "=== Insertion des agregats dans HBase (table streams_artist) ==="
hdfs dfs -cat output/streams_artist_hb/part-* | python3 hbase/put_artist_hbase.py
echo "=== Lecture depuis HBase -> PDF ==="
python3 hbase/read_artist_pdf.py /home/src/spotify/streams_artist.pdf
echo "=== Verif cote HBase : get 'streams_artist','The Weeknd' ==="
printf "get 'streams_artist', 'The Weeknd'\ncount 'streams_artist'\n" | hbase shell -n 2>/dev/null
echo "PDF -> D:\\Hadoop\\src\\spotify\\streams_artist.pdf"
