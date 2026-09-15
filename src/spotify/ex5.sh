#!/bin/bash
# EX04 - II - Exercice 5 : statistiques visuelles (PDF) des streams par annee
set -e
cd /home/src/spotify
hdfs dfs -rm -r -f output/streams_year_pdf >/dev/null 2>&1 || true
hadoop jar /opt/hadoop/share/hadoop/tools/lib/hadoop-streaming-3.3.6.jar \
  -files mapper_year_streams.py,reducer_sum.py \
  -mapper "python3 mapper_year_streams.py" -reducer "python3 reducer_sum.py" \
  -input input/Spotify_Most_Streamed_Songs.csv -output output/streams_year_pdf 2>/tmp/ex5.log
echo "=== Agregation locale + generation du PDF ==="
hdfs dfs -cat output/streams_year_pdf/part-* | python3 reducer_pdf.py /home/src/spotify/streams_par_annee.pdf | tail -6
echo "PDF -> D:\\Hadoop\\src\\spotify\\streams_par_annee.pdf"
