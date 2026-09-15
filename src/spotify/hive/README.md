# EX05 - Hive (SQL sur HDFS)

Lancer depuis l'hote (HiveServer2 doit tourner : jps -> RunJar) :

    docker exec hadoop-master bash /home/src/spotify/ex05.sh              # Parties I + II + III
    docker exec hadoop-master bash /home/src/spotify/ex05_partitions.sh  # II.3 partitions + EXPLAIN

Fichiers SQL :
  01_create_table.sql : CREATE DATABASE spotify_db + table EXTERNE (25 colonnes) + controles
  02_queries.sql      : top10 artistes, streams/annee, danceability moy., top5 titres, streams moy.
  03_partitions.sql   : table partitionnee par released_year + EXPLAIN (partition pruning)

Chiffres de controle (validation croisee avec l'EX04 MapReduce) :
  COUNT(*)=954  COUNT(streams)=952  SUM(streams)=489458828542
  Top artiste : The Weeknd 14185552870
  Top titres  : Taylor Swift 34, The Weeknd 22, Bad Bunny 19, SZA 19, Harry Styles 17

Note : table EXTERNE -> DROP TABLE supprime les metadonnees, pas le TSV dans HDFS.
