# EX04 - Partie II : jobs MapReduce sur le dataset Spotify

Scripts montes dans le master sous `/home/src/spotify/`.
Lancer chaque exercice depuis l'hote :

    docker exec hadoop-master bash /home/src/spotify/ex1.sh   # streams / artiste
    docker exec hadoop-master bash /home/src/spotify/ex2.sh   # moyenne streams / annee
    docker exec hadoop-master bash /home/src/spotify/ex3.sh   # total streams / annee
    docker exec hadoop-master bash /home/src/spotify/ex4.sh   # moyenne playlists / annee
    docker exec hadoop-master bash /home/src/spotify/ex5.sh   # PDF matplotlib

Colonnes utilisees (CSV a 25 champs) :
  0 track_name | 1 artist(s)_name | 3 released_year | 6 in_spotify_playlists | 8 streams

- mappers : csv.reader (virgules quotees), int() protege (ligne 576 corrompue)
- reducer_sum.py  : somme par cle          (ex1, ex3, ex5)
- reducer_avg.py  : moyenne (somme+compte)  (ex2, ex4)
- reducer_pdf.py  : agrege + camembert/barres -> PDF (ex5)

Ex6 & Ex7 (insertion HBase) : apres la sequence 06.
