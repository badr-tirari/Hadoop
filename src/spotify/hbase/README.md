# EX06 - HBase (+ HappyBase) et EX04 Ex6/Ex7

Prerequis : HBase + ThriftServer demarres (jps -> HMaster, ThriftServer, HRegionServer sur les slaves).

    docker exec hadoop-master bash /home/src/spotify/ex06_shell.sh      # III shell : bibliotheque
    docker exec hadoop-master bash /home/src/spotify/ex06_happybase.sh  # III python : bibliotheque_py
    docker exec hadoop-master bash /home/src/spotify/ex06_ex6.sh        # IV : streams/annee -> HBase streams_year
    docker exec hadoop-master bash /home/src/spotify/ex06_ex7.sh        # IV : streams/artiste -> HBase streams_artist -> PDF

Fichiers :
  biblio.hb            : script shell HBase (8 taches de l'exercice bibliotheque)
  biblio_happybase.py  : les memes 8 taches en Python (table bibliotheque_py)
  put_year_hbase.py    : insere annee->total dans la table HBase streams_year
  put_artist_hbase.py  : insere artiste->total dans la table HBase streams_artist
  read_artist_pdf.py   : relit streams_artist depuis HBase -> PDF top 15 artistes

Verification (consigne du cours) : la preuve d'insertion, c'est un scan/get dans HBase,
pas le retour de put (HBase ne confirme pas).
