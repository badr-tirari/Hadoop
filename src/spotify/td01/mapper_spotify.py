import sys, csv
reader = csv.reader(sys.stdin, delimiter=',')
for row in reader:
    if len(row) < 9 or row[0] == 'track_name':   # ignore l'en-tete
        continue
    try:
        year = int(row[3]); streams = int(row[8])   # ligne 576 corrompue -> skip
    except ValueError:
        continue
    print("%s\t%s" % (year, streams))
