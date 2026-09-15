import sys, csv
# Exercices 3 & 5 : (annee_de_sortie index 3, streams index 8).
reader = csv.reader(sys.stdin, delimiter=',')
for row in reader:
    if len(row) < 9 or row[0] == 'track_name':
        continue
    try:
        year = int(row[3])
        streams = int(row[8])                     # ligne 576 corrompue -> ValueError -> skip
    except ValueError:
        continue
    print("%s\t%s" % (year, streams))
