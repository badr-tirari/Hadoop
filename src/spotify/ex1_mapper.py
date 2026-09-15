import sys, csv
# Exercice 1 : (artiste, streams). Le champ artiste (index 1) contient des
# virgules quotees ("Latto, Jung Kook") -> csv.reader obligatoire, jamais split(',').
reader = csv.reader(sys.stdin, delimiter=',')
for row in reader:
    if len(row) < 9 or row[0] == 'track_name':   # en-tete / lignes trop courtes
        continue
    artist = row[1]                               # convention : duo = 1 cle unique
    try:
        streams = int(float(row[8]))
    except ValueError:
        continue                                  # champ streams corrompu -> ignore
    print("%s\t%s" % (artist, streams))
