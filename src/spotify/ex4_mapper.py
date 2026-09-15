import sys, csv
# Exercice 4 : (annee_de_sortie index 3, in_spotify_playlists index 6).
reader = csv.reader(sys.stdin, delimiter=',')
for row in reader:
    if len(row) < 9 or row[0] == 'track_name':
        continue
    try:
        year = int(row[3])
        playlists = int(row[6])
    except ValueError:
        continue
    print("%s\t%s" % (year, playlists))
